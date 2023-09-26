/// Creator: 	bianshuai
/// CreateDate: 2017-04-14
/// Descript: 	json相关
Class web.DHCSTPHCMJsonCommon Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:格式化Json数据串
ClassMethod getSisJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
{
	N (Title,DataList,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(Title,Deli)  //列
	S DLen=$L(DataList,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(Title,Deli,i)
	.S Value=$p(DataList,Deli,i)
	.S Value=$tr(Value,$c(10))   ;替换换行符
	.S Value=$tr(Value,$c(13))	;替换回车符
	.S Value=$Replace(Value,"\","\\")
	.S Value=$Replace(Value,"'","\'")
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_Value
	.e  i i=3 d
	..S jsonStr=jsonStr_","_del_Name_del_":"_Value
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_Value
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:格式化Json数据串
ClassMethod getJsonData(ListTitle As %String, ListData As %String, Deli As %String = "^") As %String
{
	n (ListTitle,ListData,Deli)
	s del=""""
	s jsonStr=""
	s HLen=$L(ListTitle,Deli)  /// 列
	s DLen=$L(ListData,Deli)   /// 值
	F i=1:1:HLen  D
	.s Name=$p(ListTitle,Deli,i)
	.s value=$p(ListData,Deli,i)
	.s value=..EvalJSON(value)
	.s:value'["[{" value=del_value_del
	.i i=1 D
	..s jsonStr="{"_del_Name_del_":"_value
	.E  D
	..s jsonStr=jsonStr_","_del_Name_del_":"_value
	s jsonStr=jsonStr_"}"
	s jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	n (Count)
	s del=""""
	Q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	Q "]}"
}

/// Descript:返回Json串起始符
ClassMethod getJsonChildPrefixSign(ListTitle As %String, ListData As %String, Deli As %String = "^") As %String
{
	n (ListTitle,ListData,Deli)
	s del=""""
	s jsonStr=""
	s HLen=$L(ListTitle,Deli)  //列
	s DLen=$L(ListData,Deli)   //值
	F i=1:1:HLen  D
	.s Name=$p(ListTitle,Deli,i)
	.s value=$p(ListData,Deli,i)
	.s value=..EvalJSON(value)
	.i i=1 D
	..s jsonStr="{"_del_Name_del_":"_del_value_del
	.e  D
	..s jsonStr=jsonStr_","_del_Name_del_":"_del_value_del
	s jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	n (Count)
	s del=""""
	Q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// Descript:返回Json串起始符
ClassMethod getJsonTreeStartSign(id, text) As %String
{
	n (id, text)
	s del=""""
	Q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del //_","_del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json空串符
ClassMethod getJsonTreeClosedSign() As %String
{
	s del=""""
	Q del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartNoTotal() As %String
{
	s del=""""
	Q "{"_del_"rows"_del_":["
}

/// Descript:返回Json串起始符
ClassMethod getJsonEndConTotal(Count) As %String
{
	n (Count)
	s del=""""
	Q "],"_del_"total"_del_":"_Count_"}"
}

/// Descript: 格式化处理字符串
ClassMethod EvalJSON(value As %String) As %String
{
	s value = value
	Q:(value="") value
	s value=##Class(ext.util.String).Replace(value,"""", "\""")
	s value=##Class(ext.util.String).Replace(value,"'", "\'")
	s value=##Class(ext.util.String).Replace(value,$c(13), "")
	s value=##Class(ext.util.String).Replace(value,$c(10), "")
	Q value
}

}
