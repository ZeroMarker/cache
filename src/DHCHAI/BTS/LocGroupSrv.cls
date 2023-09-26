/// 名称: DHCHAI.BTS.LocGroupSrv
/// 描述: 科室组相关服务
/// 编写者：pylian
/// 编写日期: 2017-03-21
Class DHCHAI.BTS.LocGroupSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  查询科室分组
/// Table：       DHCHAI.BT.LocGroup
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocGroupSrv","QryLocGroup")
Query QryLocGroup() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryLocGroupExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.LocGroupD(xID))
		Quit:xID=""
		
		Set objLocGroup = ##class(DHCHAI.BT.LocGroup).GetObjById(xID)
		Continue:'$isobject(objLocGroup)
		
		Set Code = objLocGroup.BTCode
		Set Desc = objLocGroup.BTDesc
		Set IndNo= objLocGroup.BTIndNo
				
		Set Data = $lb(xID,Code,Desc,IndNo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLocGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocGroupExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocGroupExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  科室分组关联科室
/// Input：       ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocGroupSrv).AddLocGrpCfg("P02^外一科","^")
ClassMethod AddLocGrpCfg(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set LocGrpCode = $p(aInputStr,aSeparate,1)
	Set LocCode = $p(aInputStr,aSeparate,2)
	Quit:(LocGrpCode="")||(LocCode="") return
	
	Set LocGrpID=""
	Set LocGrpID=$o(^DHCHAI.BT.LocGroupI("IdxofCode",LocGrpCode,0))
	Quit:LocGrpID="" return
	Set LocID=$o(^DHCHAI.BT.LocationI("IndexLocCode",LocCode,0))
	Quit:LocID="" return
	
	Set obj=##class(DHCHAI.BT.Location).%OpenId(LocID)
	Quit:'$IsObject(obj) return

	Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjById(LocGrpID)
	Set obj.BTGroupDr=objGroup

	Set sc=obj.%Save()	
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  删除科室分组关联
/// Input：       ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocGroupSrv).DelLocGrpCfg("P02^外一科","^")
ClassMethod DelLocGrpCfg(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set LocGrpCode = $p(aInputStr,aSeparate,1)
	Set LocCode = $p(aInputStr,aSeparate,2)
	Quit:(LocGrpCode="")||(LocCode="") return
	
	Set LocGrpID=""
	Set LocGrpID=$o(^DHCHAI.BT.LocGroupI("IdxofCode",LocGrpCode,0))
	Quit:LocGrpID="" return
	Set LocID=$o(^DHCHAI.BT.LocationI("IndexLocCode",LocCode,0))
	Quit:LocID="" return
	
	Set obj=##class(DHCHAI.BT.Location).%OpenId(LocID)
	Quit:'$IsObject(obj) return
	Set obj.BTGroupDr = ""
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  查询科室-科室组信息列表
/// Table：       DHCHAI.BT.LocGroup
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.BTS.LocGroupSrv","QryLocGroupList","1","","-1")
Query QryLocGroupList(aLocGrpID As %String, aLocAlias As %String, aQueryFlg As %String) As %Query(ROWSPEC = "LocGrpID:%String,LocGroup:%String,LocGroupDesc:%String,LocCode:%String,LocDesc:%String,LocType:%String,LocCate:%String,HospCode:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLocGroupListExecute(ByRef qHandle As %Binary, aLocGrpID As %String, aLocAlias As %String, aQueryFlg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
  	Quit:aLocGrpID="" $$$OK
 	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.LocationD(xID))
		Quit:xID=""
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
		If $IsObject(objLoc){
			Set LocCode  = objLoc.BTCode
			Set LocDesc  = objLoc.BTDesc
			Continue:(aLocAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aLocAlias,"U"))
			Set LocType="",LocCate=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocType  = objLoc.BTTypeDr.BTCode	
			}
			If $IsObject(objLoc.BTCateDr) {
				Set LocCate  = objLoc.BTCateDr.BTDesc
			}
			Set LocGroupID="",LocGroup="",LocGroupDesc=""
			If $IsObject(objLoc.BTGroupDr) {
				Set LocGrpID = objLoc.BTGroupDr.%Id()
				Set LocGroup = objLoc.BTGroupDr.BTCode
				Set LocGroupDesc = objLoc.BTGroupDr.BTDesc
				
			}
			If (+aQueryFlg)<1 {
				Continue:("|"_LocGrpID_"|")'[("|"_aLocGrpID_"|")
			}
			Set HospCode="",HospDesc=""
			If $IsObject(objLoc.BTHospDr) {
		   	 	Set HospCode     = objLoc.BTHospDr.BTCode
		    	Set HospDesc     = objLoc.BTHospDr.BTDesc
			}
			Set Data=$lb(LocGrpID,LocGroup,LocGroupDesc,LocCode,LocDesc,LocType,LocCate,HospCode,HospDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryLocGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocGroupListExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  查询科室-科室组信息列表
/// Table：       DHCHAI.BT.LocGroup
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.BTS.LocGroupSrv","QryLocByGrpCode","P01","","1")
Query QryLocByGrpCode(aLocGrpCode As %String, aLocAlias As %String, aQueryFlg As %String) As %Query(ROWSPEC = "LocGrpID:%String,LocGroup:%String,LocGroupDesc:%String,LocCode:%String,LocDesc:%String,LocType:%String,LocCate:%String,HospCode:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLocByGrpCodeExecute(ByRef qHandle As %Binary, aLocGrpCode As %String, aLocAlias As %String, aQueryFlg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
  	Quit:aLocGrpCode="" $$$OK
 	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.LocationD(xID))
		Quit:xID=""
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
		If $IsObject(objLoc){
			Set LocCode  = objLoc.BTCode
			Set LocDesc  = objLoc.BTDesc
			Continue:(aLocAlias'="")&&($zcvt(LocDesc,"U")'[$zcvt(aLocAlias,"U"))
	
		    Set LocType="",LocCate=""
			If $IsObject(objLoc.BTTypeDr) {
				Set LocType  = objLoc.BTTypeDr.BTCode	
			}
			If $IsObject(objLoc.BTCateDr) {
				Set LocCate  = objLoc.BTCateDr.BTDesc
			}
			Set LocGroupID="",LocGroup="",LocGroupDesc=""
			If $IsObject(objLoc.BTGroupDr) {
				Set LocGrpID = objLoc.BTGroupDr.%Id()
				Set LocGroup = objLoc.BTGroupDr.BTCode
				Set LocGroupDesc = objLoc.BTGroupDr.BTDesc	
				
			}
			If (+aQueryFlg)<1 {
					Continue:("|"_$ZCVT(LocGroup,"U")_"|")'[("|"_$ZCVT(aLocGrpCode,"U")_"|")
			}
			Set HospCode="",HospDesc=""
			If $IsObject(objLoc.BTHospDr) {
		   	 	Set HospCode     = objLoc.BTHospDr.BTCode
		    	Set HospDesc     = objLoc.BTHospDr.BTDesc
			}
		    
			Set Data=$lb(LocGrpID,LocGroup,LocGroupDesc,LocCode,LocDesc,LocType,LocCate,HospCode,HospDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryLocByGrpCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocByGrpCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocByGrpCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocByGrpCodeExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  根据科室分组获得科室信息列表
/// w ##Class(DHCHAI.BTS.LocGroupSrv).GetLocListByGroup(1)
ClassMethod GetLocListByGroup(aLocGrpID As %String) As %String
{
	New (aLocGrpID)
	Set return=""
	Quit:aLocGrpID="" return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.LocationD(xID))
		Quit:xID=""
		
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xID)
		If $IsObject(objLoc){
			Set LocCode  = objLoc.BTCode
			Set LocDesc  = objLoc.BTDesc
			Set LocGrpID="",LocGroup="",LocGroupDesc=""
			If $IsObject(objLoc.BTGroupDr) {
				Set LocGrpID = objLoc.BTGroupDr.%Id()
				Set LocGroup = objLoc.BTGroupDr.BTCode
				Set LocGroupDesc = objLoc.BTGroupDr.BTDesc	
				
			}
			Continue:("|"_LocGrpID_"|")'[("|"_aLocGrpID_"|")
		}
		
		Set return=return_LocCode_"|"
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}
