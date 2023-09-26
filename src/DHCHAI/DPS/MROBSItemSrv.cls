/// 名称: DHCHAI.DPS.MROBSItemSrv
/// 描述: 护理项目维护相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-05
Class DHCHAI.DPS.MROBSItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询列表
/// Table：       DHCHAI.DP.MROBSItem
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MROBSItemSrv","QryMROBSItem")
Query QryMROBSItem() As %Query(ROWSPEC = "ID:%String,BTItemCode:%String,BTItemDesc:%String,BTCatDr:%String,BTCatCode:%String,BTCatDesc:%String,BTIsActive:%String") [ SqlProc ]
{
}

ClassMethod QryMROBSItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.MROBSItemD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.MROBSItem).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ItemCode=obj.BTItemCode
		Set ItemDesc=obj.BTItemDesc
		Set (BTCatDr,BTCatCode,BTCatDesc)=""
		If $IsObject(obj.BTCatDr) {
			Set BTCatDr=obj.BTCatDr.%Id()
			Set BTCatCode=obj.BTCatDr.BTCode
			Set BTCatDesc=obj.BTCatDr.BTDesc
		} 
		Set IsActive=obj.BTIsActive
		
		Set Data=$lb(xID,ItemCode,ItemDesc,BTCatDr,BTCatCode,BTCatDesc,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMROBSItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMROBSItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMROBSItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMROBSItemExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-28
/// Description:  导入护理项目字典
/// Table：       DHCHAI.DP.MROBSItem
/// Input：       
/// w ##class("DHCHAI.DPS.MROBSItemSrv").ImportOBSItem("","^")
ClassMethod ImportOBSItem(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set CatCode = $p(aInputStr,aSeparate,4)
	Set CatDr=""
	Set:CatCode'="" CatDr =$o(^DHCHAI.DP.MROBSItemCatI("IndexCode",CatCode,0)) 
	Set $p(aInputStr,aSeparate,4) = CatDr 
	
	Set return=##Class(DHCHAI.DP.MROBSItem).Update(aInputStr,aSeparate)
	Quit return
}

}
