Import SQLUser

/// Description:公共类
/// Creator:congyue
/// CreateDate: 2016-05-06
Class web.DHCADVJSONCOMMON Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
	..S jsonStr="{"_del_Name_del_":"_del_Value_del
	.e  i i=3 d
	..S jsonStr=jsonStr_","_del_Name_del_":"_Value
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_Value_del
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Congyue
/// Descript:格式化Json数据串
/// W ##class(web.DHCADVJSONCOMMON).getJsonDataPort("id^text","1^1")
ClassMethod getJsonDataPort(ListTitle As %String, ListData As %String, Deli As %String = "^") As %String
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
	.s value = ##Class(ext.util.String).Replace(value,$c(13), "")
	.s value = ##Class(ext.util.String).Replace(value,$c(10), "\n")
	.s value = ##Class(ext.util.String).Replace(value,$c(9), "\t")
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
ClassMethod getSisJsonStartSign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"results"_del_":"_Count_","_del_"rows"_del_":["
}

/// Descript:返回Json串结束符
ClassMethod getSisJsonEndSign() As %String
{
	q "]}"
}

/// Descript:返回Json空串符
ClassMethod getSisJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"results"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// Descript:格式化Json数据串
ClassMethod getJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
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
	.;S Value=$Replace(Value,"'","\'")
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_del_Value_del
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_Value_del
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

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// Descript:获取药品列表
ClassMethod QueryDrgList(Input As %String) As %String
{
	n (Input)
	
	q:Input="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	s count=0
	w "["
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.q:incidesc'[Input
	.s tmp=inci_"^"_incidesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	w "]"
	q ""
}

/// 获取json第一列格式
ClassMethod GetJsonFirstCell(CellName, CellValue) As %String
{
	S CellValue=..GetValue(CellValue)
	Q """"_CellName_""""_":"_""""_CellValue_""""_","
}

/// 获取json最后一列格式
ClassMethod GetJsonLastCell(CellName, CellValue) As %String
{
	S CellValue=..GetValue(CellValue)
	Q """"_CellName_""""_":"_""""_CellValue_""""
}

/// 获取json第一行格式 
ClassMethod GetJsonFirstRow(RowValue) As %String
{
	Q "{"_RowValue_"},"
}

/// 获取json最后一行格式 
ClassMethod GetJsonLastRow999(RowValue) As %String
{
	//Q "{"_RowValue_"}"_"]}"
	
    Q "{"_RowValue_"}"_"]"
}

ClassMethod GetJsonLastRow(RowValue) As %String
{
	Q "{"_RowValue_"}"_"]}"
	
    //Q "{"_RowValue_"}"_"]"
}

/// 获取json总记录数
ClassMethod GetJsonStartString888(RowCount) As %String
{
	//Q "{total:"_RowCount_",rows:["
	
	//Q "{""total"""_":"_RowCount_""_","""_"rows"":"_"["
	
	Q "["
}

ClassMethod GetJsonStartString(RowCount) As %String
{
	//Q "{total:"_RowCount_",rows:["
	
	Q "{""total"""_":"_RowCount_""_","""_"rows"":"_"["
	
	Q "["
}

/// 返回空记录数
ClassMethod GetNoJson() As %String
{
	s RowCount=0
	Q "{""total"""_":"_RowCount_""_","""_"rows"":"_"[]}"
}

/// 　处理影响JSON格式的字符
ClassMethod GetValue(value) As %String
{
	s value=$tr(value,$c(10))   ;替换换行符
	s value=$tr(value,$c(13))	;替换回车符
	s value=$Replace(value,"\","\\")
	s value=$Replace(value,"'","\'")
	s value=$Replace(value,"""","")
	q value
}

/// 获取json responseText
/// cellname^cellvalue$c(2)cellname2^cellvalue2
ClassMethod JsonText(data) As %String
{
	s cnt=$l(data,$c(2))
	f i=1:1:cnt d
	.s tmp=$p(data,$c(2),i)
	.s Name=$p(tmp,"^",1)
	.s Value=$p(tmp,"^",2)
	.s Value=..GetValue(Value)
	.s Text=""""_Name_""""_":"_""""_Value_""""
	.i i=1 d
	..s info=Text
	.e  d
	..s info=info_","_Text
	.
	Q "{"_info_"}"
}

ClassMethod JsonCell(Name, Value) As %String
{
	s Value=..GetValue(Value)
	s Text=""""_Name_""""_":"_""""_Value_""""
	q Text
}

ClassMethod JsonArr(Name, Value) As %String
{
	
	s Text=""""_Name_""""_":"_""""_Value_""""
	q Text
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

/// Descript:返回Json串起始符
ClassMethod getJsonTreeStartSign(id, text, level) As %String
{
	N (id, text,level)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del_","_del_"level"_del_":"_del_level_del //_","_del_"state"_del_":"_del_"closed"_del
}

/// Descript:返回Json空串符
ClassMethod getJsonTreeClosedSign() As %String
{
	S del=""""
	q del_"state"_del_":"_del_"closed"_del
}

}
