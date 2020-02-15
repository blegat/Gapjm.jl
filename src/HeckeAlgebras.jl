"""
This   module  ports   Chevie  functionality   for  Iwahori-Hecke  algebras
associated to Coxeter groups.

Let  (W,S) be a Coxeter  system where `mₛₜ` is  the order of `st` for `s,t∈
S`. Let `R` be a commutative ring with 1 and for `s∈ S` let `uₛ₀,uₛ₁∈ R` be
elements which depend ony on the conjugacy class of `s` in `W` (this is the
same  as requiring that `uₛᵢ=uₜᵢ` whenever `mₛₜ` is odd). The Iwahori-Hecke
algebra of `W` over `R` with parameters `uₛᵢ` is a deformation of the group
algebra  of `W` over `R` defined as  follows: it is the unitary associative
`R`-algebra generated by elements `Tₛ, s∈ S` subject to the relations:

``(Tₛ-uₛ₀)(Tₛ-uₛ₁)=0`` for all `s∈ S` (the quadratic relations)

``TₛTₜTₛ…= TₜTₛTₜ…`` with `mₛₜ` factors on each side (the braid relations)

If  `uₛ₀=1` and  `uₛ₁=-1` for  all `s`  then the quadratic relations become
`Tₛ²=1` and the deformation of the group algebra is trivial.

Since  the generators `Tₛ` satisfy the  braid relations, the algebra `H` is
in  fact a quotient of the group algebra of the braid group associated with
`W`.  It follows that, if `w=s_1⋯ s_m`  is a reduced expression of `w ∈ W`
then  the  product  `Tₛ_1⋯ Tₛ_m`  depends  only  on `w`. We will therefore
denote by `T_w`. We have `T_1=1`.

If  one of `uₛ₀` or `uₛ₁` is invertible  in `R`, for example `uₛ₁`, then by
changing  the generators  to `T′ₛ=-Tₛ/uₛ₁`,  and setting `qₛ=-uₛ₀/uₛ₁`, the
braid  relations do no change  (since when `mₛₜ` is  odd we have `uₛᵢ=uₜᵢ`)
but  the quadratic relations become  `(T′ₛ-qₛ)(T′ₛ+1)=0`. This last form is
the  most common  form considered  in the  literature. Another common form,
considered  in  the  context  of  Kazhdan-Lusztig  theory, is `uₛ₀=√qₛ` and
`uₛ₁=-√qₛ⁻¹`.  The general form of parameters provided is a special case
of general cyclotomic Hecke algebras, and can be useful in many contexts.

For  some  algebras  the  character  table,  and in general Kazhdan-Lusztig
bases,  require a square root of `-uₛ₀uₛ₁`.  We provide a way to specify it
with  the  field  `.rootpara`  which  can  be  given  when constructing the
algebra. If not given a root is automatically extracted when needed (and we
know  how to compute it) by the function `RootParameter`. Note however that
sometimes  an  explicit  choice  of  root  is  necessary  which  cannot  be
automatically determined.

There  is a universal choice  for `R` and `uₛᵢ`:  Let `uₛᵢ:s∈ S,i∈[0,1]` be
indeterminates   such  that  `uₛᵢ=uₜᵢ`  whenever  `mₛₜ`  is  odd,  and  let
`A=ℤ[uₛᵢ]` be the corresponding polynomial ring. Then the Hecke algebra `H`
of  `W` over a  with parameters `uₛᵢ`  is called the *generic Iwahori-Hecke
algebra*  of  with  `W`.  Any  other  algebra  with parameters `vₛᵢ` can be
obtained  by specialization from  `H`: There is  a unique ring homomorphism
`f:A  → R` such that `f(uₛᵢ)=vₛᵢ`  for all `i`. Then we  can view `R` as an
`A`-module via `f` and we can identify the other algebra to ``R⊗ _A H``.

The  elements `{T_w∣w∈ W}` actually form an  `R`-basis of `H` if one of the
`uₛᵢ`  is invertible for all `s`. The  structure constants in that basis is
obtained  as  follows.  To  multiply  `T_v`  by  `T_w`,  choose  a  reduced
expression for `v`, say `v=s_1 ⋯ s_k` and apply inductively the formula:

``T_sT_w=T_{sw}``               if `l(sw)=l(w)+1`

``T_sT_w=-uₛ₀uₛ₁T_{sw}+(uₛ₀+uₛ₁)T_w`` if `l(sw)=l(w)-1`.

If all `s` we have `uₛ₀=q`, `uₛ₁=-1` then we call the corresponding algebra
the one-parameter or Spetsial Iwahori-Hecke algebra associated with `W`; it
can  be obtained with the  simplified call 'hecke(W,q)'. Certain invariants
of  the irreducible characters of  this algebra play a  special role in the
representation  theory of the underlying  finite Coxeter groups, namely the
`a`- and `A`-invariants. For basic properties of Iwahori-Hecke algebras and
their  relevance to the representation theory of finite groups of Lie type,
see for example Curtis and Reiner 1987, Sections~67 and 68.

In  the  following  example,  we  compute  the multiplication table for the
`0`-Iwahori--Hecke algebra associated with the Coxeter group of type `A_2`.

```julia-repl
julia> W=coxgroup(:A,2)
A₂

julia> H=hecke(W,0)             # One-parameter algebra with `q=0`
hecke(A₂,0)

julia> T=Tbasis(H);             # Create the `T` basis

julia> el=words(W)
6-element Array{Array{Int8,1},1}:
 []       
 [2]      
 [1]      
 [2, 1]   
 [1, 2]   
 [1, 2, 1]

julia> T.(el)*permutedims(T.(el))        # multiplication table
6×6 Array{HeckeTElt{Perm{Int16},Int64,FiniteCoxeterGroup{Perm{Int16},Int64}},2}:
 T.    T₂     T₁     T₂₁    T₁₂    T₁₂₁ 
 T₂    -T₂    T₂₁    -T₂₁   T₁₂₁   -T₁₂₁
 T₁    T₁₂    -T₁    T₁₂₁   -T₁₂   -T₁₂₁
 T₂₁   T₁₂₁   -T₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁ 
 T₁₂   -T₁₂   T₁₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁ 
 T₁₂₁  -T₁₂₁  -T₁₂₁  T₁₂₁   T₁₂₁   -T₁₂₁

```
Thus,  we work  with algebras  with arbitrary  parameters. We will see that
this also works on the level of characters and representations.
 
finally, benchmarks on julia 1.0.2
```benchmark
julia> function test_w0(n)
         W=coxgroup(:A,n)
         Tbasis(hecke(W,Pol([1],1)))(longest(W))^2
       end
test_w0 (generic function with 1 method)

julia> @btime test_w0(7);
  132.737 ms (1788153 allocations: 157.37 MiB)
```
Compare to GAP3 where the following function takes 0.92s
```
test_w0:=function(n)local W,T,H;
  W:=CoxeterGroup("A",n);H:=Hecke(W,X(Rationals));T:=Basis(H,"T");
  T(LongestCoxeterWord(W))^2;
end;
```
"""
module HeckeAlgebras
using Gapjm
export HeckeElt, Tbasis, central_monomials, hecke, HeckeAlgebra, HeckeTElt, 
  rootpara, equalpara

struct HeckeAlgebra{C,TW<:Group}
  W::TW
  para::Vector{Vector{C}}
  prop::Dict{Symbol,Any}
end

"""
   hecke( W [, parameter][,rootpara=r]) return a Hecke algebra for W

# Example
```julia-repl
julia> W=coxgroup(:B,2)
B₂

julia> Pol(:q)
Pol{Int64}: q

julia> H=hecke(W,q)
hecke(B₂,q)

julia> H.para
2-element Array{Array{Pol{Int64},1},1}:
 [q, -1]
 [q, -1]

julia> H=hecke(W,q^2,rootpara=q)
hecke(B₂,q²,rootpara=q)

julia> [H.para,rootpara(H)]
2-element Array{Array{T,1} where T,1}:
 Array{Pol{Int64},1}[[q², -1], [q², -1]]
 Pol{Int64}[q, q]                                  

julia> H=hecke(W,[q^2,q^4],rootpara=[q,q^2])
hecke(B₂,Pol{Int64}[q², q⁴],rootpara=Pol{Int64}[q, q²])

julia> [H.para,rootpara(H)]
2-element Array{Array{T,1} where T,1}:
 Array{Pol{Int64},1}[[q², -1], [q⁴, -1]]
 Pol{Int64}[q, q²]

julia> H=hecke(W,9,rootpara=3)
hecke(B₂,9,rootpara=3)

julia> [H.para,rootpara(H)]
2-element Array{Array{T,1} where T,1}:
 Array{Int64,1}[[9, -1], [9, -1]]
 [3, 3]                              
```
"""
function hecke(W::Group,para::Vector{Vector{C}};
    rootpara::Vector{C}=C[]) where C
  para=map(eachindex(gens(W)))do i
    j=simple_representatives(W)[i]
    if i<=length(para) 
     if j<i && para[i]!=para[j] error("one should have  para[$i]==para[$j]") end
      return para[i]
    elseif j<i return para[j]
    else error("parameters should be given for first reflection in a class")
    end
  end
  d=Dict{Symbol,Any}(:equal=>constant(para))
  if !isempty(rootpara) d[:rootpara]=rootpara end
  HeckeAlgebra(W,para,d)
end

function hecke(W,p::Vector{C};rootpara::Vector{C}=C[])where C
  oo=order.(gens(W))
  if all(isequal(2),oo) z=0 else z=zero(Cyc) end
  para=map(p,oo)do p, o
    if o==2 return [p,-one(p)].+z end
    map(i->iszero(i) ? p+z : zero(p)+E(o)^i,0:o-1)
  end
  hecke(W,para,rootpara=convert(Vector{typeof(para[1][1])},rootpara))
end
  
function hecke(W,p::C;rootpara::C=zero(C))where C
  rootpara= iszero(rootpara) ? C[] : fill(rootpara,nbgens(W))
  hecke(W,fill(p,nbgens(W)),rootpara=rootpara)
end

function hecke(W,p::Tuple;rootpara=zero(p[1]))
  rootpara= iszero(rootpara) ? typeof(p[1])[] : fill(rootpara,nbgens(W))
  hecke(W,[collect(p) for j in 1:nbgens(W)],rootpara=rootpara)
end

hecke(W::Group)=hecke(W,1)

function rootpara(H::HeckeAlgebra)
  gets(H,:rootpara) do H
    map(eachindex(H.para)) do i
       if isone(-prod(H.para[i])) return -prod(H.para[i]) end
       error("could not compute rootpara[$i]")
    end
  end
end

equalpara(H::HeckeAlgebra)::Bool=H.prop[:equal]

function Base.show(io::IO, H::HeckeAlgebra)
  print(io,"hecke(",H.W,",")
  tr(p)= p[2]==-one(p[2]) ? p[1] : p
  if constant(H.para) print(io,tr(H.para[1]))
  else print(io,map(tr,H.para))
  end
  if haskey(H.prop,:rootpara)
    rp=rootpara(H)
    if constant(rp) print(io,",rootpara=",rp[1])
    else print(io,",rootpara=",rp)
    end
  end
  print(io,")")
end

impl1(l)=length(l)==1 ? l[1] : error("implemented only for irreducible groups")

function Chars.CharTable(H::HeckeAlgebra{C})where C
  W=H.W
  ct=impl1(getchev(W,:HeckeCharTable,H.para,
       haskey(H.prop,:rootpara) ? rootpara(H) : fill(nothing,length(H.para))))
  if haskey(ct,:irredinfo) names=getindex.(ct[:irredinfo],:charname)
  else                     names=charinfo(W)[:charnames]
  end
  CharTable(Matrix(convert.(C,toM(ct[:irreducibles]))),names,
     ct[:classnames],map(Int,ct[:centralizers]),ct[:identifier])
end

function Chars.representation(H::HeckeAlgebra,i::Int)
  ct=impl1(getchev(H.W,:HeckeRepresentation,H.para,
    haskey(H.prop,:rootpara) ? rootpara(H) : fill(nothing,length(H.para)),i))
  ct=toM.(ct)
  if all(x->all(isinteger,x),ct) ct=map(x->Int.(x),ct) end
  ct
end

Chars.representations(H::HeckeAlgebra)=representation.(Ref(H),1:HasType.NrConjugacyClasses(H.W))

function Chars.WGraphToRepresentation(H::HeckeAlgebra,gr::Vector)
  S=-H.para[1][2]*WGraphToRepresentation(length(H.para),gr,
                                   rootpara(H)[1]//H.para[1][2])
  CheckHeckeDefiningRelations(H,S)
  S
end

"""
central_monomials(H)
  Let  `H` be an Hecke  algebra for the reflection  group `W`. The function
  returns  the  scalars  by  which  the  image  in  `H`  of  π  acts on the
  irreducible  representations of  the Iwahori-Hecke  algebra. When  `W` is
  irreducible, π is the generator of the center of the pure braid group. In
  general,  it  is  the  product  of  such  elements  for  each irreducible
  component. When `W` is an irreducible Coxeter group, π is the lift to the
  braid group of the square of the longest element of `W`.

```julia-repl
julia> H=hecke(coxgroup(:H,3),Pol(:q))
hecke(H₃,q)

julia> central_monomials(H)
10-element Array{Pol{Cyc{Int64}},1}:
 1  
 q³⁰
 q¹²
 q¹⁸
 q¹⁰
 q¹⁰
 q²⁰
 q²⁰
 q¹⁵
 q¹⁵
```
"""
function central_monomials(H::HeckeAlgebra)
# Cf. BrMi, 4.16 for the formula used
  W=H.W
  v=hyperplane_orbits(W)
  map(eachrow(CharTable(W).irr)) do irr
    prod(v)do C
      q=H.para[restriction(W)[C.s]]
      m=map(0:C.order-1)do j
       (irr[1]+sum(l->irr[C.cl_s[l]]*E(C.order,-j*l),1:C.order-1))//C.order
      end
      E.(irr[1],-C.N_s*sum(m.*(0:C.order-1)))*
          prod(j->q[j]^Int(C.N_s*C.order*m[j]//irr[1]),1:C.order)
    end
  end
end

#--------------------------------------------------------------------------
abstract type HeckeElt{P,C} end

Base.zero(h::HeckeElt)=clone(h,zero(h.d))
Base.iszero(h::HeckeElt)=iszero(h.d)

function Base.show(io::IO, h::HeckeElt)
  function showbasis(io::IO,e)
    repl=get(io,:limit,false)
    TeX=get(io,:TeX,false)
    w=word(h.H.W,e)
    res=basename(h)
    if repl || TeX
      if isempty(w) res*="."
      else res*="_{"*(any(>=(10),w) ? join(w,",") : join(w))*"}"
      end
    else res*="("*join(map(x->"$x",w),",")*")"
    end
    fromTeX(io,res)
  end
  show(IOContext(io,:showbasis=>showbasis),h.d)
end


Base.:+(a::HeckeElt, b::HeckeElt)=clone(a,a.d+b.d)
Base.:-(a::HeckeElt)=clone(a,-a.d)
Base.:-(a::HeckeElt, b::HeckeElt)=a+(-b)

Base.:*(a::HeckeElt, b)=clone(a,a.d*b)
Base.:*(a::HeckeElt, b::Pol)=clone(a,a.d*b)
Base.:*(a::HeckeElt, b::Mvp)=clone(a,a.d*b)
Base.:*(b::Pol, a::HeckeElt)=a*b
Base.:*(b::Mvp, a::HeckeElt)=a*b
Base.:*(b::Number, a::HeckeElt)= a*b

Base.:^(a::HeckeElt, n::Integer)= n>=0 ? Base.power_by_squaring(a,n) : 
                                   Base.power_by_squaring(inv(a),-n)
#--------------------------------------------------------------------------
struct HeckeTElt{P,C,G<:CoxeterGroup}<:HeckeElt{P,C}
  d::ModuleElt{P,C} # has better merge performance than Dict
  H::HeckeAlgebra{C,G}
end

clone(h::HeckeTElt,d)=HeckeTElt(d,h.H)

basename(h::HeckeTElt)="T"
 
function Base.one(H::HeckeAlgebra{C}) where C
  HeckeTElt(ModuleElt(one(H.W)=>one(C)),H)
end

function Base.zero(H::HeckeAlgebra{C}) where C
  HeckeTElt(zero(ModuleElt{typeof(one(H.W)),C}),H)
end

Tbasis(h::HeckeTElt)=h

function Tbasis(H::HeckeAlgebra{C,TW})where C where TW<:CoxeterGroup{P} where P
  function f(w::Vararg{Integer})
    if isempty(w) return one(H) end
    HeckeTElt(ModuleElt(H.W(w...)=>one(C)),H)
  end
  f(w::Vector{<:Integer})=f(w...)
  f(w::P)=HeckeTElt(ModuleElt(w=>one(C)),H)
# Base.show(io::IO,t::Type{f})=print(io,"Tbasis($H)")
  f(h::HeckeElt)=Tbasis(h)
end

function Base.:*(a::HeckeTElt, b::HeckeTElt)
  if iszero(a) return a end
  if iszero(b) return b end
  W=a.H.W
  sum(a.d) do (ea,pa)
    h=b.d*pa
    for i in reverse(word(W,ea))
      s=gens(W)[i]
      up=zero(h)
      down=zero(h)
      for (e,p)  in h
        if isleftdescent(W,e,i) push!(down,e=>p) 
        else push!(up,s*e=>p) end
      end
if ModuleElts.usedict
      h=ModuleElt(up.d)
else
      h=ModuleElt(sort!(up.d,by=x->x[1]))
end
      if !iszero(down)
        pp=a.H.para[i]
        ss,p=(sum(pp),-prod(pp))
        if !iszero(ss) h+=down*ss end
        if !iszero(p)  
          let s=s, p=p
            h+=ModuleElt(sort!([s*e=>c*p for (e,c) in down],by=first))
          end
        end
      end
    end
    HeckeTElt(h,a.H)
  end
end

function Base.inv(a::HeckeTElt)
  if length(a.d)!=1 error("can only invert single T(w)") end
  w,coeff=first(a.d)
  H=a.H
  T=Tbasis(H)
  l=reverse(word(H.W,w))
  inv(coeff)*prod(i->inv(prod(H.para[i]))*(T()*sum(H.para[i])-T(i)),l)
end


##
#F  HeckeClassPolynomials( <h> )  . . . . . . class polynomials of <h>
##
##  returns  the  class  polynomials  of  the  element  <h> with respect to
##  representatives  of minimal length in  the (F-)conjugacy classes of the
##  Coxeter  group (or coset). <h> is an element of <H> given in any basis.

function HeckeClassPolynomials(h)
  H=Hecke(h)
# if IsBound(h.coset) WF=Spets(h.coset); W=Group(WF);
# else 
    W=Group(H);WF=W
# end
  minl=length.(classinfo(WF)[:classtext])
  h=Tbasis(H)(h)
# Since  vF is not of minimal length in its class there exists wF conjugate
# by   cyclic  shift  to  vF  and  a  generating  reflection  s  such  that
# l(swFs)=l(vF)-2. Return T_sws.T_s^2
  function orb(orbit)
    for w in orbit
      for s in leftdescents(W,w)
        sw=W(s)*w
        sws=sw*W(s)
        if isleftdescent(W,inv(sw),s) q=H.parameter[s]
          return Dict(elm=>[sws,sw],coeff=>[-q[1]*q[2],q[1]+q[2]])
        elseif !(sws in orbit) push!(orbit,sws)
        end
      end
    end
    error("Geck-Kim-Pfeiffer theory")
  end

  min=minl*0*H.unit
  while length(h.elm)>0
    new=Dict(elm=>[],coeff=>[])
    l=map(x->Length(W,x),h.elm)
    maxl=Maximum(l)
    for i in 1:Length(h.elm)
      if l[i]<maxl push!(new.elm,h.elm[i])
                   push!(new.coeff,h.coeff[i])
      else
        p=PositionClass(WF,h.elm[i])
        if minl[p]==maxl min[p]+=h.coeff[i]
        else o=orb([h.elm[i]])
          append!(new.elm,o.elm);append!(new.coeff,o.coeff*h.coeff[i]);
        end
      end
    end
    CollectCoefficients(new);h=new
  end
  return min
end

end
