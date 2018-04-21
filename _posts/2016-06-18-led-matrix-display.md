---
layout: post
title: Hello LED matrix display
date: 2016-06-18
categories: arduino
---
In this article I'll show how to use LED matrix display with Arduino UNO.
We'll see how to control single pixel and implement 
[the game of life](https://en.wikipedia.org/wiki/The_Game_of_Life).

## Components ##
<table>
	<thead>
		<tr style="text-align: center;">
			<td>Arduino UNO</td>
			<td>8x8 LED matrix display</td>
		</tr>
	</thead>
	<tbody>		
		<tr>
			<td>
				<img src="/assets/images/arduino_uno_min.jpg">				
			</td>
			<td>
				<img src="/assets/images/led_matrix_min.jpg">
			</td>
		</tr>
	</tbody>
</table>

## Usage ##
We are going to use a module with 8x8 matrix display and MAX7219CNG display driver 
to reduce number of pins and simplify control.

We'll include a library

	:::c
	#include <LedControl.h>

Pin numbers we are going to use are described in code below

	:::c
	#define CLK 8
	#define CS  9
	#define DIN 10

## Controlling single pixel ##
Let's look at the whole sketch which lights one pixel

	:::c
	#include <LedControl.h>

	#define CLK 8
	#define CS  9
	#define DIN 10

	LedControl lc = LedControl(DIN, CLK, CS, 1 /* number of displays attached */);

	#define DISPLAY_INDEX 0

	void setup() {  
	  lc.shutdown(DISPLAY_INDEX, false);
	  lc.setIntensity(DISPLAY_INDEX, 8);
	  lc.setLed(DISPLAY_INDEX, 3/*X*/, 4/*Y*/, 1/*HIGH*/);
	}

	void loop() {
	}	

Final result should look like this.

![Final result](/assets/images/pixel_control.jpg)

## The Game of Life ##
Now let's do something more interesting and implement [the game of life](https://en.wikipedia.org/wiki/The_Game_of_Life).
The source code can be found [here](https://github.com/zjor/arduino/blob/master/the_game_of_life/the_game_of_life.ino).
There are several configurations changing one another thus forming beautiful animation like on the video below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/mDUbzU1nA8Q" frameborder="0" allowfullscreen></iframe>


