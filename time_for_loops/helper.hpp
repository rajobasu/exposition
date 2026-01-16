#pragma once

#include <vector>
#include <random>
#include <algorithm>
#include <span>

namespace helper {

inline std::vector<int> generate_random_data(size_t size) {
    std::vector<int> data(size);
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 100);
    std::generate(data.begin(), data.end(), [&]() { return dis(gen); });
    return data;
}

} // namespace helper
