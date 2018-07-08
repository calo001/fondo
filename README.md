<div align="center">
  <span align="center"> <img width="80" height="70" class="center" src="{{ repo-url }}/blob/master/data/images/com.github.calo001.fondo.png" alt="Icon"></span>
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
  <a href="{{ repo-url }}/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/License-AGPL-3.0-blue.svg">
  </a>
  <a href="{{ repo-url }}/releases">
    <img src="https://img.shields.io/badge/Release-v%201.0.0-orange.svg">
  </a>
</p>

<p align="center">
    <img  src="{{ repo-url }}/blob/master/data/images/screenshot.png" alt="Screenshot"> <br>
  <a href="{{ repo-url }}/issues/new"> Report a problem! </a>
</p>

## Installation

### Dependencies
These dependencies must be present before building:
 - `meson`
 - `valac`
 - `debhelper`
 - `libappindicator3-dev`
 - `libgranite-dev`
 - `libgtk-3-dev`
 - `libjson-glib-dev`
 - `libsoup2.4-dev`


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
  test              Builds and runs testing for the application
  test-run          Builds application, runs testing and if successful application is started
  uninstall         Removes the application from the system (requires sudo)
```

### Contributing

To help, access the links below:

- [Guide on Code Style]({{ repo-url }}/wiki/Guide-on-code-style)

- [Proposing Design Changes]({{ repo-url }}/wiki/Proposing-Design-Changes)

- [Reporting Bugs]({{ repo-url }}/wiki/Reporting-Bugs)

- [Translate]({{ repo-url }}/wiki/Translate)


### License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE.md) file for details.
