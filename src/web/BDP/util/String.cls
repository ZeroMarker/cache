/// 主要用来处理字符操作
Class web.BDP.util.String Extends %RegisteredObject [ ProcedureBlock ]
{

/// 把一个字符串分割 回传一个数组
ClassMethod Split(instr As %String, separator As %String) As %String
{
	;w ##class(web.BDP.util.String).Split("abacad","a")
	s myary(1)=""
	s mylen=$l(instr,separator)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,separator, myIdx)
	}
	
	q myary
}

/// 传入一个数组  返回一个字符串
ClassMethod Join(instrarray As %String, separator As %String) As %String
{
	;w ##class(web.BDP.util.String).Join(.myary,"^")
	s mystr=""
	s myIdx=""
	s myIdx=$o(instrarray(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(instrarray(myIdx))=""){
			s myrepstr=instrarray(myIdx)
		}else{
			s myrepstr=instrarray(myIdx)_separator
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(instrarray(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

ClassMethod Trim(instr As %String) As %String
{
}

/// 对JSON数据字符特殊字符处理,用于opendata JsonS()方法
/// JSON 中的特殊字符
/// \  " $c(13)  $c(10) $c(0)  ,保留回车换行
ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(web.BDP.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	//s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,"""", "\""")   //update2020-10-20
	
	s mystr = ..Replace(mystr,$c(13,10), "\n") //换行 ，弹出框里\n \r显示换行
	
	s mystr = ..Replace(mystr,$c(13), "\n")  //  \r
	
	s mystr = ..Replace(mystr,$c(10), "\n")
	
	s mystr = ..Replace(mystr,$c(0), "")
	
	q mystr
}

/// chenying 2020-11-03
/// 用于csp query调用对数据字符特殊字符处理
/// \  " $c(13)  $c(10) $c(0)   不保留回车换行
ClassMethod EvalList(instr As %String) As %String
{
	;w ##class(web.BDP.util.String).EvalList("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	//s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,"""", "\""")   //update2020-10-20
	
	s mystr = ..Replace(mystr,$c(13,10), "")  //列表里<br/> 可以使列表显示换行
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	s mystr = ..Replace(mystr,$c(0), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;w ##class(web.BDP.util.String).Replace()
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

}
