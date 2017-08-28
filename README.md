# Vidshare

This was my first Elixir Phoenix app (please forgive the horrible code ;) ). It is a clone of my Rails app Flatcasts which is a project I made for Flatiron School students. Flatiron's online lectures are unlisted YouTube videos that were shared via a Google Doc. This did not make it very easy for students find a particular lecture. Flatcasts allowed students and the instructors to add the lectures in a searchable format. The videos were able to be watched inside the app using YouTube embedded videos. Flatiron has since moved on to an internal tool for sharing lectures.

This app was the basis for my Elixir Phoenix tutorial: https://medium.brianemory.com/elixir-phoenix-creating-an-app-part-1-the-setup-6626264be03 (recently updated to using Phoenix 1.3).

I am in the process of updating this to Phoenix 1.3. It will get some much
needed refactoring along the way (some of which I did when I updated my
tutorial). I will be changing the process of logging in so that an organization
would create an account and then invite their team to join. Videos shared
within an organization are only visible by those in the organization.

The update version, VideoShare, will be here:
https://github.com/thebrianemory/videoshare.

## How it works

You must sign in via GitHub to add a video. To add a video, you only need the YouTube or Vimeo URL. You submit the URL and the video information is obtained from the YouTube or Vimeo API and added to the database. This allows the video to be watched within the app using the YouTube or Vimeo embed.

