/// 名称:DHCWMR.SSService.LocGroupSrv
/// 描述: 科室-科室组信息维护
/// 编写者：zhouruimeng
/// 编写日期: 2014-08-22
Class DHCWMR.SSService.LocGroupSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  查询科室-科室组信息列表
/// Table：       DHCWMR.SS.LocGroup
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.LocGroupSrv","QryLocGroupList","482","","1")
Query QryLocGroupList(aLocGrpDicID As %String, aLocAlias As %String, aQueryFlg As %String) As %Query(ROWSPEC = "LocGrpID:%String,DeptCode:%String,DeptDesc:%String,LocType:%String,LocGroup:%String,LocGroupDesc:%String")
{
}

ClassMethod QryLocGroupListExecute(ByRef qHandle As %Binary, aLocGrpDicID As %String, aLocAlias As %String, aQueryFlg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aLocGrpDicID, aLocAlias, aQueryFlg)
 	
 	Quit:aLocGrpDicID="" $$$OK
 	
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.LocGroupD(xID))
		Quit:xID=""
		
		Set objLocGrp=##class(DHCWMR.SS.LocGroup).GetObjById(xID)
		If $IsObject(objLocGrp){
			Set DeptCode  = objLocGrp.LGDeptCode
			Set DeptDesc  = objLocGrp.LGDeptDesc
			Continue:(aLocAlias'="")&&($zcvt(DeptDesc,"U")'[$zcvt(aLocAlias,"U"))
			Set LocType   = objLocGrp.LGLocType
			Set LocGroup  = objLocGrp.LGLocGroup
			If (+aQueryFlg)<1 {
				Continue:("|"_LocGroup_"|")'[("|"_aLocGrpDicID_"|")
			}
			//科室分组中的科室在HIS科室中被删除情况下不显示在维护科室组页面
			Continue:'$d(^CTLOC($zcvt(DeptCode,"U")))

			Set LocGroupDesc=""
			For indGrp=1:1:$l(LocGroup,"|") {
				Set xGrpID=$p(LocGroup,"|",indGrp)
				Continue:xGrpID=""
				Set objGrp=##class(DHCWMR.SS.Dictionary).GetObjById(xGrpID)
				Continue:'$IsObject(objGrp)
				Set GrpDesc=objGrp.SDDesc
				Set LocGroupDesc=LocGroupDesc_","_GrpDesc
			}
			Set:LocGroupDesc'="" LocGroupDesc=$e(LocGroupDesc,2,$l(LocGroupDesc))
			
			Set Data=$lb(LocGrpID,DeptCode,DeptDesc,LocType,LocGroup,LocGroupDesc)
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

/// Creator：     zhufei
/// CreatDate：   2014-12-28
/// Description:  查询科室组列表
/// Table：       DHCWMR.SS.LocGroup
/// Input：       HospitalID ：医院
///               LocAlias ：科室别名
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.LocGroupSrv","QryCboLocGroup","4","")
Query QryCboLocGroup(aHospitalID As %String, aGrpAlias As %String) As %Query(ROWSPEC = "GroupID:%String,GroupCode:%String,GroupDesc:%String")
{
}

ClassMethod QryCboLocGroupExecute(ByRef qHandle As %Binary, aHospitalID As %String, aGrpAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Set Data=$lb("0","0","全院")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Kill arrLocGroup
	Set xLocGrpID=0
	For {
		Set xLocGrpID=$o(^DHCWMR.SS.LocGroupD(xLocGrpID))
		Quit:xLocGrpID=""
		
		Set objLocGrp=##class(DHCWMR.SS.LocGroup).GetObjById(xLocGrpID)
		Continue:'$IsObject(objLocGrp)
		Set DeptCode = objLocGrp.LGDeptCode
		Set DeptDesc = objLocGrp.LGDeptDesc
		Set:$p(DeptDesc,"-",2)'="" DeptDesc=$p(DeptDesc,"-",2)
		Set LocType  = objLocGrp.LGLocType
		Set LocGroup = objLocGrp.LGLocGroup
		Continue:(DeptCode="")||(DeptDesc="")||(LocGroup="")
		Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(DeptCode)
		If aHospitalID'="" {
			Continue:(","_aHospitalID_",")'[(","_CTHospID_",")
		}
		
		For indGrp=1:1:$l(LocGroup,"|") {
			Set GroupID=$p(LocGroup,"|",indGrp)
			Continue:GroupID=""
			Set objGroup=##class(DHCWMR.SS.Dictionary).GetObjById(GroupID)
			Continue:'$IsObject(objGroup)
			Set GroupID=objGroup.%Id()
			Set GroupCode=objGroup.SDCode
			Set GroupDesc=objGroup.SDDesc
			If aGrpAlias'="" {
				Continue:(GroupDesc'[aGrpAlias)&&(GroupDesc'[aGrpAlias)
			}
			Continue:$d(arrLocGroup(GroupCode))
			Set GroupActive=objGroup.SDIsActive
			Continue:GroupActive'=1
			Set arrLocGroup(GroupCode)=$lb(GroupID,GroupCode,GroupDesc)
		}
	}
	
	Set xGroupCode=""
	For {
		Set xGroupCode=$o(arrLocGroup(xGroupCode))
		Quit:xGroupCode=""
		Set Data=$g(arrLocGroup(xGroupCode))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrLocGroup
	
	
	Quit $$$OK
}

ClassMethod QryCboLocGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCboLocGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCboLocGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCboLocGroupExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-12-28
/// Description:  查询科室组列表
/// Table：       DHCWMR.SS.LocGroup
/// Input：       HospitalID ：医院
///               LocAlias ：科室别名
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.LocGroupSrv","QryCboLocList","","-","")
Query QryCboLocList(aHospitalID As %String, aLocGrpID As %String, aLocAlias As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String")
{
}

ClassMethod QryCboLocListExecute(ByRef qHandle As %Binary, aHospitalID As %String, aLocGrpID As %String, aLocAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aLocGrpID="" $$$OK
	
	If (+aLocGrpID)>0 {
		Set xLocGrpID=0
		For {
			Set xLocGrpID=$o(^DHCWMR.SS.LocGroupD(xLocGrpID))
			Quit:xLocGrpID=""
			
			Set objLocGrp=##class(DHCWMR.SS.LocGroup).GetObjById(xLocGrpID)
			Continue:'$IsObject(objLocGrp)
			Set DeptCode = objLocGrp.LGDeptCode
			Set DeptDesc = objLocGrp.LGDeptDesc
			Continue:(aLocAlias'="")&($zcvt(DeptDesc,"U")'[$zcvt(aLocAlias,"U"))
			Set:$p(DeptDesc,"-",2)'="" DeptDesc=$p(DeptDesc,"-",2)
			Set LocType  = objLocGrp.LGLocType
			Set LocGroup = objLocGrp.LGLocGroup
			Continue:(DeptCode="")||(DeptDesc="")||(LocGroup="")
			Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(DeptCode)
			If aHospitalID'="" {
				Continue:(","_aHospitalID_",")'[(","_CTHospID_",")
			}
			Continue:("|"_LocGroup_"|")'[("|"_aLocGrpID_"|")
			
			Set Data=$lb(DeptCode,DeptDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^CTLOC(0,"Desc",xLocDesc))
			Quit:xLocDesc=""
			
			Set xLocID=0
			For {
				Set xLocID=$o(^CTLOC(0,"Desc",xLocDesc,xLocID))
				Quit:xLocID=""
				
				Set DeptCode=xLocID
				Set DeptDesc=$p($g(^CTLOC(DeptCode)),"^",2)
				Continue:(DeptDesc["停用")||(DeptDesc["作废")
				Continue:(aLocAlias'="")&($zcvt(DeptDesc,"U")'[$zcvt(aLocAlias,"U"))
				Set:$p(DeptDesc,"-",2)'="" DeptDesc=$p(DeptDesc,"-",2)
				Set LocType=$p($g(^CTLOC(DeptCode)),"^",13)
				Continue:(LocType'="E")&&(LocType'="W")
				Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(DeptCode)
				If aHospitalID'="" {
					Continue:(","_aHospitalID_",")'[(","_CTHospID_",")
				}
				
				Set Data=$lb(DeptCode,DeptDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCboLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCboLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCboLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCboLocListExecute ]
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

/// w ##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(1)
ClassMethod GetLocListByGroup(aLocGrpID As %String) As %String
{
	New (aLocGrpID)
	Set return=""
	Quit:aLocGrpID="" return
	Set xLocGrpID=0
	
	For {
		Set xLocGrpID=$o(^DHCWMR.SS.LocGroupD(xLocGrpID))
		Quit:xLocGrpID=""
		
		Set objLocGrp=##class(DHCWMR.SS.LocGroup).GetObjById(xLocGrpID)
		Continue:'$IsObject(objLocGrp)
		Set DeptCode = objLocGrp.LGDeptCode
		Set DeptDesc = objLocGrp.LGDeptDesc
		Set LocType  = objLocGrp.LGLocType
		Set LocGroup = objLocGrp.LGLocGroup
		Continue:("|"_LocGroup_"|")'[("|"_aLocGrpID_"|")
		
		Set return=return_DeptCode_"|"
	}
	Quit return
}

/// w ##Class(DHCWMR.SSService.LocGroupSrv).SynchDeptList()
ClassMethod SynchDeptList()
{
	New
	Set Count=0
	
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^CTLOC(0,"Desc",xLocDesc))
		Quit:xLocDesc=""
		
		Set xLocID=0
		For {
			Set xLocID=$o(^CTLOC(0,"Desc",xLocDesc,xLocID))
			Quit:xLocID=""
			
			Set DeptCode=xLocID
			Set DeptDesc=$p($g(^CTLOC(DeptCode)),"^",2)
			Continue:(DeptDesc["停用")||(DeptDesc["作废")
			Set LocType=$p($g(^CTLOC(DeptCode)),"^",13)
			Continue:(LocType'="E")&&(LocType'="W")
			
			Set LocGroup=""
			Set ID=$o(^DHCWMR.SS.LocGroupI("IndexDeptCode",$zcvt(DeptCode,"U"),0))
			If ID'="" {
				Set obj=##class(DHCWMR.SS.LocGroup).GetObjById(ID)
				If $IsObject(obj){
					Set LocGroup=obj.LGLocGroup
				}
			}
			Set InputStr=ID
			Set InputStr=InputStr_"^"_DeptCode
			Set InputStr=InputStr_"^"_DeptDesc
			Set InputStr=InputStr_"^"_LocType
			Set InputStr=InputStr_"^"_LocGroup
			Set InputStr=InputStr_"^"_""
			Set flg=##class(DHCWMR.SS.LocGroup).Update(InputStr,"^")
			If (+flg)>0 {
				Set Count=Count+1
			}
		}
	}
	
	Quit Count
}

}
