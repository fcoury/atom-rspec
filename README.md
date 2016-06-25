# Atom RSpec Runner Package

[![ghit.me](https://ghit.me/badge.svg?repo=fcoury/atom-rspec)](https://ghit.me/repo/fcoury/atom-rspec)

Add ability to run RSpec and see the output without leaving Atom.

HotKeys:

- <kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>T</kbd> - executes all specs the current file
- <kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>X</kbd> - executes only the spec on the line the cursor's at
- <kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>E</kbd> - re-executes the last executed spec

> macOS users can use <kbd>option</kbd> instead of <kbd>alt</kbd>.

![Screenshot](http://cl.ly/image/2G2B3M2g3l3k/stats_collector_spec.rb%20-%20-Users-fcoury-Projects-crm_bliss.png)

## Configuration

By default this package will run `rspec` as the command.

You can set the default command by either accessing the Settings page (Cmd+,)
and changing the command option like below:

![Configuration Screenshot](http://f.cl.ly/items/2k1C0E0e1l2Z3m1l3e1R/Settings%20-%20-Users-fcoury-Projects-crm_bliss.jpg)

Or by opening your configuration file (clicking __Atom__ > __Config…__)
and adding or changing the following snippet:

    'rspec':
      command: 'bundle exec rspec'

> You may need to make a change like this if you see an error like:
>
> ```bash
> bash: line 1: undefined: command not found
> ```
