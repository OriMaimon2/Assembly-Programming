# 8086 Assembly Programming Projects

A collection of educational 8086 assembly assignments and a final mini-game, all implemented for DOS text mode using direct video memory access (`0xB800`) and low-level keyboard/timer I/O.

## Repository Purpose

This repository demonstrates practical 16-bit x86 programming concepts:

- Data segment and stack setup in small memory model programs
- Direct text-mode rendering via video memory writes
- Pointer and offset manipulation
- Basic arithmetic and hex output formatting
- Procedural decomposition in assembly (`proc`/`endp`)
- Keyboard and timer polling through hardware ports
- Game-loop design with state tracking and collision checks

## Project Structure

```text
Assembly-Programming/
  8086 Assembly Maze Game Engine/
    maze.asm
  8086 Segment Logic & Opcode Analysis/
    draw.asm
    printmem.asm
  Assembly Video Memory & DPOINTERS/
    hw1.asm
```

## Modules

### 1) `8086 Assembly Maze Game Engine/maze.asm`

A complete text-mode maze game featuring:

- Opening screen with game story and instructions
- Player character ("Beeper") and enemy ("Bopper")
- Maze walls rendered from pre-defined wall segment coordinates
- Timed movement windows and keyboard polling
- Enemy pursuit based on delayed replay of the player movement history
- Win/lose screens and a step counter summary

Implementation highlights:

- Uses `ES = 0xB800` for all screen rendering
- Uses keyboard controller ports (`0x64`, `0x60`) for key polling
- Uses RTC/CMOS ports (`0x70`, `0x71`) for timing windows
- Uses a `moveMemory` queue to make Bopper follow Beeper's prior moves
- Tracks and displays number of steps on victory

Notes:

- The on-screen text mentions arrow movement, but the current keyboard scan-code checks are for `W`, `A`, `S`, `D` key events.
- `Space` starts the game from the opening screen.

### 2) `8086 Segment Logic & Opcode Analysis/draw.asm`

A drawing exercise in text mode that renders geometric shapes directly in video memory:

- Rectangle (outer border)
- Rhombus
- Symmetrical "horn" structures with multi-color bands

Implementation highlights:

- Careful memory offset arithmetic for row/column stepping
- Color attribute control using text-mode attribute byte
- Loop-driven shape generation without BIOS drawing services

### 3) `8086 Segment Logic & Opcode Analysis/printmem.asm`

A memory/arithmetic/formatting exercise:

- Loads two 16-bit values (`X`, `Y`) from data segment
- Adds values and prints the result in hexadecimal form
- Converts nibbles into ASCII (`0-9`, `A-F`)
- Writes resulting characters directly into text-mode video memory

### 4) `Assembly Video Memory & DPOINTERS/hw1.asm`

A pointer-focused exercise using arrays and address tables:

- Builds two ID digit arrays (`ID1`, `ID2`)
- Stores their offsets in a `DPOINTERS` table
- Uses pointer indirection to populate and print values
- Displays digits with varied color attributes

Implementation highlights:

- Demonstrates offset-based addressing and dereferencing
- Shows how pointer tables can generalize array access in assembly

## Prerequisites

These programs target a classic 16-bit DOS environment. Use one of the following:

- DOSBox (recommended for modern machines)
- DOSBox-X
- 8086 emulator setup that supports DOS interrupts and text-mode memory

Assembler/linker toolchains commonly used:

- TASM + TLINK
- MASM + LINK

## Build and Run

Because this repository does not include build scripts, compile each file manually.

### Option A: TASM/TLINK

```bat
tasm maze.asm
tlink maze.obj
maze.exe
```

```bat
tasm draw.asm
tlink draw.obj
draw.exe
```

```bat
tasm printmem.asm
tlink printmem.obj
printmem.exe
```

```bat
tasm hw1.asm
tlink hw1.obj
hw1.exe
```

### Option B: MASM/LINK

```bat
masm maze.asm;
link maze.obj;
maze.exe
```

(Repeat similarly for `draw.asm`, `printmem.asm`, and `hw1.asm`.)

## Game Controls (`maze.asm`)

- `Space`: start the game from the intro screen
- `W`: move up
- `A`: move left
- `S`: move down
- `D`: move right

Goal:

- Reach the maze exit while avoiding Bopper.
- Bopper follows your recent movement history, so path planning matters.

## Learning Outcomes

This repository is useful for students practicing:

- Real-mode memory segmentation
- Hardware-adjacent I/O in assembly
- Data-driven rendering in text mode
- State machines and simple AI behavior in low-level code

## Authors

- Ori Maimon (`216383174`)
- Natan Krombein (`341004471`)

(Author information appears in source file headers.)

## Disclaimer

This repository is an educational project intended for learning 8086 assembly and DOS-era programming techniques.
