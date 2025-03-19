# If this is the name of a readable file, the Python commands in that file are
# executed before the first prompt is displayed in interactive mode.
# https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
#
# Sample code which supports concurrent interactive sessions, by only
# appending the new history is taken from
# https://docs.python.org/3/library/readline.html?highlight=readline#example
#
# The goal is to store interactive Python shell history in
# $XDG_DATA_HOME/python/history instead of ~/.python_history.

import atexit
import os
import readline

histfile = os.path.join(
    os.getenv("XDG_DATA_HOME", "~/.local/share"), "python", "history"
)

if not os.path.exists(histfile):
    os.makedirs(os.path.dirname(histfile), exist_ok=True)

if not os.path.isfile(histfile):
    if os.path.exists(histfile):
        os.remove(histfile)
    # Create an empty file
    open(histfile, "a").close()

readline.read_history_file(histfile)
h_len = readline.get_current_history_length()


def save(prev_h_len, histfile):
    new_h_len = readline.get_current_history_length()
    # Make the history file much bigger for relative suggestions
    readline.set_history_length(int(os.getenv("HISTSIZE", 1000000)))
    readline.append_history_file(new_h_len - prev_h_len, histfile)


atexit.register(save, h_len, histfile)

# Map TAB to auto-completion instead of the TAB symbol
readline.parse_and_bind("tab: complete")
