# Defined interactively
function add_var_to_keychain
    set var_name $argv[1]
    set var_value $argv[2]

    security add-generic-password -a "$USER" -s $var_name -w $var_value
    echo "Variable $var_name added to keychain!"
end
