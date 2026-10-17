# frozen_string_literal: true

# pygments.rb runs mentos.py through its shebang by passing a single-element argv to Open3.popen3.
# Ruby treats a single-string command as a shell-like command line and splits it by whitespace,
# so the build breaks when the repository path contains spaces.
# Passing an explicit interpreter makes the argv two elements long, which Ruby executes verbatim.
require 'pygments'

Pygments.engine.python_binary = 'python3'
