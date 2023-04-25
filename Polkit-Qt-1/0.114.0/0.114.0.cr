class Target < ISM::Software

    def extract
        super

        moveFile("#{workDirectoryPath(false)}/polkit-qt-1-0.114.0","#{workDirectoryPath(false)}/v0.114.0")
    end

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
