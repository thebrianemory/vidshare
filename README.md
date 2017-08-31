# Vidshare
This was the first app that I built on my own after learning Elixir and Phoenix. Recently updated to use Phoenix 1.3. This app was the basis for my Elixir Phoenix tutorial: https://medium.brianemory.com/elixir-phoenix-creating-an-app-part-1-the-setup-6626264be03 (recently updated to using Phoenix 1.3 as well).

## Roadmap
- [x] Update to Phoenix 1.3 including much needed refactoring
- [ ] Change sign in and sign up to use Coherence instead of Google Ueberauth
- [ ] Organizations that create accounts can invite users to join their
  organization
- [ ] You can only see videos shared within your organization

## How it works

You must sign in via GitHub to add a video. To add a video, you only need the YouTube or Vimeo URL. You submit the URL and the video information is obtained from the YouTube or Vimeo API and added to the database. This allows the video to be watched within the app using the YouTube or Vimeo embed.

