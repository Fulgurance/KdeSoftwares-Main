class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DBUILD_TESTING=OFF",
                            "-DFORCE_NOT_REQUIRED_DEPENDENCIES=LibSpectre,KF5KExiv2,CHM,LibZip,DjVuLibre,EPub,QMobipocket,Discount",
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

        fileReplaceText("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/org.kde.okular.desktop",
                        "Categories=Qt;KDE;Graphics;Office;Viewer;",
                        "Categories=Qt;KDE;Graphics;Viewer;")
    end

end
