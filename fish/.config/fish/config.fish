source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # smth smth
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/zago/.lmstudio/bin
# End of LM Studio CLI section

fish_add_path /home/zago/.spicetify
