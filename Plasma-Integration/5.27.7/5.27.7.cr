class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                                            \
                                    -DCMAKE_BUILD_TYPE=Release                                              \
                                    -DBUILD_TESTING=OFF                                                     \
                                    -DQt5ThemeSupport_INCLUDE_DIR=/usr/include/qt5/QtThemeSupport/5.15.10   \
                                    -Wno-dev                                                                \
                                    ..",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end

