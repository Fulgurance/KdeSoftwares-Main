class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr    \
                                    -DCMAKE_BUILD_TYPE=Release      \
                                    -DBUILD_TESTING=OFF             \
                                    -DBUILD_QT6=ON                  \
                                    -DBUILD_QT5=OFF                 \
                                    -Wno-dev                        \
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

