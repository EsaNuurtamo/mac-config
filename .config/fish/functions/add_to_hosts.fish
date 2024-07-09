# Defined interactively
function add_to_hosts
    if test (count $argv) -ne 2
        echo "Usage: add_to_hosts [IP] [domain]"
        return 1
    end

    set ip $argv[1]
    set domain $argv[2]

    echo "$ip $domain" | sudo tee -a /etc/hosts
    echo "Added $ip $domain to /etc/hosts"
end
