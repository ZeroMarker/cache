/// 名称:DHCMed.NINFService.BC.LocGroupSrv
/// 描述: 科室-科室组信息维护
/// 编写者：zhufei
/// 编写日期: 2014-01-24
Class DHCMed.NINFService.BC.LocGroupSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-01-24
/// Description:  查询科室-科室组信息列表
/// Table：       DHCMed.NINF.BC.LocGroup
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.LocGroupSrv","QryLocGroupList","1","")
Query QryLocGroupList(aQueryFlg As %String, aHospitalID As %String, aLocGrpDesc As %String, aDeptDesc As %String) As %Query(ROWSPEC = "LocGrpID:%String,DeptCode:%String,DeptDesc:%String,HospCode:%String,HospDesc:%String,LocType:%String,LocGroup:%String,ICUFlag:%String,ICUFlagDesc:%String,OperFlag:%String,OperFlagDesc:%String,ErrFlag:%String")
{
}

ClassMethod QryLocGroupListExecute(ByRef qHandle As %Binary, aQueryFlg As %String, aHospitalID As %String, aLocGrpDesc As %String, aDeptDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	If (+aQueryFlg)>0 {
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^CTLOC(0,"Desc",xLocDesc))
			Quit:xLocDesc=""
			
			Set xLocID=0
			For {
				Set xLocID=$o(^CTLOC(0,"Desc",xLocDesc,xLocID))
				Quit:xLocID=""
				
				Set XDeptCode=xLocID
				Set XDeptDesc=$p($g(^CTLOC(XDeptCode)),"^",2)
				Set:$p(XDeptDesc,"-",2)'="" XDeptDesc=$p(XDeptDesc,"-",2)
				Set XHospCode=$p($g(^CTLOC(XDeptCode)),"^",22)
				Set XHospDesc=$p($g(^CT("HOSP",+XHospCode)),"^",2)
				Set XLocType=$p($g(^CTLOC(XDeptCode)),"^",13)
				Continue:(XLocType="O")||(XLocType="OR")||(XLocType="C")||(XLocType="D")
				
				Set (DeptCode,DeptDesc,HospCode,HospDesc,LocType,LocGroup,ICUFlag,ICUFlagDesc,OperFlag,OperFlagDesc)=""
				Set LocGrpID=$o(^DHCMed.NINF.BC.LocGroupI("IndexDeptCode",xLocID,0))
				Set objLocGrp=##class(DHCMed.NINF.BC.LocGroup).GetObjById(LocGrpID)
				If $IsObject(objLocGrp){
					Set DeptCode=objLocGrp.LGDeptCode
					Set DeptDesc=objLocGrp.LGDeptDesc
					Set HospCode=objLocGrp.LGHospCode
					Set HospDesc=objLocGrp.LGHospDesc
					Set LocType=objLocGrp.LGLocType
					Set LocGroup=objLocGrp.LGLocGroup
					Set ICUFlag=objLocGrp.LGICUFlag
					Set ICUFlagDesc=$s(ICUFlag="1":"是",1:"否")
					Set OperFlag=objLocGrp.LGOperFlag
					Set OperFlagDesc=$s(OperFlag="1":"是",1:"否")
				} Else {
					Set DeptCode=XDeptCode
					Set DeptDesc=XDeptDesc
					Set HospCode=XHospCode
					Set HospDesc=XHospDesc
					Set LocType=XLocType
				}
				Continue:(aLocGrpDesc'="")&&($zcvt(LocGroup,"U")'[$zcvt(aLocGrpDesc,"U"))
				Continue:(aDeptDesc'="")&&($zcvt(DeptDesc,"U")'[$zcvt(aDeptDesc,"U"))
				
				If (XDeptDesc'=DeptDesc)||(XHospDesc'=HospDesc)||(XLocType'=LocType) {
					Set ErrFlag="1"
				} Else {
					Set ErrFlag="0"
				}
				
				Set Data=$lb(LocGrpID,DeptCode,DeptDesc,HospCode,HospDesc,LocType,LocGroup,ICUFlag,ICUFlagDesc,OperFlag,OperFlagDesc,ErrFlag)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	} Else {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.NINF.BC.LocGroupI("IndexDeptCode",xLocID))
			Quit:xLocID=""
			
			Set XDeptCode=xLocID
			Set XDeptDesc=$p($g(^CTLOC(XDeptCode)),"^",2)
			Set:$p(XDeptDesc,"-",2)'="" XDeptDesc=$p(XDeptDesc,"-",2)
			Set XHospCode=$p($g(^CTLOC(XDeptCode)),"^",22)
			Set XHospDesc=$p($g(^CT("HOSP",+XHospCode)),"^",2)
			Set XLocType=$p($g(^CTLOC(XDeptCode)),"^",13)
			
			Set xLocGrpID=0
			For {
				Set xLocGrpID=$o(^DHCMed.NINF.BC.LocGroupI("IndexDeptCode",xLocID,xLocGrpID))
				Quit:xLocGrpID=""
				
				Set LocGrpID=xLocGrpID
				Set objLocGrp=##class(DHCMed.NINF.BC.LocGroup).GetObjById(LocGrpID)
				Continue:'$IsObject(objLocGrp)
				Set DeptCode=objLocGrp.LGDeptCode
				Set DeptDesc=objLocGrp.LGDeptDesc
				Set HospCode=objLocGrp.LGHospCode
				Set HospDesc=objLocGrp.LGHospDesc
				Set LocType=objLocGrp.LGLocType
				Set LocGroup=objLocGrp.LGLocGroup
				Set ICUFlag=objLocGrp.LGICUFlag
				Set ICUFlagDesc=$s(ICUFlag="1":"是",1:"否")
				Set OperFlag=objLocGrp.LGOperFlag
				Set OperFlagDesc=$s(OperFlag="1":"是",1:"否")
				
				Continue:(aLocGrpDesc'="")&&($zcvt(LocGroup,"U")'[$zcvt(aLocGrpDesc,"U"))
				Continue:(aDeptDesc'="")&&($zcvt(DeptDesc,"U")'[$zcvt(aDeptDesc,"U"))
				
				If (XDeptDesc'=DeptDesc)||(XHospDesc'=HospDesc)||(XLocType'=LocType) {
					Set ErrFlag="1"
				} Else {
					Set ErrFlag="0"
				}
				
				Set Data=$lb(LocGrpID,DeptCode,DeptDesc,HospCode,HospDesc,LocType,LocGroup,ICUFlag,ICUFlagDesc,OperFlag,OperFlagDesc,ErrFlag)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
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

}
