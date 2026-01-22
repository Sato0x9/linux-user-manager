# Linux User & Permission Manager (Bash)

A beginner-friendly Linux administration tool written in **Bash** to manage users, groups, and file permissions safely from the command line.

This project was built to understand how Linux handles users, groups, permissions, and root privileges at a fundamental level.

---

## Features

- Create users with home directories
- Delete users (with or without home directory removal)
- Create groups
- Add users to supplementary groups safely
- Set file and directory permissions
- Root privilege validation to prevent unsafe execution
- Menu-driven interface for clarity and safety

---

## Why this project?

Linux system administration relies heavily on understanding:
- the Linux user model
- permission bits (r, w, x)
- ownership and groups
- root vs non-root execution

This project focuses on **understanding before automation**, using only Bash and standard Linux utilities.

---

## What I learned

- How Linux represents users and groups internally
- Difference between primary and supplementary groups
- How file permissions actually work (not just memorizing chmod)
- Why administrative scripts must validate root privileges
- Writing safer Bash scripts with input validation
- Using Git and GitHub for version control

---

## Requirements

- Linux system (tested on Ubuntu via WSL)
- Root privileges (sudo access)
- Bash shell

---

## Usage

Make the script executable:

```bash
chmod +x user_manager.sh

