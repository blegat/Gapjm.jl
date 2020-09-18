"""
Eigenspaces and `d`-Harish-Chandra series

Let `Wϕ` be a reflection coset on a vector space `V` and `Lwϕ` a reflection
subcoset  where `L` is a  parabolic subgroup (the fixator  of a subspace of
`V`).  There  are  several  interesting  cases  where  the *relative group*
`N_W(Lwϕ)/L`, or a subgroup of it normalizing some further data attached to
`L`, is itself a reflection group.

A first example is the case where `ϕ=1` and `w=1`, `W` is the Weyl group of
a finite reductive group `𝐆^F` and the Levi subgroup `𝐋^F` corresponding to
`L`  has a cuspidal unipotent character. Then `N_W(L)/L` is a Coxeter group
acting  on the  space `X(Z𝐋)⊗ℝ`.  A combinatorial  characterization of such
parabolic  subgroups of Coxeter  groups is that  they are normalized by the
longest element of larger parabolic subgroups (see [5.7.1
Lusztig1976](biblio.htm#Lus76)).

A  second  example  is  when  `L`  is  trivial  and  `wϕ` is a *`ζ`-regular
element*,  that  is  the  `ζ`-eigenspace  `V_ζ`  of  `wϕ` contains a vector
outside all the reflecting hyperplanes of `W`. Then `N_W(Lwϕ)/L=C_W(wϕ)` is
a reflection group in its action on `V_ζ`.

A  similar but more general example is  when `V_ζ` is the `ζ`-eigenspace of
some  element of  the reflection  coset `Wϕ`,  and is  of maximal dimension
among such possible `ζ`-eigenspaces. Then the set of elements of `Wϕ` which
act  by `ζ`  on `V_ζ`  is a  certain subcoset  `Lwϕ`, and `N_W(Lwϕ)/L` is a
reflection group in its action on `V_ζ` (see [2.5
Lehrer-Springer1999](biblio.htm#LS99)).

Finally,  a  still  more  general  example,  but which only occurs for Weyl
groups  or  Spetsial  reflection  groups,  is  when `𝐋` is a `ζ`-split Levi
subgroup  (which means that  the corresponding subcoset  `Lwϕ` is formed of
all  the elements which act by `ζ` on  some subspace `V_ζ` of `V`), and `λ`
is  a  `d`-cuspidal  unipotent  character  of  `𝐋`  (which  means  that the
multiplicity  of `ζ`  as a  root of  the degree  of `λ`  is the same as the
multiplicity  of `ζ` as a root of the generic order of the semi-simple part
of `𝐆`); then `N_W(Lwϕ,λ)/L` is a complex reflection group in its action on
`V_ζ`.

Further,  in the above cases the relative group describes the decomposition
of a Lusztig induction.

When  `𝐆^F`  is  a  finite  reductive  group,  and `λ` a cuspidal unipotent
character  of the Levi subgroup  `𝐋^F`, then the `𝐆^F`-endomorphism algebra
of  the Harish-Chandra induced representation `R_𝐋^𝐆(λ)` is a Hecke algebra
attached  to the group `N_W(L)/L`, thus  the dimension of the characters of
this group describe the multiplicities in the Harish-Chandra induced.

Similarly, when `𝐋` is a `ζ`-split Levi subgroup, and `λ` is a `d`-cuspidal
unipotent  character  of  `𝐋`  then  (conjecturally) the `𝐆^F`-endomorphism
algebra of the Lusztig induced `R_𝐋^𝐆(λ)` is a cyclotomic Hecke algebra for
to  the group `N_W(Lwϕ,λ)/L`.  The constituents of  `R_𝐋^𝐆(λ)` are called a
`ζ`-Harish-Chandra  series.  In  the  case  of  rational  groups or cosets,
corresponding  to  finite  reductive  groups,  the conjugacy class of `Lwϕ`
depends only on the order `d` of `ζ`, so one also talks of
`d`-Harish-Chandra  series. These series correspond to `ℓ`-blocks where `l`
is  a prime divisor of `Φ_d(q)` which  does not divide any other cyclotomic
factor of the order of `𝐆^F`.

The functions described in this module allow to explore these situations.
"""
module Eigenspaces
export relative_degrees, regular_eigenvalues,
  position_regular_class, eigenspace_projector, GetRelativeAction,
  GetRelativeRoot, split_levis, cuspidal_unipotent_characters

using Gapjm
"""
`relative_degrees(WF,d)`

Let  `WF` be a reflection group or a reflection coset. Here `d` specifies a
root  of unity `ζ`: either `d` is an integer and specifies `ζ=E(d)` or is a
fraction  smaller `a/b` with `0<a<b`  and specifies `ζ=E(b,a)`. If omitted,
`d`   is  taken  to  be  `1`,  specifying  `ζ=1`.  Then  if  `V_ζ`  is  the
`ζ`-eigenspace  of some element of `WF`,  and is of maximal dimension among
such   possible  `ζ`-eigenspaces,  and  `W`  is  the  group  of  `WF`  then
`N_W(V_ζ)/C_W(V_ζ)`  is  a  reflection  group  in  its action on `V_ζ`. The
function  `relative_degrees` returns the reflection degrees of this complex
reflection group, which are a subset of those of `W`.

These   degrees  are   computed  by   an  invariant-theoretic  formula:  if
`(d₁,ε₁),…,(dₙ,εₙ)`  are the generalized degrees of  `WF` they are the `dᵢ`
such that `ζ^{dᵢ}=εᵢ`.

```julia-repl
julia> W=coxgroup(:E,8)
E₈

julia> relative_degrees(W,4)
4-element Array{Int64,1}:
  8
 12
 20
 24
```
"""
relative_degrees(W,d::Integer)=relative_degrees(W,Root1(1,d))
relative_degrees(W,d::Rational)=relative_degrees(W,Root1(;r=d))
relative_degrees(W,d::Root1)=filter(x->isone(d^x),degrees(W))
relative_degrees(W)=relative_degrees(W,Root1(0,1))
relative_degrees(W::Spets,z::Root1)=[d for (d,f) in degrees(W) if E(z)^d==f]

"""
`regular_eigenvalues(W)`

Let `W` be a reflection group or a reflection coset. A root of unity `ζ` is
a *regular eigenvalue* for `W` if some element of `W` has a `ζ`-eigenvector
which   lies   outside   of   the   reflecting  hyperplanes.  The  function
`regular_eigenvalues` returns the list of regular eigenvalues for `W`.
```julia-repl
julia> regular_eigenvalues(coxgroup(:G,2))
6-element Array{Root1,1}:
   1
  -1
  ζ₃
 ζ₃²
  ζ₆
 ζ₆⁵

julia> W=ComplexReflectionGroup(6)
G₆

julia> L=twistings(W,[2])[4]
G₆₍₂₎=G₃‚₁‚₁[ζ₄]Φ′₄

julia> regular_eigenvalues(L)
3-element Array{Root1,1}:
    ζ₄
  ζ₁₂⁷
 ζ₁₂¹¹
```
"""
function regular_eigenvalues(W)
  d=degrees(W)
  c=codegrees(W)
  if !(W isa Spets)
    l=filter(x->count(iszero.(d.%x))==count(iszero.(c.%x)),
                  sort(union(divisors.(d)...)))
    return sort(vcat(map(x->map(y->Root1(;r=y//x),prime_residues(x)),l)...))
  end
  l=union(map(p->divisors(conductor(Root1(p[2]))*p[1]),d)...)
  res=Root1[]
  for n in l
    p=prime_residues(n)
    p1=filter(i->count(p->E(n,i*p[1])==p[2],d)==count(p->E(n,i*p[1])==p[2],c),p)
    append!(res,map(x->Root1(;r=x//n),p1))
  end
  res
end

"""
`position_regular_class(WF,d=0)`

Let  `WF` be a reflection group or a reflection coset. Here `d` specifies a
root  of unity `ζ`: either `d` is an integer and specifies `ζ=E(d)' or is a
fraction  smaller `a/b` with `0<a<b`  and specifies `ζ=E(b,a)'. If omitted,
`d`  is taken to be `0`, specifying `ζ=1`. The root `ζ` should be a regular
eigenvalue  for `WF` (see "regular_eigenvalues").  The function returns the
index of the conjugacy class of `WF` which has a `ζ`-regular eigenvector.

```julia-repl
julia> W=coxgroup(:E,8)
E₈

julia> position_regular_class(W,30)
65

julia> W=ComplexReflectionGroup(6)
G₆

julia> L=twistings(W,[2])[4]
G₆₍₂₎=G₃‚₁‚₁[ζ₄]Φ′₄

julia> position_regular_class(L,7//12)
2
```
"""
position_regular_class(W,d::Integer)=position_regular_class(W,Root1(1,d))
position_regular_class(W,d::Rational)=position_regular_class(W,Root1(;r=d))
function position_regular_class(W,d::Root1=1)
  drank=length(relative_degrees(W,d))
  if drank==0 return nothing end
  return findfirst(x->count(==(d),x)==drank,refleigen(W))
end

"""
`eigenspace_projector(WF,w[,d=0//1])`

Let  `WF` be a reflection group or a reflection coset. Here `d` specifies a
root  of unity `ζ`: either `d` is an integer and specifies `ζ=E(d)' or is a
fraction  smaller `a/b` with `0<a<b` and specifies `ζ=E(b,a)'. The function
returns the unique `w`-invariant projector on the `ζ`-eigenspace of `w`.

```julia-repl
julia> W=coxgroup(:A,3)
A₃

julia> w=W(1:3...)
(1,12,3,2)(4,11,10,5)(6,9,8,7)

julia> p=eigenspace_projector(W,w,1//4)
3×3 Array{Cyc{Rational{Int64}},2}:
  1/4+ζ₄/4   ζ₄/2  -1/4+ζ₄/4
  1/4-ζ₄/4    1/2   1/4+ζ₄/4
 -1/4-ζ₄/4  -ζ₄/2   1/4-ζ₄/4

julia> GLinearAlgebra.rank(p)
1

```
"""
eigenspace_projector(WF,w,d::Integer)=eigenspace_projector(WF,w,Root1(1,d))
eigenspace_projector(WF,w,d::Rational=0//1)=eigenspace_projector(WF,w,Root1(;r=d))
function eigenspace_projector(WF, w, d::Root1)
  c=refleigen(WF)[position_class(WF,w)]
  c=E.(filter(x->x!=d,c))
  f=reflrep(WF,w)
  if length(c)==0 f^0
  else prod(x->f-f^0*x,c)//prod(x->E(d)-x,c)
  end
end

function GetRelativeAction(W,L,w)
  m=reflrep(W,w)
  if size(m,2)==0 return m end
  m=m^inv(baseX(L))
  m[semisimplerank(L)+1:end,semisimplerank(L)+1:end]
end

function Groups.normalizer(W::PermRootGroup,L::PermRootGroup)
  r=unique!(sort(reflections(L)))
  centralizer(W,r;action=(x,g)->sort(x.^g))
end

iscyclic(W::Group)=length(Weyl.AbelianGenerators(elements(W)))<=1

function GetRelativeRoot(W,L,i)
  J=vcat(inclusiongens(L,W),[i])
# printc("W=",W," J=",J," L=",L,"\n")
  N=normalizer(reflection_subgroup(W,J),L)
  F=N/L
# rshow(Weyl.AbelianGenerators(elements(F)))
  if  !iscyclic(F)  error("in theory N/L expected to be cyclic") end
  d=length(F)
# println("d=$d ",order.(elements(F)))
  for rc in filter(x->order(x)==d,elements(F))
    m=GetRelativeAction(W,L,rc.phi)
    r=reflection(m)
    if isnothing(r) error("I thought this does not happen") end
#   println("rc=$rc")
    if E(r.eig)==E(d)
      res=Dict{Symbol,Any}(:root=>r.root, :coroot=>r.coroot,
                         :eigenvalue=>r.eig)
      res[:index]=i
      rc=filter(c->GetRelativeAction(W,L,c)==m,classreps(N))
#     println("rc=$rc")
      c=unique!(sort(map(x->position_class(W,x),rc)))
      m=maximum(map(x->count(isone,x),refleigen(W)[c]))
      m=filter(x->count(isone,refleigen(W)[x])==m,c)
      m=filter(x->position_class(W,x) in m,rc)
      if any(x->order(x)==d,m)  m=filter(x->order(x)==d,m) end
      res[:parentMap]=m[1]
      return res
    end
  end
  error("no root found for reflection",i,"\n")
end

"""
`split_levis(WF,d=0,ad=-1)`

Let  `WF`  be  a  reflection  group  or  a  reflection  coset.  If `W` is a
reflection group it is treated as the trivial coset 'Spets(W)'.

Here  `d`  specifies  a  root  of  unity  `ζ`: either `d` is an integer and
specifies  `ζ=E(d)`  or  is  a  fraction  `a/b`  with `0<a<b` and specifies
`ζ=E(b,a)`. If omitted, `d` is taken to be `0`, specifying `ζ=1`.

A  *Levi*  is  a  subcoset  of  the  form `W₁F₁` where `W₁` is a *parabolic
subgroup* of `W`, that is the centralizer of some subspace of `V`.

The  function returns  a list  of representatives  of conjugacy  classes of
`d`-split  Levis of `W`. A  `d`-split Levi is a  subcoset of `WF` formed of
all  the  elements  which  act  by  `ζ`  on  a given subspace `V_ζ`. If the
additional  argument `ad`  is given,  it returns  only those subcosets such
that the common `ζ`-eigenspace of their elements is of dimension `ad`.

```julia-repl
julia> W=coxgroup(:A,3)
A₃

julia> split_levis(W,4)
2-element Array{Any,1}:
 A₃
 A₃₍₎=.Φ₂Φ₄

julia> W=spets(coxgroup(:D,4),Perm(1,2,4))
³D₄

julia> split_levis(W,3)
3-element Array{Any,1}:
 ³D₄
 D₄₍₁₃₎=A₂Φ₃
 ³D₄

julia> W=coxgroup(:E,8)
E₈

julia> split_levis(W,4,2)
3-element Array{Any,1}:
 E₈₍₃₂₄₅₎=D₄₍₁₃₂₄₎Φ₄²
 E₈₍₅₇₂₃₎=(A₁A₁)×(A₁A₁)Φ₄²
 E₈₍₃₁₅₆₎=²(A₂A₂)₍₁₄₂₃₎Φ₄²
```
"""
split_levis(WF,d=0//1)=vcat(map(ad->split_levis(WF, d,
                                   ad),0:length(relative_degrees(WF,d)))...)

split_levis(WF,d::Integer,ad)=split_levis(WF,Root1(1,d),ad)
split_levis(WF,d::Rational,ad)=split_levis(WF,Root1(;r=d),ad)
function split_levis(WF,d::Root1,ad)
  if WF isa Spets W=WF.W
  else W=WF; WF=spets(W)
  end
  refs=eachindex(reflections(W)[1:nref(W)]) #hum
#  refs=filter(i->Position(reflections(W),reflection(W,i))==i,
#              eachindex(roots(W)))
  mats=map(i->reflrep(W,reflection(W,i)),refs)
  eig=refleigen(WF)
  cl=filter(j->count(==(d),eig[j])==ad,1:length(eig))
  res=[]
  while length(cl)>0
    w=classreps(WF)[cl[1]]
    if rank(W)==0 V=fill(0,0,0)
    else m=reflrep(WF,w)
      V=permutedims(GLinearAlgebra.nullspace(permutedims(m-E(d)*one(m))))
    end
    I=refs[map(m->V==V*m, mats)]
    HF=subspets(WF, inclusion(W)[I], w/WF.phi)
    if isnothing(HF)
      error("subspets($WF,",inclusion(W)[I],",class#",cl[1],") failed")
    else
      f=intersect(fusion_conjugacy_classes(HF, WF), cl)
      if length(f)==0
          error("fusion is wrong")
          return false
      end
      cl=setdiff(cl,f)
      H=HF.W
      P=standard_parabolic(W, H)
      if P==false P=Perm() end
      J=inclusiongens(H).^P
      if P!=Perm() || J!=inclusiongens(H)
         HF=subspets(WF,J,HF.phi^P/WF.phi)
      end
      push!(res, HF)
    end
  end
  return res
end

function PermRoot.standard_parabolic(W::PermRootGroup, H)
  wr=inclusiongens(W)
  hr=inclusiongens(H)
  if issubset(hr,wr) return Perm() end
  I=combinations(wr,length(hr))
  I=filter(l->length(reflection_subgroup(W,l))==length(H),I)
  try_=function(a)
    H1=H
    w=Perm()
    for i in 1:length(a)
      C=centralizer(W, reflection_subgroup(W,a[1:i-1]))
      t=transversal(C,inclusion(H1)[i])
      if haskey(t,a[i]) w1=t[a[i]]
      else
        t=transversal(C,H1(i))
        r=reflection(W,restriction(W)[a[i]])
        if haskey(t,r) w1=t[r] else return nothing end
      end
      w=w*w1
      H1=H1^w1
    end
    return w
  end
  for l in I
    for a in arrangements(l, length(l))
      w=try_(a)
      if !isnothing(w) return w end
    end
  end
  InfoChevie("\n# ****** ", hr, " not conjugate to a standard parabolic\n")
  return nothing
end

function Weyl.relative_group(W,J,indices=false)
# println("relative_group: W=$W J=$J indices=$indices")
  res = Dict{Symbol, Any}(:callarg => joindigits(J))
  if indices!=false
      res[:callarg]*=","
      res[:callarg]*=joindigits(indices)
  end
# res = CHEVIE[:GetCached](W, "RelativeGroups", res, x->x[:callarg])
  if length(keys(res))>1 return res end
  L = reflection_subgroup(W, J)
  if length(J)==0
    W.prop[:MappingFromNormalizer]=w->PermX(W,GetRelativeAction(W, L, w))
    W.prop[:relativeIndices] = eachindex(gens(W))
    return W
  end
  if indices==false
    indices=filter(x->!(reflection(W, x) in L),eachindex(gens(W)))
  end
  if sort(inclusion(L))==sort(inclusion(W))
    res[:relativeIndices]=Int[]
    res[:MappingFromNormalizer]=w->Perm()
    return PRG(Matrix{Int}[],Vector{Int}[],Vector{Int}[],
          Group(Perm{Int16}[]),res)
  end
  res[:roots] = []
  res[:simpleCoroots] = []
  res[:relativeIndices] = []
  res[:parentMap] = []
  for R in filter(!isnothing,map(r->GetRelativeRoot(W,L,r),indices))
   if !(R[:root] in res[:roots]) ||
    findfirst(==(R[:root]),res[:roots])!=
    findfirst(==(R[:coroot]),res[:simpleCoroots])
      push!(res[:roots], R[:root])
      push!(res[:simpleCoroots], R[:coroot])
      push!(res[:relativeIndices], R[:index])
      push!(res[:parentMap], R[:parentMap])
    end
  end
  N=length(normalizer(W,L))//length(L)
  res[:roots]=improve_type(res[:roots])
  res[:simpleCoroots]=improve_type(res[:simpleCoroots])
# println(res[:roots],res[:simpleCoroots])
  R=PRG(res[:roots], res[:simpleCoroots])
  R.prop[:MappingFromNormalizer] = w->PermX(R, GetRelativeAction(W, L, w))
  if N==length(R)
    merge!(R.prop,res)
#   InfoChevie("W_",W,"(L_",res[:callarg],")==",R,"<",join(R.prop[:relativeIndices]),">")
    printc("W_",W,"(L_",res[:callarg],")==",R,"<",join(R.prop[:relativeIndices]),">\n")
    return R
  end
  printc("# warning: W_",W,"(L_"*res[:callarg]*")", ":size ", N, " not generated by ",
    joindigits(indices, "!="), " ==>size ", length(R), "\n#",
    "           trying all other roots")
  indices=filter(r->!(reflection(W,r) in gens(W)) &&
                    !(reflection(W,r) in L), eachindex(gens(W)))
  for r in indices
    l=GetRelativeRoot(W, L, r)
    if !isnothing(l) && !(l[:root] in res[:roots])
      R=PRG(vcat(res[:roots],[l[:root]]),vcat(res[:simpleCoroots],[l[:coroot]]))
      if N == Size(R)
        push!(res[:roots], l[:root])
        push!(res[:simpleCoroots], l[:coroot])
        push!(res[:relativeIndices], l[:index])
        push!(res[:parentMap], l[:parentMap])
        R.prop=res
        return R
      end
    end
  end
  error("relgroup not found")
end

"""
`cuspidal_unipotent_characters(WF[,d])`

Let  `WF`  be  a  reflection  group  or  a  reflection  coset.  If `W` is a
reflection group it is treated as the trivial coset `Spets(W)`.

A  unipotent character `γ` of the corresponding finite reductive group `bG`
is  `d`-cuspidal if its Lusztig restriction to any proper `d`-split Levi is
zero.  When  `d==1`  we  recover  the  usual  notion of cuspidal character.
Equivalently  the `Phi_d`-part of the generic degree of `γ` is equal to the
` Phi_d`-part of the generic order of the adjoint group of ` bG`.

The  function returns the list of indices of unipotent characters which are
`d`-cuspidal.  If ` d` is  omitted, it is taken  to be `1`.

```julia-repl
julia> W=coxgroup(:D,4)
D₄

julia> cuspidal_unipotent_characters(W)
1-element Array{Int64,1}:
 14

julia> cuspidal_unipotent_characters(W,6)
8-element Array{Int64,1}:
  1
  2
  6
  7
  8
  9
 10
 12
```
"""
function cuspidal_unipotent_characters(WF,d=1)
  if length(WF)==1 return [1] end
  ad=count(!isone,relative_degrees(WF,d))
# if ad=0 then Error(d," should divide one of the degrees");fi;
  ud=Uch.CycPolUnipotentDegrees(WF)
  filter(i->ad==valuation(ud[i],d),eachindex(ud))
end

end
