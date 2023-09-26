/// 创建人：李阳
/// 名称：DHCMed.IMPService.WardQuery
/// 功能：查询全院的科室/病房列表
Class DHCMed.IMPService.WardQuery Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("DHCMed.IMPService.WardQuery","QueryAllWard","1","")
/// Modified By LiYang 2011-12-17
/// 增加用户级科室管理
Query QueryAllWard(tmp As %String, checkBox As %String, LogonLocID As %String, UserID As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String")
{
}

ClassMethod QueryAllWardExecute(ByRef qHandle As %Binary, tmp As %String, checkBox As %String, LogonLocID As %String, UserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set UserID=+$g(UserID) //add By LiYang 2011-12-17
	If LogonLocID'="" {
		Set LocType=$p($g(^CTLOC(LogonLocID)),"^",13)
		If LocType="E" {
			Set aLocID=LogonLocID
			Set aWardID=""
		} Else {
			Set aLocID=""
			Set aWardID=LogonLocID
		}
	} Else {
			Set aLocID=""
			Set aWardID=""
	}
	Set WardID=0
	For {
		Set WardID=$o(^PAWARD(WardID))
		Quit:+WardID=0
		Continue:(aWardID'="")&&(aWardID'=WardID)
		Set LinkLocID=$p($g(^PAWARD(WardID)),"^",5)
		Continue:LinkLocID=""
		Continue:(aLocID'="")&&('$d(^CTLOC(+aLocID,"LINK",0,"Loc",+LinkLocID)))
		Continue:(($d(^DHCMed.IMP.ChargeDepartmentI("IndexUser",UserID,LinkLocID))=0)&&(UserID'=0))
		Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
		If $IsObject(objWard){
			Set WardDesc=objWard.Descs
			Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
			Continue:WardDesc=""
			Continue:(WardDesc["作废")||(WardDesc["废除")
			Set WardDesc="'"_WardDesc_"'"
			If checkBox="Y" {
				Set IsChecked="true"
			} ElseIf checkBox="N" {
				Set IsChecked="false"
			} Else {
				Set IsChecked="null"
			}
		    Set Data=$lb(WardID,WardDesc,"true",IsChecked)
		    Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
		If objWard'="" Do objWard.%Close()
	}
	
	Quit $$$OK
}

ClassMethod QueryAllWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllWardExecute ]
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

ClassMethod QueryAllWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
