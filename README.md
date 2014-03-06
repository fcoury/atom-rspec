# Atom RSpec Runner Package

Add ability to run RSpec and see the output without leaving Atom.

HotKeys:

- __Ctrl+Alt+T__ - executes all specs the current file
- __Ctrl+Alt+X__ - executes only the spec on the line the cursor's at
- __Ctrl+Alt+E__ - re-executes the last executed spec

![Screenshot](http://cl.ly/image/2G2B3M2g3l3k/stats_collector_spec.rb%20-%20-Users-fcoury-Projects-crm_bliss.png)

## Configuration

By default this package will run `rspec` as the command.

You can set the default command by either accessing the Settings page (Cmd+,)
and changing the command option like below:

![Configuration Screenshot](http://f.cl.ly/items/1h0N2N1V0E1M3d060w3N/atom-rspec-settings.png)

Or by opening your configuration file (clicking __Atom__ > __Open Your Config__)
and adding or changing the following snippet:

    'atom-rspec':
      'command': 'bundle exec rspec'
