imap \Ga α
imap \alp α
imap \alpha α
imap \beta β
imap \Gp π
imap \pi π
imap \Gk κ
imap \kappa κ
imap \Gs σ
imap \sigma σ
imap \times ×
imap \x ×
imap \to →
imap \-> →
imap \<- ←
imap \_0 ₀
imap \_1 ₁
imap \_2 ₂
imap \_3 ₃
imap \_4 ₄
imap \forall ∀
imap \all ∀
imap \exists ∃
imap \ex ∃
imap \imp ⇒
imap \=> ⇒
imap \iff ⇔
imap \land ∧
imap \and ∧
imap \lor ∨
imap \or ∨
imap \in ∊
imap \nin ∉
imap \le ≤
imap \<= ≤
imap \ge ≥
imap \>= ≥
imap \cap ∩
imap \cup ∪
imap \equiv ≡
imap \=== ≡
imap \bN ℕ
imap \bZ ℤ
imap \bR ℝ
imap \langle ⟨
imap \< ⟨
imap \rangle ⟩
imap \> ⟩
imap \. •
imap \bu •
imap \o ◦
imap \circ ◦
imap \emptyset ∅
imap \0 ∅
imap \subseteq ⊆
imap \neg ¬
imap \ne ≠
imap \bTheta Θ
imap \^1 ¹
imap \^2 ²
imap \^3 ³
imap \^n ⁿ
imap \infty ∞
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
set iskeyword+=?,=,&,#,<,>
syn keyword tadADT ArregloDimensionable Bool Cola ColaDePrioridad Conjunto Diccionario Multiconjunto Nat Pila Secuencia String ÁrbolBinario
hi tadADT cterm=bold,underline ctermfg=2
syn keyword tadSort ab ad bool cola colaPrior conj dicc multiconj nat pila secu string
syn match tadSort "α"
syn match tadSort "κ"
syn match tadSort "σ"
hi tadSort ctermfg=2
syn keyword tadKeyword <=> =obs ENUMFin ES TAD axiomas básicos else exporta fi formales generadores géneros if igualdad observacional observadores operaciones otras parámetros then usa
syn match tadKeyword "⇒"
syn match tadKeyword "⇒L"
syn match tadKeyword "⇔"
syn match tadKeyword "∀"
syn match tadKeyword "∃"
syn match tadKeyword "∧"
syn match tadKeyword "∧L"
syn match tadKeyword "∨"
syn match tadKeyword "∨L"
hi tadKeyword cterm=bold
syn keyword tadConstructor Ag apilar bin crearArreglo definir encolar false nil suc true vacía vacío zero
syn match tadConstructor " • "
syn match tadConstructor "∅"
syn match tadConstructor "⟨"
syn match tadConstructor "⟨⟩"
syn match tadConstructor "⟩"
hi tadConstructor ctermfg=4
syn keyword tadEliminator =0? def? der desapilar desencolar fin izq nil? obtener pred prim próximo raíz tam tope vacía?
syn match tadEliminator "π₁"
syn match tadEliminator "π₂"
syn match tadEliminator "π₃"
syn match tadEliminator "π₄"
syn match tadEliminator "∊"
hi tadEliminator ctermfg=1
syn keyword tadOtherOperations # & altura borrar claves com dameUno esHoja? está inorder long máx mín postorder preorder sinUno tamaño últ
syn match tadOtherOperations " ◦ "
syn match tadOtherOperations "∅?"
syn match tadOtherOperations "⊆"
hi tadOtherOperations ctermfg=5
hi tadVariable cterm=italic
syn region tadComment start="--" end="$" keepend
hi tadComment cterm=italic ctermfg=6
syn sync minlines=200
syn sync maxlines=500
