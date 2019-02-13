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
bases,  require a square root of `qₛ=-uₛ₀/uₛ₁`. We provide a way to specify
it  with  the  field  `.sqpara`  which  can  be given when constructing the
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
can  be obtained with the  simplified call 'Hecke(W,q)'. Certain invariants
of  the irreducible characters of  this algebra play a  special role in the
representation  theory of the underlying  finite Coxeter groups, namely the
`a`- and `A`-invariants. For basic properties of Iwahori-Hecke algebras and
their  relevance to the representation theory of finite groups of Lie type,
see for example Curtis and Reiner 1987, Sections~67 and 68.

In  the  following  example,  we  compute  the multiplication table for the
`0`-Iwahori--Hecke algebra associated with the Coxeter group of type `A_2`.

```julia-repl
julia> W=WeylGroup(:A,2)
W(A₂)

julia> H=hecke(W,0)             # One-parameter algebra with `q=0`
Hecke(W(A₂),0)

julia> T=Tbasis(H)              # Create the `T` basis
(::getfield(Gapjm.Hecke, Symbol("#f#20")){Int64,Perm{Int16},HeckeAlgebra{Int64,WeylGroup{Int16}}}) (generic function with 4 methods)

julia> el=words(W)
6-element Array{Array{Int8,1},1}:
 []       
 [2]      
 [1]      
 [2, 1]   
 [1, 2]   
 [1, 2, 1]

julia> T.(el)*permutedims(T.(el))        # multiplication table
6×6 Array{HeckeTElt{Perm{Int16},Int64,WeylGroup{Int16}},2}:
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
         W=WeylGroup(:A,n)
         Tbasis(hecke(W,Pol([1],1)))(longest(W))^2
       end
test_w0 (generic function with 1 method)

julia> @btime test_w0(7);
  132.737 ms (178853 allocations: 157.37 MiB)
```
Compare to GAP3 where the following function takes 0.92s
```
test_w0:=function(n)local W,T,H;
  W:=CoxeterGroup("A",n);H:=Hecke(W,X(Rationals));T:=Basis(H,"T");
  T(LongestCoxeterWord(W))^2;
end;
```
"""
module Hecke
using Gapjm
export HeckeElt, Tbasis, hecke, HeckeAlgebra, HeckeTElt

struct HeckeAlgebra{C,TW<:CoxeterGroup}
  W::TW
  para::Vector{Tuple{C,C}}
  sqpara::Vector{<:Union{Missing,C}}
  prop::Dict{Symbol,Any}
end

"""
   hecke( W [, parameter, [rootparameter]] ) return a Hecke algebra for W

# Example
```julia-repl
julia> W=WeylGroup(:B,2)
W(B₂)

julia> Pol(:q)
q

julia> H=hecke(W,q)
Hecke(W(B₂),q)

julia> [H.para,H.sqpara]
2-element Array{Array{T,1} where T,1}:
 Tuple{Pol{Int64},Pol{Int64}}[(q, -1), (q, -1)]
 Missing[missing, missing]                     

julia> H=hecke(W,q^2,q)
Hecke(W(B₂),q²,q)

julia> [H.para,H.sqpara]
2-element Array{Array{T,1} where T,1}:
 Tuple{Pol{Int64},Pol{Int64}}[(q², -1), (q², -1)]
 Pol{Int64}[q, q]                                  

julia> H=hecke(W,[q^2,q^4],[q,q^2])
Hecke(W(B₂),Pol{Int64}[q², q⁴],Pol{Int64}[q, q²])

julia> [H.para,H.sqpara]
2-element Array{Array{T,1} where T,1}:
 Tuple{Pol{Int64},Pol{Int64}}[(q², -1), (q⁴, -1)]
 Pol{Int64}[q, q²]

julia> H=hecke(W,9,3)
Hecke(W(B₂),9,3)

julia> [H.para,H.sqpara]
2-element Array{Array{T,1} where T,1}:
 Tuple{Int64,Int64}[(9, -1), (9, -1)]
 [3, 3]                              
```
"""
function HeckeAlgebra(W::CoxeterGroup,para::Vector{Tuple{C,C}},
                      sqpara::Vector{<:Union{Missing,C}})where C
  para=map(1:coxrank(W))do i
   j=simple_representatives(W)[i]
    if i<=length(para) 
     if j<i && para[i]!=para[j] error("one should have  para[$i]==para[$j]") end
      return para[i]
    elseif j<i return para[j]
    else error("parameters should be given for first reflection in a class")
    end
  end
  sqpara=map(1:coxrank(W))do i
    j=simple_representatives(W)[i]
    if i<=length(sqpara) && !ismissing(sqpara[i])
      if j<i && sqpara[i]!=sqpara[j] 
        error("one should have sqpara[$i]==sqpara[$j]")
      end
      if sqpara[i]^2*para[i][2]!=-para[i][1]
       error("one should have sqpara[$i]^2*$(para[i][2])==$(-para[i][1])")
      end
      return sqpara[i]
    elseif j<i return sqpara[j]
    elseif isone(-prod(para[i])) return para[i][1]
    else return missing
    end
  end
  HeckeAlgebra(W,para,sqpara,Dict{Symbol,Any}())
end

function hecke(W::CoxeterGroup,p::Vector{C},sqp::Vector{C}=C[])where C
  HeckeAlgebra(W,map(p->(p,-one(p)),p),sqp)
end
  
function hecke(W::CoxeterGroup,p::Vector{Tuple{C,C}},sqp::Vector{C}=C[])where C
  HeckeAlgebra(W,p,sqp)
end
  
function hecke(W::CoxeterGroup,p::C,sqp::Union{C,Missing}=missing)where C
  HeckeAlgebra(W,fill((p,-one(p)),coxrank(W)),fill(sqp,coxrank(W)))
end

function hecke(W::CoxeterGroup,p::Tuple{C,C},sqp::Union{C,Missing}=missing)where C
  HeckeAlgebra(W,fill(p,coxrank(W)),fill(sqp,coxrank(W)))
end

hecke(W::CoxeterGroup)=hecke(W,1,1)

function Base.show(io::IO, H::HeckeAlgebra)
  print(io,"Hecke(",H.W,",")
  tr(p)= p[2]==-one(p[2]) ? p[1] : p
  if constant(H.para) print(io,tr(H.para[1]))
  else print(io,map(tr,H.para))
  end
  if !ismissing(H.sqpara[1]) && !iszero(H.sqpara[1]) 
    if constant(collect(skipmissing(H.sqpara))) print(io,",",H.sqpara[1])
    else print(io,",",H.sqpara)
    end
  end
  print(io,")")
end

#--------------------------------------------------------------------------
abstract type HeckeElt{P,C} end

Base.zero(h::HeckeElt)=clone(h,empty(h.d))
Base.iszero(h::HeckeElt)=length(h.d)==0

const usedict=false
function Base.show(io::IO, h::HeckeElt)
  if isempty(h.d) return "0" end
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  s=map(usedict ? collect(h.d) : h.d)do (e,c)
    w=word(h.H.W,e)
    res=basename(h)
    if repl || TeX
      if isempty(w) res*="."
      else res*="_{"*(any(x->x>=10,w) ? join(w,",") : join(w))*"}"
      end
    else res*="("*join(map(x->"$x",w),",")*")"
    end
    c=sprint(show,c; context=io)
    if !(repl || TeX) || occursin(r"[-+*]",c[nextind(c,0,2):end]) c="($c)" end
    res= (c=="1" ? "" : (c=="-1" ? "-" : c))*res
    if res[1]!='-' res="+"*res end
    res
  end
  s=join(s)
  if  s[1]=='+' s=s[2:end] end
  print(io, (repl && !TeX) ? TeXstrip(s) : s)
end

if usedict
function weed!(a::Dict)
  for (k,v) in a if iszero(v) delete!(a,k) end end
  a
end
end

if usedict
Base.:+(a::HeckeElt, b::HeckeElt)=clone(a,weed!(merge(+,a.d,b.d)))
else
Base.:+(a::HeckeElt, b::HeckeElt)=clone(a,mergesum(a.d,b.d))
end
Base.:-(a::HeckeElt)=clone(a,[p=>-c for (p,c) in a.d])
Base.:-(a::HeckeElt, b::HeckeElt)=a+(-b)

Base.:*(a::HeckeElt, b)=iszero(b) ? zero(a) : clone(a,[p=>c*b for (p,c) in a.d])
Base.:*(a::HeckeElt, b::Pol)=iszero(b) ? zero(a) : clone(a,[p=>c*b for (p,c) in a.d])
Base.:*(b::Pol, a::HeckeElt)=a*b
Base.:*(b::Number, a::HeckeElt)= a*b

Base.:^(a::HeckeElt, n::Integer)= n>=0 ? Base.power_by_squaring(a,n) : 
                                   Base.power_by_squaring(inv(a),-n)
#--------------------------------------------------------------------------
if usedict
struct HeckeTElt{P,C,G<:CoxeterGroup}<:HeckeElt{P,C}
  d::Dict{P,C}
  H::HeckeAlgebra{C,G}
end
HeckeTElt(a::Vector{Pair{P,C}},H::HeckeAlgebra) where {P,C}=HeckeTElt(Dict(a),H)
else
struct HeckeTElt{P,C,G<:CoxeterGroup}<:HeckeElt{P,C}
  d::SortedPairs{P,C} # has better merge performance than Dict
  H::HeckeAlgebra{C,G}
end
end

clone(h::HeckeTElt,d)=HeckeTElt(d,h.H)

basename(h::HeckeTElt)="T"
 
function Base.one(H::HeckeAlgebra{C}) where C
  HeckeTElt([one(H.W)=>one(C)],H)
end

function Base.zero(H::HeckeAlgebra{C}) where C
  HeckeTElt(Pair{typeof(one(H.W)),C}[],H)
end

function Tbasis(H::HeckeAlgebra{C,TW})where C where TW<:CoxeterGroup{P} where P
  function f(w::Vector{<:Integer})
    if isempty(w) return one(H) end
    HeckeTElt([element(H.W,w...)=>one(C)],H)
  end
  f(w::Vararg{Integer})=f(collect(w))
  f(w::P)=HeckeTElt([w=>one(C)],H)
  f(h::HeckeElt)=Tbasis(h)
end

Tbasis(h::HeckeElt)=h

function Base.:*(a::HeckeTElt, b::HeckeTElt)
  if iszero(a) return a end
  if iszero(b) return b end
  W=a.H.W
  sum(a.d) do (ea,pa)
    h=usedict ? Dict(e=>p*pa for (e,p) in b.d) : [e=>p*pa for (e,p) in b.d]
    for i in reverse(word(W,ea))
      s=gens(W)[i]
      up=empty(h)
      down=empty(h)
      for (e,p)  in h
        if isleftdescent(W,e,i) push!(down,e=>p) 
        else push!(up,s*e=>p) end
      end
      h=usedict ? up : sort!(up,by=x->x[1])
      if !isempty(down)
        pp=a.H.para[i]
        ss,p=(sum(pp),-prod(pp))
        if usedict
          let ss=ss; merge!(+,h,Dict(e=>c*ss for (e,c) in down)) end
          let s=s, p=p; merge!(+,h,Dict(s*e=>c*p for (e,c) in down)) end
          weed!(h)
        else
          if !iszero(ss) 
            let ss=ss; h=mergesum(h,[e=>c*ss for (e,c) in down]) end
          end
          if !iszero(p)  
            let s=s, p=p
              h=mergesum(h,sort!([s*e=>c*p for (e,c) in down],by=x->x[1]))
            end
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

end
