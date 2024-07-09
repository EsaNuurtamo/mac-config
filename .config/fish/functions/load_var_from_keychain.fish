# Defined interactively
function load_var_from_keychain
    set var_name $argv[1]
    set var_value (security find-generic-password -a "$USER" -s $var_name -w)

    if test -n "$var_value"
        set -gx $var_name $var_value
    end
end
