CC := gcc
debug:   CFLAGS := -O0 -ggdb -fpic -Wall -I. -Iulib-svn/include
release: CFLAGS := -O3 -fpic -Wall -I. -Iulib-svn/include
LDFLAGS := -lpthread

SRCDIR := src
OBJDIR := objects
OBJECTS := util.o chunk.o object_table.o arena.o nvm_malloc.o
SRC := util.c chunk.c object_table.c arena.c nvm_malloc.c
LIBNAME := libnvmmalloc.so

release: $(LIBNAME) libnvmmallocnoflush.so libnvmmallocnofence.so libnvmmallocnone.so

debug: $(LIBNAME)

$(LIBNAME): ulib-svn/lib/libulib.a $(SRCDIR)/*.c
	$(CC) $(CFLAGS) -shared -o $@ $(SRCDIR)/*.c $(LDFLAGS) ulib-svn/lib/libulib.a

libnvmmallocnoflush.so: $(SRCDIR)/*.c ulib-svn/lib/libulib.a
	$(CC) $(CFLAGS) -shared -o $@ -DNOFLUSH $(SRCDIR)/*.c $(LDFLAGS) ulib-svn/lib/libulib.a

libnvmmallocnofence.so: $(SRCDIR)/*.c ulib-svn/lib/libulib.a
	$(CC) $(CFLAGS) -shared -o $@ -DNOFENCE $(SRCDIR)/*.c $(LDFLAGS) ulib-svn/lib/libulib.a

libnvmmallocnone.so: $(SRCDIR)/*.c ulib-svn/lib/libulib.a
	$(CC) $(CFLAGS) -shared -o $@ -DNOFLUSH -DNOFENCE $(SRCDIR)/*.c $(LDFLAGS) ulib-svn/lib/libulib.a

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(SRCDIR)/*.h
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $< $(LDFLAGS)

ulib-svn/lib/libulib.a:
	cd ulib-svn; make release

clean:
	@rm -f $(LIBNAME)
	@rm -rf $(OBJDIR)
	@rm -rf *.so

.PHONY: test debug release
