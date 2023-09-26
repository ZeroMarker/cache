/// 创建者：李阳
/// 刷新Ext表格的表头
Class web.DHCCPW.QueryService Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetQueryStore(ClassName, QueryName)
{

	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	set count = cdef.Queries.Count() 
 	s ret="var arryCol = "
 	s cr=$c(9)
 	s ret=ret_"["_cr
 	F i=1:1:count  d
	.i (cdef.Queries.GetAt(i).Name=QueryName)  d
	..s rowSpec=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
	..f cnt=1:1:$l(rowSpec,",")  d
	...s col=$p(rowSpec,",",cnt)
	...s:cnt>1 ret=ret_","
	...s ret=ret_"{name: '"_$p(col,":",1)_"',mapping: '"_$p(col,":",1)_"'}"_cr
	..s ret=ret_"];"
 	d cdef.%Close()
 	k cdef	
 	q ret
}

ClassMethod GetQueryGridHeaderDeclare(ClassName, QueryName)
{

	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	set count = cdef.Queries.Count() 
 	s cr=$c(9)
 	s ret="var colModel = new Ext.grid.ColumnModel(["_cr
 	s displayCnt=0
 	F i=1:1:count  d
	.i (cdef.Queries.GetAt(i).Name=QueryName)  d
	..s rowSpec=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
	..f cnt=1:1:$l(rowSpec,",")  d
	...s col=$p(rowSpec,",",cnt)
	...q:$p(col,":",3)=""
	...s:displayCnt>0 ret=ret_","
	...s ret=ret_"{header: '"_$p(col,":",3)_"',width: 80,dataIndex: '"_$p(col,":",1)_"', sortable: true}"_cr
	...s displayCnt=displayCnt+1
	..s ret=ret_"]);"
 	d cdef.%Close()
 	k cdef	
 	q ret
}

Storage Default
{
<Data name="QueryServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.QueryServiceD</DataLocation>
<DefaultData>QueryServiceDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.QueryServiceD</IdLocation>
<IndexLocation>^web.DHCCPW.QueryServiceI</IndexLocation>
<StreamLocation>^web.DHCCPW.QueryServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
