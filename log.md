# Log

1. 修改 benchmark/run_benchmarks.py 中的默认线程数为64，时间单位改为 us
2. 修改 benchmark/src/bench_alloc_free.cpp 中打印的时间单位为每个操作的时延
3. 其他的测试还没修改打印的时间，因此对应的图中显示的时间单位有误，单位应该为 ms
4. 其他一些编译运行的问题
