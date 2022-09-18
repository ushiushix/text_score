# Text Score
Simple web app to create/edit/play songs with text_sequencer

## About
[text_sequencer](https://github.com/ushiushix/text_sequencer) provides a dsl which allows us to write music scores by note-st-gt-velocity format, then convert it to MIDI using midilib.

Text Score is web application to make text_sequencer usable with your browser.
You can input multi-track scores by text_sequencer notation, and make it renderd via timidity and lame in server-side. You can listen to it in the browser using HTML5 audio or flash by [audio5js](https://github.com/zohararad/audio5js).

## Setup

You will need:
- ruby 3.1.x or higher
- timidity++ properly configured with good GS-compatible soundfont like FluidR3_GM2
- lame encoder

1. Clone this repository.
1. Do `bundle install`.
1. Create sqlite database and tables by:
    ```
    bundle exec padrino rake db:migrate
    ```
1. Create admin user by:
    ```
    bundle exec padrino rake db:seed
    ```
1. Run the server:
    ```
    bundle exec padrino start
    ```

Now you can visit http://localhost:3000 to see the login page.

## History

This project is started originally for myself, and I used it in a workshop in [Jump2Science](http://www.jump2science.org/activity_summer-camp.html) summer camp for blind students from 2012.

## Disclaimer

Please note:
- This application is designed for internal network within limited users. Deployment to the internet-connected servers is not recommended for now.
- The visual appearance has not been considered so much because the primary users are screen-reader users.

There is no warranty of any kind.

Contributions are always welcomed.

## License

See the file "LICENSE.

Copyright (c) 2012 - 2017 Koichi Inoue.



