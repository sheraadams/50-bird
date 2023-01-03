# 50-bird
Flappy bird remake in lua for Harvard GD50

Updates: Randomize x and y locations of pipes as they spawn,  add a pause, sound,  button, and pause features, and add three award states and medals.

Be sure to watch Lecture 1 and read through the code so you have a firm understanding of how it works before diving in! In particular, take note of where the logic is for spawning pipes and the parameters that drive both the gap between pipes and the interval at which pipes spawn, as those will be two primary components of this update! You’ll be making some notable changes to the ScoreState, so be sure to read through that as well and get a sense for how images are stored, since you’ll be incorporating your own! Lastly, think about what you need in order to incorporate a pause feature (a simple version of which we saw in lecture!). And if we want to pause the music, we’ll probably need a method to do this that belongs to the audio object LÖVE gives us when we call love.audio.newSource; try browsing the documentation on the LÖVE2D wiki to find out what it is!

Specification: 

Randomize the gap between pipes (vertical space), such that they’re no longer hardcoded to 90 pixels.

Randomize the interval at which pairs of pipes spawn, such that they’re no longer always 2 seconds apart.

When a player enters the ScoreState, award them a “medal” via an image displayed along with the score; this can be any image or any type of medal you choose (e.g., ribbons, actual medals, trophies, etc.), so long as each is different and based on the points they scored that life. Choose 3 different ones, as well as the minimum score needed for each one (though make it fair and not too hard to test :)).

Implement a pause feature, such that the user can simply press “P” (or some other key) and pause the state of the game. This pause effect will be slightly fancier than the pause feature we showed in class, though not ultimately that much different. When they pause the game, a simple sound effect should play (I recommend testing out bfxr for this, as seen in Lecture 0!). At the same time this sound effect plays, the music should pause, and once the user presses P again, the gameplay and the music should resume just as they were! To cap it off, display a pause icon in the middle of the screen, nice and large, so as to make it clear the game is paused.

https://youtu.be/Mk-BOCxmzks

![22](https://user-images.githubusercontent.com/110789514/210417853-269ccf94-5433-438c-8933-785e58bed43d.png)
