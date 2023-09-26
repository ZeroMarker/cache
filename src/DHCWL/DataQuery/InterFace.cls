/// 名称: DHCWL.DataQuery.InterFace
/// 描述: 统计数据的对外接口
/// 编写者：王峥
/// 编写日期: 2017-7
Class DHCWL.DataQuery.InterFace Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	统计报表数据，供raq文件调用。
/// Table：       	ServOfQryLineRpt，ServOfQryCrossRpt
/// Input：         报表编码rptCode，开始日期startDate，结束日期endDate，查询项searchArgs
/// Output： 
/// Return：		rowData:行数据,colData:列数据,value：值数据
Query QryRptDataOfKpi(rptCode As %String, startDate As %String, endDate As %String, searchArgs As %Text = "") As %Query(ROWSPEC = "rowData:%String,colData:%String,value:%String") [ SqlProc ]
{
}

ClassMethod QryRptDataOfKpiExecute(ByRef qHandle As %Binary, rptCode As %String, startDate As %String, endDate As %String, searchArgs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)	
	q:startDate="" $$$OK
	q:endDate="" $$$OK 

	//s ^DHCWLTEMP("QryRptDataOfKpi","ARGS")=searchArgs
	k ^||DHCWLTEMP
	//1、根据报表名称创建一个报表统计对象
	s rptObj=##class(DHCWL.DataQuery.FactoryOfQry).creator(rptCode,searchArgs)
	q:'$ISOBJECT($g(rptObj)) $$$OK
	
	//2、创建一个输出接口
	s outputIFAry("repid")=repid	
	s outputIFAry("ind")=ind
	
	if rptObj.%ClassName()="ServOfQryLineRpt" {
		s outputIF=##class(DHCWL.DataQuery.ServOfOutIFLineQry).%New(.outputIFAry)
	}elseif rptObj.%ClassName()="ServOfQryCrossRpt" {
		s outputIF=##class(DHCWL.DataQuery.ServOfOutIFCrossQry).%New(.outputIFAry)
	}
	//3、查询并输出统计数据
	d rptObj.QryRptStatData(startDate,endDate,outputIF)
	
	
	k ^||DHCWLTEMP
    Quit $$$OK
}

ClassMethod QryRptDataOfKpiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRptDataOfKpiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRptDataOfKpiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRptDataOfKpiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// s a= ##class(DHCWL.DataQuery.InterFace)BelongToStatGrp(981)
ClassMethod BelongToStatGrp(UserID As %String) As %String
{
	s ssgrpDesc=""
	&sql(SELECT ssgrpDesc into :ssgrpDesc FROM (SELECT ssusr_group->SSGRP_Desc AS ssgrpDesc FROM SQLUser.SS_User WHERE ssusr_rowid=:UserID UNION SELECT OTHLL_UserGroup_DR->SSGRP_Desc AS ssgrpDesc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_ParRef=:UserID) WHERE ssgrpDesc='Statistic')
	if ssgrpDesc'="" q 1
	else  q 0
}

}
