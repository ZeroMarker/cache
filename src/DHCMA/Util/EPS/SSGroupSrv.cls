/// 名称: DHCMA.Util.EPS.SSGroupSrv
/// 描述: 安全组 服务类
/// 编写者：zhufei
/// 编写日期: 2018-12-26
Class DHCMA.Util.EPS.SSGroupSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2018-12-26
/// Description:  查询安全组列表
/// Table：       DHCMA.Util.EPx.SSGroup
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.SSGroupSrv","QrySSGrpInfo","med")
Query QrySSGrpInfo(aAlias As %String, aHospID As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,GrpDesc:%String,SYSID:%String,SYSDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySSGrpInfoExecute(ByRef qHandle As %Binary, aAlias As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set aAlias=$zcvt(aAlias,"U")
	Set xSYSDr=""
	For {
		Set xSYSDr=$o(^DHCMA.Util.EPx.SSGroupI("IdxOfDesc",xSYSDr))
		Quit:xSYSDr=""
		
		Set xDesc=""
		For {
			Set xDesc=$o(^DHCMA.Util.EPx.SSGroupI("IdxOfDesc",xSYSDr,xDesc))
			Quit:xDesc=""
			Continue:(aAlias'="")&&(xDesc'[aAlias)
			
			Set xID=0
			For {
				Set xID=$o(^DHCMA.Util.EPx.SSGroupI("IdxOfDesc",xSYSDr,xDesc,xID))
				Quit:xID=""
				
				Set obj=##class(DHCMA.Util.EPx.SSGroup).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.SYSDr)
				Set OID         = obj.OID
				Set SYSID       = obj.SYSDr.%Id()
				Set SYSDesc     = obj.SYSDr.SYSDesc
				Set Desc        = obj.BTDesc
				Set IsActive    = obj.BTIsActive
				Set ActDate     = obj.BTActDate
				Set ActTime     = obj.BTActTime
				Set ActUserID   = obj.BTActUserID
				
				//院区检查
			 	If (IsOpen="Y")&&(aHospID'=""){
				 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("SS_Group",+OID,aHospID)
				 	Continue:retFlg'="Y"
				}
				
				Set IsActive=$s(IsActive=1:"是",1:"否")
				Set:ActDate'="" ActDate=$zd(ActDate,3)
				Set:ActTime'="" ActTime=$zt(ActTime,1)
				
				Set ActUserDesc=""
				Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
				If $IsObject(objActUser){
					Set ActUserDesc=objActUser.BTDesc
				}
				
				set Data=$lb(xID,OID,Desc,SYSID,SYSDesc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
		        Set ^CacheTemp(repid,ind)=Data
		        Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QrySSGrpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSGrpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSGrpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSGrpInfoExecute ]
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
