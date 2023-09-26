/// 名称: CT.IPMR.DPS.LocationMapSrv
/// 描述: 科室对照相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DPS.LocationMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  自动对照数据
/// Table：       CT.IPMR.DP.LocationMap
/// Return：      
/// w ##class(CT.IPMR.DPS.LocationMapSrv).AutoMap()
ClassMethod AutoMap()
{
	New
	Set return=0
	// 根据代码自动对照数据
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.LocationD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.Location).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		
		Set DpLocID = objDp.DLLocID
		// 未对照数据进行对照
		if '$d(^CT.IPMR.DP.LocationMapI("IndexOfHisLoc"," "_$zcvt(DpLocID,"U"))) {
			Set LocID=$o(^MA.IPMR.BT.LocationI("IdxOfCode"," "_$zcvt(objDp.DLCode,"U"),0))
			Set InputStr=""
			Set InputStr=InputStr_"^"_LocID
			Set InputStr=InputStr_"^"_DpLocID
			Set ret = ##class(CT.IPMR.DP.LocationMap).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.LocationMapSrv","AutoMap",InputStr)
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询已对照科室
/// Table：       CT.IPMR.DP.LocationMap
/// Input：       aIpmrLocId:MA_IPMR_BT.Location.ID
/// output:       已对照科室列表CT.IPMR.DP.Location
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.LocationMapSrv","QryMapLoc","1")
Query QryMapLoc(aIpmrLocId As %String = "") As %Query(ROWSPEC = "MapID:%String,SysCode:%String,SysDesc:%String,DicID:%String,HisLocID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocType:%String,AdmType:%String,HospID:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryMapLocExecute(ByRef qHandle As %Binary, aIpmrLocId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xMapID = ""
 	For {
		Set xMapID=$o(^CT.IPMR.DP.LocationMapI("IndexOfIpmrLoc"," "_aIpmrLocId,xMapID))
		Quit:xMapID=""
		
		Set objMap = ##class(CT.IPMR.DP.LocationMap).GetObjById(xMapID)
		Continue:'$isobject(objMap)
		Set HisLocID = objMap.DLHisLocID
		Set objHisLoc = ##class(CT.IPMR.DP.Location).GetObjByOID(HisLocID)
		Continue:'$isobject(objHisLoc)
		Set objSys = objHisLoc.DLSysDr 
		Continue:'$isobject(objSys)
		
		Set SysCode = objSys.DSSysCode
		Set SysDesc = objSys.DSSysDesc
		
		Set DicID = objHisLoc.DLDicID
		Set LocCode = objHisLoc.DLCode
		Set LocDesc = objHisLoc.DLDesc
		Set LocDesc2 = objHisLoc.DLDesc2
		Set LocType = objHisLoc.DLType
		Set AdmType = objHisLoc.DLAdmType
		Set HospID = objHisLoc.DLHospID
		Set IsActive = objHisLoc.DLIsActive
		Set Data=$lb(xMapID,SysCode,SysDesc,DicID,HisLocID,LocCode,LocDesc,LocDesc2,LocType,AdmType,HospID,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMapLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapLocExecute ]
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
