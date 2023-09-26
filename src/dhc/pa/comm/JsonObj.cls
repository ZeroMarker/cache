Class dhc.pa.comm.JsonObj Extends dhc.pa.comm.DataStore [ ClassType = serial, ProcedureBlock ]
{

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
		....;s itemValue=$REPLACE($REPLACE($REPLACE($p(temp,deli,j),$char(10),""),$char(0),""),$char(13),"") //替换换行符
		....s itemValue=$ZSTRIP($p(temp,deli,j),"*C")
		....i item = "" s item = $p(mapping,deli,j)_":'"_itemValue_"'"
		....e  s item = item_","_$p(mapping,deli,j)_":'"_itemValue_"'"
		...i items = "" s items = "{"_item_"}"
		...e  s items = items_",{"_item_"}"
		s str = "{"_result_":"_count_","_root_":["_items_"]}"
		q str
}

Method getJsonDataNew(mapping As %String, count As %Integer, totalCount As %Integer, checksjson As %String, deli As %String = "^", result As %String = "results", root As %String = "rows") As %String
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
		....;s aa=$p(temp,deli,j) ;="0.555612236"
		....;s itemValue=$REPLACE($REPLACE($p(temp,deli,j),$char(10),""),$char(0),"") //替换换行符
		....s itemValue=$ZSTRIP($p(temp,deli,j),"*C")
		....i item = "" s item = $p(mapping,deli,j)_":'"_itemValue_"'"
		....e  s item = item_","_$p(mapping,deli,j)_":'"_itemValue_"'"
		...i items = "" s items = "{"_item_"}"
		...e  s items = items_",{"_item_"}"
		s str = "{"_result_":'"_count_"',totalCount:'"_totalCount_"',checks:'"_checksjson_"',"_root_":["_items_"]}"
	
		
		q str
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
