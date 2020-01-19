<div align="center">
  <span align="center"> <img width="120" height="120" class="center" src="https://raw.githubusercontent.com/calo001/fondo/master/data/images/com.github.calo001.fondo.png" alt="Icon"></span>
  <h1 align="center">Fondo</h1>
  <h3 align="center"></h3>
</div>

<br/>

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.calo001.fondo" target="_blank">
        <img src="https://appcenter.elementary.io/badge.svg">
    </a>
    <a href='https://flathub.org/apps/details/com.github.calo001.fondo' target="_blank"><img width='150' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.png'/></a>
</p>

<p align="center">
  <a href="https://github.com/calo001/fondo">
    <img src="https://img.shields.io/badge/Version-1.3.8-orange.svg">
  </a>
  <a href="https://github.com/calo001/fondo/blob/master/LICENSE.md">
    <img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg">
  </a>
  <a href="https://travis-ci.org/calo001/fondo">
    <img src="https://travis-ci.org/calo001/fondo.svg?branch=master">
  </a>
</p>

<p align="center">
    <img src="data/images/screenshot_1.png" alt="Screenshot">
    <table>
      <tr>
        <td>
          <img src="data/images/screenshot_2.png" alt="Screenshot">
        </td>
        <td>
          <img src="data/images/screenshot_3.png" alt="Screenshot">
        </td>
        <td>
          <img src="data/images/screenshot_4.png" alt="Screenshot">
        </td>
        <td>
          <img src="data/images/screenshot_5.png" alt="Screenshot">
        </td>
      </tr>
    </table>
</p>
<p align="center">
  <a href="https://github.com/calo001/fondo/issues/new">Report a problem!</a>
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


Use the App script to simplify installation by running `./app install-deps`, in this case, make sure that `dpkg-dev` package is installed
 
 ### Building

```
git clone https://github.com/calo001/fondo.git && cd com.github.calo001.fondo
./app install-deps && ./app install
```

### Deconstruct

```
./app uninstall
```

### Development

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

## Support me

Fondo is and will always be free for the world 🌎️. If you like the project and would like to fund and contribute to my work, you can do it via Patreon or Paypal.Me:

<p align="center">
  <a href="https://www.paypal.me/calo001" target="_blank">
    <img src="resources/paypalme.png" alt="Screenshot">
  </a>
</p>
<p align="center">
  <a href="https://www.patreon.com/carloslr" target="_blank">
      <img src="resources/become_a_patron_button.png" alt="Screenshot">
  </a>
</p>


## Special thanks

<p align="center">
  <a href="http://unsplash.com" target="_blank">
    <img src="resources/unsplash_logo.png" alt="Screenshot" width="300px">
  </a>
</p>
<p align="center">
Beautiful, free photos.
Gifted by the world’s most generous community of photographers. 🎁
</p>

### Support, help & inspiration

- [KJ Lawrence](https://github.com/kjlaw89) for making easier the development of apps for elementary OS with [Archetype](https://appcenter.elementary.io/com.github.kjlaw89.archetype/)
- [Cassidy James Blaede](https://github.com/cassidyjames) for his apps to use as code examples
- [Daniel Foré](https://github.com/danrabbit) for his help in the google + community
- [Ricardho](https://github.com/ricdev2) ideas, support and UX
- [Andres Lopez](https://github.com/andreslopezrm) ideas and support
- [VeckCol](https://github.com/VeckCol) ideas, support and translations

### Flatpak maintainers
- [Bilal Elmoussaoui](https://github.com/bilelmoussaoui)
- [Yi-Soo An](https://github.com/memnoth)

### Translators
- [Rafael C. Nunes](https://github.com/rafaelcn) Brazilian Portuguese
- [NathanBnm](https://github.com/NathanBnm) French
- [Heimen Stoffels](https://github.com/Vistaus) Dutch (Netherlands)
- [Onno Giesmann](https://github.com/Etamuk) Turkish and German

## License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE.md) file for details.
