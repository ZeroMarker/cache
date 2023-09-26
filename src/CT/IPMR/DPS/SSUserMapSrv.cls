/// 名称: CT.IPMR.DPS.SSUserMapSrv
/// 描述: 用户对照相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DPS.SSUserMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  自动对照数据
/// Table：       CT.IPMR.DP.SSUserMap
/// Return：      
/// w ##class(CT.IPMR.DPS.SSUserMapSrv).AutoMap()
ClassMethod AutoMap()
{
	New
	Set return=0
	// 根据代码自动对照数据
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.SSUserD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.SSUser).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		
		Set DpUserID = objDp.DSUserID
		// 未对照数据进行对照
		if '$d(^CT.IPMR.DP.SSUserMapI("IndexOfHisUser"," "_$zcvt(DpUserID,"U"))) {
			Set UserID=$o(^MA.IPMR.BT.SSUserI("IdxOfCode"," "_$zcvt(objDp.DSCode,"U"),0))
			Set InputStr=""
			Set InputStr=InputStr_"^"_UserID
			Set InputStr=InputStr_"^"_DpUserID
			Set ret = ##class(CT.IPMR.DP.SSUserMap).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.SSUserMapSrv","AutoMap",InputStr)
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询已对照用户
/// Table：       CT.IPMR.DP.SSUserMap
/// Input：       aIpmrUserId:MA_IPMR_BT.SSUser.ID
/// output:       已对照用户列表CT.IPMR.DP.SSUser
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.SSUserMapSrv","QryMapUser","1")
Query QryMapUser(aIpmrUserId As %String = "") As %Query(ROWSPEC = "MapID:%String,SysCode:%String,SysDesc:%String,DicID:%String,HisUserID:%String,Code:%String,Desc:%String,Password:%String,LocID:%String,CPTInternalType:%String,CPTDesc:%String,Unit:%String,IsActive:%String,Spell:%String") [ SqlProc ]
{
}

ClassMethod QryMapUserExecute(ByRef qHandle As %Binary, aIpmrUserId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xMapID = ""
 	For {
		Set xMapID=$o(^CT.IPMR.DP.SSUserMapI("IndexOfIpmrUser"," "_aIpmrUserId,xMapID))
		Quit:xMapID=""
		
		Set objMap = ##class(CT.IPMR.DP.SSUserMap).GetObjById(xMapID)
		Continue:'$isobject(objMap)
		Set HisUserID = objMap.DSHisUserID
		Set objHisUser = ##class(CT.IPMR.DP.SSUser).GetObjByOID(HisUserID)
		Continue:'$isobject(objHisUser)
		Set objSys = objHisUser.DSSysDr 
		Continue:'$isobject(objSys)
		
		Set SysCode = objSys.DSSysCode
		Set SysDesc = objSys.DSSysDesc
		
		Set DicID = objHisUser.DSDicID
		Set Code = objHisUser.DSCode
		Set Desc = objHisUser.DSDesc
		Set Password = objHisUser.DSPassword
		Set LocID = objHisUser.DSLocID
		Set CPTInternalType = objHisUser.DCCPTInternalType
		Set CPTDesc = objHisUser.DCCPTDesc
		Set Unit = objHisUser.DCUnit
		Set IsActive = objHisUser.DSIsActive
		Set Spell = objHisUser.DSSpell
		Set Data=$lb(xMapID,SysCode,SysDesc,DicID,HisUserID,Code,Desc,Password,LocID,CPTInternalType,CPTDesc,Unit,IsActive,Spell)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMapUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapUserExecute ]
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
