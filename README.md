# 🪢 Hangman — x86 Assembly (8086)

> 📌 **Note:** Built during my **3rd semester** as a Computer Organization & Assembly Language project. Writing a fully interactive game with animations, sound, and direct video memory access was one of the most challenging and rewarding things I did in my degree.

A complete Hangman game written in **8086 Assembly**, running as a COM program directly on DOS/DOSBox. The game features animated hangman drawing, sound effects, 4 difficulty levels, randomized word selection, and a full alphabet keyboard display — all rendered by writing directly to video memory at `0xB800`.

---

## 🎮 Features

### Gameplay
- ✅ Full Hangman game loop — guess letters, fill dashes, track incorrect guesses
- ✅ 4 difficulty levels — Beginner (3 letters), Medium (5), Hard (6), Master (9)
- ✅ Randomized word selection using system clock via `INT 1Ah`
- ✅ Category hints displayed per round (e.g. "Countries", "Stationary")
- ✅ On-screen alphabet keyboard — used letters disappear as they are guessed
- ✅ Duplicate guess detection — already-guessed letters rejected with error
- ✅ Input validation — only lowercase a–z accepted

### Hangman Figure Animation
The hangman is drawn **part by part** in real time as incorrect guesses accumulate:

| Mistakes | Part Added |
|---|---|
| 1 | Beam |
| 2 | Knot |
| 3 | Head |
| 4 | Body |
| 5 | Right Arm |
| 6 | Left Arm |
| 7 | Right Leg |
| 8 | Left Leg → Game Over |

### Win / Lose Screens
- **WIN!** — Large pixel-art "WON!" rendered directly to video memory
- **LOSE** — Large pixel-art "OUT!" rendered directly to video memory

### Post-Game Options
- `(a)` — Play another round (same level)
- `(c)` — Change difficulty level
- `(q)` — Quit game

### Welcome & Rules Screen
- Animated welcome screen with full hangman drawn part-by-part on startup
- Complete rules displayed with delays before game starts
- Sound effects on valid/invalid inputs and transitions

---

## 🧠 Technical Highlights

### Direct Video Memory Access
All rendering is done by writing directly to the CGA/VGA text buffer at segment `0xB800`. No BIOS print calls for game rendering — every character and attribute byte is written manually:

```asm
mov ax, 0xB800
mov es, ax          ; point ES to video segment
mov al, 80
mul byte [row]      ; row * 80
add ax, [col]       ; + column
shl ax, 1           ; * 2 (char + attribute byte)
mov di, ax          ; DI = target offset
mov ax, 0x7420      ; attribute 0x74 + space char
stosw               ; write to screen
```

### Custom String Printing (`printstr2`)
A reusable subroutine that takes x position, y position, attribute, and string address as stack parameters — calculates the exact video memory offset and prints character by character:

```asm
push ax     ; x
push ax     ; y
push ax     ; attribute (e.g. 0x74 = white on red)
push ax     ; address of string
call printstr2
```

### Randomized Word Selection
Uses `INT 1Ah` (BIOS time service) to read the system clock tick count, then takes `tick mod 3` to select one of three word pairs per difficulty level.

### Bubble Sort on Guessed Letters
Guessed characters are stored in the `inps` array and sorted using a custom in-place **bubble sort** routine to enable efficient duplicate detection.

### Sound Effects
Custom beep routine using port `42h`/`43h`/`61h` to produce sound — different beep patterns for valid guesses, invalid input, and game transitions.

### Stack-Based Subroutines
All subroutines use `BP`-based stack frames, preserving registers with `PUSHA`/`POPA` and cleaning up parameters with `RET n`.

---

## 🗂️ Word Bank

| Level | Category | Word |
|---|---|---|
| Beginner | Calendar | may |
| Beginner | Loyal | dog |
| Beginner | Furry | cat |
| Medium | Music | piano |
| Medium | Fruits | apple |
| Medium | Flowers | daisy |
| Hard | Countries | france |
| Hard | Professions | lawyer |
| Hard | Colors | orange |
| Master | Stationary | sharpener |
| Master | Study | knowledge |
| Master | Trips | adventure |

---

## 🛠️ Tech Stack

| | |
|---|---|
| **Language** | x86 Assembly (8086) |
| **Format** | COM executable (`ORG 0x0100`) |
| **Assembler** | NASM |
| **Platform** | DOS / DOSBox |
| **Rendering** | Direct video memory (`0xB800`) |
| **I/O** | BIOS interrupts (`INT 16h`, `INT 1Ah`, `INT 21h`) |

---

## 🚀 How to Run

### Using DOSBox
1. Install [DOSBox](https://www.dosbox.com/)
2. Assemble the source:
```bash
nasm hangman.asm -o hangman.com
```
3. Mount and run in DOSBox:
```
mount c /path/to/folder
c:
hangman.com
```

---

## 📁 Project Structure

```
hangman-x86-assembly/
├── hangman.asm       ← Full source (single file)
└── README.md
```

---

## 📌 Limitations & Possible Extensions

- Single player only
- Word bank is hardcoded (could be loaded from a file)
- Could add more words per level
- Could be ported to protected mode for extended features


---

## 📄 License

Open-source — feel free to fork or use as a learning reference.