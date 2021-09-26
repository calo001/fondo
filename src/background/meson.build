dependencies = [
	dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0')
]

sources = files(
    'Application.vala',
    'Main.vala',
    'Model.vala',
    'Dummy.vala'
)

executable(
    'com.github.calo001.fondo.background',
    sources,
    dependencies: dependencies,
    install: true
)