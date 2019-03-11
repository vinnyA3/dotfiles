Config { font = "xft:GohuFont:style=Regular:pixelsize=12:antialias=true:hinting=false"
       , additionalFonts = ["xft:Siji:style=Regular:size=9"]
       , bgColor = "#282A36"
       , fgColor = "#E6E6E6"
       , alpha = 255
       , position = TopSize C 100 32
       , lowerOnStart = True
       , pickBroadest = False
       , persistent = True
       , hideOnStart = False
       , allDesktops = True
       , overrideRedirect = True
       , commands = [ Run Cpu ["-t", "<fc=#8BE9FD><fn=1>\xe0c2</fn></fc> <total>", "-L","3","-H","50",
                               "--high","#FF5555", "-S", "True", "-w", "3",
                               "-c", "0"] 10
                    , Run Memory [ "-t","<fc=#FF79C6><fn=1>\xe0c5</fn></fc> <usedratio>",
                      "-S", "True", "-w", "3", "-c", "0"] 10
                    , Run Volume "default" "Master" ["-t", "<status> <volume>%"
                        , "--", "-O", "<fc=#FF6E67><fn=1>\xe05d</fn></fc>"
                        , "-o", "<fc=#FF6E67><fn=1>\xe052</fn></fc>"] 10
                    , Run Weather "KEWR" ["-t"
                        , "<fc=#F1FA8C><fn=1>\xe0cf</fn></fc> <tempF><fc=#E6E6E6><fn=2>\xfa04</fn></fc>, rh <rh>% [<hour>]"] 36000
                    , Run Date "<fc=#BD93F9><fn=1>\xe016</fn></fc> %a %b %d %H:%M" "date" 60
                    , Run Mpris2 "cmus" ["-t"
                        , "<fc=#50FA7B><fn=1>\xe195</fn></fc> <artist> <fc=#6d7c8c>-</fc> <title> <fc=#50FA7B><fn=1>\xe195</fn></fc>"
                        , "-M", "200", "-x", ""] 10
                    , Run XMonadLog
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "  %XMonadLog% }%mpris2%{ %default:Master%    %cpu%    %memory%    %KEWR%    %date%   "
}
