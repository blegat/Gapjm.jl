"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%A  curvintr.tex      VKCURVE documentation    David Bessis,  Jean Michel
%%
%Y  Copyright (C) 2001-2002  University  Paris VII.
%%
%%  This  file  introduces the VKCURVE package.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

The  main function of the VKCURVE  package computes the fundamental group
of  the  complement  of  a  complex  algebraic  curve  in  $\C^2$, using an
implementation  of the Van Kampen method  (see for example \cite{C73} for a
clear and modernized account of this method).

|    gap> FundamentalGroup(x^2-y^3);
    #I  there are 2 generators and 1 relator of total length 6
    1: bab=aba
    
    gap> FundamentalGroup((x+y)*(x-y)*(x+2*y));
    #I  there are 3 generators and 2 relators of total length 12
    1: cab=abc
    2: bca=abc|

The  input is  a  polynomial in  the  two variables  'x'  and 'y',  with
rational  coefficients.  Though  approximate calculations  are  used  at
various places, they are controlled and the final result is exact.

The output is a  record which  contains lots  of information  about the
computation, including a presentation of the computed fundamental group,
which is what is displayed when printing the record.

Our  motivation   for  writing  this   package  was  to   find  explicit
presentations for  generalized braid groups attached  to certain complex
reflection groups. Though presentations were known for almost all cases,
six exceptional  cases were  missing (in the  notations of  Shephard and
Todd, these  cases are $G_{24}$, $G_{27}$,  $G_{29}$, $G_{31}$, $G_{33}$
and $G_{34}$).  Since the a  priori existence of nice  presentations for
braid groups was proved in \cite{B01}, it was upsetting not to know them
explicitly. In the absence of any good grip on the geometry of these six
examples, brute force  was a way to  get an answer. Using  \VKCURVE , we
have  obtained  presentations for  all of them.

This package was developed thanks to computer resources of the Institut
de Math\accent 19  ematiques de Jussieu in Paris. We  thank the computer
support team,  especially Jo\accent 127  el Marchand, for  the stability
and the efficiency of the working environment.

We have tried to design this package with the novice \GAP\ user in mind.
The only steps required to use it are
\begin{itemize}
\item Run \GAP 3 (the package is not compatible with \GAP 4).
\item  Make  sure  the  packages   \CHEVIE\  and  \VKCURVE\  are  loaded
(beware   that  we   require   the  development   version  of   \CHEVIE,
'http\://www.math.jussieu.fr/\~{}jmichel/chevie.html' and not the one in
the \GAP.3.3.4 distribution)

\item Use the function 'FundamentalGroup',  as demonstrated in the above
examples.

\end{itemize}
If  you are  not interested  in  the details  of the  algorithm, and  if
'FundamentalGroup' gives you satisfactory  answers in a reasonable time,
then you do not need to read this manual any further.

\bigskip

We  use our  own  package  for multivariate  polynomials  which is  more
effective, for  our purposes, than  the default  in \GAP 3  (see 'Mvp').
When \VKCURVE\ is  loaded, the variables 'x' and 'y'  are pre-defined as
'Mvp's; one can  also use \GAP\ polynomials (which will  be converted to
'Mvp's).

The  implementation uses 'Decimal' numbers, 'Complex' numbers and braids as
implemented  in  the  (development  version  of  the)  package  \CHEVIE, so
\VKCURVE\ is dependent on this package.

To implement  the algorithms, we  needed to write  auxiliary facilities,
for instance find  zeros of complex polynomials, or  work with piecewise
linear  braids,  which  may  be  useful  on  their  own.  These  various
facilities are documented in this manual.

Before discussing  our actual  implementation, let  us give  an informal
summary of the mathematical background. Our strategy is adapted from the
one originally  described in the  1930\'s by Van  Kampen. Let $C$  be an
affine  algebraic curve,  given as  the  set of  zeros in  $\C^2$ of  a
non-zero  reduced  polynomial $P(x,y)$.  The  problem  is to  compute  a
presentation of the fundamental group of  $\C^2 - C$. Consider $P$ as a
polynomial in $x$, with coefficients in the ring of polynomials in $y$
$$P= \alpha_0(y)x^n +  \alpha_1(y) x^{n-1}  + \dots +  \alpha_{n-1}(y) x
+  \alpha_n(y),$$  where the  $\alpha_i$  are  polynomials in  $y$.  Let
$\Delta(y)$ be the discriminant of $P$ or, in other words, the resultant
of  $P$  and $\frac{\partial  P}{\partial  x}$.  Since $P$  is  reduced,
$\Delta$ is non-zero. For a generic  value of $y$, the polynomial in <x>
given by $P(x,y)$ has $n$ distinct roots.
When $y=y_j$, with $j$ in $1,\dots,d$,
we are in exactly one of
the following situations\:\ either $P(x,y_j)=0$
(we then say that $y_j$ is bad),
or $P(x,y_j)$ has a number of roots in $x$ strictly smaller than
$n$.
Fix $y_0$  in $\C  - \{y_1,\dots,y_d\}$.  Consider the  projection $p\:
\C^2  \rightarrow \C,  (x,y) \mapsto  y$.  It restricts  to a  locally
trivial  fibration with  base  space $B=  \C  - \{y_1,\dots,y_d\}$  and
fibers homeomorphic  to the  complex plane with  $n$ points  removed. We
denote by  $E$ the  total space  $p^{-1}(B)$ and by  $F$ the  fiber over
$y_0$. The fundamental  group of $F$ is isomorphic to  the free group on
$n$ generators.  Let $\gamma_1,\dots,\gamma_d$  be loops in  the pointed
space  $(B,y_0)$ representing  a generating  system for  $\pi_1(B,y_0)$.
By  trivializing  the pullback  of  $p$  along  $\gamma_i$, one  gets  a
(well-defined up to isotopy) homeomorphism  of $F$, and a (well-defined)
automorphism  $\phi_i$  of  the  fundamental group  of  $F$,  identified
with  the  free  group  $F_n$  by the  choice  of  a  generating  system
$f_1,\dots,f_n$. An effective way of  computing $\phi_i$ is by following
the solutions in $x$ of $P(x,y)=0$,  when $y$ moves along $\phi_i$. This
defines a loop in  the space of configuration of $n$  points in a plane,
hence an element  $b_i$ of the braid group $B_n$  (via an identification
of $B_n$  with the fundamental  group of this configuration  space). Let
$\phi$ be the Hurwitz action of $B_n$  on $F_n$. All choices can be made
in such a way that $\phi_i=\phi(b_i)$. The theorem of Van Kampen asserts
that, if there are no bad  roots of the discriminant, a presentation for
the fundamental group of $\C^2 -  C$ is $$\< f_1,\dots,f_n \mid \forall
i,j,  \phi_i(f_j)=f_j >  $$ A  variant  of the  above presentation  (see
'VKQuotient') can be used to deal with bad roots of the discriminant.

This algorithm is implemented in the following way.

\begin{itemize}
\item As input,  we have a polynomial $P$. The  polynomial is reduced if
it was not.

\item The discriminant $\Delta$ of $P$  with respect to $x$ is computed.
It is a polynomial in $y$.

\item  The  roots  of  $\Delta$  are  approximated,  via  the  following
procedure. First, we reduce  $\Delta$ and get $\Delta_{red}$ (generating
the   radical  of   the  ideal   generated  by   $\Delta$).  The   roots
$\{y_1,\dots,y_d\}$ of  $\Delta_{red}$ are separated  by 'SeparateRoots'
(which implements Newton\'s method).

\item Loops  around these roots are  computed by 'LoopsAroundPunctures'.
This function first computes some sort of honeycomb, consisting of a set
$S$  of  affine  segments,  isolating  the $y_i$.  Since  it  makes  the
computation of  the monodromy  more effective, each  inner segment  is a
fragment of the mediatrix of two roots of $\Delta$. Then a vertex of one
the segments is  chosen as a basepoint, and the  function returns a list
of lists of  oriented segments in $S$\:\ each list  of segment encodes a
piecewise linear loop $\gamma_i$ circling one of $y_i$.

\item For each  segment in $S$, we compute the  monodromy braid obtained
by  following  the  solutions  in  $x$  of  $P(x,y)=0$  when  $y$  moves
along  the segment.  By default,  this  monodromy braid  is computed  by
'FollowMonodromy'. The  strategy is to compute  a piecewise-linear braid
approximating the  actual monodromy geometric braid.  The approximations
are controlled. The piecewise-linear  braid is constructed step-by-step,
by computations of linear pieces. As soon as new piece is constructed, it
is converted into an element  of $B_n$ and multiplied; therefore, though
the  braid  may  consist  of  a huge  number  of  pieces,  the  function
'FollowMonodromy' works with constant memory. The packages also contains
a  variant  function  'ApproxFollowMonodromy', which  runs  faster,  but
without guarantee on the result (see below).

\item The monodromy  braids $b_i$ corresponding to  the loops $\gamma_i$
are  obtained  by  multiplying  the corresponding  monodromy  braids  of
segments. The action of these elements  of $B_n$ on the free group $F_n$
is  computed  by 'BnActsOnFn'  and  the  resulting presentation  of  the
fundamental group is computed by 'VKQuotient'. It happens for some large
problems that  the whole fundamental  group process fails  here, because
the braids $b_i$ obtained are too long and the computation of the action
on $F_n$ requires thus too much memory.  We have been able to solve such
problems  when they  occur by  calling on  the $b_i$  at this  stage our
function 'ShrinkBraidGeneratingSet'  which finds smaller  generators for
the subgroup of $B_n$ generated by the $b_i$ (see the description in the
third chapter). This  function is called automatically at  this stage if
'VKCURVE.shrinkBraid' is set to 'true' (the default for this variable is
'false').

\item Finally,  the presentation is simplified  by 'ShrinkPresentation'.
This  function is  a heuristic  adaptation and  refinement of  the basic
\GAP\ functions for simplifying presentations. It is non-deterministic.

\end{itemize}

From the algorithmic  point of view, memory should not  be an issue, but
the procedure may  take a lot of  CPU time (the critical  part being the
computation of the monodromy braids by 'FollowMonodromy'). For instance,
an empirical  study with the  curves $x^2-y^n$ suggests that  the needed
time grows  exponentially with  $n$. Two solutions  are offered  to deal
with curves for which the computation time becomes unreasonable.

A   global  variable  'VKCURVE.monodromyApprox'  controls  which  monodromy
function  is used.  The default  value of  this variable  is 'false', which
means  that 'FollowMonodromy' will be  used. If the variable  is set by the
user  to  'true'  then  the  function  'ApproxFollowMonodromy' will be used
instead.   This  function  runs  faster  than  'FollowMonodromy',  but  the
approximations  are no longer  controlled. Therefore presentations obtained
while  'VKCURVE.monodromyApprox'  is  set  to  'true'  are  not  certified.
However,  though  it  is  likely  that  there  exists  examples  for  which
'ApproxFollowMonodromy'  actually returns incorrect  answers, we still have
not seen one.

The second way of dealing with  difficult examples is to parallelize the
computation. Since  the computations  of the  monodromy braids  for each
segment  are  independent,  they  can  be  performed  simultaneously  on
different computers. The functions 'PrepareFundamentalGroup', 'Segments'
and   'FinishFundamentalGroup'  provide   basic  support   for  parallel
computing.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\Section{FundamentalGroup}
\index{FundamentalGroup}

'FundamentalGroup(<curve> [, <printlevel>])'

<curve> should be an 'Mvp' in <x>  and <y>, or a \GAP\ polynomial in two
variables (which means a polynomial in a variable which is assumed to be
'y' over the polynomial ring $\Q[x]$) representing an equation $f(x,y)$
for a curve  in $\C^2$. The coefficients should  be rationals, gaussian
rationals or 'Complex' rationals. The result  is a record with a certain
number of fields which record steps in the computation described in this
introduction\:

|    gap> r:=FundamentalGroup(x^2-y^3);
    #I  there are 2 generators and 1 relator of total length 6
    1: bab=aba
    
    gap> RecFields(r);
    [ "curve", "discy", "roots", "dispersal", "points", "segments", "loops",
      "zeros", "B", "monodromy", "basepoint", "dispersal", "braids", 
      "presentation","operations" ]
    gap> r.curve;
    x^2-y^3
    gap> r.discy;
    X(Rationals)
    gap> r.roots;
    [ 0 ]
    gap> r.points;
    [ -I, -1, 1, I ]
    gap> r.segments;
    [ [ 1, 2 ], [ 1, 3 ], [ 2, 4 ], [ 3, 4 ] ]
    gap> r.loops;
    [ [ 4, -3, -1, 2 ] ]
    gap> r.zeros;
    [ [ 707106781187/1000000000000+707106781187/1000000000000I,
       -707106781187/1000000000000-707106781187/1000000000000I ],
      [ I, -I ], [ 1, -1 ],
      [ -707106781187/1000000000000+707106781187/1000000000000I,
      707106781187/1000000000000-707106781187/1000000000000I ] ]
    gap> r.monodromy;
    [ (w0)^-1, w0, , w0 ]
    gap> r.braids;
    [ w0.w0.w0 ]
    gap> DisplayPresentation(r.presentation);
    1: bab=aba|

Here 'r.curve' records the  entered equation, 'r.discy' its discriminant
with  respect  to  <x>,  'r.roots'   the  roots  of  this  discriminant,
'r.points',  'r.segments' and  'r.loops'  describes  loops around  these
zeros  as  explained  in   the  documentation  of  'LoopsAroundPunctures';
'r.zeros'  records the  zeros of  $f(x,y_i)$  when $y_i$  runs over  the
various 'r.points';  'r.monodromy' records  the monodromy along  each of
'r.segments', and 'r.braids' is the resulting monodromy along the loops.
Finally 'r.presentation'  records the  resulting presentation  (which is
what is printed by default when 'r' is printed).

The second optional argument triggers  the display of information on the
progress of the  computation. It is recommended to  set the <printlevel>
at 1 or 2  when the computation seems to take a  long time without doing
anything. <printlevel> set  at 0 is the default and  prints nothing; set
at 1 it shows which segment is  currently active, and set at 2 it traces
the computation inside each segment.

|    gap> FundamentalGroup(x^2-y^3,1);
    # There are 4 segments in 1 loops
    # The following braid was computed by FollowMonodromy in 8 steps.
    monodromy[1]:=B(-1);
    # segment 1/4 Time=0sec
    # The following braid was computed by FollowMonodromy in 8 steps.
    monodromy[2]:=B(1);
    # segment 2/4 Time=0sec
    # The following braid was computed by FollowMonodromy in 8 steps.
    monodromy[3]:=B();
    # segment 3/4 Time=0sec
    # The following braid was computed by FollowMonodromy in 8 steps.
    monodromy[4]:=B(1);
    # segment 4/4 Time=0sec
    # Computing monodromy braids
    # loop[1]=w0.w0.w0
    #I  there are 2 generators and 1 relator of total length 6
    1: bab=aba|

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\Section{PrepareFundamentalGroup}
\index{PrepareFundamentalGroup}

'PrepareFundamentalGroup(<curve>, <name>)'

'VKCURVE.Segments(<name>[,<range>])'

'FinishFundamentalGroup(<r>)'
\index{FinishFundamentalGroup}

These  functions provide  a means  of distributing  a fundamental  group
computation over  several machines.  The basic strategy  is to  write to
a  file  the  startup-information  necessary to  compute  the  monodromy
along  a  segment,  in  the   form  of  a  partially-filled  version  of
the  record returned  by  'FundamentalGroup'. Then  the monodromy  along
each  segment can  be  done in  a separate  process,  writing again  the
result  to files.  These  results  are then  gathered  and processed  by
'FinishFundamentalGroup'. The whole process is illustrated in an example
below.  The  extra argument  <name>  to  'PrepareFundamentalGroup' is  a
prefix used to name intermediate files. One does first \:

|    gap> PrepareFundamentalGroup(x^2-y^3,"a2");
        ----------------------------------
    Data saved in a2.tmp
    You can now compute segments 1 to 4
    in different GAP sessions by doing in each of them:
        a2:=rec(name:="a2");
        VKCURVE.Segments(a2,[1..4]);
    (or some other range depending on the session)
    Then when all files a2.xx have been computed finish by
        a2:=rec(name:="a2");
        FinishFundamentalGroup(a2);|

Then  one can  compute in  separate  sessions the  monodromy along  each
segment.  The second  argument  of 'Segments'  tells  which segments  to
compute in the current session (the  default is all). An example of such
sessions may be\:

|    gap> a2:=rec(name:="a2");
    rec(
      name := "a2" )
    gap> VKCURVE.Segments(a2,[2]);
    # The following braid was computed by FollowMonodromy in 8 steps.
    a2.monodromy[2]:=a2.B(1);
    # segment 2/4 Time=0.1sec
    gap> a2:=rec(name:="a2");
    rec(
      name := "a2" )
    gap> VKCURVE.Segments(a2,[1,3,4]);
    # The following braid was computed by FollowMonodromy in 8 steps.
    a2.monodromy[2]:=a2.B(1);
    # segment 2/4 Time=0.1sec|

When all segments have been computed the final session looks like:

|    gap> a2:=rec(name:="a2");
    rec(
      name := "a2" )
    gap> FinishFundamentalGroup(a2);
    1: bab=aba|

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
#------------------- utilities -------------------------------
"""
`nearest_pair(v::Vector{<:Complex})`

returns  a pair whose first element is the minimum distance (in the complex
plane)  between two elements  of `v`, and  the second is  a pair of indices
`[i,j]` such that `v[i]`, `v[j]` achieves this minimum.

julia> nearest_pair([1+im,0,1])
1=>[1,3]
"""
function nearest_pair(v)
  l=combinations(eachindex(v),2)
  m,c=findmin(((x,y),)->abs(v[x]-v[y]),l)
  m=>l[c]
end

"`dist_seg(z,a,b)` distance (in the complex plane) of `z` to segment `[a,b]` "
function dist_seg(z,a,b)
  b-=a
  z-=a
  r=abs(b)
  z*=r/b
# @show z,b
  real(z)<0 ? abs(z) : real(z)>r ? abs(z-r) : imag(z)>0 ? imag(z) : -imag(z)
end

#---------------------- global functions --------------------------
VKCURVE=Dict(
:name=>"vkcurve",
:version=>"2.0",
:date=>[2009,3],
:homepage=>"http://webusers.imj-prg.fr/~jean.michel/vkcurve.html",
:copyright=>
"(C) David Bessis, Jean Michel -- compute Pi_1 of hypersurface complements",
:monodromyApprox=>false,
:showallnewton=>false,
:NewtonLim=>800,
:AdaptivityFactor=>10,
:shrinkBraid=>false,
:mvp=>1)

@GapObj struct VK{T}
  curve::Mvp{T,Int}
  ismonic::Bool
end

function Base.show(io::IO,r::VK)
  if haskey(r,:presentation) display_balanced(r.presentation)
  else xdisplay(r.prop)
  end
end

# Loops(r)
#  r should be a record with the fields
#    .roots   -- roots of the curve discriminant
#    .ismonic -- tells if the discriminant is monic in x
#  the function computes the following fields describing loops around the
#  .roots around from a basepoint:
#
#  .loops --  a list of loops, each described by a list of indices in r.segments
#             (a negative index tells to follow the reverse segment)
#  .segments -- oriented segments represented as a pair of indices in r.points.
#  .points -- a list of points stored a complex decimal numbers.
#  .basepoint -- holds the chosen basepoint
#
function Loops(r)
# here we  have loops around the  'true' roots and around  the 'extra'
# roots setdiff(r.roots,r.trueroots). We get rid of the extra loops
# and the associated segments and points, first saving the basepoint.
# (its location is known now, and maybe not later? J.M.)
  p=r.loops[1][1]
  r.basepoint=p<0 ? last(r.segments[-p]) : first(r.segments[p])
  if !r.ismonic
    r.loops=r.loops[sort(indexin(r.trueroots,r.roots))]
    segmentNumbers=sort(union(map(x->abs.(x),r.loops)...))
    r.segments=r.segments[segmentNumbers]
    r.loops=map(x->map(y->y<0 ? -findfirst(==(-y),segmentNumbers) :
                    findfirst(==(y),segmentNumbers), x),r.loops)
    uniquePoints=sort(union(r.segments...))
    r.points=r.points[uniquePoints]
    r.segments=map(x->indexin(x,uniquePoints), r.segments)
    r.basepoint=findfirst(==(r.basepoint),uniquePoints)
  end
  if VKCURVE[:showSegments]
    println("# There are ",length(r.segments)," segments in ",
            length(r.loops)," loops")
  end
  if VKCURVE[:showWorst]
    l=map(enumerate(r.segments))do (i,s)
      m,ixm=findmin(dist_seg.(r.roots, r.points[s[1]], r.points[s[2]]))
      (m,i,ixm)
    end
    sort!(l)
    print("worst segments:\n")
    for i in 1:min(5,length(l))
      d,s,s1=l[i]
      println("segment ",s,"==",r.segments[s]," dist to ",s1,"-th root is ",d)
    end
  end
# find the minimum distance m between two roots
  if length(r.roots)>1
    m=nearest_pair(r.roots)
    if VKCURVE[:showRoots]
      print("\nMinimum distance==",m[1]," between roots ",m[2][1]," and ",m[2][2]," of discriminant\n")
    end
    r.dispersal=m[1]
  else
    r.dispersal=1/1000
  end
# and round points to m/100
end


"""
`VKCURVE.Discy(r)`

`r`  should be a record with field `r.curve`, a quadratfrei `Mvp` in `x,y`.
The discriminant of this curve with respect to `x` (a polynomial in `y`) is
computed. First, the curve is split in
  - `r.curveVerticalPart`: gcd(coefficients(r.curve,:x)) (an Mvp in y).
  - `r.nonVerticalPart`:   curve/curveVerticalPart
Then `r.discy=discriminant(r.nonVerticalPart)` (a `Pol`) is computed. 
Its   quadratfrei  part  is  computed,  stripped  of  factors  common  with
`r.curveVerticalPart` and then factored (if possible which for now means it
is  a  polynomial  over  the  rationals),  and  its  factors  are stored in
`r.discyFactored` as a list of `Mvp` in `x`.
"""
function Discy(r)
  r.curveVerticalPart=gcd(Pol.(values(coefficients(r.curve,:x))))
  if VKCURVE[:showRoots] && degree(r.curveVerticalPart)>0
    println("Curve has ",degree(r.curveVerticalPart)," linear factors in y")
  end
  r.nonVerticalPart=exactdiv(r.curve,r.curveVerticalPart(Mvp(:y)))
  # discriminant wrto x of r.nonVerticalPart
  d=Pol(discriminant(Pol(r.nonVerticalPart,:x)))
  if iszero(d)
    error("Discriminant is 0 but ", r.curve," should be quadratfrei")
  end
  if VKCURVE[:showRoots] print("Discriminant has ",degree(d)," roots, ") end
  d=exactdiv(d,gcd(d,derivative(d)))
  if VKCURVE[:showRoots] println(" of which ", degree(d), " are distinct") end
  common=gcd(d,r.curveVerticalPart)
  if VKCURVE[:showRoots] && degree(common)>0
    println(" and of which ",degree(common)," are roots of linear factors")
  end
  d=exactdiv(d,common)
  d//=d[end]
  r.discy=d
  if eltype(coefficients(d))<:Union{Complex{<:Rational},Rational}
    r.discyFactored=factor(r.discy)
    if r.discyFactored isa Tuple r.discyFactored=r.discyFactored[1] end
    r.discyFactored=collect(keys(r.discyFactored))
  else
    r.discyFactored=[d]
  end
# @show r.discyFactored
end

function Braids(r)
  pr=VKCURVE[:showgetbraid] ? println : function(x...)end
  pr("# Computing monodromy braids")
  r.braids=empty([r.B()])
  pr("loops=[")
  for i in eachindex(r.loops)
    l=filter(s->!(r.monodromy[s]!==nothing),abs.(r.loops[i]))
    if length(l)>0 pr("# loop[$i] missing segments ",l)
    else
      bb=prod(s->s<0 ? r.monodromy[-s]^-1 : r.monodromy[s],r.loops[i])
      pr("r.",bb,",")
      push!(r.braids, bb)
    end
  end
  pr("]")
  if VKCURVE[:shrinkBraid] && r.ismonic
    r.rawBraids=r.braids
    r.braids=shrink(r.braids)
  end
end

function SearchHorizontal(r) # Searching for a good horizontal
  height=9
  while true
    height+=1
    section=Pol(r.curve(x=height))
    section=exactdiv(section,gcd(derivative(section), section))
    if degree(section)==degree(r.curve,:y) &&
       degree(gcd(r.discy,section))==0 break end
  end
  section=exactdiv(section,gcd(section,r.curveVerticalPart))
  println("Curve is not monic in x -- Trivializing along horizontal line x == ", height)
  r1=VK(r.curve*(Mvp(:x)-height),false,Dict{Symbol,Any}()) # is it monic?
  r1.height=height
  r1.input=r.curve
  if haskey(r,:name) r1.name=r.name end
  Discy(r1)
# set trueroots  to roots  of Discy  which do  not correspond only to
# intersections of the curve with the chosen horizontal
  r1.trueroots=r.roots
  r1.verticallines=r.roots[1:degree(r.curveVerticalPart)]
  r1.roots=copy(r1.trueroots)
  append!(r1.roots,SeparateRoots(section,1000))
  r1
end

function TrivialCase(r)
  r.presentation=Presentation(FpGroup(degree(r.curve,:x)))
  r
end

# curve --  an Mvp in x and y describing a curve in complex^2
function FundamentalGroup(curve::Mvp;printlevel=0,abort=false)
  VKCURVE[:showSingularProj]=VKCURVE[:showBraiding]=VKCURVE[:showLoops]=
  VKCURVE[:showAction]=VKCURVE[:showInsideSegments]=VKCURVE[:showWorst]=
  VKCURVE[:showZeros]=VKCURVE[:showNewton]=VKCURVE[:showRoots]=printlevel>=2
  VKCURVE[:showSegments]=VKCURVE[:showgetbraid]=printlevel>=1
  if !issubset(variables(curve),[:x,:y])
    error(curve," should be an Mvp in x,y")
  end
  d=gcd(curve, derivative(curve,:x))
  if degree(d,:x)>0
    xprintln("**** Warning: curve is not quadratfrei: dividing by ", d)
    curve=exactdiv(curve,d)
  end
#  record with fields .curve and .ismonic if the curve is monic in x
  r=VK(curve,degree(Pol(curve,:x)[end])==0,Dict{Symbol,Any}())
#  we should make coefficients(curve) in  Complex{Rational}
  Discy(r);
  if VKCURVE[:showRoots] println("Computing roots of discriminant...") end
  r.roots=vcat(map(p->SeparateRoots(p,1000),r.discyFactored)...)
  if degree(r.curveVerticalPart)>0
    prepend!(r.roots,SeparateRoots(r.curveVerticalPart, 1000))
  end
  if isempty(r.roots) return TrivialCase(r) end
  if !r.ismonic r=SearchHorizontal(r) end
  loops=convert_loops(LoopsAroundPunctures(r.roots))
  merge!(r.prop,pairs(loops))
  Loops(r)
  #------------------compute r.zeros[i]=zeros of r.curve(y=r.points[i])
  if VKCURVE[:showRoots]
    println("Computing zeros of curve at the ",length(r.points)," segment extremities...")
  end
  mins=Tuple{Float64,Int}[]
  r.zeros=map(1:length(r.points))do i
    if VKCURVE[:showZeros] print("<",i,"/",length(r.points),">") end
    zz=SeparateRoots(Pol(r.curve(y=r.points[i])), 10^4)
    if length(zz)>1
      m=nearest_pair(zz); push!(mins,(m[1],i))
      if VKCURVE[:showZeros] println(" d==",approx(m[1])," for ",m[2]) end
    end
    zz
  end
  if VKCURVE[:showWorst] && length(r.zeros[1])>1
    sort!(mins)
    println("worst points:")
    for m in mins[1:min(5,length(mins))]
      println("mindist(zeros[",m[2],"])==",approx(m[1]))
    end
  end
  if isempty(r.zeros[1]) return TrivialCase(r) end
#---------------------- zeros computed -------------------------------
  r.B=BraidMonoid(coxsym(length(r.zeros[1])))
  r.monodromy=fill(r.B(),length(r.segments))
  for segno in eachindex(r.segments)
    tm=time()
    r.monodromy[segno]=(VKCURVE[:monodromyApprox] ?
                    ApproxFollowMonodromy : FollowMonodromy)(r, segno)
    tm=time()-tm
    if VKCURVE[:showSegments]
      println("monodromy[$segno]=",r.monodromy[segno])
      println("#segment $segno/",length(r.segments)," Time==",approx(tm),"sec")
    end
  end
  Braids(r)
  if r.ismonic F=VKQuotient(r.braids)
  else F=DBVKQuotient(r)
  end
  r.presentation=Presentation(F)
  r.rawPresentation=Presentation(F)
  simplify(r.presentation)
  r
end

#---------------------- simp ----------------------------------
# simplest fraction approximating t closer than prec
function simp(t0::Real,prec=10^-15)
  t=t0
  a=BigInt[]
  k=BigInt[1,0]
  h=BigInt[0,1]
  while abs(h[end]//k[end]-t0)>prec
   n=floor(BigInt,t)
   push!(a,n)
   push!(h,n*h[end]+h[end-1])
   push!(k,n*k[end]+k[end-1])
   t=1/(t-n)
  end
  h[end]//k[end]
end

simp(t::Complex,prec=10^-15)=simp(real(t),prec)+im*simp(imag(t),prec)

#---------------------- root-finding ----------------------------------
"""
`NewtonRoot(p::Pol,initial,precision;showall=false,show=false,lim=800)`

Here `p` is a complex polynomial. The function computes an approximation to a
root of `p`, guaranteed of distance closer than `precision` to
an  actual root. The first approximation used is `initial`. If `initial` is
in  the  attraction  basin  of  a  root  of  `p`,  the  one approximated. A
possibility  is that  the Newton  method starting  from `initial`  does not
converge  (the  number  of  iterations  after  which  this  is  decided  is
controlled  by  `lim`);  then  the  function returns `nothing`.
Otherwise  the function returns  a pair: the  approximation found, and an
upper  bound of the distance between that approximation and an actual root.
The point of returning
an upper bound is that it is usually better than the asked-for `precision`.
For the precision estimate a good reference is cite{HSS01}.

```julia-repl
julia> p=Pol([1,0,1])
Pol{Int64}: x²+1

julia> NewtonRoot(p,1+im,10^-7)
2-element Vector{ComplexF64}:
  8.463737877036721e-23 + 1.0im
 1.8468154345305913e-11 + 0.0im

julia> NewtonRoot(p,1,10^-7;show=true)
****** Non-Convergent Newton after 800 iterations ******
p=x²+1 initial=-1.0 prec=1.0000000000000004e-7
```
"""
function NewtonRoot(p::Pol,z,precision;showall=VKCURVE[:showallnewton],
                          show=VKCURVE[:showNewton],lim=VKCURVE[:NewtonLim])
  deriv=derivative(p)
  for cnt in 1:lim
    a=p(z)
    b=deriv(z)
    c=iszero(b) ? a : a/b
    err=abs(c)
    if iszero(err) err=(precision/100)/(degree(p)+1) end
    if err>precision err=precision end
    z=simp(z-c,precision/100/(degree(p)+1)/2)
    if showall println(cnt,": ",z) end
    if err<=(precision/100)/(degree(p)+1)
      if show print(cnt,":") end
      return (z,err)
    end
  end
  if show
    println("\n****** Non-Convergent Newton after ", lim," iterations ******")
    @show p,z,precision
    return nothing
  end
end

"""
'SeparateRootsInitialGuess(p, v, safety)'

Here  `p` is a complex  polynomial, and `v` is  a list of approximations to
roots  of `p` which should lie in different attraction basins for Newton' s
method.  The  result  is  a  list  `l`  of  complex  rationals representing
approximations  to the  roots of  `p` (each  element of  `l` is the root in
whose attraction basin the corresponding element of `v` lies), such that if
`d`  is the minimum distance  between two elements of  `l`, then there is a
root  of `p` within radius  `d/(2*safety)` of any element  of `l`. When the
elements  of  `v`  do  not  lie  in  different  attraction basins (which is
necessarily the case if `p` has multiple roots), 'false' is returned.

```julia-repl
julia> p=Pol([1,0,1])
Pol{Int64}: x²+1

julia> SeparateRootsInitialGuess(p,[1+im,1-im],10^5)
2-element Vector{ComplexF64}:
 8.463737877036721e-23 + 1.0im
 8.463737877036721e-23 - 1.0im

julia> SeparateRootsInitialGuess(p,[1+im,2+im],1000)
    # 1+im and 2+im in same attraction basins
```
"""
function SeparateRootsInitialGuess(p, v, safety)
  if degree(p)==1 return [-p[0]/p[1]] end
  radv=nearest_pair(v)[1]/safety/2
  res=map(e->NewtonRoot(p,e,radv),v)
  if !any(isnothing,res) && nearest_pair(first.(res))[1]/safety/2>maximum(last.(res))
    return first.(res)
  end
  print("dispersal required=",nearest_pair(first.(res))[1]/safety/2)
  println(" obtained=",maximum(last.(res)))
  println(join(v[nearest_pair(first.(res))[2]]," and ")," lie in the same attraction basin")
  return nothing
end

"""
'SeparateRoots(<p>, <safety>)'

Here  `p` is  a complex  polynomial. The  result is  a list  `l` of complex
numbers  representing approximations to the roots  of `p`, such that if `d`
is  the minimum distance between two elements  of `l`, then there is a root
of  `p` within  radius `d/(2*safety)`  of any  element of  `l`. This is not
possible when `p` has multiple roots, in which case `nothing` is returned.

```julia-repl
julia> @Pol q
Pol{Int64}: q

julia> SeparateRoots(q^2+1,100)
2-element Vector{ComplexF64}:
  2.3541814200656927e-43 + 1.0im
 -2.3541814200656927e-43 - 1.0im

julia> SeparateRoots((q-1)^2,100)

julia> SeparateRoots(q^3-1,100)
3-element Vector{ComplexF64}:
 -0.5 - 0.8660254037844386im
  1.0 - 1.232595164407831e-32im
 -0.5 + 0.8660254037844387im
```
"""
function SeparateRoots(p,safety)
  subtractroot(p,r)=divrem(p,Pol([-r,1]))[1]
  if p isa Mvp p=Pol(p) end
  if degree(p)<1 return empty(p.c)
  elseif degree(p)==1 return [-p[0]/p[1]]
  end
  p//=p[end]
# e=complex(E(7))
  e=big(simp(complex(E(7))))
  v=nothing
  cnt = 0
  while isnothing(v) && cnt<2*(degree(p)+1)
    if VKCURVE[:showNewton] && cnt>0
      println("****** ", cnt, " guess failed for p degree ", degree(p))
    end
    v=NewtonRoot(p,e,(1/safety)*10.0^(-degree(p)-4))
    e*=simp(complex(5//4*E(2*(degree(p)+1))))
#   e*=complex(5//4*E(2*(degree(p)+1)))
    cnt+=1
  end
  if cnt>=2*(degree(p)+1) error("no good initial guess") end
  v=[v[1]]
  append!(v,SeparateRoots(subtractroot(p,v[1]), safety))
  safety==0 ? v : SeparateRootsInitialGuess(p, v, safety)
end

"""
'FindRoots(<p>, <approx>)'

<p>  should be a univariate 'Mvp'  with cyclotomic or 'Complex' rational or
decimal  coefficients or  a list  of cyclotomics  or 'Complex' rationals or
decimals  which represents  the coefficients  of a  complex polynomial. The
function  returns  'Complex'  rational  approximations  to the roots of <p>
which  are  better  than  <approx>  (a  positive rational). Contrary to the
functions  'SeparateRoots', etc... described in  the previous chapter, this
function handles quite well polynomials with multiple roots. We rely on the
algorithms explained in detail in cite{HSS01}.

```julia-repl
julia> FindRoots((Pol()-1)^5,1/5000)
5-element Vector{ComplexF64}:
 1.0009973168670234 - 6.753516026574732e-9im
 1.0004572203796391 - 0.00033436001135679156im
  0.999029224439348 + 5.075797152907413e-12im
  0.999723670720127 - 0.0008487747754577878im
 1.0007950023584915 - 0.0005779801979057327im

julia> FindRoots(Pol()^3-1,10^-5)
3-element Vector{Complex{Rational{BigInt}}}:
 -1//2 - 16296//18817*im
  1//1 + 0//1*im
 -1//2 + 16296//18817*im

julia> approx.(ans.^3)
3-element Vector{ComplexF64}:
 1.0 - 1.83e-9im
 1.0 + 0.0im
 1.0 + 1.83e-9im
```
"""
function FindRoots(p,prec)
  subtractroot(p,r)=divrem(p,Pol([-r,1]))[1]
  if degree(p)<1 return empty(p.c)
  elseif degree(p)==1 return [-p[0]//p[1]]
  end
  e=big(simp(complex(E(7))))
  v=nothing
  while isnothing(v)
    v=NewtonRoot(p,e,10.0^(-degree(p)-1))
    e*=simp(complex(E(degree(p)+1)))
  end
   v=vcat([v[1]],FindRoots(subtractroot(p,v[1]),prec))
   map(e->NewtonRoot(p,e,prec)[1],v)
end

#------------------ Loops --------------------------------------------
# sorts a list of points trigonometrically around a center
# starting from -im+ε and going anticlockwise
function cycorder(list, center)
  right=empty(list)
  left=empty(list)
  top=empty(list)
  bottom=empty(list)
  for y in list
    if real(y)>real(center) push!(right, y)
    elseif real(y)<real(center) push!(left, y)
    elseif imag(y)>imag(center) push!(top, y)
    else push!(bottom, y)
    end
  end
  sort!(right,by=x->imag(x-center)/real(x-center))
  sort!(left,by=x->imag(x-center)/real(x-center))
  vcat(right, top, left, bottom)
end
function cycorder2(list,center) # slightly slower
  angles=map(x->iszero(x-center) ? pi/2 : angle(-im*(x-center)),list)
  list[sortperm(angles)]
end

# Input: (l::Vector{Complex},center::Complex)
# Output: sublist of l in cycorder of "neighbours" of center,
# y is neighbour of center iff y≠center and no z∈l, z∉(y,center) is in the
# disk of diameter [y,center]
function neighbours(l, center)
  cycorder(filter(l)do y
    if y==center return false end
    for z in l
      if z==y || z==center continue end
      if abs2(y-z)+abs2(z-center)<=abs2(y-center) return false end
    end
    return true
  end,center)
end

# value at z of an equation of the line (x,y)
function lineq(x, y, z)
  if real(x)==real(y)
    if imag(x)==imag(y) error("Undefined line\n")
    else return real(z)-real(x)
    end
  else
    return (imag(y)-imag(x))*(real(z)-real(x))/(real(y)-real(x))+imag(x)-imag(z)
  end
end

# mediatrix of segment (x,y) of length abs2(x-y) on each side of segment
function mediatrix(x, y)
  if x==y error("Undefined mediatrix") end
  (x+y)/2 .+[im,-im].*(x-y)
end

crossing(v1,v2)=crossing(v1...,v2...)

# Computes the intersection of lines (x1,x2) and (y1,y2)
# returns nothing if the lines are parallel or elements of a pair are too close
function crossing(x1,x2,y1,y2)
  if x1==x2 || y1==y2 return nothing end
  if !(real(x1)==real(x2))
    λx=(imag(x1)-imag(x2))/(real(x1)-real(x2))
    μx=-λx*real(x1)+imag(x1)
    if !(real(y1)==real(y2))
      λy=(imag(y1)-imag(y2))/(real(y1)-real(y2))
      μy=-λy*real(y1)+imag(y1)
      if λx==λy return nothing end
      resr=(μy-μx)/(λx-λy)
      res=resr+(λx*resr+μx)*im
      return res
    else
      E3=simp(complex(E(3)))
      res=crossing(E3*x1, E3*x2, E3*y1, E3*y2)
      if isnothing(res) return nothing end
      return res/E3
    end
  else
    res=crossing(im*x1, im*x2, im*y1, im*y2)
    if isnothing(res) return nothing end
    return res/im
  end
end

function detectsleftcrossing(c, w, y, z)
  res=fill(false,length(c)-1)
  a,b=mediatrix(y, z)
  for k in 1:length(c)-1
    if lineq(a, b, c[k])*lineq(a, b, c[k+1])<=0
      x=crossing(a, b, c[k], c[k+1])
      if !isnothing(x) res[k]=imag((z-y)/(w[k]-y))>=0 end
    end
  end
  res
end

# eliminates trivial segments and contracts pairs [a,b],[b,a]
function Garside.shrink(l)local k
  k=findfirst(i->l[i]==l[i+1],1:length(l)-1)
  if !isnothing(k) return shrink(vcat(l[1:k],l[k+2:end])) end
  k=findfirst(i->l[i]==l[i+2],1:length(l)-2)
  if !isnothing(k) return shrink(vcat(l[1:k],l[k+3:end])) end
  l
end

"""
The  input is a list  of loops, each a  list of complex numbers representing
the vertices of the loop.

The output is a named tuple with fields
  - `points`: a list of complex  numbers.
  - `segments`:  a list of oriented segments, each of them  encoded by the
    list of the positions in 'points' of  its two endpoints.
  - `loops`: a list of loops. Each loops is a list  of integers representing
    a  piecewise  linear  loop,  obtained  by  concatenating the `segments`
    indexed  by the  integers, where  a negative  integer is  used when the
    opposed orientation of the segment is taken.
"""
function convert_loops(ll)
  points=unique(vcat(ll...))
  points=points[filter(i->!any(==(points[i]),points[1:i-1]),eachindex(points))]
  points=sort(points,by=x->(imag(x),real(x)))
  np(p)=findfirst(==(p),points)
  loops=map(l->np.(l),ll)
  loops=shrink.(loops)
  loops=map(l->map(i->l[i-1:i],2:length(l)),loops)
  segments=sort(unique(sort.(vcat(loops...))))
  loops=map(loops)do l
    map(l)do seg
     seg[1]<seg[2] ? findfirst(==(seg),segments) :
                    -findfirst(==(reverse(seg)),segments)
    end
  end
  (;points, segments, loops)
end

function Box(l)
  minr,maxr=extrema(real.(l))
  mini,maxi=extrema(imag.(l))
  [Complex(minr-2, mini-2), Complex(minr-2, maxi+2),
   Complex(maxr+2, maxi+2), Complex(maxr+2, mini-2), 
   Complex((maxr+minr)/2, mini-2-(maxr-minr)/2),
   Complex(minr-2-(maxi-mini)/2, (maxi+mini)/2),
   Complex((maxr+minr)/2, maxi+2+(maxr-minr)/2),
   Complex(maxr+2+(maxi-mini)/2, (maxi+mini)/2)]
end

# Guarantees on LoopsAroundPunctures:
# For a set Z of zeroes and z in Z, let R(z):=1/2 dist(z,Z-z).
# The  input of  LoopsAroundPunctures is  a set  Z of approximate zeroes of
# r.discy such that for any z one of the zeroes is closer than R(z)/S where
# S is a global constant of the program (in practice we may take S=100).
# Let  d=inf_{z in  Z}(R(z)); we  return points  with denominator  10^-k or
# 10^-k<d/S'  (in practive we take S'=100) and  such that the distance of a
# segment to a zero of r.discy is guaranteed >= d-d/S'-d/S

"""
'LoopsAroundPunctures(points)'

`points`  should be complex numbers. The function computes piecewise-linear
loops representing generators of the fundamental group of `ℂ -{points}`.

```julia-repl
julia> LoopsAroundPunctures([0])
1-element Vector{Vector{Complex{Int64}}}:
 [1 + 0im, 0 + 1im, -1 + 0im, 0 - 1im, 1 + 0im]
```
"""
function LoopsAroundPunctures(originalroots)
# tol=first(nearest_pair(originalroots))
  roots=originalroots*(1+0im)
  n=length(roots)
  if n==1 return [roots[1].+[1,im,-1,-im,1]] end
  average=sum(roots)/n
  sort!(roots, by=x->abs2(x-average))
  ys=map(x->(neighbours=Int[],friends=Int[], lovers=Int[],
             cycorder=empty(roots),circle=empty(roots),
             witness=empty(roots),path=empty(roots),handle=empty(roots),
             loop=empty(roots)),roots)
  err=filter(x->==(roots[x]...),combinations(eachindex(roots),2))
  if length(err)>0 error("roots too close ",err) end
  iy(y)=findfirst(==(y),roots)
  sy(y)=ys[iy(y)]
  for (yi,y) in enumerate(ys)
    append!(y.neighbours,iy.(neighbours(roots, roots[yi])))
    push!(y.friends,yi)
  end
  if VKCURVE[:showLoops] println("neighbours computed") end
  for (yi,y) in enumerate(ys)
    for z in y.neighbours
      if !(z in y.friends)
        push!(y.lovers, z)
        push!(ys[z].lovers, yi)
        newfriends=vcat(y.friends, ys[z].friends)
        for t in y.friends 
          empty!(ys[t].friends);append!(ys[t].friends,newfriends)
        end
        for t in ys[z].friends 
          empty!(ys[t].friends);append!(ys[t].friends,newfriends)
        end
      end
    end
  end
  for (yi,y) in enumerate(ys) 
    sort!(y.neighbours,by=z->abs2(roots[yi]-roots[z]))
  end
# To avoid trouble with points on the border of the convex hull,
# we make a box around all the points;
  box=Box(roots)
  for (yi,y) in enumerate(ys) 
    append!(y.cycorder,cycorder(vcat(deleteat!(copy(roots),yi),box),roots[yi]))
    n1=roots[y.neighbours[1]]
    k=findfirst(==(n1),y.cycorder)
    y.cycorder.=circshift(y.cycorder,1-k)
    push!(y.cycorder, y.cycorder[1])
    push!(y.circle,(roots[yi]+n1)/2)
    push!(y.witness,n1)
    for z in y.cycorder[2:end]
      cut=detectsleftcrossing(y.circle, y.witness, roots[yi], z)
      if any(cut)
        k=findfirst(cut)
        resize!(y.circle,k)
        resize!(y.witness,k)
      end
      k=length(y.circle)
      newcirc=crossing(mediatrix(roots[yi],y.witness[k]),mediatrix(roots[yi], z))
      if !isnothing(newcirc)
        push!(y.circle, newcirc)
        push!(y.witness, z)
      end
      if iy(z) in y.lovers
        push!(y.circle, (roots[yi]+z)/2)
        push!(y.witness, z)
      end
    end
  end
  if VKCURVE[:showLoops] println("circles computed") end

  function boundpaths(path, i) # y must be an element of ys
    if !isempty(ys[i].path) return end
    append!(ys[i].path,path);push!(ys[i].path,roots[i])
    for z in ys[i].lovers boundpaths(ys[i].path, z) end
  end

  boundpaths(empty(roots), 1)
  for (yi,y) in enumerate(ys) 
    k=length(y.path)
    if k>1
      circleorigin=(roots[yi]+y.path[k-1])/2
      k=findfirst(==(circleorigin),y.circle)
      y.circle.=circshift(y.circle,1-k)
    end
  end
  for y in ys
    k=length(y.path)
    append!(y.handle,vcat(map(1:k-1)do i
      l=sy(y.path[i]).circle
      l[1:findfirst(==((y.path[i]+y.path[i+1])/2),l)]
     end...))
    append!(y.loop,vcat(y.handle, y.circle, reverse(y.handle)))
  end
  ys=ys[sort(eachindex(ys),by=i->findfirst(==(roots[i]),originalroots))]
  map(ys)do y
#   loop=map(x->round(x;sigdigits=8),y.loop)
    y.loop
  end
end

#-------------------- ApproxMonodromy ----------------------------
# for each point of a find closest point in b
# Complain if the result is not a bijection between a and b of if
# the distance between an a and the corresponding b is bigger than 1/10
# of minimum distance between two b's
function fit(a, b)
  dm=map(p->findmin(abs.(b.-p)),a)
  monodromyError=maximum(first.(dm))
# println("# Monodromy error==",monodromyError)
  if monodromyError>nearest_pair(b)[1]/10 error("monodromy error too big") end
  pos=last.(dm)
  if sort(pos)!=1:length(pos) error("monodromy cannot find perm") end
  b[pos]
end

# Decimal Log of Norm of polynomial d evaluated at point p
function normdisc(d, p)
  p=abs(prod(map(f->f(p), d)))
  if log10(p)==0 return round(Float64(-log10(1/p));digits=3)
  else return round(Float64(log10(p));digits=3)
  end
end

# keep only 3 significant digits of x
approx(x::Real)=round(Float64(x);sigdigits=3)
approx(x::Complex)=round(Complex{Float64}(x);sigdigits=3)

"""
'ApproxFollowMonodromy(<r>,<segno>,<pr>)'

This function  computes an approximation  of the monodromy braid  of the
solution in `x`  of an equation `P(x,y)=0` along  a segment `[y_0,y_1]`.
It is called  by 'FundamentalGroup', once for each of  the segments. The
first  argument is  a  global record,  similar to  the  one produced  by
'FundamentalGroup'  (see the  documentation of  this function)  but only
containing intermediate information. The second argument is the position
of the segment in 'r.segments'. The  third argument is a print function,
determined  by the  printlevel set  by the  user (typically,  by calling
'FundamentalGroup' with a second argument).

Contrary to 'FollowMonodromy',  'ApproxFollowMonodromy' does not control
the approximations; it just uses a  heuristic for how much to move along
the segment  between linear braid  computations, and this  heuristic may
possibly fail. However,  we have not yet found an  example for which the
result is actually incorrect, and thus the existence is justified by the
fact that  for some difficult  computations, it is sometimes  many times
faster  than 'FollowMonodromy'.  We illustrate  its typical  output when
<printlevel> is 2.

|   VKCURVE.monodromyApprox:=true;
julia-rep1```
julia> FundamentalGroup((x+3*y)*(x+y-1)*(x-y);printlevel=2)

  ....

546 ***rejected
447<15/16>mindist=2.55 step=0.5 total=0 logdisc=0.55 ***rejected
435<15/16>mindist=2.55 step=0.25 total=0 logdisc=0.455 ***rejected
334<15/16>mindist=2.55 step=0.125 total=0 logdisc=0.412 ***rejected
334<15/16>mindist=2.55 step=0.0625 total=0 logdisc=0.393
334<15/16>mindist=2.55 step=0.0625 total=0.0625 logdisc=0.412
334<15/16>mindist=2.56 step=0.0625 total=0.125 logdisc=0.433
334<15/16>mindist=2.57 step=0.0625 total=0.1875 logdisc=0.455
334<15/16>mindist=2.58 step=0.0625 total=0.25 logdisc=0.477
======================================
==    Nontrivial braiding B(2)      ==
======================================
334<15/16>mindist=2.6 step=0.0625 total=0.3125 logdisc=0.501
334<15/16>mindist=2.63 step=0.0625 total=0.375 logdisc=0.525
334<15/16>mindist=2.66 step=0.0625 total=0.4375 logdisc=0.55
334<15/16>mindist=2.69 step=0.0625 total=0.5 logdisc=0.576
334<15/16>mindist=2.72 step=0.0625 total=0.5625 logdisc=0.602
334<15/16>mindist=2.76 step=0.0625 total=0.625 logdisc=0.628
334<15/16>mindist=2.8 step=0.0625 total=0.6875 logdisc=0.655
334<15/16>mindist=2.85 step=0.0625 total=0.75 logdisc=0.682
334<15/16>mindist=2.9 step=0.0625 total=0.8125 logdisc=0.709
334<15/16>mindist=2.95 step=0.0625 total=0.875 logdisc=0.736
334<15/16>mindist=3.01 step=0.0625 total=0.9375 logdisc=0.764
# Minimal distance==2.55
# Minimal step==0.0625==-0.0521 + 0.0104im
# Adaptivity==10
monodromy[15]=[2]

# segment 15/16 Time==0.002741098403930664sec
```

Here at each  step the following information is  displayed: first, how
many iterations of  the Newton method were necessary to  compute each of
the 3  roots of the current  polynomial `f(x,y_0)` if we  are looking at
the point `y_0` of the segment.  Then, which segment we are dealing with
(here the  15th of  16 in  all). Then the  minimum distance  between two
roots of  `f(x,y_0)` (used in our  heuristic). Then the current  step in
fractions of the length of the segment  we are looking at, and the total
fraction of the segment we have  done. Finally, the decimal logarithm of
the absolute  value of the discriminant  at the current point  (used in
the heuristic). Finally, an indication if the heuristic predicts that we
should  halve the  step  ('***rejected')  or that  we  may double  it
('***up').

The function returns an element of the ambient braid group 'r.B'.
"""
function ApproxFollowMonodromy(r,segno)
  if VKCURVE[:showInsideSegments] ipr=print
  else ipr=function(x...)end
  end
  p,q=r.segments[segno]
  res=r.B()
  prevzeros=r.zeros[p]
  n=length(prevzeros)
  if n==1 return r.B() end
  mindm=nearest_pair(prevzeros)[1]
  p=r.points[p]
  v=r.points[q]-p
  prev=p
  step=1//1
  minstep=step
  total=0//1
  nextzeros=nothing
  while true
    next=prev+step*v
    P=Pol(r.curve(y=next))
    nextzeros=SeparateRootsInitialGuess(P, prevzeros, 100)
    if isnothing(nextzeros) ||
      (iszero(maximum(abs.(nextzeros-prevzeros))) && step>1//16)
      rejected=true
    else
      dm=map(i->minimum(abs.(prevzeros[i]-prevzeros[j] for j in 1:n if j!=i)),
                                                                          1:n)
      mdm=minimum(dm)
      if step<1 ipr("<$segno/",length(r.segments),">mindist=",approx(mdm),
         " step=$step total=$total logdisc=",normdisc(r.discyFactored,next))
      end
      dn=abs.(prevzeros-nextzeros)
      rejected=any(dm.<VKCURVE[:AdaptivityFactor].*dn)
      if !rejected && mdm<mindm mindm=mdm end
    end
    if rejected
      step/=2
      ipr(" ***rejected\n")
      if step<minstep minstep=step end
    else
      total+=step
      if all(dm.>2 .*VKCURVE[:AdaptivityFactor] .*dn) && total+step!=1
        step*=2
        ipr(" ***up")
      end
      ipr("\n")
      if total != 1
        res*=LBraidToWord(prevzeros, nextzeros, r.B)
        prevzeros=nextzeros
      end
      prev=next
    end
    if total+step>1 step=1-total end
    if total==1 break end
  end
  if VKCURVE[:showSegments]
    println("# Minimal distance=", approx(mindm))
    println("# Minimal step=", minstep, "=", approx(v*minstep))
    println("# Adaptivity=", VKCURVE[:AdaptivityFactor])
  end
  res*LBraidToWord(prevzeros,fit(nextzeros,r.zeros[q]),r.B)
end
#-------------------- Monodromy ----------------------------
# ceil(-log2(p)) for 0<p<1
function Intlog2(p)
  k=0
  q=p
  while q<1
    q=2q
    k+=1
  end
  k
end

# computes the lower approximation of the rational a by a
# rational with denominator 2^k
function binlowevalf(a, time)
  k=Intlog2(a-time)+3
  b=floor(Int,a*2^k)
  a>=0 ? b//2^k : (b-1)//2^k
end

# truncated iteration of the Newton method
function mynewton(p,z)
  a=p(z)
  b=derivative(p)(z)
  if iszero(b) c=a
    print("NewtonError\n")
  else c=a/b
  end
  err=degree(p)*abs(c)
  if err==0 prec=1
  else prec=max(0,ceil(Int,-log10(err)))+2
  end
  simp(z-c,(1//10)^(prec+1))
end

# for each point of a find closest point in b
function myfit(a, b)
  d=length(a)
  dist=fill(zero(real(eltype(a))),d,d)
  for k in 1:d, l in k+1:d
    dist[k,k]=dist[l,k]=dist[k,l]=abs2(a[k]-a[l])
  end
  dist[d,d]=dist[d,d-1]
  R=map(k->minimum(dist[k,:])*1//4,1:d)
  map(k->only(filter(i->abs2(i-a[k])<R[k], b)),1:d)
end

# sets coeff of degree i of p to x
Base.setindex!(p::Pol{T},x::T,i::Integer) where T=p.c[i+1-p.v]=x

# Sturm(pp,time)
# if polynomial pp is positive  at time<1
# returns some rational number t such that
#    time<t<=1  and  pp  is positive on [time,t]
# otherwise returns 0
# [third input and second output is an adaptive factor to
#  accelerate the computation]
function Sturm(pp::Pol, tm, adapt::Integer;pr=print)
  q=Pol()
  pol=pp((1-q)*tm+q)
  if pol[0]<=0
    print("*****",Float32(pol[0]))
    return [0, 0]
  end
  k=1
  while k<degree(pol) && pol[k]>=0 k+=1 end
  while k<degree(pol) && pol[k]<=0 k+=1 end
  for i in k:degree(pol) if pol[i]>0 pol[i]=zero(pol[i]) end end
  t=big(1//2)^adapt
  m=adapt
  while pol(t)<=0
    t//=2
    m+=1
  end
  pr(m)
  if m==adapt && adapt>0
    if pol(3t//2)>0
      if pol(2t)>0 res=[(1-2t)*tm+2t, adapt-1]
      else res=[(1-3t//2)*tm+3t//2, adapt-1]
      end
    else res=[(1-t)*tm+t, adapt]
    end
  else res=[(1-t)*tm+t, m]
  end
  res
end

Base.real(p::Pol)=Pol(real.(p.c),p.v)
Base.imag(p::Pol)=Pol(imag.(p.c),p.v)
Base.abs2(p::Pol)=real(p)^2+imag(p)^2

# fraction 0≤tm≤1 in hexa width l
function formattm(tm,l)
  if iszero(tm) return rpad("0",l) end
  d=denominator(tm)
  n=numerator(tm)
  m=2^Int(4-mod1(log2(d),4))
# @show n,d,m
  d*=m
  n*=m
  rpad("0."*"0"^max(0,floor(Int,(log2(d)-log2(n+1))/4))*string(n,base=16),l)
end 

"""
'FollowMonodromy(<r>,<segno>,<print>)'
This function computes the monodromy braid  of the solution in `x` of an
equation  `P(x,y)=0`  along  a  segment `[y_0,y_1]`.  It  is  called  by
'FundamentalGroup', once for each of the segments. The first argument is
a global record, similar to  the one produced by 'FundamentalGroup' (see
the  documentation of  this function)  but only  containing intermediate
information.  The second  argument is  the  position of  the segment  in
'r.segments'. The third argument is  a print function, determined by the
printlevel  set by  the user  (typically, by  calling 'FundamentalGroup'
with a second argument).

The function returns an element of the ambient braid group 'r.B'.

This function has no reason to be  called directly by the user, so we do
not illustrate its  behavior. Instead, we explain what  is displayed on
screen when the user sets the printlevel to `2`.

What is quoted below is an excerpt of what is displayed on screen
during the execution of
|    gap>  FundamentalGroup((x+3*y)*(x+y-1)*(x-y),2);
<1/16>    1 time=0           ?2?1?3
<1/16>    2 time=0.2         R2. ?3
<1/16>    3 time=0.48        R2. ?2
<1/16>    4 time=0.74        ?2R1?2
<1/16>    5 time=0.94        R1. ?2
======================================
==    Nontrivial braiding B(2)      ==
======================================
<1/16>    6 time=0.bc        R1. ?1
<1/16>    7 time=0.d8        . ?0. 
<1/16>    8 time=0.dc        ?1R0?1
# The following braid was computed by FollowMonodromy in 8 steps.
monodromy[1]=[2]
# segment 1/16 Time==0.0048370361328125sec

'FollowMonodromy' computes  its results by subdividing  the segment into
smaller  subsegments  on which  the  approximations  are controlled.  It
starts at one  end and moves subsegment after subsegment.  A new line is
displayed at each step.

The  first column  indicates which  segment is  studied. In  the example
above, the function  is computing the monodromy along  the first segment
(out  of  `16`).  This  gives  a  rough  indication  of  the  time  left
before  completion of  the total  procedure.  The second  column is  the
number of  iterations so  far (number of  subsegments). In  our example,
'FollowMonodromy'  had to  cut the  segment into  `8` subsegments.  Each
subsegment has its own length. The cumulative length at a given step, as
a  fraction of  the  total length  of the  segment,  is displayed  after
'time='.  This  gives  a  rough  indication  of  the  time  left  before
completion  of the  computation of  the monodromy  of this  segment. The
segment is completed when this fraction reaches `1`.

The last column has to do with the piecewise-linear approximation of the
geometric monodromy  braid. It is  subdivided into sub-columns  for each
string. In  the example above,  there are  three strings. At  each step,
some strings are fixed (they are  indicated by '. ' in the corresponding
column). A symbol like 'R5' or '?3' indicates that the string is moving.
The exact meaning of the symbol has to do with the complexity of certain
sub-computations.

As  some strings  are moving,  it  happens that  their real  projections
cross. When such a crossing occurs, it is detected and the corresponding
element of `B_n` is displayed on screen ('Nontrivial braiding ='...) The
monodromy braid is the product of these elements of `B_n`, multiplied in
the order in which they occur.
"""
# Exact computation of the monodromy braid along a segment
# r: global VKCURVE record
# seg: segment number
# sprint: Print function (to screen, to file, or none)
function FollowMonodromy(r,seg)
  iPrint=VKCURVE[:showInsideSegments] ? print : function(arg...) end
  p=r.curve
  dpdx=derivative(r.curve,:x)
  a,b=r.segments[seg]
  v=r.zeros[a]
  B=r.B
  res=B()
  # If there is only one string, the braid is trivial
  if length(v)==1 return res end
  d=length(r.zeros[1])
  t=Mvp(:t)
  tm=big(0)
  pt=p(;y=r.points[b]*t+r.points[a]*(1-t))
  dpdxt=dpdx(;y=r.points[b]*t+r.points[a]*(1-t))
  RR=fill(big(0.0),d)
  adapt=fill(0,d)
  protected=fill(0//1,d)
  protp=map(i->zero(Pol(real(v[1]))),1:d)
  protdpdx=map(i->zero(Pol(real(v[1]))),1:d)
  steps=0
  dist=fill(big(0.0),d,d)
  while true
    steps+=1
#   if steps>540 error() end
    iPrint("<$seg/",length(r.segments),">",lpad(steps,5))
    iPrint(" time=",formattm(tm,9),"   ")
    for k in 1:d, l in k+1:d
      dist[k,k]=dist[l,k]=dist[k,l]=abs2((v[k]-v[l])*big(1))
    end
    dist[d,d]=dist[d,d-1]
    for k in 1:d
      Rk=minimum(dist[k,:])/4
      z=v[k]
      if protected[k]>tm && Rk>=RR[k]
        iPrint(". ")
      elseif protected[k]>tm
        if adapt[k]+2<maximum(adapt) Rk/=2 end
        iPrint("R")
        s,adapt[k]=Sturm(Rk*protdpdx[k]-protp[k], tm, adapt[k])
        if s>tm protected[k]=binlowevalf(s,tm)
        else iPrint("How bizarre...")
#         @show Rk,protdpdx[k],protp[k]
#         @show Rk*protdpdx[k]-protp[k], tm, adapt[k]
        end
        RR[k]=Rk
      else
        iPrint("?")
        cptz=Pol(pt(;x=z))
#       @show pt, z,cptz
        protp[k]=d^2*abs2(cptz)
        cdpdxtz=Pol(dpdxt(;x=z))
        protdpdx[k]=abs2(cdpdxtz)
        s,adapt[k]=Sturm(Rk*protdpdx[k]-protp[k], tm, adapt[k])
        if s>tm protected[k]=binlowevalf(s,tm)
        else error("Something's wrong...s=",s,"≤time=",tm)
#         @show R[k],protdpdx[k],protp[k]
#         @show R[k]*protdpdx[k]-protp[k], tm, adapt[k]
        end
        RR[k]=Rk
      end
    end
    allowed=minimum(protected)
    tm=allowed
    py=Pol(p(;y=r.points[a]*(1-tm)+r.points[b]*tm))
    iPrint("\n")
    newv=map(1:d)do k
      if protected[k]>allowed v[k]
      else mynewton(py,v[k])
      end
    end
    res*=LBraidToWord(v, newv, B)
    v=newv
    if tm==1 break end
  end
  if VKCURVE[:showSegments]
    println("# The following braid was computed by FollowMonodromy in $steps steps.")
  end
  res*LBraidToWord(v, myfit(v, r.zeros[b]), B)
end

#------------------- Compute PLBraid ----------------------------------
# Deals with "star" linear braids, those with associated permutation w_0
function starbraid(y, offset, B)
  n=length(y)
  if n==1 return B() end
  k=argmin(y)
  B((k:n-1).+offset...)*starbraid(deleteat!(copy(y),k),offset,B)/
  B((n+1-k:n-1).+offset...)
end

# In case two points have the same real projection, we use
# a "lexicographical" desingularization by "infinitesimal rotation"
function desingularized(v1, v2)
  n=length(v1)
  tan=1
  for k in 1:n, l in k+1:n
    rv,iv=reim(v1[k]-v1[l])
    if !iszero(iv*rv) tan=min(tan,abs(rv/iv)) end
    rv,iv=reim(v2[k]-v2[l])
    if !iszero(iv*rv) tan=min(tan,abs(rv/iv)) end
  end
  [v1, v2].*(1-im*tan/2)
end

"""
'LBraidToWord(v1,v2,B)'

This function converts  the linear braid joining the points in `v1` to the
corresponding ones in `v2` into an element of the braid group.

```julia-repl
julia> B=BraidMonoid(coxsym(3))
BraidMonoid(𝔖 ₃)

julia> LBraidToWord([1+im,2+im,3+im],[2+im,1+2im,4-6im],B)
1
```

The lists `v1` and `v2` must have the same length, say `n`. Then `B` should
be  `BraidMonoid(coxsym(n))`, the braid group  on `n` strings. The elements
of  `v1` (resp. `v2`)  should be `n`  distinct complex rational numbers. We
use the Brieskorn basepoint, namely the contractible set `C+iV_ℝ` where `C`
is  a real chamber; therefore the endpoints  need not be equal. The strings
defined  by `v1` and `v2` should be  non-crossing. When the numbers in `v1`
(resp.  `v2`)  have  distinct  real  parts,  the  real picture of the braid
defines a unique element of `B`. When some real parts are equal, we apply a
lexicographical  desingularization, corresponding to a rotation of `v1` and
`v2` by an arbitrary small positive angle.
"""
# two printlevel control fields: VKCURVE.showSingularProj
#				 VKCURVE.showBraiding
# Deals with linear braids
# 1) singular real projections are identified
# 2) calls starbraid for each
function LBraidToWord(v1, v2, B)
  n=length(v1)
  x1,y1=reim(v1)
  x2,y2=reim(v2)
  if length(Set(x1))<length(x1) || length(Set(x2))<length(x2)
    if VKCURVE[:showSingularProj]
      println("WARNING: singular projection(resolved)")
    end
    return LBraidToWord(desingularized(v1, v2)..., B)
  end
  q=sortPerm(x1)
  crit=empty(x1)
  for i in 1:n-1, j in i+1:n
    iq=i^q;jq=j^q
    if x2[iq]>x2[jq]
      push!(crit,(x1[iq]-x1[jq])/((x2[jq]-x1[jq]+x1[iq])-x2[iq]))
    end
  end
  tcrit=unique(sort(crit))
  res=B()
  u=0
  for t in tcrit
    xt=map(k->x1[k]+t*(x2[k]-x1[k]),1:n)
    yt=map(k->y1[k]+t*(y2[k]-y1[k]),1:n)
    ut=(u+t)/2
    xut=map(k->x1[k]+ut*(x2[k]-x1[k]),1:n)
    put=inv(sortPerm(xut))
    xt=permute(xt,put)
    yt=permute(yt,put)
    xcrit=unique(sort(xt))
    for x in xcrit
      posx=findfirst(==(x),xt)
      nx=count(==(x),xt)
      res*=starbraid(yt[posx:posx+nx-1], posx-1, B)
    end
    u=t
  end
  if VKCURVE[:showBraiding]
   if !isempty(tcrit)
      if VKCURVE[:showInsideSegments]
        println("======================================")
        println("==    Nontrivial braiding ",rpad(res,10),"==")
        println("======================================")
#       print("v1:=",gap(v1),";\n")
#       print("v2:=",gap(v2),";\n")
      else println("==    Nontrivial braiding ",rpad(res,10),"==")
      end
    end
  end
  return res
end
#----------------------- Presentation -------------------------------
"""
'VKQuotient(braids)'

The  input `braid` is a list of braids `b₁,…,bᵣ`, living in the braid group
on `n` strings. Each `bᵢ` defines by Hurwitz action an automorphism `φᵢ` of
the free group `Fₙ`. The function returns the group defined by the abstract
presentation: ``< f₁,…,fₙ ∣ ∀ i,j φᵢ(fⱼ)=fⱼ >``

```julia-repl
julia> B=BraidMonoid(coxsym(3))
BraidMonoid(𝔖 ₃)

julia> g=VKQuotient([B(1,1,1),B(2)])
FreeGroup(a,b,c)/[b⁻¹a⁻¹baba⁻¹,b⁻¹a⁻¹b⁻¹aba,.,.,cb⁻¹,c⁻¹b]

julia> p=Presentation(g)
Presentation: 3 generators, 4 relators, total length 16

julia> display_balanced(p)
1: c=b
2: b=c
3: bab=aba
4: aba=bab

julia> simplify(p)
Presentation: 2 generators, 1 relator, total length 6
Presentation: 2 generators, 1 relator, total length 6

julia> display_balanced(p)
1: bab=aba
```
"""
function VKQuotient(braids)
  F=FpGroup(Symbol.('a'.+(0:ngens(braids[1].M.W)))...)
  f=gens(F)
  F/reduce(vcat,map(b->hurwitz(f,b).*inv.(f),braids))
end

# A variant of the previous function.
# See arXiv:math.GR/0301327 for more mathematical details.
# Input: global VKCURVE record
# Output: the quotient, encoded as an FpGroup
############################################################
# Printing controlled by VKCURVE.showAction
function DBVKQuotient(r)
  # get the true monodromy braids and the Hurwitz action basic data
  n=ngens(r.braids[1].M.W)+1
  F=FpGroup(Symbol.('a'.+(0:n+length(r.verticallines)-1))...)
# above the basepoint for the loops, locate the position of the string
# corresponding to the trivializing horizontal line
  bzero=r.zeros[r.basepoint]
  height=bzero[argmin(abs2.(bzero.-r.height))]
  fbase=F(count(z->reim(z)<=reim(height),bzero))
  rels=AbsWord[]
  auts=map(b->Hom(F,F,hurwitz(gens(F),b)),r.braids)
  for (i,aut) in enumerate(auts)
# Find an element conjugator such that aut(fbase)^inv(conjugator)=fbase
    ifbase=aut(fbase)
    conjugator=one(F)
    while length(ifbase)>1
      x=ifbase[1]
      ifbase=ifbase^x
      conjugator*=x
    end
# Replacing aut by  correctaut:= Conj(conjugator)*aut
    conj=Hom(F, F, gens(F).^Ref(conjugator))
    correctaut=x->conj(aut(x))
    g=i>length(r.verticallines) ? one(F) : F(i+n)
    append!(rels, map(f->correctaut(f)*g*inv(g*f), gens(F)[1:n]))
  end
  push!(rels, fbase)
  F/rels
end

VKCURVE[:showInsideSegments]=true
VKCURVE[:showBraiding]=true
VKCURVE[:showNewton]=false

gg(x)="Complex(evalf(\"$(real(x))\"),evalf(\"$(imag(x))\"))"
data=Dict()

@Mvp x,y,z,t
data[23]=discriminant(crg(23))(x,y,z)(;x=1,z=x)
data[24]=discriminant(crg(24))(x,y,z)(;x=1,z=x)
data[27]=discriminant(crg(27))(x,y,z)(;x=1,z=x)
data[29]=discriminant(crg(29))(x,y,z,t)(;t=y+1,z=x)
data[31]=discriminant(crg(31))(x,y,z,t)(;t=x+1,z=y)
data[34]=
95864732434895657396628326400//164799823*x*y^3-598949723065092000//
1478996726054382501274179923886253687929138281*x*y^7-
67840632073999787861633181671139840000*x^2-
7622790471072621273612030528032173587500421120000*y^2-273861000//
27158981660831329*x^2*y^4+37130333513291749382400//7130353846013*x^3*y-
13608525//50841945969352380915996169*x^4*y^2-2606867429323404078970327//
1675017448527954334139901265590107596081497211494411528*x^6+
3269025273548225517660538475128200000//390195840687434028022928452202401489*y^6
#---------plotting
function _segs(r,v)
  rp=Float64[]
  ip=Float64[]
  for seg in v
    s=r[:points][seg<0 ? reverse(r[:segments][-seg]) : r[:segments][seg]]
    append!(rp,real.(s))
    append!(ip,imag.(s))
  end
  rp,ip
end

function _loops(r,v)
  rp=Float64[]
  ip=Float64[]
  for l in r[:loops][v]
    nrp,nip=_segs(r,l)
    append!(rp,nrp)
    append!(ip,nip)
  end
  rp,ip
end

function plotloops(r,v)
 colors=[:black,:green,:blue,:red,:yellow,:cyan,:magenta]
 plt=lineplot(_loops(r,v[1])...,color=:black)
 for i in 2:length(v)
   lineplot!(plt,_loops(r,v[i])...,color=colors[i])
 end
 plt
end
