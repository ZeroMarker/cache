/// Creator:   bianshuai
/// CreateDate:2014-08-13
/// Descript:  ExtJS Json公共类
Class web.DHCSTExtJsJsonCommon Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	N (Count)
	Q "{results:'"_Count_"',rows:["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	Q "]}"
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign() As %String
{
	Q "{results:0,rows:[]}"
}

/// Descript:返回一条record(json)
/// Creator：wangjiabin
/// CreatDate：2013-06-24
/// Table:		
/// Input:数据串, 标题串, 分隔符
/// Output:
/// Return:记录数
ClassMethod getJsonData(dataStr, titleStr, del = "^", currow) As %Library.String
{
	N (dataStr,titleStr,del,currow)
	Q:dataStr="" "{}"
	Q:titleStr="" "{}"
	S len=$L(dataStr,del)
	S tlen=$L(titleStr,del)
	Q:len'=tlen "{}"
	//S jsonStr="{"
	S jsonStr=$S(currow=1:"{",1:",{")
	F i=1:1:len  D
	.S data=$P(dataStr,del,i)
	.S data=..trSpecialSym(data,"\","\\")	;替换转义序列,防js显示错误
	.S data=..trSpecialSym(data,"'","\'")
	.S title=$P(titleStr,del,i)
	.If i=1 D
	..S jsonStr=jsonStr_title_":'"_data_"'"
	.E  D
	..S jsonStr=jsonStr_","_title_":'"_data_"'"
	.
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$C(13,10))
	Q jsonStr
}

/// Descript:替换特殊字符
ClassMethod trSpecialSym(data, frStr, toStr) As %Library.String
{
	N (data,frStr,toStr)
	Q $Replace(data,frStr,toStr)
}

Storage Default
{
<Data name="DHCSTExtJsJsonCommonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTExtJsJsonCommonD</DataLocation>
<DefaultData>DHCSTExtJsJsonCommonDefaultData</DefaultData>
<IdLocation>^web.DHCSTExtJsJsonCommonD</IdLocation>
<IndexLocation>^web.DHCSTExtJsJsonCommonI</IndexLocation>
<StreamLocation>^web.DHCSTExtJsJsonCommonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
