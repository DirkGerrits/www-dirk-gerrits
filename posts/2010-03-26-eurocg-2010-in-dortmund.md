---
title: EuroCG 2010 in Dortmund
---

Last Wednesday evening I returned from [EuroCG
2010](http://2010.eurocg.org) held in Dortmund, Germany.  The weather
was nice throughout the conference, and so were the food and
drinks. (Although some people did not seem to care for the coffee in
the lobby, but I'm not a coffee drinker.) [Jan
Vahrenhold](http://ls11-www.cs.uni-dortmund.de/staff/jv) and his team
made this into a very smoothly run event, even in the presence of some
unforeseen cancellations of talks.

<!--more-->

A lot of interesting topics were presented in talks ranging in quality
from moderate to excellent. I have to give special mention to [Amit
Chattopadhyay](http://www.math.rug.nl/~amit/Site/Amit_Chattopadhyay.html).
When the speakers for the talk *2-Factor Approximation Algorithm for
Computing Maximum Independent Set of a Unit Disk Graph*" could not
attend the conference, he offered to give the talk instead of letting
it get cancelled. Not being one of the authors, nor being affiliated
with them, he just read their article and their slides a day in
advance and gave a talk on-the-fly. Kudos!

Fast-forward sessions
---------------------

As decided by vote at the business meeting of [EuroCG
2009](http://2009.eurocg.org), this year's EuroCG was the first to
have fast-forward sessions. In these short sessions, all conference
attendees are together in one room. The speakers of the next two
parallel sessions get 60 seconds each (with slides submitted in
advance) to promote their talks. There is a coffee or lunch break
before the actual parallel sessions start, and then the process
repeats. This way, attendees are supposed to be able to make a more
informed choice about which talks they want to attend.

This notion ~~stolen from~~ inspired by
[SIGGRAPH](http://www.siggraph.org/) was still a bit unfamiliar to
both organizers and speakers. During the first few fast-forward
sessions the speakers were asked to go in "column order", that is,
first all the speakers of session A, then all speakers of session
B. At the suggestion of several attendees, this was changed to "row
order" so that "competing" speakers went one after another. This order
was then kept for the rest of the conference.

In both orders, the speaker of session A always came before the parallel
speaker of session B. This seemed unfair to me, but no one present seems
to have used this to their benefit. More generally, I think most
speakers (myself included) did not think the fast-forward through from a
strategic point of view. My parallel speaker even had a slide with the
title of our paper on it, saying something to the effect of "this guy is
speaking in parallel to me, and his talk will surely also be nice".
Certainly a nice gesture, but I'm not entirely sure why someone would
do this except to get a smaller audience.

All in all, I quite like the concept. Skimming the proceedings in
advance says something of the topics, but not of the speakers. The
addition of fast-forward sessions thus gives one this extra variable by
which to decide which talks to attend. At the business meeting, the vote
was *n*-3 against 3 in favor of keeping the fast-forward sessions, so
they will be used again at EuroCG 2011 held in Morschach, Switzerland.

Keynote speaker
---------------

Although all the invited speakers gave excellent talks, the one by
[Timothy Chan](http://www.cs.uwaterloo.ca/~tmchan/) was the most
memorable to me. With his inimitable enthusiasm he gave a one-hour
talk on *Instance-Optimal Geometric Algorithms*.

He explained the concept using the example of computing 2D convex hulls.
For some, "easy" sets *S* of *n* points there are algorithms to compute
its *h*-point convex hull in *O(n)* time, while for other, "hard" point
sets different algorithms with a running time of *O(n* log *h)* are
known to be optimal.

![An "easy" (left) and a "hard" (right) point set for computing the
convex hull](/images/easy-hard-convex-hull.png "An "easy" and a "hard"
point set for computing the convex hull")

Timothy defined a function *H* (somewhat similar to
[entropy](http://en.wikipedia.org/wiki/Entropy#Entropy_and_information_theory))
so that *H(S)* is a number that measures how "hard" it is to compute
the convex hull for point set *S*. More precisely, he proved that
there is a *Ω(H(S))* lower bound for computing the 2D convex hull in
the multilinear decision-tree model, by a simple and elegant adversary
argument. He also showed that a slight modification of the
[Kirkpatrick-Seidel convex-hull
algorithm](http://en.wikipedia.org/wiki/Kirkpatrick%E2%80%93Seidel_algorithm)
yields a running time of *O(H(S))*. Thus its running time (up to
constant factors) is as good or better than any other 2D convex hull
algorithm that does not depend on the order of the points.

Timothy ended the talk with applications of the same technique to
other problems, which in some cases did require new algorithms, such
as for 3D convex hull. All in all a very impressive talk on some very
impressive research, the paper for which can be found on [Timothy's
website](http://www.cs.uwaterloo.ca/~tmchan/pub.html).
