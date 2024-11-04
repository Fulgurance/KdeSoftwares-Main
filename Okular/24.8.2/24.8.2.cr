class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                                                                                            \
                                    -DCMAKE_BUILD_TYPE=Release                                                                                              \
                                    -DBUILD_TESTING=OFF                                                                                                     \
                                    -DFORCE_NOT_REQUIRED_DEPENDENCIES=\"LibSpectre;CHM;LibZip;DjVuLibre;EPub;QMobipocket;Discount;Poppler;TIFF;KF5KExiv2\"  \
                                    -Wno-dev                                                                                                                \
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

        fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/org.kde.okular.desktop",
                        text:       "Categories=Qt;KDE;Graphics;Office;Viewer;",
                        newText:    "Categories=Qt;KDE;Graphics;Viewer;")
    end

end
