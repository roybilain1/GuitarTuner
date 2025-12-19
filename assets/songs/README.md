# Songs Audio Files

This folder contains audio files for the song previews in the guitar tuner app.

## Required Audio Files:

Add the following MP3 files to this folder for the audio preview feature to work:

1. `wonderwall.mp3` - Wonderwall by Oasis
2. `hotel_california.mp3` - Hotel California by Eagles
3. `wish_you_were_here.mp3` - Wish You Were Here by Pink Floyd
4. `sweet_child_o_mine.mp3` - Sweet Child O' Mine by Guns N' Roses
5. `blackbird.mp3` - Blackbird by The Beatles
6. `stairway_to_heaven.mp3` - Stairway to Heaven by Led Zeppelin
7. `house_of_the_rising_sun.mp3` - House of the Rising Sun by The Animals
8. `nothing_else_matters.mp3` - Nothing Else Matters by Metallica
9. `creep.mp3` - Creep by Radiohead
10. `good_riddance.mp3` - Good Riddance by Green Day

## File Format:
- Format: MP3
- Quality: Recommended 128kbps or higher
- Duration: 30-60 seconds clips are sufficient for previews

## Copyright Notice:
Make sure you have proper licensing for any audio files you add here. For development purposes, you can use:
- Royalty-free covers
- Short clips (fair use)
- Creative Commons licensed versions
- Original recordings

## Database Integration:
When you implement your backend, the `audioPath` field in the Song model will point to these files. You can later move these to a cloud storage solution like Firebase Storage, AWS S3, or similar.
