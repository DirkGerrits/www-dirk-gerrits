---
title: A week of ICRA'10
---

The first week of May I was in Anchorage, Alaska at the [2010 IEEE
International Conference on Robotics and
Automation](http://icra2010.grasp.upenn.edu/) (ICRA'10). In short, it
was an awesome event amidst great scenery, but for my tastes it was way
too large and too far away. (The US customs officer even asked me why
they decided to hold the event so far away from the rest of the world.)

![View from convention center balcony](/images/panorama.jpg)

<!--more-->

# Size

There were roughly 1,600 registered attendees, so the event was spread
out over two big convention centers. All of Anchorage's hotels were
packed with roboticists. It wasn't long until local cafetarias were
playing into this.

![Anchorage welcomes its new robot overlords](/images/robot-overlords.jpg)

More than 2,000 papers were submitted, of which 857 were accepted. While
that's an acceptance rate of only about 40%, it's still one heck of a
lot of papers! Instead of actual paper proceedings we received a booklet
called the "Conference Digest", containing a single slide for each
paper. With six slides on each side of each page, this thing is still
about the same size as the full proceedings to SoCG or
[EuroCG](../../../../index.html@p=601.html). The actual proceedings came
on a DVD, and my tablet PC lacks a DVD drive, so I have not been able to
look at them yet. But I presume that there is still *a lot* of space
left on the DVD, so I wonder why there is a 6-page limit on the
submitted papers. For the initial versions it makes sense, as this
reduces the reviewing load, but why not allow larger final versions?

# Diversity

<figure style="float: right; margin-left: 30px;">
<img src="/images/robocooking.jpg" title="Image from the slides of my talk" alt="Image from the slides of my talk">
<figcaption>Image from the slides of my talk</figcaption>
</figure>

To accomodate all these papers there were *thirteen* parallel tracks;
but really, it felt more like thirteen parallel *conferences*.
Robot-building disciplines like mechanical engineering, electrical
engineering, and computer science come together with application areas
for robotics such as the life sciences, geology, logistics, and
manufacturing. It seems like you could present research on just about
*any* topic ("X") at ICRA, provided you word it the right way ("X *using
robots*"). Heck, I attended one talk that went into anthropology! While
it was nice to get a glimpse of what is happening in other fields, and
how they all relate to one another, most speakers assumed the audience
already had intimate knowledge of their specific field and its acronyms.
I felt a bit left out, most of the time, and wondered whether that
described half the audience or just me.

# Workshops

<figure style="float: right; margin-left: 20px; margin-top: -10px;">
<img src="/images/vision.jpg" title="Willow Garage's PR2 checking us out" alt="Willow Garage's PR2">
<figcaption>Willow Garage's PR2</figcaption>
</figure>

On Monday I attended the workshop on [Best Practice in 3D Perception
and Modeling for Mobile
Manipulation](http://www.best-of-robotics.org/en/brics-events/icra2010-workshop.html).
My main take-away was that we've come farther than I thought, and that
the state-of-the-art is all freely available as open-source libraries.
You just download the [ROS](http://www.ros.org/) robot operating
system and [OpenCV](http://opencv.willowgarage.com/wiki/) computer
vision library, and you're all set. In a couple of lines of code you
can combine a stereo image into a single image where you know the
distance of each pixel to the camera. A bunch more lines and you can
build up a fully textured 3D model of the world from a stream of these
images, captured as the robot moves around.

Of course, that's when the tricky part starts of determining what all
the objects you are seeing are, and what you should do with them. This
is where the open problems are. The rest of the workshop had some talks
on these. All were interesting techniques for different kinds of special
cases, but we are still nowhere near dealing with the full variety of
objects humans deal with on a daily basis.

# Technical sessions

Tuesday till Thursday were exhausting. A 12-minute talk every 15 minutes
from 8:30 to 19:30, except for breaks and the occasional plenary or
keynote speakers who had longer talks. The sessions ended earlier on
Wednesday because of the conference banquet, but that's still more than
70 talks I attended. For many of them I only vaguely understood the
problem that was being solved, and usually had no idea what the
state-of-the-art was and how the presented method improved on it. Still,
there were a couple of talks I found really enjoyable.

-   My own talk was on pushing a disk with a disk-shaped robot, and it
    turns out there were two more talks on the subject of pushing
    (though all in different sessions, for some reason). In *A Dipole
    Field for Object Delivery by Pushing on a Flat Surface*, [Takeo
    Igarashi](http://www-ui.is.s.u-tokyo.ac.jp/~takeo/) presented a very
    simple and elegant algorithm for the same problem I looked at, and
    even showed how it worked with actual
    [Roombas](http://en.wikipedia.org/wiki/Roomba). The algorithm cannot
    (yet?) deal with obstacles, but I had a nice chat with him
    afterwards about future work. In *Dynamic Pushing Strategies for
    Dynamically Stable Mobile Manipulators*, [Pushkar
    Kolhe](http://www.pushkar.name/) (how awesomely appropriate is that
    name?) studied how a differently designed robot should push or pull
    in order to exert the most force. It turns out that pulling is
    actually better than pushing.

-   In *Adaptive Multi-Robot Coordination: A Game-Theoretic
    Perspective*, [Gal Kaminka](http://u.cs.biu.ac.il/~galk/) talked
    about a new protocol for moving robots to avoid colliding with each
    other. They could easily have had the paper accepted after just
    showing through experiment *that* their method works, and I would
    have thought nothing special of the talk. Instead, they went the
    extra mile in using game theory to also show *why* the method works.

-   In *Avoiding Zeno's Paradox in Impulse-Based Rigid Body Simulation*,
    [Evan Drumwright](http://robotics.usc.edu/~drumwrig/index.html)
    explained how physics simulation libraries such as
    [ODE](http://www.ode.org/) and [Bullet](http://bulletphysics.org/)
    get resting contacts wrong, and presents an alternative method that
    has been implemented in a new physics library called
    [Moby](http://physsim.sourceforge.net/).

-   My favorite talk actually won the best paper award in its
    category.  In *Gesture-Based Human-Robot Jazz Improvisation*, [Guy
    Hoffman](http://web.media.mit.edu/~guy/) presented his jam
    sessions with
    [Shimon](http://edition.cnn.com/2010/TECH/04/29/robot.musician/),
    a marimba-playing robot. Rather than play a preprogrammed piece of
    music, it improvises based on what the human is playing. The
    result [sounds great](http://www.youtube.com/watch?v=jqcoDECGde8),
    and the addition of a head that [head-bangs to the
    beat](http://www.youtube.com/watch?v=0YpZnVCiMiU) was a nice
    touch.  It really looks like it gets into the groove!

    <object width="416" height="374" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="ep"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="wmode" value="transparent" /><param name="movie" value="http://i.cdn.turner.com/cnn/.element/apps/cvp/3.0/swf/cnn_416x234_embed.swf?context=embed_edition&videoId=tech/2010/04/28/marimba.robot.cnn" /><param name="bgcolor" value="#000000" /><embed src="http://i.cdn.turner.com/cnn/.element/apps/cvp/3.0/swf/cnn_416x234_embed.swf?context=embed_edition&videoId=tech/2010/04/28/marimba.robot.cnn" type="application/x-shockwave-flash" bgcolor="#000000" allowfullscreen="true" allowscriptaccess="always" width="416" wmode="transparent" height="374"></embed></object>

# Tutorials

On Friday morning I went to the workshop on [Guaranteeing Safe
Navigation in Dynamic Environments](http://safety2010.inrialpes.fr/).
All great talks on how to avoid collisions among moving obstacles, each
illustrated with pretty videos. [Jur van den
Berg](http://www2.decf.berkeley.edu/~berg/) showed an especially
impressive video on simulating human movement in crowds.

<iframe width="640" height="360" src="//www.youtube-nocookie.com/embed/hpYdjHzHTkY?rel=0" frameborder="0" allowfullscreen></iframe>

Friday afternoon I attended the tutorial on [Real-Time Planning in
Dynamic and Partially-Known
Domains](http://www.seas.upenn.edu/~maximl/wt/ICRA10_trl/). It
emphasised how almost any planning problem can be reformulated as
finding a path in a graph where edges are labeled with a cost and/or
probability. The obvious way to do that is using A\* search, but I had
no idea how many different variants of A\* have been developed to deal
with different kinds of problems. Almost a dozen of them were explained,
having funky names like Fringe-Saving A\*, Lifelong Planning A\*, and
Anytime Repairing A\*.

# Homecoming

The A\* tutorial at the end was actually the first time during this
conference that I saw someone use theorems and complexity theory. What's
perhaps a little disturbing is that that actually made me feel
*relieved*, as if I had come home from a long ardous journey through the
wastelands. That's not to say that the other talks at the conference
were bad, but they were rather different from the kinds of talks I'm
used to. I think computational geometry may have spoiled me a bit in
that regard. I'm used to talks with clear, precise definitions and
theoretical analyses. It's easy to forget that in the "real world" one
deals with vague concepts and must rely on experimental validation.
