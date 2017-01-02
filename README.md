# apt-remove-meta
A script to help remove all packages pulled by a debian metapackage

## Status
Not fully completed. But you can use it if you want.

## Installation
Download the archive zip or clone the repository.

## Usage
`cd` to the extracted directory and run

    ruby search-apt-log.rb

command. It will ask you to enter a search term or package name.

If an event is found with matching name, it will be shown. You can see which packages were
installed, removed, upgraded etc.

The most recent event will be listed at bottom.

## Todo
1. Add interactive UI
2. Add capability to reverse an action handled by the script


