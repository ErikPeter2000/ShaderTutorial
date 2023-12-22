# Shader Tutorial for Unity
This is me following a [tutorial on HLSL](https://docs.unity3d.com/2020.1/Documentation/Manual/SL-VertexFragmentShaderExamples.html) in [Unity](https://unity.com/). I uploaded it to GitHub as evidence of me doing my winter 2023 homework.

## Introduction

### What is Unity?
Unity is a popular cross-platform game engine. It provides extensive libraries for developing 3D and 2D mobile and desktop games.

### What are shaders?
Shaders are algorithms for rendering meshes. You input some parameters, like the vertex coordinates and pixel (fragment) coordinates and the shader outputs a color.  
These shaders are written in High Level Shader Language (HLSL), which is run on the GPU.

### How is this useful in A-level Computer Science?
I am considering using Unity to develop my NEA. If this goes ahead, a basic understanding of shaders and materials will be necessary.

## What I learned
![Image of the scene](./Scene.jpg)

The image above shows 8 shaders, representing the 8 stages I took to create a decent diffuse shader.

### Block Color
[Link to shader](./Assets/Shaders/SingleColor.shader)  
The first shader (back left) is a simple emission shader. It does not interact with the scene lighting and uses no textures.

### Checkerboard Texture
[Link to shader](./Assets/Shaders/Checkerboard.shader)  
By performing some basic arithmetic on the UV coordinates, I was able to procedurally texture the sphere to create a simple pattern.

### Image Texture
[Link to shader](./Assets/Shaders/NewUnlitShader.shader)  
The shaders samples an image texture and returns the color. It still does not interact with the world. I commented this one thoroughly.

### World Normal
[Link to shader](./Assets/Shaders/WorldSpaceNormals.shader)  
Using the object's normals is key to calculating correct lighting. The shader color is simply the normal of the fragment.

### Skybox Reflection
[Link to shader](./Assets/Shaders/SkyReflection.shader)  
The skybox represents the ambient lighting of the scene. By reflecting the view direction using the object's normals, I was able to sample the sky texture, which is why the sphere looks glossy.

### Using Normals with the Skybox Reflection
[Link to shader](./Assets/Shaders/SkyReflectionPerPixel.shader)  
A normal map describes surface detail. Here, one is used to create a brickwork effect.

### Considering Albedo Occlusion and Normals
[Link to shader](./Assets/Shaders/ThreeTextures.shader)  
This shader uses an albedo (base color) map and occlusion (shadow details) texture as well.

### Final Diffuse shader
[Link to shader](./Assets/Shaders/CustomDiffuse.shader)  
Transmitting and creating shadows is done quite easily using pre-existing libraries. I also implemented active lighting.