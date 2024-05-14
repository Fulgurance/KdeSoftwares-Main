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

        fileReplaceText("#{buildDirectoryPath}/usr/share/xsessions/plasma.desktop","Exec=/usr/bin/startplasma-x11","Exec=dbus-launch --exit-with-session startplasma-x11")
        fileReplaceText("#{buildDirectoryPath}/usr/share/xsessions/plasma.desktop","TryExec=/usr/bin/startplasma-x11","TryExec=dbus-launch --exit-with-session startplasma-x11")

        ffileReplaceText("#{buildDirectoryPath}/usr/share/xsessions/plasmawayland.desktop","Exec=/usr/lib/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland","Exec=dbus-launch --exit-with-session startplasma-wayland")
        fileReplaceText("#{buildDirectoryPath}/usr/share/xsessions/plasmawayland.desktop","TryExec=/usr/bin/startplasma-wayland","TryExec=dbus-launch --exit-with-session startplasma-wayland")

        if option("Linux-Pam")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d")

            kdeData = <<-CODE
            auth requisite pam_nologin.so
            auth required pam_env.so
            auth required pam_succeed_if.so uid >= 1000 quiet
            auth include system-auth
            account include system-account
            password include system-password
            session include system-session
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/kde",kdeData)

            kdeNpData = <<-CODE
            auth requisite pam_nologin.so
            auth required pam_env.so
            auth required pam_succeed_if.so uid >= 1000 quiet
            auth required pam_permit.so
            account include system-account
            password include system-password
            session include system-session
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/kde-np",kdeNpData)

            kscreensaverData = <<-CODE
            auth include system-auth
            account include system-account
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/kscreensaver",kscreensaverData)
        end

        if !option("Emojier")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/plasma-emojier")
            deleteFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/applications/org.kde.plasma.emojier.desktop")
        end
    end

    def install
        super

        runLdconfigCommand
    end

end
