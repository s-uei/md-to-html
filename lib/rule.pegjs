{
    var indentlevel = 0;
    var codelevel =0;
    // html tag
    function tag(name, text, ...options){
        var str="";
        if(options){
            for(var i=0,l=options.length;i<l;i+=2){
                str+=" "+options[i]+'="'+options[i+1]+'"';
            }
        }
        return "<"+name+str+">"+text+"</"+name+">"
    }
    // html close tag ex) <img />
    function ctag(name, ...options){
        var str="";
        if(options){
            for(var i=0,l=options.length;i<l;i+=2){
                str+=" "+options[i]+'="'+options[i+1]+'"';
            }
        }
        return "<"+name+str+"/>"
    }
}

start 
    = Markdown

Markdown
    = 
    b:Block* EOF{
            return tag("html"
                ,tag("head"
                    ,ctag("meta", "charset", "utf-8")
                )
                +tag("body"
                    ,b.join("")
                )
            );
        }

Block
    = BlankLine* e:Element BlankLine* {return e}

BlankLine
    = _* EOL

Element
    = Heading
    / Blockquote
    / UnorderedList
    / OrderedList
    / HozizontalRule
    / CodeBlock
    / Paragraph

Heading
    = idt:Indent* &{return idt.length >= indentlevel} _* i:"#"+ _+ t:InnerText EOL {return tag("h"+i.length, t)}

Blockquote
    = b:(idt:Indent* &{return idt.length >= indentlevel} _* ">"+ InnerText EOL )+ {
        var str="",level=0,level_next=0;
        for(var i=0,il=b.length; i<il;i++){
            level_next = b[i][3].length;
            for(;level<level_next;level++){
                str+="<blockquote>";
            }
            for(;level>level_next;level--){
                str+="</blockquote>"
            }
            str+=b[i][4];
        }
        for(;level>0;level--){
            str+="</blockquote>"
        }
        return str;
    }

UnorderedList
    = list:(idt:Indent* &{return idt.length >= indentlevel} _* "-" _+ InnerText EOL &{indentlevel++;return true} Block* &{indentlevel--; return true})+ {
        return tag("ul", list.map(el=>tag("li", el[5] + el[8].join(""))).join(""))
    }

OrderedList
    = list:(idt:Indent* &{return idt.length >= indentlevel} _* [0-9]+ "." _* InnerText EOL &{indentlevel++;return true} Block* &{indentlevel--; return true})+ {
        return tag("ol", list.map(el=>tag("li", el[6] + el[9].join(""))).join(""))
    }

HozizontalRule
    = idt:Indent* &{return idt.length >= indentlevel} _* "---" [-]* _* EOL {return ctag("hr")} 

CodeBlock
    = idt:Indent* &{return idt.length >= indentlevel} _* s:[`]+ &{
        if(s.length < 3) return false;
        codelevel = s.length;
        return true;
    } _* EOL c:Code {return "<pre><code>"+c}

Code 
    = g:[`]+ &{return codelevel == g.length} {return "</code></pre>"} 
    / x:[<] y:Code {return "&lt;"+y}
    / x:[>] y:Code {return "&gt;"+y}
    / x:. y:Code {return x+y}

Paragraph
    = t:(idt:Indent* &{return idt.length >= indentlevel} _* InnerText EOL)+ {return tag("p", t.map(val=>val[3]).join(""))} 
    
InnerText
    = t:( Escape
    / Bold
    / Italic
    / Link 
    / Image
    / InlineCode
    / [^\n] )+ {return t.join("")} 

Bold 
    = "**" 
    t:( Escape
    / Italic
    / Link 
    / [^\n\*])+ "**" {return tag("b",t.join(""))}

Italic
    = "*" 
    t:( Escape
    / Bold
    / Link 
    / [^\n\*])+ "*" {return tag("i",t.join(""))}

Link
    = ("[" 
    t:( Escape
    / Bold
    / Italic
    / [^\n\[\]\(\)])+ "]" "(" _* link:[^ \t\n\[\]\(\)]* _* ")" {return tag("a",t.join(""),"href",link.join(""))} )

    / left:"https://" right:[^ \t\n]* {var s = left + right.join(""); return tag("a",s,"href",s)}
    / left:"http://" right:[^ \t\n]* {var s = left + right.join(""); return tag("a",s,"href",s)}

Image
    = "![" alt:[^\n\[\]\(\)]+ "](" _* link:[^ \t\n\[\]\(\)]* _* ")" {return ctag("img", "alt", alt.join(""), "src", link.join(""))}

InlineCode
    = "`" c:[^\n`]* "`" {return tag("code",c.join(""))}
_
    = " "
    / "\t"

Indent
    = "\t"
    / "  "

Escape
    = "\\" c:. {return c}

EOL
    = "\n"

EOF
    = !.

