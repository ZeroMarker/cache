/// 名称: DHCMA.Util.EPS.HospitalSrv
/// 描述: 医院字典 服务类
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPS.HospitalSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2018-07-31
/// Description:  查询科室列表
/// Table：       DHCMA.Util.EPx.Hospital
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.HospitalSrv","QryHospInfo")
Query QryHospInfo(aHospID As %String = "", aIsActive As %String = "", IsShowAllHosp As %String = "0") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,Desc2:%String,GroupID:%String,GroupDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHospInfoExecute(ByRef qHandle As %Binary, aHospID As %String = "", aIsActive As %String = "", IsShowAllHosp As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//增加登录科室医院分组过滤
 	Set aHospGroupDr=""
	If (aHospID'="") {
		Set aHospDr=$o(^DHCMA.Util.EPx.HospitalI("IdxOfOID"," "_$zcvt(aHospID,"U"),0))
		Quit:(aHospDr="") $$$OK
		Set objHosp=##class(DHCMA.Util.EPx.Hospital).%OpenId(aHospDr)
		Set:$IsObject(objHosp.BTGroupDr) aHospGroupDr=objHosp.BTGroupDr.%Id()	
	}
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.HospitalD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.Hospital).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set Desc2       = obj.BTDesc2
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set IsActDesc 	= $SELECT(obj.BTIsActive=1:"是",1:"否")
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		Continue:(aIsActive'="")&&(IsActive'=1)
		
		Set GroupID="",GroupDesc=""
		If $IsObject(obj.BTGroupDr) {
			Set GroupID=obj.BTGroupDr.%Id()
			Set GroupDesc=obj.BTGroupDr.BTDesc
		}
		Continue:(IsShowAllHosp="0")&&(aHospGroupDr'="")&&(aHospGroupDr'=GroupID)
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.Hospital).GetObjByOID(RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
		Set ActUserDesc=""
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
			Set ActUserDesc=objActUser.BTDesc
		}
		
		//进行医院描述翻译
		Set Desc=##class(User.CTHospital).GetTranByDesc("HOSPDesc",Desc)
		set Data=$lb(xID,OID,Code,Desc,Desc2,GroupID,GroupDesc,RangeID,RangeDesc,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryHospInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospInfoExecute ]
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

/// Creator:	  liuzhenhe
/// CreatDate：   2019-09-06
/// Description:  查询医院描述 以,隔离
/// Table：       DHCMA.Util.EPx.Hospital
/// Input：       
/// Return：      返回ROWSPEC
/// w ##class("DHCMA.Util.EPS.HospitalSrv").GetHospDescList("2!!1,3!!1")
ClassMethod GetHospDescList(aHospId)
{
	new (aHospId)
	Set HospDesc="",ind=0,Sum=$l(aHospId,",")
		
		for {
			Set ind = ind+1
		    Quit:ind>Sum
		    
			Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID($p(aHospId,",",ind))
			If $IsObject(objHosp){
			Set HospDesc=$s(HospDesc="":objHosp.BTDesc,1:HospDesc_","_objHosp.BTDesc)
			}
		}
		Quit HospDesc
}

/// Creator:	  yankai
/// CreatDate：   2021-07-20
/// Description:  手动同步医院及医院组方法
/// Table：       DHCMA.Util.EPx.Hospital、DHCMA.Util.BT.HospGroup
/// Input：       >1成功，<0失败,其他:空
/// Return：      返回ROWSPEC
/// w ##class("DHCMA.Util.EPS.HospitalSrv").SyncHospAndGroupInfo("HIS01")
ClassMethod SyncHospAndGroupInfo(aSysCode As %String = "HIS01") As %String
{
	New (aSysCode)
	Set return=0
	
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode(aSysCode)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	
	Set return=##Class(DHCMA.Util.EPy.HospitalSrv).SyncHospital(SYSDr)
	Quit return
}

}
