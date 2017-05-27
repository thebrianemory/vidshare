# Vidshare

This is a clone of my Rails app Flatcasts. Flatcasts was a project for Flatiron School students. The online lectures are unlisted YouTube videos that were shared via a Google Doc. This did not make it very easy for students find a particular lecture. Flatcasts allowed students and the instructors to add the lectures in a searchable format. The videos were able to be watched inside the add using YouTube embedded videos. Flatiron has since moved on to an internal tool for sharing lectures.

I wanted to use my idea as my first Elixir Phoenix project. I have thought of ways to expand my original idea and think it will be a good jumping off point to get my feet wet with Elixir and Phoenix.

## How it works

You must sign in via GitHub to add a video. To add a video, you only need the YouTube URL. You submit the URL
and the video information is obtained from the YouTube API and added to the database. This allows the video to be watched within the app using the YouTube embed.

## Future features

- Adding Vimeo videos
- Have organizations that a user is a part of. Videos added as part of an organization are only viewed by that organization.
