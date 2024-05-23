<p align="center">
    <img src='./img/logo.png'>
</p>

<h1 align="center">RPG Maker Database Tool</h1>
<h3 align="center">This extension should be used for development purposes only!</h3>

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
  - [Command Syntax](#command-syntax)
  - [Basic Information](#basic-information)
  - [Options](#options)
    - [--debug](#--debug)
    - [--backup, --no-backup](#--backup---no-backup)
    - [-d, --directory](#-d---directory)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Introduction

RGSS Database is a tool designed for developers to export and import the database files of a game created in RPG Maker.

This gem is compatible with any RPG Maker editor based on RGSS, including:

- RPG Maker XP
- RPG Maker VX
- RPG Maker VX Ace

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

You can install this gem using the following

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

## Usage

### Command Syntax

```sh
rgss-db data_directory [options]
```

### Basic Information

You can simply use this tool by calling the rgss-db command and supplying a RPG Maker data path:

```sh
# Opens the current directory
rgss-db .
```

The path needs to be the data folder where all binary database files are stored, otherwise the app won't work.

This will open the application's menu where you can manually perform the desired actions:

- **Export**: Exports all RPG Maker binary database files into human-readable data files:
  - YAML
  - JSON
- **Import**: Creates new RPG Maker binary files from previously exported files

The application has a number of options that allow you to customize the behavior and output of the application, you can check more about this below

### Options

#### --debug

You can set the application's debug mode with the following option

A log file will be created inside the application's working directory

```sh
rgss-db . --debug 0 # Disables debug functionality (default)
rgss-db . --debug 1 # Enables debug error level
rgss-db . --debug 2 # Enables debug warning level
rgss-db . --debug 3 # Enables debug info level
```

#### --backup, --no-backup

You can enable/disable the automatic backup creation with these flags

```sh
rgss-db . --backup      # Backups are created (default)
rgss-db . --no-backup   # Backups are not created
```

#### -d, --directory

Sets the application's working directory (used for exporting and importing)

```sh
rgss-db . -d "./custom_path/from/the data folder"
rgss-db . -d "C:/Absolute/Path/To/A Folder"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SnowSzn/rgss-db-cli/issues.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/SnowSzn/rgss-db-cli/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [GNU General Public License version 3 License](https://opensource.org/license/gpl-3-0).

## Code of Conduct

Everyone interacting in the RGSS Database project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SnowSzn/rgss-db-cli/blob/main/CODE_OF_CONDUCT.md).
