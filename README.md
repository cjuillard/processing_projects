# Processing Projects
This is a set of projects I've created using [Processing 3.5.4](https://processing.org/).

## DelaunaySketch
In this sketch I'm creating a mosaic-like output given a source image using Delaunay triangulation. I like the asthetic of mosaics and wanted to try generating one from an arbitrary input image. In particular I didn't want to lose too much of the original image's detail, so I attempted to place smaller pieces where the frequency of detail in the image was high. 

The logic essentially boils down to...

1. Generate some points using Poisson disc sampling with a variable radius
     - Choose the radius of each point based on the standard deviation of pixels surrounding the new point's location within the image
2. Triangulate those points with Delaunay

I also added in an animation because... why not?

[![Example output animation](https://img.youtube.com/vi/buedfMFLppg/0.jpg)](https://www.youtube.com/watch?v=buedfMFLppg)

[Example output animation](https://www.youtube.com/watch?v=buedfMFLppg)


## FlowMap
Sketch of small particle simulation driven by a flow map.

![black and white flow map particle rendering](/FlowMap/FlowMap2/screen-0258.png)
![colorful flow map particle rendering](/FlowMap/FlowMap2/screen-0235.png)

## Loops2
Some satisfyingly seamless GIf loops.

![flower like image loop](/Loops2/loop_small.gif)
![inward spiral image loop](/Loops2/loop_spiral.gif)
![star image loop](/Loops2/loop_star.gif)
![rippling waves loop](/Loops2/waves.gif)



## ProceduralAnimation
Basic 2D bone chain IK.




