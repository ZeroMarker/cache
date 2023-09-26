Class dhc.pa.com.JsonObj Extends dhc.pa.com.DataStore [ ClassType = serial, ProcedureBlock ]
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
		....i item = "" s item = $p(mapping,deli,j)_":'"_$p(temp,deli,j)_"'"
		....e  s item = item_","_$p(mapping,deli,j)_":'"_$p(temp,deli,j)_"'"
		...i items = "" s items = "{"_item_"}"
		...e  s items = items_",{"_item_"}"
		s str = "{"_result_":"_count_","_root_":["_items_"]}"
		q str
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
