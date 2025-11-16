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
                                    -DBUILD_kwrite=OFF              \
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

        fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/org.kde.kate.desktop",
                        text:       "Categories=Qt;KDE;Utility;TextEditor;Development;",
                        newText:    "Categories=Qt;KDE;Utility;TextEditor;")

        if option("MultipleInstances")
            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/org.kde.kate.desktop",
                            text:       "Exec=kate -b %U",
                            newText:    "Exec=kate -n")
        end
    end

end
