Import SQLUser

/// Description:提供Jquery公用方法
/// Creator:LiangQiang
Class web.DHCSTJQUERYCOMMON Extends %Library.RegisteredObject
{

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
	
    Q "{"_RowValue_"}"_"]"
}

ClassMethod GetJsonLastRow(RowValue) As %String
{
	Q "{"_RowValue_"}"_"]}"
}

/// 获取json总记录数
ClassMethod GetJsonStartString888(RowCount) As %String
{
	Q "["
}

ClassMethod GetJsonStartString(RowCount) As %String
{
	Q "{""total"""_":"_RowCount_","""_"rows"":"_"["
}

/// 返回空记录数
/// easyui表格,部分界面使用footer
ClassMethod GetNoJson() As %String
{
	S RowCount=0
	Q "{""total"""_":"_RowCount_""_","""_"rows"":"_"[]"_","""_"footer"":"_"[]}"
}

/// 　处理影响JSON格式的字符
ClassMethod GetValue(value) As %String
{
	s value=$tr(value,$c(3,9,10,13)) // 替换已知常见隐藏字符
	s value=$Replace(value,"\","\\")
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

/// Descript:格式化Json数据串
ClassMethod getJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
{
	S del=""""
	S jsonStr=""
	S HLen=$L(Title,Deli)  //列
	S DLen=$L(DataList,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(Title,Deli,i)
	.S Value=$p(DataList,Deli,i)
	.s Value=..GetValue(Value)
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
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// creator:yunhaibao
/// createdate:20160806
/// description:jqGrid数据格式开头
/// input:总记录数,每页记录数
/// total在jqgrid代表总页数
/// w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(10,3)
ClassMethod getJsonStartStringJqGrid(rowCount, limit) As %String
{
	s pageCount="1"
	i limit'="" d
	.s rem=rowCount#limit
	.i rem=0 s pageCount=rowCount/limit
	.e  s pageCount=(rowCount\limit)+1
	Q "{""total"""_":"_rowCount_","_""""_"pages"_""":"_pageCount_","""_"rows"":"_"["
}

/// w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
ClassMethod getJsonRowSign() As %String
{
	q "{""rows"""_":["
}

/// w ##class(web.DHCSTJQUERYCOMMON).getJsonEndStringJqGrid(10,3)
ClassMethod getJsonEndStringJqGrid(rowCount, limit) As %String
{
	s pageCount="1"
	i limit'="" d
	.s rem=rowCount#limit
	.i rem=0 s pageCount=rowCount/limit
	.e  s pageCount=(rowCount\limit)+1
	Q "],""total"""_":"_rowCount_","_""""_"pages"_""":"_pageCount_"}"
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySignJQGrid(Count) As %String
{
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// w ##class(web.DHCSTJQUERYCOMMON).getJsonTotalEndSign(10)
ClassMethod getJsonTotalEndSign(Count) As %String
{
	S del=""""
	q "]," _del _ "total" _ del _ ":" _ Count _ "}"
}

}
