class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/opt/kf5",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DBUILD_TESTING=OFF",
                            "-Wno-dev",
                            "-DQt5Xml_DIR=/opt/qt5/lib/cmake/Qt5Xml",
                            "-DQt5Network_DIR=/opt/qt5/lib/cmake/Qt5Network",
                            "-DKF5XmlGui_DIR=/opt/kf5/lib/cmake/KF5XmlGui",
                            "-DKF5Parts_DIR=/opt/kf5/lib/cmake/KF5Parts",
                            "-DKF5KIO_DIR=/opt/kf5/lib/cmake/KF5KIO",
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

end
