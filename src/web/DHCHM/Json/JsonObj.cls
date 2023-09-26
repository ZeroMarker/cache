Class web.DHCHM.Json.JsonObj Extends DataStore [ ClassType = serial, ProcedureBlock ]
{

//得到表格Json数据

Method getJsonData(mapping As %String, count As %Integer, deli As %String = "^", result As %String = "results", root As %String = "rows") As %String
{
		s str = ""
		s items = ""
		s cols = $l(mapping,deli)
		i cols > 0 d
		.s rows = ..RowCount()
		.i rows > 0 d
		..f i=1:1:rows d
		...s item = ""
		...s temp = ..GetRowData(i)
		...f j=1:1:cols d
		....i item = "" s item = $p(mapping,deli,j)_":'"_$p(temp,deli,j)_"'"
		....e  s item = item_","_$p(mapping,deli,j)_":'"_$p(temp,deli,j)_"'"
		...i items = "" s items = "{"_item_"}"
		...e  s items = items_",{"_item_"}"
		s str = "{"_result_":"_count_","_root_":["_items_"]}"
		q str
}

//form中的Json数据,创建record使用

ClassMethod GetJsonStr(jsonTitle, jsonValue, splitStr)
{
	s jsonStr="{"
	s count=$l(jsonValue,splitStr)
	f i=1:1:count d
	.s value=$p(jsonValue,splitStr,i)
	.s name=$p(jsonTitle,splitStr,i)
	.s value=##class(web.DHCHM.Tools).AddSQM(value)
	.s name=##class(web.DHCHM.Tools).AddSQM(name)
	.i jsonStr="{" d
	..s jsonStr=jsonStr_name_":"_value
	.e  d
	..s jsonStr=jsonStr_","_name_":"_value
	s jsonStr=jsonStr_"}"
	q jsonStr
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
