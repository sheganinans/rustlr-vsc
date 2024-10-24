let Prelude = https://prelude.dhall-lang.org/v23.0.0/package.dhall

let list = Prelude.List

let Pat = { name : Text, match : Text }

let Include = { include : Text }

let include = \(include : Text) -> { include }

let include_list = list.map Text Include include

let pat = \(name : Text) -> \(match : Text) -> { name = name, match }

let pattern = \(name : Text) -> \(match : Text) -> { patterns = [ pat name match ] }

let comment = { begin = "#", end = "$", name = "comment.line.rustlr" }

let eof-comment = { begin = "^EOF", end = "", name = "comment.eof.rustlr" }

let lit-include-1 = { begin = "^\\$", end = "$", name = "entity.name.function.lit-include-1.rustlr" }

let lit-include-2 = { begin = "^!", end = "$", name = "entity.name.function.lit-include-2.rustlr" }

let keywords =
  pattern
    "keyword.control.rustlr"
    ("^(grammarname|auto|genabsyn|auto-bump|terminals|terminal|typedterminal|nonterminals|typednonterminal|" ++
    "nonterminal|topsym|startsymbol|flatten|errsym|recover|resynch|resync|lifetime|absyntype|externtype|" ++
    "externaltype|left|right|nonassoc|lexname|lexvalue|valueterminal|valterminal|lexterminal|lexattribute|" ++
    "lexconditional|variant-group-for|operator-group-for)")

let ops = pattern "entity.name.function.operator.rustlr" "[~!@#$%^&*-+=|:;,<.>?/]+"

let strings = {
  begin = "r?\"",
  end = "\"",
  patterns = [ pat "constant.character.escape.rustlr" "." ]
}

let ids = pattern "variable.id.rustlr" "[\\p{Letter}_]+[\\p{Letter}_\\d]"

let constructor =
  pattern
    "support.type.constructor.rustlr"
    ("(?<!^)(\\(\\)|bool|i8|u8|i16|u16|i32|u32|i64|u64|usize|isize|f32|f64|char|" ++
    "\\(usize,usize\\)|str|String|LC|Vec|\\p{Upper}[\\p{Letter}]*(?=\\()|(?<=externtype\\s)[\\p{Letter}_]+(?=<))(?!(\\w|_))")

let bind-name = pattern "support.type.bind-name.rustlr" "(?<=:)[\\p{Letter}_]+"

let lit-tokens = pattern "constant.language.rustlr" "(?<!\\w)[\\p{Upper}_]+(?!\\w)"

let add-custom = pattern "entity.name.function.add-custom.rustlr" "add_custom"

let lifetime = pattern "storage.modifier.lifetime.rustlr" "'[\\p{Lower}_]+"

in {
	`$schema` = "https://raw.githubusercontent.com/martinring/tmlanguage/master/tmlanguage.json",
	scopeName = "source.rustlr",
	name = "rustlr",
	patterns = include_list [
    "#comment", "#eof-comment", "#lit-include-1", "#lit-include-2",
    "#keywords", "#strings", "#ops", "#constructor", "#lit-tokens",
    "#bind-name", "#add-custom", "#lifetime", "#ids"
  ],
	repository = { comment, eof-comment, lit-include-1, lit-include-2, keywords, strings, ops, constructor, lit-tokens, bind-name, add-custom, lifetime, ids },
}