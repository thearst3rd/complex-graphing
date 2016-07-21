# My Complex Graphing Series

These are a few programs I wrote to help people understand the basics of complex (imaginary) numbers and how to graph and visualize them. They are meant to build on each other and to make analogys from the real numbers into the complex numbers to make them easier to understand. We'll see how well I did :P

For information on running the programs, check the bottom of this file.

### Complex Numbers

I've been talking about these "complex" a lot, but what are they? You might know them better by the name "imaginary" numbers, which in my opinion is a terrible name, which I'll get into later.

The imaginary unit, `i`, is the square root of -1. Now you might be confuzed by this, you can't take the square root of a negative number! Any time you square a number, it will always be positive. 2*2 = 4, but (-2)*(-2) also equals 4! There are no numbers on the number line that can be squared to be a negative number.

And so are born complex numbers. These numbers do not lie on the number line, they extend that line into a plane. You can think of the number line as a one dimensional line that contains all real numbers. 1, 4, -3/2, pi^2/e, all of the points on the line are a single real number. You can imagine this line as the x-axis. Now imagine that there is also a y-axis. Now there is a whole plane of numbers, and each point on that plane corresponds to a unique number, just like each point on the number line corresponded to a unique real number. Bam, you have the complex plane!

All numbers in this plane can be written in the form of `a+bi`. `a` is the "real component" of the number, which is it's position along the x-axis. `b` is then the "imaginary component", and that it's position along the y-axis. Together, these form a single complex number.

These are the basics of complex numbers. I could go way more into their details and cool stuff, which I might do later, but for now I think I've covered the basics well enough to move on to the actual programs.

## The Programs

### 1. Real Graphing with Sliders

This is a very simple example using only real numbers. In this program there are two input numbers which you can control using sliders. The output is another slider (which you cannot control), and the value of that output is simply the first number raised to the power of the second number.

You might be thinking, "well this is useless", and in a sense you're right, but let me explain. This is definitely not a great way to visualize real numbers, because they're just not very interesting. It would be better to look at a full graph on a graphing calculator. But this program works together with the next program to demonstrate that complex numbers are just like the real numbers.

I'll explain further in the next program:

### 2. Complex Graphing with Planes

This program functions exactly the same as the previous function with one change - instead of real numbers and number lines, we have complex numbers and complex planes. The program other than that is identical though, you plug in two input points and you see it's output point.

This is cool because it shows some identities such as `i^2 = -1` and `(-1)^(1/2) = i` if you put the points there. Have fun and mess around! It's fun seeing what setting the right point to be constant and dragging the left point around will do.

### 3. Real Graphing Calculator

This one isn't quite exactly analogous to the next one, but it's to demonstrate something simple. There are much better ways to visualize graphs of real numbers than looking at a single point at a time like we did with the sliders. So in this graph, we can look at a whole range of input points and look at all of their corresponding outputs at the same time, which is much more informative.

Note, you can edit the function of the graph by changing the return value of `function f( x )` on line 8 of main.lua. There's also a bunch of stuff commented out like integrals and derivatives hidden in the code so check those out >:D

### 4. Complex Maps

Now to be exactly analogous to the previous program, we'd need to look at all of the input points over a range and all of their corresponding output points at the same time, and since the input points are 2-dimensional and the output points are 2-dimensional, we'd require 4 spacial dimensions to look at such a graph. That would be awesome.

But since we don't live in a 4D world, we have to make it more friendly for us to understand. Luckily there is a nice way to do that using time as a medium! We start with a grid of input points. Then, we apply the function to all points on this grid, resulting in another point, and slowly animate each input point moving to it's output point. The result is a complex map, which looks pretty darn cool.

Note, just like the previous program you can change the function which is hard coded at the top of main.lua. For this and the other graphing program I wrote that uses complex numbers, they both use a simple complex library that I wrote that handles complex numbers, and I included things like sine and cosine using complex numbers, so try replacing `z^2` with something like `math.sin( z )` and changing the domain from `1` to `math.pi/2` or whatever. Mess around, explore your own functions and look at how cool these are!!!

## Running the Programs - Love2D

These programs are all written in Lua using the Love2D framework. It's absolutely excellent and you should check it out here: https://love2d.org/

To run any of the programs in this set, download Love2D (I wrote them using 0.10.1, so if a newer version comes out they might not be guarenteed to work using those). Once it's downloaded, drag the directory of the program onto love.exe and it'll run (on Windows. Not sure about Mac and Linux but I'm sure it's not very hard).