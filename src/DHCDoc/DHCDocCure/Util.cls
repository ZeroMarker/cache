Class DHCDoc.DHCDocCure.Util Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:格式化Json数据串
ClassMethod getJsonData(ListTitle As %String, ListData As %String, Deli As %String = "^") As %String
{
	N (ListTitle,ListData,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(ListTitle,Deli)  //列
	S DLen=$L(ListData,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(ListTitle,Deli,i)
	.S value=$p(ListData,Deli,i)
	.s value = ##Class(ext.util.String).Replace(value,"\", "\\")
	.s value = ##Class(ext.util.String).Replace(value,"""", "\""")
	.//s value = ##Class(ext.util.String).Replace(value,"'", "\'")
	.s value = ##Class(ext.util.String).Replace(value,$c(13), "")
	.s value = ##Class(ext.util.String).Replace(value,$c(10), "")
	.s value = ##Class(ext.util.String).Replace(value,$c(0), "")
	.S:value'["[{" value=del_value_del
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_value
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_value
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	q "]}"
}

/// Descript:返回Json串起始符
ClassMethod getJsonChildPrefixSign(ListTitle As %String, ListData As %String, Deli As %String = "^") As %String
{
	N (ListTitle,ListData,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(ListTitle,Deli)  //列
	S DLen=$L(ListData,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(ListTitle,Deli,i)
	.S value=$p(ListData,Deli,i)
	.S value=$tr(value,$c(10))   ;替换换行符
	.S value=$tr(value,$c(13))	;替换回车符
	.//S value=$Replace(value,"\","\\")
	.//S value=$Replace(value,"'","\'")
	.S value=##Class(ext.util.String).EvalJSON(value)
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_del_value_del
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_value_del
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// Descript:返回Json串起始符
ClassMethod getJsonTreeStartSign(id, text) As %String
{
	N (id, text)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del //_","_del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json串起始符
ClassMethod getJsonTreeStart(id, text, code) As %String
{
	N (id, text, code)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del_","_del_"code"_del_":"_del_code_del
}

/// Descript:返回Json空串符
ClassMethod getJsonTreeClosedSign() As %String
{
	S del=""""
	q del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartNoTotal() As %String
{
	S del=""""
	q "{"_del_"rows"_del_":["
}

/// Descript:返回Json串起始符
ClassMethod getJsonEndConTotal(Count) As %String
{
	N (Count)
	S del=""""
	q "],"_del_"total"_del_":"_Count_"}"
}

ClassMethod EvalJson(val, type As %String = "")
{
	s rtn=""
	if (type="JSON"){
		s rtn="{"_"""result"""_":"_""""_val_""""_"}"
	}else{
		s rtn=val
	}
	q rtn
}

ClassMethod CureEvalJSON(instr As %String) As %String
{
	;w ##class(DHCDoc.DHCDocCure.Util).CureEvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ##class(ext.util.String).Replace(mystr,"\", "\\")
	
	s mystr = ##class(ext.util.String).Replace(mystr,"""", "\""")
	
	//s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(8), "\b") 			// 退格(BS)
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(9), "\t")
	
	;s mystr = ..Replace(mystr,$c(10), "\n")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(12), "") // FF(NP from feed, new page)
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(13), "\r")
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(14), "") //SO(shift out)  
	//32之前是不可见字符
	
	s mystr = ##class(ext.util.String).Replace(mystr,$c(0), "")
	q mystr
}

}
