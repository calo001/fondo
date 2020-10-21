project('com.github.calo001.fondo', 'vala', 'c', version : '1.3.10', license: 'GPL-3.0')


gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

asresources = gnome.compile_resources(
    'as-resources',
    join_paths('data', meson.project_name()) + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subdir('src')

dependencies = [
	dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0'),
    dependency('libsoup-2.4'),
    meson.get_compiler('vala').find_library('posix'),
]

executable(
    meson.project_name(),
    sources,
    asresources,
    dependencies: dependencies,
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
