"""
This module is a port of some GAP functionality on groups.

The only field of a Group G at the start is gens, the list of generators of
G.  To  mimic  GAP  records  where  attributes/properties  of an object are
computed  on demand when asked for, other attributes computed on demand are
stored in the field .prop of the Group, which starts as Dict{Symbol,Any}()

# Examples
```julia-repl
julia> G=Group([Perm(1,2),Perm(1,2,3)])
Group([perm"(1,2)",perm"(1,2,3)"])

julia> gens(G)
2-element Array{Perm{Int16},1}:
 (1,2)  
 (1,2,3)

julia> nbgens(G)
2
```

The group itself, applied to a sequence of integers, returns the element
defined by the corresponding word in the generators
```julia-repl
julia> G(2,1,-2) # returns gens(G)[2]*gens(G)[1]*inv(gens(G)[2])
(1,3)
```
"""
module Groups
# to use as a stand-alone module uncomment the next line
# export word, elements, kernel, order
export Group, minimal_words, element, gens, nbgens, class_reps, centralizer,
  conjugacy_classes, orbit, transversal, orbits, Hom, isabelian,
  position_class, fusion_conjugacy_classes, Coset, representative_operation,
  centre

using ..Util: gets
#--------------general groups and functions for "black box groups" -------
abstract type Group{T} end # T is the type of elements of G

Base.one(G::Group{T}) where T=isempty(gens(G)) ? one(T) : one(gens(G)[1])
gens(G::Group)=G.gens
nbgens(G::Group)=length(gens(G))
@inline gen(W,i)=i>0 ? gens(W)[i] : inv(gens(W)[-i])

" element of W corresponding to a sequence of generators and their inverses"
element(W::Group,w...)=isempty(w) ? one(W) : length(w)==1 ? gen(W,w[1]) : 
    prod( gen(W,i) for i in w)
(W::Group)(x...)=element(W,x...)

"""
  orbit(gens::vector,p;action::Function=^)

  the orbit of `p` under generators `gens`. `p` should be hashable
```julia-repl
julia> orbit([Perm(1,2),Perm(2,3)],1) 
3-element Array{Int64,1}:
 1
 2
 3
```
"""
function orbit(gens::Vector,pnt;action::Function=^)
  set=Set([pnt])
  orb=[pnt]
  for pnt in orb, gen in gens
    img=action(pnt,gen)
    if !(img in set)
      push!(orb,img)
      push!(set,img)
    end
  end
  orb
end

"""
  orbit(G::Group,p;action::Function=^)

  the orbit of `p` under Group `G`. `p` should be hashable
```julia-repl
julia> G=Group([Perm(1,2),Perm(2,3)]);
julia> orbit(G,1) 
3-element Array{Int64,1}:
 1
 2
 3
```
"""
orbit(G::Group,pnt;action::Function=^)=orbit(gens(G),pnt;action=action)

"""
  transversal(G::Group,p;action::Function=^)

 returns  a Dict with entries x=>g where x runs over orbit(G,p) and where g
 is such that x=action(p,g)

```julia-repl
julia> G=Group([Perm(1,2),Perm(2,3)]);
julia> transversal(G,1)
Dict{Int64,Perm{Int16}} with 3 entries:
  2 => (1,2)
  3 => (1,3,2)
  1 => ()
```
 orbit functions can take any action of G as keyword argument

```julia-repl
julia> transversal(G,[1,2],action=(x,y)->x.^y)
Dict{Array{Int64,1},Perm{Int16}} with 6 entries:
  [1, 3] => (2,3)
  [1, 2] => ()
  [2, 3] => (1,2,3)
  [3, 2] => (1,3)
  [2, 1] => (1,2)
  [3, 1] => (1,3,2)
```
"""
function transversal(G::Group,pnt;action::Function=^)
  trans=Dict(pnt=>one(G))
  orb=[pnt]
  for pnt in orb, gen in gens(G)
    img=action(pnt,gen)
    if !haskey(trans,img)
      push!(orb,img)
      trans[img]=trans[pnt]*gen
    end
  end
  trans
end

function orbits(gens::Vector,v::AbstractVector;action::Function=^,trivial=true)
  res=Vector{eltype(v)}[]
  while !isempty(v)
    o=orbit(gens,v[1],action=action)
    if length(o)>1 || trivial push!(res,o) end
    v=setdiff(v,o)
  end
  res
end

"""
    `orbits(G,v;action=^)`
    
the orbits of Group `G` on `v`; the elements of `v` should be hashable.
```julia-repl
julia> G=Group([Perm(1,2),Perm(2,3)]);
julia> orbits(G,1:4)
2-element Array{Array{Int64,1},1}:
 [1, 2, 3]
 [4]
```
"""
orbits(G::Group,v::AbstractVector=1:degree(G);action::Function=^,trivial=true)=
  orbits(gens(G),v;action=action,trivial=trivial)

"""
    centralizer(G,p;action=^) 
    computes the centralizer C_G(p)
```julia-repl
julia> G=Group([Perm(1,2),Perm(1,2,3)]);
julia> centralizer(G,1)
Group([perm"(2,3)"])
```
"""
function centralizer(G::Group,p;action::Function=^)
# this computes Schreier generators
  t=transversal(G,p;action=action)
  C=[wx*s/t[action(x,s)] for (x,wx) in t for s in gens(G)]
  Group(unique(sort(C)))
end

centralizer(G::Group,H::Group)=centralizer(G,gens(H);action=(x,s)->x.^s)

centre(G::Group)=centralizer(G,G)

"""
    `minimal_words(G)`
  returns a Dict giving for each element of `G` a minimal positive word in 
  the generators representing it.

```julia-repl
julia> G=Group([Perm(1,2),Perm(1,2,3)]);
julia> minimal_words(G)
Dict{Perm{Int16},Array{Int64,1}} with 6 entries:
  ()      => Int64[]
  (2,3)   => [2, 1]
  (1,3,2) => [1, 2, 1]
  (1,3)   => [1, 2]
  (1,2)   => [1]
  (1,2,3) => [2]
```
  This Dict is stored in `G.prop[:words]` for further use.
"""
function minimal_words(G::Group)
  gets(G,:words)do G
    words=Dict(one(G)=>Int[])
    for i in eachindex(gens(G))
      nwords=copy(words)
      rw = [one(G)=>Int[]]
      while !isempty(rw)
        p=popfirst!(rw)
        for k in 1:i
          e=first(p)*gens(G)[k]
          if !haskey(nwords,e)
            we=vcat(last(p),[k])
            push!(rw,e=>we)
            for (e1,w1) in words nwords[e1*e]=vcat(w1,we) end
          end
        end
      end
      words = nwords
    end
    words
  end
end

"word(G::Group,w): a word in  gens(G) representing element w of G"
word(G::Group,w)=minimal_words(G)[w]

"elements(G::Group): the list of elements of G"
elements(G::Group)=collect(keys(minimal_words(G)))

"length(G::Group): the number of elements of G"
Base.length(G::Group)=length(minimal_words(G))

function conjugacy_classes(G::Group{T})::Vector{Vector{T}} where T
  gets(G,:classes) do G
    if haskey(G.prop,:classreps)
      map(x->orbit(G,x),class_reps(G))
    elseif length(G)>10000
      error("length(G)=",length(G),": should call Gap4")
    else
      orbits(G,elements(G))
    end
  end
end

function position_class(G::Group,g)
  findfirst(c->g in c,conjugacy_classes(G))
end

function fusion_conjugacy_classes(H::Group,G::Group)
  map(x->position_class(G,x),class_reps(H))
end

"class_reps(G::Group): representatives of conjugacy classes of G"
function class_reps(G::Group{T})::Vector{T} where T
  gets(G,:classreps) do G
    first.(conjugacy_classes(G))
  end
end

# hom from source to target sending gens(source) to images
struct Hom{T,T1}
  source::Group{T}
  target::Group{T1}
  images::Vector{T1}
end

function Base.show(io::IO,h::Hom)
  print(io,"Hom(",h.source,"→ ",h.target,";",gens(h.source),"↦ ",h.images)
end

function kernel(h::Hom)
  if all(isone,h.images) return h.source
  elseif length(h.source)==length(Group(h.images)) 
    return Group(empty(gens(h.source)))
  elseif length(h.source)<1000
    return Group(filter(x->isone(h(x)),elements(h.source)))
  else error("not implemented: kernel(",h,")")
  end
end

# h(w) is the image of w by h
(h::Hom)(w)=isone(w) ? one(h.target) : prod(h.images[word(h.source,w)])

isabelian(W::Group)=all(x*y==y*x for x in gens(W), y in gens(W))

function representative_operation(W::Group,p1,p2;action::Function=^)
  t=transversal(W,p1;action=action)
  if haskey(t,p2) return t[p2] end
end

#------------------- "abstract" concrete groups -------------------------------
struct GroupofAny{T}<:Group{T}
  gens::Vector{T}
  prop::Dict{Symbol,Any}
end

Group(a::AbstractVector{T}) where T=GroupofAny(a,Dict{Symbol,Any}())

#------------------- cosets ----------------------------------------
# for now normal cosets (phi normalizes G)
abstract type Coset{TW<:Group} end

struct CosetofAny{T,TW<:Group{T}}<:Coset{TW}
  phi::T
  G::TW
  prop::Dict{Symbol,Any}
end

Coset(G::Group,phi)=CosetofAny(phi,G,Dict{Symbol,Any}())

Group(W::Coset)=W.G

(W::Coset)(x...)=element(Group(W),x...)*W.phi

Base.cmp(a::Coset, b::Coset)=cmp(a.phi,b.phi)

Base.isless(a::Coset, b::Coset)=cmp(a,b)==-1

Base.:(==)(a::Coset, b::Coset)= cmp(a,b)==0

Base.hash(a::Coset, h::UInt)=hash(a.phi,h)

Base.copy(C::Coset)=Coset(Group(C),C.phi)

Base.one(C::Coset)=Coset(Group(C),one(C.phi))

Base.inv(C::Coset)=Coset(Group(C),inv(C.phi))

Base.length(C::Coset)=length(Group(C))

Base.:*(a::Coset,b::Coset)=Coset(Group(a),a.phi*b.phi)

Base.:^(a::Coset, n::Integer)= n>=0 ? Base.power_by_squaring(a,n) :
                               Base.power_by_squaring(inv(a),-n)

Base.:^(a::Coset, b::Coset)= inv(b)*a*b

order(a::Coset)=findfirst(i->isone(a^i),1:order(a.phi))

Base.show(io::IO,C::Coset)=print(io,Group(C),".",C.phi)

struct CosetGroup{TW}<:Group{Coset{TW}}
  gens::Vector{Coset{TW}}
  prop::Dict{Symbol,Any}
end

Groups.Group(g::Vector{Coset})=CosetGroup(filter(!isone,g),Dict{Symbol,Any}())

Base.:/(W::Group,H::Group)=Group(map(x->Coset(H,x),gens(W)))

elements(C::Coset)=C.phi .* elements(Group(C))

function class_reps(G::Coset{Group{T}})::Vector{T} where T
  gets(G,:classreps) do G
    first.(conjugacy_classes(G))
  end
end

function conjugacy_classes(G::Coset{<:Group{T}})::Vector{Vector{T}} where T
  gets(G,:classes) do G
    if haskey(G.prop,:classreps)
      map(x->orbit(Group(G),x),class_reps(G))
    elseif length(G)>10000
      error("length(G)=",length(G),": should call Gap4")
    else
      orbits(Group(G),elements(G))
    end
  end
end

function position_class(G::Coset,g)
  findfirst(c->g in c,conjugacy_classes(G))
end

function fusion_conjugacy_classes(H::Coset,G::Coset)
  map(x->position_class(G,x),class_reps(H))
end

end
