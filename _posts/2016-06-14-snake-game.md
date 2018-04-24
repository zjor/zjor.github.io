---
layout: post
title: The Snake Game
comments: true
date: 2016-06-14
categories: arduino
---
This time we'll create somthing more interactive.

We'll use the following items:

<table>
	<thead>
		<tr style="text-align: center;">
			<td>Arduino UNO</td>
			<td>8x8 LED matrix</td>
			<td>Joystick</td>
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
			<td>
				<img src="/assets/images/joystick_min.jpg">
			</td>			
		</tr>
	</tbody>
</table>

Eventually my little monster looks like this:

![Snake](/assets/images/snake.jpg)

Wiring should be clear from the source code listed below, also available [here](https://github.com/zjor/arduino/blob/master/snake/arduino/snake/snake.ino)

	:::c
	/**
	 * Snake
	 * Implementation of the classical Snake game 
	 * where the snake moved constantly and the player
	 * have to avoid intersections with itself and borders.
	 * When the snake eats food it grows and speeds up a little bit.
	 * 
	 * 23 Jun 2016
	 * by Sergey Royz
	 */
	 
	#include <LedControl.h>

	/* Joystick PINs */
	#define VRX     A0
	#define VRY     A1
	#define SW      2

	/* Display PINs */
	#define CLK     8
	#define CS      9
	#define DIN     10

	#define SIZE    8
	#define ADVANCE_DELAY 20

	int snake[SIZE*SIZE][2];
	int length;
	int food[2], v[2];
	bool is_game_over = false;
	long current_time;
	long prev_advance;
	int blink_count;

	LedControl lc = LedControl(DIN, CLK, CS, 1);

	void init_game() {
	  prev_advance = current_time = 0;
	  blink_count = 3;
	  int half = SIZE / 2;
	  length = SIZE / 3;

	  for (int i = 0; i < length; i++) {
	      snake[i][0] = half - 1;
	      snake[i][1] = half + i;
	  }

	  food[0] = half + 1;
	  food[1] = half - 1;

	  v[0] = 0;
	  v[1] = -1;
	}

	void render() {
	  for (int i = 0; i < length; i++) {
	    lc.setLed(0, snake[i][0], snake[i][1], 1);
	  }
	  lc.setLed(0, food[0], food[1], 1);
	}

	void clearScreen() {
	  for (int x = 0; x < SIZE; x++) {
	    for (int y = 0; y < SIZE; y++) {
	      lc.setLed(0, x, y, 0);
	    }
	  }
	}

	/**
	 * moves the snake forward
	 * returns true if the game is over
	 */
	bool advance() {
	  int head[2] = {snake[0][0] + v[0], snake[0][1] + v[1]};

	  if (head[0] < 0 || head[0] >= SIZE) {
	      return true;
	  }
	  
	  if (head[1] < 0 || head[1] >= SIZE) {
	      return true;
	  }
	  
	  for (int i = 0; i < length; i++) {
	      if (snake[i][0] == head[0] && snake[i][1] == head[1]) {
	          return true;
	      }
	  }
	  
	  bool grow = (head[0] == food[0] && head[1] == food[1]);
	  if (grow) {
	      length++;  
	      randomSeed(current_time);    
	      food[0] = random(SIZE);
	      food[1] = random(SIZE);
	  }
	  
	  for (int i = length - 1; i >= 0; i--) {
	      snake[i + 1][0] = snake[i][0];
	      snake[i + 1][1] = snake[i][1];
	  }
	  snake[0][0] += v[0];
	  snake[0][1] += v[1];
	  return false;
	}

	void setup() {
	  pinMode(SW, INPUT_PULLUP);
	  pinMode(VRX, INPUT);
	  pinMode(VRY, INPUT);
	  attachInterrupt(digitalPinToInterrupt(SW), restart, RISING);

	  lc.shutdown(0, false);
	  lc.setIntensity(0, 8);

	  init_game();
	  render();
	}

	void loop() {
	  if (!is_game_over) {
	    clearScreen();
	    render();
	    if (current_time - prev_advance > ADVANCE_DELAY) {
	      is_game_over = advance();
	      prev_advance = current_time;    
	    }
	  } else {
	    while (blink_count > 0) {
	      clearScreen();
	      delay(300);
	      render();
	      delay(300);
	      blink_count--;      
	    }
	  }
	  readControls();
	  current_time++;
	}

	void restart() {  
	  init_game();
	  is_game_over = false;
	}

	void readControls() {
	  int dx = map(analogRead(VRX), 0, 906, 2, -2);
	  int dy = map(analogRead(VRY), 0, 906, -2, 2);
	  if (dx != 0) {dx = dx / abs(dx);}
	  if (dy != 0) {dy = dy / abs(dy);}

	  if (dy != 0 && v[0] != 0) {
	    v[0] = 0;
	    v[1] = dy;    
	  }

	  if (dx != 0 && v[1] != 0) {
	    v[0] = dx;
	    v[1] = 0;
	  }

	}

<iframe width="560" height="315" src="https://www.youtube.com/embed/bKMDyU7dsYs" frameborder="0" allowfullscreen></iframe>
