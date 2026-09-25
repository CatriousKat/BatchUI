# BatchUI

## 1. Overview & Compatibility
* **Purpose:** Lightweight modular GUI library for Windows batch scripts (`.bat`/`.cmd`) using native HTML Applications (`mshta.exe`).
* **Compatibility:** Windows NT family (**Windows 2000 through Windows 11**). Incompatible with Windows 95/98 (`COMMAND.COM`).
* **Dependencies:** None (uses built-in `cmd`, `mshta`, and Windows Script Host).

---

## 2. Architecture & Data Flow
1. **Init:** Sets up window title/dimensions and clears temporary buffers.
2. **Build:** Appends UI elements sequentially to a temporary body stream file.
3. **Run:** Merges the frame, embedded JavaScript DOM scraper, and body into a temporary `.hta` file, launching it synchronously via `start /wait`.
4. **Output:** Form inputs are written line-by-line (`\r\n`) to `batchui_result.txt` via ActiveX `FileSystemObject`.
5. **Parse:** The main batch script reads the result file, populating `UI_*` environment variables, then cleans up temporary files.

---

## 3. Core API Reference

| Subroutine | Parameters | Description |
| :--- | :--- | :--- |
| `BatchUI_Init` | `Title`, `Width`, `Height` | Initializes window properties. |
| `BatchUI_AddHeading` | `Text` | Inserts an `<h2>` header. |
| `BatchUI_AddSubHeading` | `Text` | Inserts an `<h4>` descriptive subheading. |
| `BatchUI_AddText` | `Text` | Inserts static text. |
| `BatchUI_AddInput` | `Label`, `ID`, `Default` | Inserts a text input field. |
| `BatchUI_AddTextArea` | `Label`, `ID`, `Default` | Inserts a multiline text area. |
| `BatchUI_AddCheckbox` | `Label`, `ID`, `State` | Inserts a checkbox (`true`/`false`). |
| `BatchUI_AddSelect` | `Label`, `ID`, `Options` | Inserts a comma-separated dropdown menu. |
| `BatchUI_AddHR` | *None* | Inserts a horizontal divider rule. |
| `BatchUI_AddButton` | `Label`, `JS_Action` | Inserts a clickable button. |
| `BatchUI_Run` | *None* | Compiles and executes the HTA window. |

---

## 4. Return Variables
* **`%BatchUI_Status%`**: Returns `OK` on submission or unsets if cancelled/closed.
* **`%UI_<id>%`**: Dynamically created environment variables containing the submitted form data.
