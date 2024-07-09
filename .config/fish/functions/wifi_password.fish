# Defined interactively
function wifi_password
    security find-generic-password -wa (wifi_network_name)
end
