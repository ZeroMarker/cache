/// 名称: MA.IPMR.BTS.HospitalSrv
/// 描述: 医院对照相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DPS.HospitalMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  自动对照数据
/// Table：       CT.IPMR.DP.HospitalMap
/// Return：      
/// w ##class(CT.IPMR.DPS.HospitalMapSrv).AutoMap()
ClassMethod AutoMap()
{
	New
	Set return=0
	// 根据代码自动对照数据
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.HospitalD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.Hospital).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		
		Set DpHospID = objDp.DHHospID
		// 未对照数据进行对照
		if '$d(^CT.IPMR.DP.HospitalMapI("IndexOfHisHospID"," "_$zcvt(DpHospID,"U"))) {
			Set HospID=$o(^MA.IPMR.BT.HospitalI("IdxOfCode"," "_$zcvt(objDp.DHCode,"U"),0))
			Set InputStr=""
			Set InputStr=InputStr_"^"_HospID
			Set InputStr=InputStr_"^"_DpHospID
			Set ret = ##class(CT.IPMR.DP.HospitalMap).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.HospitalMapSrv","AutoMap",InputStr)
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询已对照医院
/// Table：       CT.IPMR.DP.HospitalMap
/// Input：       aIpmrHospId:MA_IPMR_BT.Hospital.ID
/// output:       已对照医院列表CT.IPMR.DP.Hospital
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.HospitalMapSrv","QryMapHosp","")
Query QryMapHosp(aIpmrHospId As %String = "") As %Query(ROWSPEC = "MapID:%String,SysCode:%String,SysDesc:%String,HisHospID:%String,HospCode:%String,HospDesc:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryMapHospExecute(ByRef qHandle As %Binary, aIpmrHospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xMapID = ""
 	For {
		Set xMapID=$o(^CT.IPMR.DP.HospitalMapI("IndexOfIpmrHospID"," "_aIpmrHospId,xMapID))
		Quit:xMapID=""
		
		Set objMap = ##class(CT.IPMR.DP.HospitalMap).GetObjById(xMapID)
		Continue:'$isobject(objMap)
		Set HisHospID = objMap.DHHisHospID
		Set objHisHosp = ##class(CT.IPMR.DP.Hospital).GetObjByOID(HisHospID)
		Continue:'$isobject(objHisHosp)
		Set objSys = objHisHosp.DHSysDr 
		Continue:'$isobject(objSys)
		
		Set SysCode = objSys.DSSysCode
		Set SysDesc = objSys.DSSysDesc
		
		Set HospCode = objHisHosp.DHCode
		Set HospDesc = objHisHosp.DHDesc
		Set IsActive = objHisHosp.DHIsActive
		Set Data=$lb(xMapID,SysCode,SysDesc,HisHospID,HospCode,HospDesc,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMapHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapHospExecute ]
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
