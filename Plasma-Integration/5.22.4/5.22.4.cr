class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/opt/kf5",
                            "-DQt5ThemeSupport_LIBRARY=/opt/qt5/lib/libQt5ThemeSupport.a",
                            "-DQt5ThemeSupport_INCLUDE_DIR=/opt/qt5/include/QtThemeSupport/5.15.2",
                            "-DQt5DBus_DIR=/opt/qt5/lib/cmake/Qt5DBus",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DBUILD_TESTING=OFF",
                            "-Wno-dev",
                            ".."],
                            buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

    def install
        super

        runLdconfigCommand
    end

end
