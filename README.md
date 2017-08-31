# Vidshare

This was my first Elixir Phoenix app (please forgive the horrible code ;) ). It is a clone of my Rails app Flatcasts which is a project I made for Flatiron School students. Flatiron's online lectures are unlisted YouTube videos that were shared via a Google Doc. This did not make it very easy for students find a particular lecture. Flatcasts allowed students and the instructors to add the lectures in a searchable format. The videos were able to be watched inside the app using YouTube embedded videos. Flatiron has since moved on to an internal tool for sharing lectures.

This app was the basis for my Elixir Phoenix tutorial: https://medium.brianemory.com/elixir-phoenix-creating-an-app-part-1-the-setup-6626264be03 (recently updated to using Phoenix 1.3).

I am in the process of updgrading this app to Phoenix 1.3. Since my tutorial is
based off this app, I will also have a chance to follow along the tutorial to
fix any mistakes I have made (I've found a few so far).

## Roadmap
- [ ] Update to Phoenix 1.3 including much needed refactoring (in progress)
- [ ] Change sign in and sign up to use Coherence instead of Google Ueberauth
- [ ] Organizations that create accounts can invite users to join their
  organization
- [ ] You can only see videos shared within your organization

## How it works

You must sign in via GitHub to add a video. To add a video, you only need the YouTube or Vimeo URL. You submit the URL and the video information is obtained from the YouTube or Vimeo API and added to the database. This allows the video to be watched within the app using the YouTube or Vimeo embed.

