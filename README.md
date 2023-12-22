# Shader Tutorial for Unity
This is me following a [tutorial on HLSL](https://docs.unity3d.com/2020.1/Documentation/Manual/SL-VertexFragmentShaderExamples.html) in [Unity](https://unity.com/). I uploaded it to GitHub as evidence of me doing my winter 2023 homework.

## Introduction

### What is Unity?
Unity is a popular cross-platform game engine. It provides extensive libraries for developing 3D and 2D mobile and desktop games.

### What are Shaders?
Shaders are algorithms for rendering meshes. You input some parameters, like the vertex coordinates and pixel (fragment) coordinates and the shader outputs a color.  
These shaders are written in High Level Shader Language (HLSL), which runs on the GPU.

### Vertex and Fragment shaders
Shaders in Unity follow two functions (at their core). The first is to retrieve vertex data from the mesh (a vertex shader), and then interpolate that on a face-level to render the color of each pixel (a fragment shader). You can see these as `v2f vert (...)` for the vertex shader, where `v2f` is a struct defining the inputs for the fragment shader `fixed4 frag (v2f i)`.

### How is this useful in A-level Computer Science?
I am considering using Unity to develop my NEA. If this goes ahead, a basic understanding of shaders and materials will be necessary.

## Key Terms
Fragment: Alias of pixel.  
Material: A Unity component that defines the inputs for a shader.  
Texture: An image used to represent 2D data of a surface. Also referred to as a "map".  
Albedo: The base color of a surface.  
Occlusion: A grayscale texture representing the shadows of a surface.  
Normal: The direction a surface is pointing.  
Tangent: A vector 90° to the normal.  
Bitangent: A vector 90° to both the normal and the tangent.  
UV Map: A 2D texture space defined by the object mesh for projecting 2D object data onto 3D faces. This is similar to a "Net" of a 3D object in geometry.  
Skybox: Data representing the scene background.  
Specular: A type of surface where the color is determined by reflections.  
Diffuse: A type of surface where the color is determined by absorption. The scientific definitions are not really relevant to the actual computer graphics. Diffuse surfaces are matt whilst specular are glossy.

## Result
![Image of the scene](./Scene.jpg)

The image above shows 8 shaders, representing the 8 stages I took to create a decent diffuse shader. I list them from back left to front, reading across.

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
Using the object's normals is key to calculating correct lighting effects. The shader color is simply the normal vector of the fragment.

### Skybox Reflection
[Link to shader](./Assets/Shaders/SkyReflection.shader)  
The skybox represents the ambient lighting of the scene. By reflecting the view direction vector using the object's normals, I was able to sample the sky texture, which is why the sphere looks like a mirror.

### Using Normals with the Skybox Reflection
[Link to shader](./Assets/Shaders/SkyReflectionPerPixel.shader)  
A normal map describes surface detail. Here, one is used to create a brickwork effect by altering the surface normal.

### Considering Albedo, Occlusion and Normals
[Link to shader](./Assets/Shaders/ThreeTextures.shader)  
This shader uses an albedo map and occlusion texture as well. However, it isn't entirely obvious.

### Final Diffuse shader
[Link to shader](./Assets/Shaders/CustomDiffuse.shader)  
Transmitting and creating shadows is done quite easily using pre-existing libraries. I also implemented active lighting. Ambient illumination is calculated using the ShadeSH9 algorithm, which for me is just a simple function call.

## Other Things to Mention

### Git LFS
I used [Git Large File System](https://github.com/git-lfs/git-lfs) to store binary files like images properly (at least I hope so). This should be included with Git for Windows.