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
                            "-DBUILD_kwrite=OFF",
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

        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/org.kde.kate.desktop",
                        "Categories=Qt;KDE;Utility;TextEditor;Development;",
                        "Categories=Qt;KDE;Utility;TextEditor;")

        if option("MultipleInstances")
            fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/org.kde.kate.desktop",
                        "Exec=kate -b %U",
                        "Exec=kate -n")
        end
    end

end
