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

        kcmAboutDistrorcData = <<-CODE
        [General]
        Name=#{Ism.settings.systemName}
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/xdg/kcm-about-distrorc",kcmAboutDistrorcData)
    end

    def install
        super

        runLdconfigCommand
    end

end
