#include <benchmark/benchmark.h>
#include <span>
#include <vector>
#include <cstdint>
#include "helper.hpp"

using namespace std;

// 1. Do-While Loop
int loop_do_while(int* arr, const size_t n) {
    if (n == 0) return 0;
    int loop_counter = 0;
    int sum = 0;
    do {
        sum += arr[loop_counter++] + sum / 10;
    } while (loop_counter < n);
    return sum;
}

// 2. While Loop
int loop_while(int* arr, const size_t n) {
    int loop_counter = 0;
    int sum = 0;
    while (loop_counter < n) {
        sum += arr[loop_counter++] + sum / 10;
    }
    return sum;
}

// 3. For Loop
int loop_for(int* arr, const size_t n) {
    int sum = 0;
    for(int i = 0; i < n; i++) {
        sum += arr[i] + sum / 10;
    }
    return sum;
}

template <int (*LoopFunc)(int*, size_t)>
static void BM_Loop(benchmark::State& state) {
    const size_t size = state.range(0);
    auto data = helper::generate_random_data(size);
    
    for (auto _ : state) {
        int result = LoopFunc(data.data(), data.size());
        benchmark::DoNotOptimize(result);
    }
    
    state.SetItemsProcessed(state.iterations() * size);
    state.SetBytesProcessed(state.iterations() * size * sizeof(int));
}

static void CustomArguments(benchmark::internal::Benchmark* b) {
    for (double i = 16; i <= 25000000; i *= 1.4) {
        b->Arg(static_cast<int64_t>(i));
    }
}

static void FastArguments(benchmark::internal::Benchmark* b) {
    for (auto s : {1000, 10000, 100000, 10000000}) {
        b->Arg(s);
    }
}

// Full Benchmarks
BENCHMARK(BM_Loop<loop_do_while>)->Name("DoWhile_Full")->Apply(CustomArguments)->MinTime(0.2);
BENCHMARK(BM_Loop<loop_while>)->Name("While_Full")->Apply(CustomArguments)->MinTime(0.2);
BENCHMARK(BM_Loop<loop_for>)->Name("For_Full")->Apply(CustomArguments)->MinTime(0.2);

// Fast Benchmarks
BENCHMARK(BM_Loop<loop_do_while>)->Name("DoWhile_Fast")->Apply(FastArguments)->MinTime(0.2);
BENCHMARK(BM_Loop<loop_while>)->Name("While_Fast")->Apply(FastArguments)->MinTime(0.2);
BENCHMARK(BM_Loop<loop_for>)->Name("For_Fast")->Apply(FastArguments)->MinTime(0.2);

BENCHMARK_MAIN();
