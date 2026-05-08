# EnvBuilder

A small batch tool that automates the setup of C++ projects using **CMake** and **vcpkg**. It handles vcpkg detection, installation, and generates all the boilerplate files you need to get started.

---

## What it does

EnvBuilder takes care of the repetitive setup work when starting a new C++ project, it can :

1. **Finds or installs vcpkg** — scans your PATH, common environment variables, or lets you point to an existing installation. If vcpkg isn't on your machine, it clones and bootstraps it automatically.
2. **Configures environment variables** — sets `VCPKG_ROOT` so CMake can locate the vcpkg toolchain.
3. **Generates boilerplate project files** — creates `CMakeLists.txt`, `CMakePresets.json`, and `vcpkg.json` templates ready to be customized.
4. **Generates your Visual Studio solution** — runs CMake to produce build files from your configuration.

---

## Requirements

- **Windows 10** or later
- **Git** — for cloning vcpkg if not already installed
- **CMake 3.20+** — for project configuration and build
- **A C++ compiler** — Visual Studio 2022 (recommended), MinGW, or any CMake-compatible compiler
- **PowerShell** — pre-installed on Windows 10+ (used for locating system folders)

---

## Project structure

```
YourProject/
├── GenerateSolution.bat              # Main entry point
├── Scripts/
│   ├── Setup.bat                   # Orchestrates vcpkg search, install & file generation
│   ├── Vcpkg/
│   │   ├── VcpkgSearch.bat         # Finds vcpkg in PATH & environment variables
│   │   ├── VcpkgFindOrInstall.bat  # Interactive: locate or install vcpkg
│   │   └── VcpkgUpdate.bat         # Updates vcpkg to the latest version
│   └── Project/
│       ├── CheckAndGenerateFiles.bat   # Checks & generates missing project files
│       ├── CreateVcpkgJson.bat         # Generates vcpkg.json template
│       ├── CreateCMakePresetJson.bat   # Generates CMakePresets.json
│       └── CreateCmakeLists.bat        # Generates CMakeLists.txt template
├── Source/                         # Your C++ source files go here
│   └── main.cpp
├── CMakeLists.txt                  # (generated)
├── CMakePresets.json               # (generated)
└── vcpkg.json                      # (generated)
```

---

## How to use

### 1. Clone or download this repository

```bash
git clone https://github.com/yourusername/CMakeBootstrap.git MyProject
cd MyProject
```

### 2. Run the bootstrapper

Double-click `GenerateSolution.bat` in an existing project or empty folder where you will put your project

### 3. Choose an option

```
[CHOICE] 1 - Regenerate your solution
[CHOICE] 2 - Setup the solution environment
[CHOICE] 3 - Exit
```

**First time?** Pick option **2**. The tool will:
- Search for vcpkg on your system
- If not found, offer to install it or let you provide a path
- Set the `VCPKG_ROOT` environment variable
- Generate `CMakeLists.txt`, `CMakePresets.json`, and `vcpkg.json`

**Already set up?** Pick option **2** again to update vcpkg, or option **1** to regenerate the Visual Studio solution.

### 4. You can now add your dependencies (example with opengl)

Edit `vcpkg.json` to add the packages you need:

```json
{
  "name": "myproject",
  "version-string": "1.0.0",
  "dependencies": [
    "opengl",
    "glfw3",
    "glew",
    "glm",
  ]
}
```

### 5. Configure CMakeLists.txt

Edit `CMakeLists.txt` to find and link your packages:

```cmake
find_package(OpenGL REQUIRED)
find_package(glfw3 CONFIG REQUIRED)
find_package(GLEW CONFIG REQUIRED)

target_link_libraries(${PROJECT_NAME} OpenGL::GL glfw GLEW::GLEW)
```

### 6. Build a solution

Pick option **1** to generate and build the solution:

---

## How it works under the hood

### Vcpkg detection flow

```
Search PATH
  └─ Found? ──► Use it
  └─ Not found?
      Search environment variables
      (VCPKG_ROOT, VCPKG_ROOT_DIR, VCPKG_HOME, VCPKG_PATH, VCPKG_DIR)
        └─ Found? ──► Use it
        └─ Not found?
            Ask user:
              1. Install vcpkg (clone + bootstrap)
              2. Provide path to existing install
```

### File generation

Each generated file is created only if it doesn't already exist, so your customizations are never overwritten. The generated files include:

- **vcpkg.json** — manifest file with an empty dependencies array, ready to fill in
- **CMakePresets.json** — configures the vcpkg toolchain via `VCPKG_ROOT` with default, debug and release presets
- **CMakeLists.txt** — project skeleton with `GLOB_RECURSE` on the `Source/` directory for `.cpp`, `.h`, and `.inl` files

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `'...' is not recognized as an internal command` | Your path contains spaces. Make sure all paths in scripts are wrapped in double quotes. |
| Git clone fails | Check your internet connection and that `git` is in your PATH. |
| CMake can't find vcpkg toolchain | Run option 2 again to ensure `VCPKG_ROOT` is set. Restart your terminal for `setx` changes to take effect. |
| Bootstrap fails | Make sure you have a C++ compiler installed (Visual Studio with C++ workload). |

---

## License

MIT
