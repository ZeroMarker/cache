/// 编写者：wuqk
/// 刷新Ext表格的表头
Class web.DHCHM.QueryService Extends web.DHCHM.Abstract
{

//w ##class(web.DHCHM.QueryService).GetQueryStore("web.DHCHM.Tools","FindSetting")

//w ##class(web.DHCHM.QueryService).GetQueryGridHeaderDeclare("web.DHCHM.Tools","FindSetting")

ClassMethod GetQueryStore(ClassName, QueryName)
{

	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	set count = cdef.Queries.Count() 
 	s ret="var arryCol = "
 	s ret=ret_"["_$c(13)_$c(10)
 	F i=1:1:count  d
	.i (cdef.Queries.GetAt(i).Name=QueryName)  d
	..s rowSpec=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
	..f cnt=1:1:$l(rowSpec,",")  d
	...s col=$p(rowSpec,",",cnt)
	...s:cnt>1 ret=ret_","
	...s ret=ret_"{name: '"_$p(col,":",1)_"',mapping: '"_$p(col,":",1)_"'}"_$c(13)_$c(10)
	..s ret=ret_"];"
 	d cdef.%Close()
 	k cdef	
 	q ret
}

//w ##class(DHCMed.QueryService).GetQueryGridHeaderDeclare("web.DHCHM.Tools","FindSetting")

ClassMethod GetQueryGridHeaderDeclare(ClassName, QueryName)
{

	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	set count = cdef.Queries.Count() 
 	s ret="var colModel = new Ext.grid.ColumnModel(["_$c(13)_$c(10)
 	s displayCnt=0
 	F i=1:1:count  d
	.i (cdef.Queries.GetAt(i).Name=QueryName)  d
	..s rowSpec=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
	..f cnt=1:1:$l(rowSpec,",")  d
	...s col=$p(rowSpec,",",cnt)
	...q:$p(col,":",3)=""
	...s:displayCnt>0 ret=ret_","
	...s ret=ret_"{header: '"_$p(col,":",3)_"',width: 80,dataIndex: '"_$p(col,":",1)_"', sortable: true}"_$c(13)_$c(10)
	...s displayCnt=displayCnt+1
	..s ret=ret_"]);"
 	d cdef.%Close()
 	k cdef	
 	q ret
}

//w ##class(web.DHCHM.QueryService).GetQueryGridHeaderList("web.DHCHM.Tools","FindSetting")

/// Add By LiYang 2010-07-02 根据Query的声明，生成ExtJS中GridPanel的列声明
ClassMethod GetQueryGridHeaderList(ClassName, QueryName)
{

	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	set count = cdef.Queries.Count() 
 	s ret="var arryCols = ["_$c(13)_$c(10)
 	s displayCnt=0
 	F i=1:1:count  d
	.i (cdef.Queries.GetAt(i).Name=QueryName)  d
	..s rowSpec=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
	..f cnt=1:1:$l(rowSpec,",")  d
	...s col=$p(rowSpec,",",cnt)
	...q:$p(col,":",3)=""
	...s:displayCnt>0 ret=ret_","
	...s ret=ret_"{header: '"_$p(col,":",3)_"',width: 80,dataIndex: '"_$p(col,":",1)_"', sortable: true}"_$c(13)_$c(10)
	...s displayCnt=displayCnt+1
	..s ret=ret_"];"
 	d cdef.%Close()
 	k cdef	
 	q ret
}

}
