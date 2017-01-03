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

Alternatively, You can supply the search term while invoking it like this

    ruby search-apt-log.rb wvdial

In this format, `wvdial` will be used as search term. If you input two or more words
those will be concatenated to form a single search term.

If an event is found with matching the term, it will be shown. You can see which packages were
installed, removed, upgraded on that event.

The most recent event will be listed at bottom.

## Todo
1. Support for more details if user desires.
2. Add capability to reverse an action handled by the script


