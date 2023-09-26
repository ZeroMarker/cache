/// creator:xbl
/// createdate:2017-06-24
/// description:表格设置业务类
Class web.NurMgSetTable Extends %RegisteredObject
{

/// creator:xbl
/// createdate:20170624
/// input:"TableTitle|人力资源列表^TableCode|DHCNurPersons^TableMenu|..."
/// output:0 失败 1 成功
/// description: 保存表格设置记录
/// other: w ##class(web.NurMgSetTable).SaveTable("")
ClassMethod SaveTable(parr As %String) As %String
{
	s ret=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:ret=0
	s rw=$g(tmp("rw"))
	i rw="" d
	.s obj=##class(DHCNMG.Set.MgTable).%New()
	e  d
	.s obj=##class(DHCNMG.Set.MgTable).%OpenId(rw)
	s obj.TableTitle=$g(tmp("TableTitle"))
	s obj.TableCode=$g(tmp("TableCode"))
	i $g(tmp("TableMenu"))'="" d
	.s obj.TableMenu=##class(DHCNMG.Set.MgMenu).%OpenId(tmp("TableMenu"))
	e  s obj.TableMenu=""
	s obj.LinkType=$g(tmp("LinkType"))
	s obj.LinkClass=$g(tmp("LinkClass"))
	s obj.LinkMethod=$g(tmp("LinkMethod"))
	s obj.ReturnType=$g(tmp("ReturnType"))
	s obj.DefaultParams=$g(tmp("DefaultParams"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20170624
/// input:"TableTitle|人力资源列表^TableCode|DHCNurPersons^TableMenu|..."
/// output:0 失败 1 成功
/// description: 保存表格设置记录
/// other: w ##class(web.NurMgSetTable).SaveTable("")
ClassMethod CheckTable(code As %String) As %String
{
	s id=$O(^DHCNMG.Set.MgTableI("Code"," "_$zcvt(code,"U"),""))
	q id
}

/// creator:xbl
/// createdate:20170624
/// input:"ColumnHeader|姓名^ColumnIndex|PerName^ColumnWidth|...^Parref|1^rw|1"
/// output:0 失败 1 成功
/// description: 保存表格列设置记录
/// other: w ##class(web.NurMgSetTable).SaveColumns("")
ClassMethod SaveColumns(parr As %String) As %String
{
}

/// creator:xbl
/// createdate:20170624
/// input:"ColumnHeader|姓名^ColumnIndex|PerName^ColumnWidth|...^Parref|1^rw|1"
/// output:0 失败 1 成功
/// description: 保存表格列设置记录
/// other: w ##class(web.NurMgSetTable).SaveColumns("")
ClassMethod GetColumns(code As %String) As %String
{
	q:code="" 0
	s parid=$O(^DHCNMG.Set.MgTableI("Code"," "_$zcvt(code,"U"),""))
	q:parid="" 0
	s subid="" f  s subid=$O(^DHCNMG.Set.MgColumnsD(parid,subid)) q:subid=""  d
	.s colid=parid_"||"_subid
	.s obj=##class(DHCNMG.Set.MgColumns).%OpenId(colid)
	.s tmp(obj.ColumnOrder)="{ColumnHeader:"""_obj.ColumnHeader_""",ColumnIndex:"""_obj.ColumnIndex_""",ColumnWidth:"""_obj.ColumnWidth_"""}"
	s ret=""
	s order="" f  s order=$g(tmp(order)) q:order=""  d
	.i ret'="" s ret=ret_","
	.s ret=ret_tmp(order)
	s ret="["_ret_"]"
	q ret
}

}
