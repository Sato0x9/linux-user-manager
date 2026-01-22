#!/usr/bin/env bash
# ==================================================
# Root check (mandatory)
# ==================================================
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run this script as root using sudo."
    exit 1
fi

# ==================================================
# Main menu loop
# ==================================================
while true; do
    echo ""
    echo "====== Linux User & Permission Manager ======"
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Create Group"
    echo "4. Add User to Group"
    echo "5. Set File Permissions"
    echo "6. Exit"
    echo "============================================"
    read -p "Choose an option: " choice

    case $choice in

        # --------------------------------------------------
        # 1. Create User
        # --------------------------------------------------
        1)
            read -p "Enter username to create: " username

            if [[ -z "$username" ]]; then
                echo "❌ Username cannot be empty."
                continue
            fi

            if id "$username" &>/dev/null; then
                echo "❌ User '$username' already exists."
            else
                useradd -m "$username"
                echo "✅ User '$username' created with home directory."
            fi
            ;;

        # --------------------------------------------------
        # 2. Delete User (admin-aware, safe cleanup)
        # --------------------------------------------------
        2)
            read -p "Enter username to delete: " username

            if [[ -z "$username" ]]; then
                echo "❌ Username cannot be empty."
                continue
            fi

            if ! id "$username" &>/dev/null; then
                echo "❌ User '$username' does not exist."
                continue
            fi

            homedir="/home/$username"
            read -p "Delete home directory too? (y/n): " confirm

            if [[ "$confirm" =~ ^[yY]$ ]]; then
                if [[ -d "$homedir" ]]; then
                    owner_uid=$(stat -c %u "$homedir")
                    user_uid=$(id -u "$username")

                    if [[ "$owner_uid" -ne "$user_uid" ]]; then
                        echo "⚠️ Home directory exists but is not owned by $username."
                        read -p "Force delete home directory anyway? (y/n): " force

                        if [[ "$force" =~ ^[yY]$ ]]; then
                            userdel "$username"
                            rm -rf "$homedir"
                            echo "✅ User '$username' and home directory forcibly removed."
                        else
                            userdel "$username"
                            echo "✅ User deleted. Home directory preserved."
                        fi
                    else
                        userdel -r "$username"
                        echo "✅ User '$username' and home directory deleted."
                    fi
                else
                    userdel "$username"
                    echo "✅ User '$username' deleted. No home directory found."
                fi
            else
                userdel "$username"
                echo "✅ User '$username' deleted (home preserved)."
            fi
            ;;

        # --------------------------------------------------
        # 3. Create Group
        # --------------------------------------------------
        3)
            read -p "Enter group name to create: " groupname

            if [[ -z "$groupname" ]]; then
                echo "❌ Group name cannot be empty."
                continue
            fi

            if getent group "$groupname" >/dev/null; then
                echo "❌ Group '$groupname' already exists."
            else
                groupadd "$groupname"
                echo "✅ Group '$groupname' created."
            fi
            ;;

        # --------------------------------------------------
        # 4. Add User to Group
        # --------------------------------------------------
        4)
            read -p "Enter username: " username
            read -p "Enter group name: " groupname

            if [[ -z "$username" || -z "$groupname" ]]; then
                echo "❌ Username and group name cannot be empty."
                continue
            fi

            if ! id "$username" &>/dev/null; then
                echo "❌ User '$username' does not exist."
                continue
            fi

            if ! getent group "$groupname" >/dev/null; then
                echo "❌ Group '$groupname' does not exist."
                continue
            fi

            usermod -aG "$groupname" "$username"
            echo "✅ User '$username' added to group '$groupname'."
            ;;

        # --------------------------------------------------
        # 5. Set File Permissions
        # --------------------------------------------------
        5)
            read -p "Enter file or directory path: " path

            if [[ -z "$path" ]]; then
                echo "❌ Path cannot be empty."
                continue
            fi

            if [[ ! -e "$path" ]]; then
                echo "❌ Path does not exist."
                continue
            fi

            read -p "Enter numeric permissions (e.g. 750): " perms

            if [[ ! "$perms" =~ ^[0-7]{3}$ ]]; then
                echo "❌ Invalid permission format."
                continue
            fi

            read -p "Enter owner (user:group): " owner

            if [[ ! "$owner" =~ ^[^:]+:[^:]+$ ]]; then
                echo "❌ Invalid owner format. Use user:group"
                continue
            fi

            chmod "$perms" "$path"
            chown "$owner" "$path"
            echo "✅ Permissions updated successfully."
            ;;

        # --------------------------------------------------
        # 6. Exit
        # --------------------------------------------------
        6)
            echo "Exiting..."
            exit 0
            ;;

        *)
            echo "❌ Invalid option"
            ;;
    esac
done

