#pragma once
#include <cuda.h>
#include <shared/cuda_helpers.cuh>
#include <shared/vecs/vec3.cuh>
#include <shared/vecs/vec5.cuh>
#include <shared/vecs/vec8.cuh>
#include <string>
#include <vector>

namespace ppt
{
namespace path_tracer
{

using namespace ppt::shared;
/**
 * Render class contains logic for handeling the memory of a render,
 * as well as utility functions for serializing the render.
 */
class render
{
    private:
    vec3* d_color_matrix;
    vec8* d_image_matrix;

    public:
    const size_t w;
    const size_t h;
    const size_t render_color_bytes;
    const size_t render_image_bytes;

    render(int w, int h)
      : w(w), h(h), render_color_bytes(w * h * sizeof(vec3)), render_image_bytes(w * h * sizeof(vec8))
    {
        checkCudaErrors(cudaMalloc((void**)&d_color_matrix, render_color_bytes));
        checkCudaErrors(cudaMalloc((void**)&d_image_matrix, render_image_bytes));
    }

    // move operator
    render(render&& other)
      : d_image_matrix{ other.d_image_matrix }
      , w(w)
      , h(h)
      , render_color_bytes(render_color_bytes)
      , render_image_bytes(render_image_bytes)
    {
        other.d_color_matrix = nullptr;
        other.d_image_matrix = nullptr;
    }

    // For now delete copy and assignment to make sure we do not do it anywhere
    render(const render& other) = delete;
    render& operator=(const render& other) = delete;
    render& operator=(render&& other)
    {
        cudaFree(d_image_matrix);
        d_image_matrix = other.d_image_matrix;
        other.d_image_matrix = nullptr;

        cudaFree(d_color_matrix);
        d_color_matrix = other.d_color_matrix;
        other.d_color_matrix = nullptr;

        return *this;
    }

    ~render()
    {
        cudaFree(d_image_matrix);
    }

    // todo think about how we can return as ref?
    vec8* get_image_matrix()
    {
        return d_image_matrix;
    }

    vec3* get_color_matrix()
    {
        return d_color_matrix;
    }

    std::vector<vec3> get_vector3_representation() const;

    std::vector<vec8> get_vector8_representation() const;
};

} // namespace path_tracer
} // namespace ppt