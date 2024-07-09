import os
import curses
import subprocess

def main(stdscr):
    # Initialize curses
    curses.curs_set(0)
    stdscr.nodelay(0)
    stdscr.timeout(100)

    current_dir = os.path.expanduser("~")
    directories = [current_dir]
    index = 0
    selected_files = []

    while True:
        stdscr.clear()

        h, w = stdscr.getmaxyx()
        files = os.listdir(directories[-1])
        for idx, file in enumerate(files[:h-1]):  # Only display as many files as can fit in the window
            # If the file is selected, highlight it
            if file in selected_files:
                stdscr.attron(curses.color_pair(1))
            # If the file is currently highlighted, underline it
            if idx == index:
                stdscr.attron(curses.A_UNDERLINE)
            stdscr.addstr(idx, 0, file)
            stdscr.attroff(curses.A_UNDERLINE)
            stdscr.attroff(curses.color_pair(1))

        # Key handling
        key = stdscr.getch()

        # Scroll down
        if key == curses.KEY_DOWN and index < min(len(files) - 1, h - 2):
            index += 1
        # Scroll up
        elif key == curses.KEY_UP and index > 0:
            index -= 1
        # Select file or navigate into directory
        elif key == ord(' '):
            selected_file = os.path.join(directories[-1], files[index])
            if os.path.isdir(selected_file):
                directories.append(selected_file)
                index = 0
            else:
                if selected_file in selected_files:
                    selected_files.remove(selected_file)
                else:
                    selected_files.append(selected_file)
        # Navigate up a directory
        elif key == ord('b'):
            if len(directories) > 1:
                directories.pop()
                index = 0
        # Commit and push changes
        elif key == ord('a'):
            for file in selected_files:          
                commandline f"dotfiles add {file}"
                commandline -f execute
            break

        stdscr.refresh()

if __name__ == "__main__":
    curses.wrapper(main)