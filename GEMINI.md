# CometEngine Rhythm Project - Architecture and Style Guide

## Tech Stack
* **Engine:** CometEngine (Custom Engine).
* **Scripting Language:** AngelScript (Strict static typing).
* **Target Build:** WebGL.
* **Assigned AI Model:** MODEL_NAME = 'gemini-3-pro-preview'

## Coding Standards
* **Naming Conventions:**
  * Classes and Structs in `PascalCase` (e.g., `BeatmapParser`, `NoteData`).
  * Variables and functions in `camelCase` (e.g., `audioTimeMs`, `calculateHit()`).
  * Constants in `UPPER_SNAKE_CASE` (e.g., `HIT_WINDOW_MS`).
* **Code Delivery:** You must **always provide the full script**. Generating snippets or incomplete code blocks with comments like `// ... rest of the code` is strictly prohibited.
* **Technical Honesty:** If a native CometEngine function is unknown or engine API information is missing, state it explicitly. Do not invent data or hallucinate engine API functions to "fill in the gaps".
* **Separation of Concerns (MVC):** Rhythm calculation logic (Model) must not contain rendering calls (View). Use state variables or events to communicate the rhythm backend with Animation Controllers.

## Avoidance (Critical errors to avoid)
* **Desync Danger:** **DO NOT USE** `DeltaTime` or framerate-dependent `Update()` for moving or validating musical notes. All rhythm calculations must be based exclusively on the audio playback position returned by the engine (in milliseconds).
* **Memory Allocation:** Avoid creating new objects every frame while reading the grid. Use *Object Pooling* for the generation and destruction of "Hit Circles".
* **Silent Error Handling:** If a Beatmap file is corrupt or missing metadata, the parser must return an explicit error or halt execution, never "guess" default values to force the game to run in a broken state.

## Context Map
* `\Assets\Marc\SoundSpacePlus`: Contains the reference source code in GDScript from the open-source project. Use **only** for reading mathematical logic of approach rates and data formatting.
* `BeatmapParser.as`: Script responsible for reading local files (JSON/TXT) of Rhythia maps and converting them into an array of `NoteData` structs usable in AngelScript.
* `RhythmGrid.as`: Script in charge of managing the logical state of the 3x3 grid. It does not draw; it only calculates which note is active in which quadrant according to `audioTimeMs`.
* `HitDetector.as`: Script that receives player input (mouse coordinates / hover event), compares it with the `RhythmGrid` state, and returns the result (Hit, Miss, Accuracy). Note: Rhythia style, hovering over the correct cell at the perfect time is valid, clicking is NOT required.

## CometEngine & Language Specific Rules
* **Language Constraint:** ALWAYS code and write comments in English inside `.as` scripts. No Spanish comments or meta-logs in the code!
* **Base Class:** In CometEngine, scripts inherit from `CometBehaviour` (similar to Unity's `MonoBehaviour`). Use `using namespace CometEngine;`.
* **GameObject Equivalent:** Elements in the scene are called `Entity`.
* **Logging:** Use `Debug::Log("message")` instead of `Print()` or `Console.WriteLine()`.

## Methodology
* **Verify Before Proceeding:** Always visually/functionally test features in-engine to ensure they work perfectly before moving on to new tasks or developing new systems. Do not assume logic is fully complete until it is seen and executed flawlessly by the user.