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
                                    -DBUILD_KCM_MOUSE_X11=OFF       \
                                    -DBUILD_KCM_TOUCHPAD_X11=OFF    \
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

        if option("Linux-Pam")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d")

            kdeData = <<-CODE
            auth requisite pam_nologin.so
            auth required pam_env.so
            auth required pam_succeed_if.so uid >= 1000 quiet
            auth include system-auth
            account include system-account
            password include system-password
            session include system-session
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/kde",kdeData)

            kdeNpData = <<-CODE
            auth requisite pam_nologin.so
            auth required pam_env.so
            auth required pam_succeed_if.so uid >= 1000 quiet
            auth required pam_permit.so
            account include system-account
            password include system-password
            session include system-session
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/kde-np",kdeNpData)

            kscreensaverData = <<-CODE
            auth include system-auth
            account include system-account
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/kscreensaver",kscreensaverData)
        end

        if !option("Emojier")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/plasma-emojier")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/org.kde.plasma.emojier.desktop")
        end
    end

end
