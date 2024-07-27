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

        fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/wayland-sessions/plasmawayland.desktop",
                        text:       "Exec=/usr/lib/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland",
                        newText:    "Exec=/usr/lib64/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland")
    end

end
