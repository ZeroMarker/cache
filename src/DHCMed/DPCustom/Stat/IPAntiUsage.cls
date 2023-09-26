/// 名称: DHCMed.DPCustom.Stat.IPAntiUsage
/// 描述: 抗生素使用相关查询
/// 编写者：zhufei
/// 编写日期: 2014-03-20
Class DHCMed.DPCustom.Stat.IPAntiUsage Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-03-20
/// Description:  查询住院患者
/// Table：       OE_OrdItem,PHC_DrgMast,PHC_DrgForm
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.DPCustom.Stat.IPAntiUsage","QryIPAntiUsage","","")
Query QryIPAntiUsage(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,DataType:%String,ActDept:%String,ActWard:%String,ActDate:%String,ActTime:%String,AntiUseFlag:%String,AntiObject:%String,AntiDDDs:%String,SubmitFlag:%String,KSS1UseFlag:%String,KSS1Object:%String,KSS1DDDs:%String,KSS2UseFlag:%String,KSS2Object:%String,KSS2DDDs:%String,KSS3UseFlag:%String,KSS3Object:%String,KSS3DDDs:%String")
{
}

ClassMethod QryIPAntiUsageExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set ^CacheTemp(repid,ind)=""
 	Set ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QryIPAntiUsageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIPAntiUsageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIPAntiUsageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIPAntiUsageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
