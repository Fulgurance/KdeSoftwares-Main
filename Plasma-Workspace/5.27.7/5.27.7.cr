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

        fileReplaceTextAtLineNumber("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/xsessions/plasma.desktop","Exec=/usr/bin/startplasma-x11","Exec=dbus-launch --exit-with-session startplasma-x11",3)
        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/xsessions/plasma.desktop","TryExec=/usr/bin/startplasma-x11","TryExec=/usr/bin/startplasma-x11")
        fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/wayland-sessions/plasmawayland.desktop","Exec=/usr/lib/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland","Exec=dbus-launch --exit-with-session startplasma-wayland")
    end

    def install
        super

        runLdconfigCommand
    end

end
