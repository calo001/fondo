<<<<<<< HEAD
<div align="center">
  <span align="center"> <img width="80" height="80" class="center" src="https://raw.githubusercontent.com/calo001/fondo/develop/data/images/com.github.calo001.fondo.png" alt="Icon"></span>
  <h1 align="center">Fondo</h1>
  <h3 align="center"></h3>
</div>

<br/>

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.calo001.fondo">
        <img src="https://appcenter.elementary.io/badge.svg">
    </a>
</p>

<p align="center">
  <a href="https://github.com/calo001/fondo/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/License-AGPL-3.0-blue.svg">
  </a>
  <a href="https://github.com/calo001/fondo/releases">
    <img src="https://img.shields.io/badge/Release-v%201.0.0-orange.svg">
  </a>
</p>

<p align="center">
    <img  src="https://raw.githubusercontent.com/calo001/fondo/develop/data/images/screenshot_1.png" alt="Screenshot"> <br>
  <a href="https://github.com/calo001/fondo/issues/new"> Report a problem! </a>
</p>

## Installation

### Dependencies
These dependencies must be present before building:
 - `meson`
 - `valac`
 - `libgranite-dev`
 - `libgtk-3-dev`
 - `libjson-glib-dev`
 - `libsoup2.4-dev`
 - `libunity-dev`


Use the App script to simplify installation by running `./app install-deps`
 
 ### Building

```
git clone {{ repo-url }}.git com.github.calo001.fondo && cd com.github.calo001.fondo
./app install-deps && ./app install
```

### Deconstruct

```
./app uninstall
```

### Development & Testing

Fondo includes a script to simplify the development process. This script can be accessed in the main project directory through `./app`.

```
Usage:
  ./app [OPTION]

Options:
  clean             Removes build directories (can require sudo)
  generate-i18n     Generates .pot and .po files for i18n (multi-language support)
  install           Builds and installs application to the system (requires sudo)
  install-deps      Installs missing build dependencies
  run               Builds and runs the application
  uninstall         Removes the application from the system (requires sudo)
```


### License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE.md) file for details.
=======
# fondo
Unsplash wallpaper App for elementary OS
>>>>>>> fb18c57e20b3f621ef26c2a2b1e8c9b6c28c7d02
