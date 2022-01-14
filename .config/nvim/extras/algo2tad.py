#!/usr/bin/env python
import re
import sys

"""
Este script sirve para ayudar a escribir especificaciones de TADs
de Algo2 en vim. En particular, hace dos cosas:
  (1) Genera mappings para escribir símbolos comunes, por ejemplo
      \forall ---> ∀
  (2) Genera un archivo de syntax highlighting para vim, para
      resaltar la sintaxis de especificaciones de TADs.
      El resaltado es dinámico porque generadores, observadores y
      otras operaciones se resaltan con diferentes colores.

Instalación:
(1) Ubicar este script en algún lado, ej.:
    ~/algo2/algo2tad.py

(2) Editar .vimrc y anexar el siguiente código (con la ruta correspondiente):

au BufRead,BufNewFile *.tad set filetype=tad
nmap <c-l> :w<Return>:!python ~/algo2/algo2tad.py %<Return>:source %:r.vim<Return>|
imap <c-l> <Esc><c-l>

(3) Cada vez que editemos un archivo con extensión .tad
    apretando Ctrl+L se resalta la sintaxis, teniendo en cuenta todos
    los generadores, observadores y otras operaciones definidos en
    ese archivo.
    Además, se definen mappings para símbolos comunes.
    (Ver abajo la lista UNICODE_MAPPINGS).

NOTA:
  No es un parser ni es perfecto, se hacen varios hacks.
  El objetivo es poder proyectar una clase usando vim.

Updates:

Soporte para enums en la forma:

    TAD Abc es ENUM(Cons1, Cons2, Cons3)
"""

UNICODE_MAPPINGS = [
    ("\\Ga", "α"),
    ("\\alp", "α"),
    ("\\alpha", "α"),
    ("\\beta", "β"),
    ("\\Gp", "π"),
    ("\\pi", "π"),
    ("\\Gk", "κ"),
    ("\\kappa", "κ"),
    ("\\Gs", "σ"),
    ("\\sigma", "σ"),
    ("\\times", "×"),
    ("\\x", "×"),
    ("\\to", "→"),
    ("\\->", "→"),
    ("\\<-", "←"),
    ("\\_0", "₀"),
    ("\\_1", "₁"),
    ("\\_2", "₂"),
    ("\\_3", "₃"),
    ("\\_4", "₄"),
    ("\\forall", "∀"),
    ("\\all", "∀"),
    ("\\exists", "∃"),
    ("\\ex", "∃"),
    ("\\imp", "⇒"),
    ("\\=>", "⇒"),
    ("\\iff", "⇔"),
    ("\\land", "∧"),
    ("\\and", "∧"),
    ("\\lor", "∨"),
    ("\\or", "∨"),
    ("\\in", "∊"),
    ("\\nin", "∉"),
    ("\\le", "≤"),
    ("\\<=", "≤"),
    ("\\ge", "≥"),
    ("\\>=", "≥"),
    ("\\cap", "∩"),
    ("\\cup", "∪"),
    ("\\equiv", "≡"),
    ("\\===", "≡"),
    ("\\bN", "ℕ"),
    ("\\bZ", "ℤ"),
    ("\\bR", "ℝ"),
    ("\\langle", "⟨"),
    ("\\<", "⟨"),
    ("\\rangle", "⟩"),
    ("\\>", "⟩"),
    ("\\.", "•"),
    ("\\bu", "•"),
    ("\\o", "◦"),
    ("\\circ", "◦"),
    ("\\empty", "∅"),
    ("\\0", "∅"),
    ("\\subseteq", "⊆"),
    ("\\neg", "¬"),
    ("\\ne", "≠"),
    ("\\!=", "≠"),
    ("\\bTheta", "Θ"),
    ("\\^1", "¹"),
    ("\\^2", "²"),
    ("\\^3", "³"),
    ("\\^n", "ⁿ"),
    ("\\infty", "∞")
  ]

PUNCTUATION = ['(', ')', '{', '}', ':', '⟨', '⟩', ',']

KEYWORDS = [
    "TAD",
    "ES",
    "ENUM"
    "Fin",
    "generadores",
    "observadores",
    "otras",
    "operaciones",
    "basicos",
    "parametros",
    "formales",
    "igualdad",
    "observacional",
    "exporta",
    "usa",
    "generos",
    "axiomas",
    "∀",
    "∃",
    "∧",
    "∧L",
    "∨",
    "∨L",
    "⇒",
    "⇒L",
    "⇔",
    "<=>",
    "if",
    "then",
    "else",
    "fi",
    "=obs",
  ]

ADTS = [
    "Bool",
    "Nat",
    "Secuencia",
    "Conjunto",
    "Multiconjunto",
    "ArregloDimensionable",
    "Pila",
    "Cola",
    "ÁrbolBinario",
    "Diccionario",
    "ColaDePrioridad",
    "String",
  ]

SORTS = [
    "α",
    "κ",
    "σ",
    "bool",
    "nat",
    "secu",
    "conj",
    "multiconj",
    "ad",
    "pila",
    "cola",
    "ab",
    "dicc",
    "colaPrior",
    "string",
    "rosetree",
  ]

CONSTRUCTORS = [
  # bool
   "true",
   "false",
  # nat
   "zero",
   "suc",
  # secu
   "⟨⟩",
   " • ",
  # tuple
   "⟨",
   "⟩",
  # conj
   "∅",
   "Ag",
  # ad
   "crearArreglo",
  # pila
   "vacia",
   "apilar",
  # cola
   "encolar",
  # ab
   "nil",
   "bin",
  # dicc
   "vacio",
   "definir",
   # rosetree
   "rose",
  ]

ELIMINATORS = [
  # nat
   "=0?",
   "pred",
  # secu
   "vacia?",
   "prim",
   "fin",
  # tuple
   "π₁",
   "π₂",
   "π₃",
   "π₄",
  # conj
   "∊",
   "vacio?",
  # ad
   "tam",
  # pila
   "tope",
   "desapilar",
  # cola
   "proximo",
   "desencolar",
  # ab
   "nil?",
   "raiz",
   "izq",
   "der",
  # dicc
   "def?",
   "obtener",
   # rosetree
   "hijos",
  ]

OTHER_OPERATIONS = [
  # nat
    "mín",
    "máx",
    "0?",
  # secu
   " ◦ ",
   "&",
   "últ",
   "com",
   "long",
   "está",
  # conj
   "#",
   "∅?",
   "dameUno",
   "sinUno",
   "⊆",
  # pila/cola
   "tamaño",
  # ab
   "altura",
   "preorder",
   "inorder",
   "postorder",
   "esHoja?",
  # dicc
   "borrar",
   "claves",
  ]

VARIABLES = []

class Namespace:

    def __init__(self):
        self.clear_tad()

    def clear_tad(self):
        self.keywords = set(KEYWORDS)
        self.adts = set(ADTS)
        self.sorts = set(SORTS)
        self.constructors = set(CONSTRUCTORS)
        self.eliminators = set(ELIMINATORS)
        self.other_operations = set(OTHER_OPERATIONS)
        self.variables = set(VARIABLES)

    def all(self):
        return ( self.keywords
               | self.adts
               | self.sorts
               | self.constructors
               | self.eliminators
               | self.other_operations
               | self.variables
               )

    def is_name(self, x):
        return x not in PUNCTUATION \
           and x not in self.keywords \
           and x not in self.adts \
           and x not in self.sorts

    def load_from(self, file):
        current = ''
        lines = file.readlines()
        for line in lines:
            toks = tokenize(line)
            if len(toks) >= 3 and toks[0] == 'TAD' and toks[2] == 'ES':
               if toks[3] == 'ENUM':
                  for t in toks[4:-1]:
                     if t not in PUNCTUATION:
                        self.constructors.add(t)
               self.adts.add(toks[1])
               self.sorts.add(toks[1].lower())
               current = ''
            elif len(toks) >= 2 and toks[0] == 'TAD':
               self.adts.add(toks[1])
               current =''
            elif len(toks) >= 2 and toks[0] == 'generos':
               self.sorts.add(toks[1])
            elif len(toks) >= 1 and toks[0] == 'observadores':
               current = 'eliminators'
            elif len(toks) >= 1 and toks[0] == 'generadores':
               current = 'constructors'
            elif len(toks) >= 2 and toks[0:2] == ['otras', 'operaciones']:
               current = 'other_operations'
            elif len(toks) >= 2 and toks[0:2] == ['axiomas']:
               current = 'axiomas'
            elif len(toks) >= 2 and toks[0:2] == ['Fin', 'TAD']:
               current = ''
            if len(toks) >= 2 and toks[1] == ':' and self.is_name(toks[0]):
                if current == 'eliminators':
                    self.eliminators.add(toks[0])
                elif current == 'constructors':
                    self.constructors.add(toks[0])
                elif current == 'other_operations':
                    self.other_operations.add(toks[0])

def tokenize(line):
    for p in PUNCTUATION:
        line = line.replace(p, ' ' + p + ' ')
    line = re.sub('[ \t\r\n]+', ' ', line)
    line = line.strip(' ')
    return line.split(' ')

def unicode_mappings():
    s = []
    for x, y in UNICODE_MAPPINGS:
        s.append(f'imap {x} {y}')
    s.append('')
    return '\n'.join(s)

def uses_unicode(x):
    for c in x:
        if ord(c) > 255:
            return True
    return False

def syntax(name, highlighting, values):
    s = []

    values_safe = []
    values_unicode = []
    for value in sorted(values):
        if uses_unicode(value):
            values_unicode.append(value)
        else:
            values_safe.append(value)
    if len(values_safe) > 0:
        s.append(f'syn keyword {name} ' + ' '.join(sorted(values_safe)))
    for value in sorted(values_unicode):
        s.append(f'syn match {name} \"' + value + '\"')
    s.append(f'hi {name} {highlighting}')
    return s

def syntax_highlighting(ns):
    s = []

    # Header
    s.append('if version < 600')
    s.append('  syntax clear')
    s.append('elseif exists("b:current_syntax")')
    s.append('  finish')
    s.append('endif')

    s.append('set iskeyword+=?,=,&,#,<,>')

    # Highlighting

    s.extend(syntax('tadADT', 'cterm=bold,underline ctermfg=2', ns.adts))
    s.extend(syntax('tadSort', 'ctermfg=2', ns.sorts))
    s.extend(syntax('tadKeyword', 'cterm=bold', ns.keywords))
    s.extend(syntax('tadConstructor', 'ctermfg=4', ns.constructors))
    s.extend(syntax('tadEliminator', 'ctermfg=1', ns.eliminators))
    s.extend(syntax('tadOtherOperations', 'ctermfg=5', ns.other_operations))
    s.extend(syntax('tadVariable', 'cterm=italic', ns.variables))

    s.append('syn region tadComment start="--" end="$" keepend')
    s.append('hi tadComment cterm=italic ctermfg=6')

    # Footer
    s.append('syn sync minlines=200')
    s.append('syn sync maxlines=500')
    s.append('')
    return '\n'.join(s)

def generate_vim_syntax_file(tad_filename):
    vim_filename = tad_filename[:-4] + '.vim'
    ns = Namespace()
    with open(tad_filename) as tad_file:
        ns.load_from(tad_file)
    with open(vim_filename, 'w') as vim_file:
        vim_file.write(unicode_mappings())
        vim_file.write(syntax_highlighting(ns))

def usage(program_name):
    sys.stderr.write(f'Usage: {program_name} file.tad\n')
    sys.exit(1)

def main():
    if len(sys.argv) != 2 or not sys.argv[1].endswith('.tad'):
        usage(sys.argv[0])
    generate_vim_syntax_file(sys.argv[1])

if __name__ == '__main__':
    main()

