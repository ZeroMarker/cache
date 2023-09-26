/// 名称: DHCMA.Util.EPS.LocationSrv
/// 描述: 科室字典 服务类
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPS.LocationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2018-07-31
/// Description:  查询科室列表
/// Table：       DHCMA.Util.EPx.Location
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.LocationSrv","QryLocInfo")
Query QryLocInfo(aHospID As %String = "", aAdmType As %String = "", aType As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,Desc2:%String,Type:%String,TypeDesc:%String,HospID:%String,HospDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String,AdmType:%String,AdmTypeDesc:%String,CPWIndNo:%String") [ SqlProc ]
{
}

ClassMethod QryLocInfoExecute(ByRef qHandle As %Binary, aHospID As %String = "", aAdmType As %String = "", aType As %String = "", aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.LocationD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.Location).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Continue:(aAlias'="")&&(($zcvt(Code,"U")'[aAlias)&&($zcvt(Desc,"U")'[aAlias))
		Set Desc2       = obj.BTDesc2
		Set Type        = obj.BTType
		Set HospID      = obj.BTHospID
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set IsActDesc	= $SELECT(obj.BTIsActive:"是",1:"否")
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		Set AdmType     = obj.BTAdmType
		Set CPWIndNo 	= obj.CPWIndNo
		Continue:(aType'="")&&(aType'=Type)
		Set TypeDesc=$s(Type="E":"执行科室",Type="W":"病区",1:"其他")
		
		//OP门诊 IP住院 EP急诊 Sup医技辅助  Manage管理职能部门 Health健康体检
		Continue:(aAdmType'="")&&(aAdmType'=AdmType)
		Set AdmTypeDesc=$s(AdmType="O":"门诊",AdmType="I":"住院",AdmType="E":"急诊",AdmType="S":"医技辅助",AdmType="M":"职能辅助",AdmType="H":"健康体检",1:"")

		Set HospDesc=##class("DHCMA.Util.EPS.HospitalSrv").GetHospDescList(HospID)
		Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
		If $IsObject(objHosp){
			Set HospDesc=objHosp.BTDesc
		}
		Continue:(aHospID'="")&&(aHospID'=HospID)
		
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.Location).GetObjByOID(RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
		Set ActUserDesc=""
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
			Set ActUserDesc=objActUser.BTDesc
		}
		//进行科室描述翻译
		Set Desc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Desc)
		set Data=$lb(xID,OID,Code,Desc,Desc2,Type,TypeDesc,HospID,HospDesc,RangeID,RangeDesc,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserDesc,AdmType,AdmTypeDesc,CPWIndNo)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocInfoExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.LocationSrv","QryLocInfoNew","3!!1,4!!1,5!!1")
Query QryLocInfoNew(aLocOIDs As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,Desc2:%String,Type:%String,TypeDesc:%String,HospID:%String,HospDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLocInfoNewExecute(ByRef qHandle As %Binary, aLocOIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set LocOIDList=""
	For idx=1:1:$l(aLocOIDs,","){
		Set LocOID=$p(aLocOIDs,",",idx)
		Continue:LocOID=""
		Set LocOIDList=LocOIDList_$lb(LocOID)
	}
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.LocationD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.Location).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Continue:(LocOIDList'="")&&($listfind(LocOIDList,OID)=0)
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set Desc2       = obj.BTDesc2
		Set Type        = obj.BTType
		Set HospID      = obj.BTHospID
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		
		Set TypeDesc=$s(Type="E":"执行科室",Type="W":"病区",1:"其他")
		
		Set HospDesc=""
		Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
		If $IsObject(objHosp){
			Set HospDesc=objHosp.BTDesc
		}
		
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.Location).GetObjByOID(RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
		Set ActUserDesc=""
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
			Set ActUserDesc=objActUser.BTDesc
		}
		
		set Data=$lb(xID,OID,Code,Desc,Desc2,Type,TypeDesc,HospID,HospDesc,RangeID,RangeDesc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLocInfoNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocInfoNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocInfoNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocInfoNewExecute ]
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

/// Creator:	  zhangdc
/// CreatDate：   2020-03-24
/// Description:  查询住院科室列表
/// Table：       DHCMA.Util.EPx.Location
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.LocationSrv","QryHosLocInfo")
Query QryHosLocInfo() As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,Desc2:%String,Type:%String,TypeDesc:%String,HospID:%String,HospDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHosLocInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.LocationD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.Location).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set Desc2       = obj.BTDesc2
		Set Type        = obj.BTType
		Set HospID      = obj.BTHospID
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set IsActDesc	= $SELECT(obj.BTIsActive:"是",1:"否")
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		
		//过滤门诊科室
		//Continue:Desc["门诊"
		Continue:'$d(^PAC("ADMLOC",0,"AdmType","I",xID))
		
		Set TypeDesc=$s(Type="E":"执行科室",Type="W":"病区",1:"其他")
		
		Set HospDesc=##class("DHCMA.Util.EPS.HospitalSrv").GetHospDescList(HospID)
		Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(HospID)
		If $IsObject(objHosp){
			Set HospDesc=objHosp.BTDesc
		}
		
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.Location).GetObjByOID(RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
		Set ActUserDesc=""
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
			Set ActUserDesc=objActUser.BTDesc
		}
		
		set Data=$lb(xID,OID,Code,Desc,Desc2,Type,TypeDesc,HospID,HospDesc,RangeID,RangeDesc,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryHosLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHosLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHosLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHosLocInfoExecute ]
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

/// Creator:	  zqy
/// CreatDate：   2022-8-25
/// Description:  查询科室类型W E
/// w ##class(DHCMA.Util.EPS.LocationSrv).GetTypeByOID("6!!1")
ClassMethod GetTypeByOID(aId As %String) As %String
{
	New (aId)
	Set obj=##class(DHCMA.Util.EP.Location).GetObjByOID(aId)
	Quit:'$IsObject(obj) ""
	Quit obj.BTType
}

}
