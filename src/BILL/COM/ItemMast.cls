/// 名称: BILL.COM.ItemMast.cls
/// 描述: 计费组公共医嘱相关类
/// 编写者: ZhYW
/// 编写日期: 2021-03-05
Class BILL.COM.ItemMast Extends %RegisteredObject
{

/// Creator: ZhYW
/// CreatDate: 2021-03-05
/// Description: 查询医嘱项
/// Input: alias:别名, sessionStr:SS_User.RowId^SS_Group.RowId^CT_Loc.RowId^CT_Hospital.RowId
/// Output: 医嘱项名称,医嘱项ID
/// Debug: do ##class(%ResultSet).RunQuery("BILL.COM.ItemMast","ARCIMastList","ycx","5^122^49^2")
Query FindARCItmMast(alias As %String, sessionStr As %String = "") As websys.Query(ROWSPEC = "ArcimRowID:%String:医嘱项ID,ArcimCode:%String:医嘱项代码,ArcimDesc:%String:医嘱项名称")
{
}

ClassMethod FindARCItmMastExecute(ByRef qHandle As %Binary, alias As %String, sessionStr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindARCItmMast")=$lb(alias, sessionStr)
	if (alias="") quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set deptId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	do rset.Execute(alias, groupId, "", "", "", "", "", "", "", "", userId, "", "", deptId_$c(3)_hospId, "", "^1")
	while(rset.Next()){
		set arcim=rset.GetData(2)
		continue:(arcim="")
		set arcimDesc=rset.GetData(1)
		set arcimCode=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",1)
		do OutputARCItmMast
	}
	
	kill rset
	set rset=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpItem")
	do rset.Execute(alias, groupId, "", "", "", "ALL", "", "", "", "", "", "", "", deptId_$c(3)_hospId, "", "^1")
	while(rset.Next()){
		set arcim=rset.GetData(2)
		continue:(arcim="")
		set arcimDesc=rset.GetData(1)
		set arcimCode=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",1)
		do OutputARCItmMast
	}
	
	quit $$$OK
	
OutputARCItmMast
	set data=$lb(arcim,arcimCode,arcimDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

}
