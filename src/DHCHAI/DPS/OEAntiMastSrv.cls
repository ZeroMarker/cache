/// 名称: DHCHAI.DPS.OEAntiMastSrv
/// 描述: 医嘱-抗菌药物字典相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-05
Class DHCHAI.DPS.OEAntiMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询列表
/// Table：       DHCHAI.DP.OEAntiMast
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OEAntiMastSrv","QryOEAntiMast")
Query QryOEAntiMast() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTName:%String,BTName1:%String,BTCatDr:%String,BTCatCode:%String,BTCatDesc:%String,BTIsActive:%String,IsKeyDrugs:%String,KeyDrugs:%String") [ SqlProc ]
{
}

ClassMethod QryOEAntiMastExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OEAntiMastD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OEAntiMast).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set BTCode=obj.BTCode
	 	Set BTName=obj.BTName
		Set BTName1=obj.BTName1
		
		If $IsObject(obj.BTCatDr) {
			Set BTCatDr=obj.BTCatDr.%Id()
			Set BTCatCode=obj.BTCatDr.BTCode
			Set BTCatDesc=obj.BTCatDr.BTDesc
		} Else {
			Set BTCatDr="",BTCatCode="",BTCatDesc=""
		}
		Set IsActive=obj.BTIsActive
		Set IsKeyDrugs=obj.BTIsKeyDrugs
		Set KeyDrugs  = $s(IsKeyDrugs=1:"是",1:"否")
		Set Data=$lb(xID,BTCode,BTName,BTName1,BTCatDr,BTCatCode,BTCatDesc,IsActive,IsKeyDrugs,KeyDrugs)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOEAntiMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOEAntiMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOEAntiMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOEAntiMastExecute ]
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
/// Description:  导入医嘱-抗菌药物字典
/// Table：       DHCHAI.DP.OEAntiMast
/// Input：       
/// w ##class("DHCHAI.DPS.OEAntiMastSrv").ImportAntiMast("^J01AA05^美他环素^metacycline^J01AA^1","^")
ClassMethod ImportAntiMast(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set CatCode = $p(aInputStr,aSeparate,5)
	Set AntiCatDr=""
	Set objAntiCat  = ##class(DHCHAI.DP.OEAntiCat).GetObjByCodeDesc(CatCode,"")
	Set:$isobject(objAntiCat) AntiCatDr = objAntiCat.%Id()
	Set $p(aInputStr,aSeparate,5) = AntiCatDr 
	//update 20220303 导入数据不能修改数据问题修改
	Set ID=$p(aInputStr,aSeparate,1)
	Set AntCode=$p(aInputStr,aSeparate,2)
	Set AntDesc=$p(aInputStr,aSeparate,3)
	Set tID=""
	If ID="" {
		Set tID=$o(^DHCHAI.DP.OEAntiMastI("IndexCode",AntCode,0))
		If tID="" {
			Set tID=$o(^DHCHAI.DP.OEAntiMastI("IndexName",AntDesc,0))
		}
	}
	Set:tID'="" $p(aInputStr,aSeparate,1) = tID 
	Set return=##Class(DHCHAI.DP.OEAntiMast).Update(aInputStr,aSeparate)
	Quit return
}

}
