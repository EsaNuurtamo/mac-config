# Defined interactively
function wifi_reset
    networksetup -setairportpower en0 off
    networksetup -setairportpower en0 on
end
