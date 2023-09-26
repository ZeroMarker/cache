/// author: wanghc 
/// date:   2010-03-28
/// 门诊打印接口,
/// 用于写打印串的方法
Class web.DHCOPPrintCommIF Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Property printMsg As %String(TRUNCATE = 1) [ Private ];

Property printListMsg As %String(TRUNCATE = 1) [ Private ];

Method SetCell(row As %Integer, column As %Integer, info As %String)
{
	s %this.printMsg = %this.printMsg_row_"^"_column_"^"_info_$c(2)
}

/// @param: info 打印格式a^b^c^d^e
Method SetCellList(row As %Integer, column As %Integer, info As %String)
{
	s %this.printListMsg = %this.printListMsg_row_"^"_column_"^"_info_$c(2)
}

/// @param:  key  xml模板中的name
/// @param:  value: xml位置对应的值caption
Method SetXMLText(key As %String, value As %String)
{
	s %this.printMsg=%this.printMsg_key_$c(2)_value_"^"
}

/// @param:  info:将要打印的行DrugName^Price^DrugUnit^Qty^PaySum
Method SetXMLList(info As %String)
{
	s %this.printListMsg=%this.printListMsg_info_""_$c(2)
}

/// @param:	  str: %String
/// @param:   char: char字符
/// @desc:    去掉最后的char,不以char结束的话就原样返回
ClassMethod ClearEndChar(str As %String, char)
{
	s len=$l(str) 
	q:char=$e(str,len,len) $e(str,1,len-1)
	q str
}

/// 清除最后的分割符
ClassMethod ClearEnd(str As %String)
{
	q ..ClearEndChar(..ClearEndChar(str,$c(2)),"^")
}

Method GetPrintListMsg()
{
	q ..ClearEndChar(%this.printListMsg,$c(2))
}

Method GetPrintMsg()
{
	q ..ClearEndChar(%this.printMsg,$c(2))
}

/// @param:   globalName: "^TMPOPCOM(desc,inv,2)"
/// @return:  返回一个^TMPOPCOM("desc","inv","2")的值
ClassMethod GetGlobalValue(globalName As %String) As %String
{
	s globalName =..FormatGlobalString(globalName)
	s exe="globalValue="_globalName
	s @exe
	q @"globalValue"
}

/// @param:  globalName: "^TMPOPCOM(xxxx,yyyyy,zzzz)"
/// @return: ^TMP("xxxxx","yyyy","zzzz")
/// @desc:   格式化字符串
ClassMethod FormatGlobalString(globalName As %String) As %String
{
	q:$l(globalName,"""")'=1 globalName  //含有"时直接return 
	s:$e(globalName,1,1)'="^" globalName="^"_globalName
	s len=$l(globalName,",")
	s $p(globalName,"(",2)= """"_$p(globalName,"(",2)
	s $p(globalName,",",1)=$p(globalName,",",1)_""""
	s $p(globalName,",",len)=""""_$p(globalName,",",len)
	f i=2:1:len-1 d
	.s $p(globalName,",",i)=""""_$p(globalName,",",i)_""""
	s $p(globalName,")",1)= $p(globalName,")",1)_""""
	q globalName
}

/// @param:   globalName: "^TMPOPCOM(xxxx,yyyy,zzzz)"
/// @param:   step:        global下step个值  -1,1 
/// @return:  返回一个global的值
/// w ##class(web.DHCOPPrintCommIF).GetNextGlobalValue("^TMPWANG(xx,yy,zz)")<=>w ##class(web.DHCOPPrintCommIF).GetNextGlobalValue("^TMPWANG(xx,yy,zz)",1)
/// w ##class(web.DHCOPPrintCommIF).GetNextGlobalValue("^TMPWANG(xx,yy,zz)",-1)
ClassMethod GetNextGlobalValue(globalName As %String, step As %Integer) As %String
{
	s:'$g(step) step=1
	s globalName=..FormatGlobalString(globalName)
	s exe="s ind=$o("_globalName_","_step_")"
	x exe
	s $p(globalName,",",$l(globalName,","))=""""_@"ind"_""")"
	q ..GetGlobalValue(globalName)
}

}
