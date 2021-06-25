# Atom RSpec Runner Package

Add ability to run RSpec and see the output without leaving Atom.

HotKeys:

- __Ctrl+Alt+T__ - executes all specs the current file
- __Ctrl+Alt+X__ - executes only the spec on the line the cursor's at
- __Ctrl+Alt+E__ - re-executes the last executed spec


## Configuration

By default this package will run `rspec` as the command.

You can set the default command by either accessing the Settings page (Cmd+,)
and changing the command option like below:


Or by opening your configuration file (clicking __Atom__ > __Open Your Config__)
and adding or changing the following snippet:

    'rspec':
      'command': 'bundle exec rspec'
