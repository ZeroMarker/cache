/// 名称: CT.IPMR.DPS.SSUserSrv
/// 描述: DP包用户服务方法
/// 创建者：liyi
/// 创建日期: 2019-11-19
Class CT.IPMR.DPS.SSUserSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 系统代码
Parameter SourceSystem = "EM";

Parameter ContentNode = "Model";

Parameter UserModel = "MA.IPMR.IOModel.Base.User";

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  同步用户字典到DP包
/// Table：       CT.IPMR.DP.SSUser
/// Return：      
/// w ##class(CT.IPMR.DPS.SSUserSrv).SyncSSUser()
ClassMethod SyncSSUser()
{
	New
	Set return=0
	Set xID = ""
	For {
		Set xID = $o(^CT.IPMR.DP.SystemD(xID))
		Quit:xID=""
		Set objsys = ##class(CT.IPMR.DP.System).GetObjById(xID)
		Continue:'$isobject(objsys)
		Set ExCode = objsys.DSExCode
		Continue:ExCode=""
		Set ret = ..SyncUserByExCode(ExCode)
		Set return=return+(+ret)
	}
	w "共计：同步用户数据"_return_"条！",!
	Set ret = ##class(CT.IPMR.DPS.SSUserSrv).InsertMAData()
	w "共计：新生成MA用户数据"_ret_"条！",!
	Set ret = ##class(CT.IPMR.DPS.SSUserMapSrv).AutoMap()
	w "共计：自动对照用户数据"_ret_"条！",!
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  根据DP用户数据生成MA用户数据
/// Table：       
/// Input：		  
/// Return：      
/// w ##class(CT.IPMR.DPS.SSUserSrv).InsertMAData()
ClassMethod InsertMAData()
{
	New
	Set return=0
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.SSUserD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.SSUser).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		Set dpcode = objDp.DSCode
		
		if '$d(^MA.IPMR.BT.SSUserI("IdxOfCode"," "_$zcvt(dpcode,"U"))) {
			Set InputStr=""
			Set InputStr=InputStr_"^"_objDp.DSCode
			Set InputStr=InputStr_"^"_objDp.DSDesc
			Set InputStr=InputStr_"^"_objDp.DSIsActive
			Set InputStr=InputStr_"^"_objDp.DSSpell
			Set InputStr=InputStr_"^"_objDp.DCCPTInternalType
			Set InputStr=InputStr_"^"_objDp.DCCPTDesc
			Set InputStr=InputStr_"^"_objDp.DCUnit
			Set ret =  ##class(MA.IPMR.BT.SSUser).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.SSUserSrv","InsertMAData",InputStr)
			}
		}else{
			Set InputStr=$o(^MA.IPMR.BT.SSUserI("IdxOfCode"," "_$zcvt(dpcode,"U"),""))
			Set InputStr=InputStr_"^"_objDp.DSCode
			Set InputStr=InputStr_"^"_objDp.DSDesc
			Set InputStr=InputStr_"^"_objDp.DSIsActive
			Set InputStr=InputStr_"^"_objDp.DSSpell
			Set InputStr=InputStr_"^"_objDp.DCCPTInternalType
			Set InputStr=InputStr_"^"_objDp.DCCPTDesc
			Set InputStr=InputStr_"^"_objDp.DCUnit
			Set ret =  ##class(MA.IPMR.BT.SSUser).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.SSUserSrv","InsertMAData",InputStr)
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  同步用户字典到DP包
/// Table：       CT.IPMR.DP.SSUser
/// Input：		  aExCode：约定的系统外部代码
/// Return：      
/// w ##class(CT.IPMR.DPS.SSUserSrv).SyncUserByExCode("HIS01")
ClassMethod SyncUserByExCode(aExCode)
{
	New (aExCode)
	Set return=0
	Set objsys = ##class(CT.IPMR.DP.System).GetObjByExCode(aExCode)
	Quit:'$isobject(objsys) return
	Quit:objsys.DSExCode="" return
	
	Set request = ##class(MA.IPMR.IOModel.ENS.Request).Create()
	Set request.Header.SourceSystem=..#SourceSystem
	Set request.Header.MessageID=""
	Set request.Body.Arguments.ExCode=aExCode
	If aExCode="localhost"{
		Set xml = ##class(MA.IPMR.IOiMedical.Srv.WebService.Server.ForMR).GetUser(request.ToXML())
	}else{	// 接口获取数据
		Set xml = ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(objsys.%Id(),"User",request.ToXML())
	}
	Set return = ..Update(xml)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  解析xml数据流并插入结构
/// Table：       
/// Input：		  aInput：xml数据
/// Return：      
/// w ##class(CT.IPMR.DPS.SSUserSrv).Update("")
ClassMethod Update(xml As %GlobalCharacterStream) As %String
{
	New (xml)
	Set return=""
	Quit:(xml="") return
	
	Set Count = 0
	set response=##class(MA.IPMR.IOModel.ENS.Response).CloneFromXML(xml,..#ContentNode,..#UserModel)
	set Models = response.Body.ResultStruct.Models
	while (Models.GetNext(.key))
	{
		set model = Models.GetAt(key)
		set ExCode   = model.ExCode
		Set UserID    = model.ID
		Set Code      = model.Code
		Set Desc      = model.Desc
		Set Password  = model.Password
		Set LocID     = model.LocID
		Set CPTInternalType	  = model.CPTInternalType
		Set CPTDesc	  = model.CPTDesc
		Set Unit	  = model.Unit
		Set DateFrom  = model.DateFrom
		Set DateTo	  = model.DateTo
		Set PYCode	  = model.PYCode
		Set objSYS=##class(CT.IPMR.DP.System).GetObjByExCode(ExCode)
		continue:'$IsObject(objSYS)
		Set SYSDr=objSYS.%Id()
		Set SYSExCode=objSYS.DSExCode
		
		Set IsActive=1
		Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
		Set:(DateTo'="")&(DateTo<+$h) IsActive=0
		
		Set OID = ##class(CT.IPMR.DPS.Common).GetIdString(UserID,SYSDr)
		Set LocID = ##class(CT.IPMR.DPS.Common).GetIdString(LocID,SYSDr)
		Set ID=""
		Set objTmp=##class(CT.IPMR.DP.SSUser).GetObjByOID(OID)
		If $IsObject(objTmp){
			Set ID=objTmp.%Id()
		}
		Set InputStr=ID
		Set InputStr=InputStr_"^"_SYSDr
		Set InputStr=InputStr_"^"_UserID
		Set InputStr=InputStr_"^"_OID
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_Password
		Set InputStr=InputStr_"^"_LocID
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_PYCode
		Set InputStr=InputStr_"^"_CPTInternalType
		Set InputStr=InputStr_"^"_CPTDesc
		Set InputStr=InputStr_"^"_Unit
		Set ret=##class(CT.IPMR.DP.SSUser).Update(InputStr,"^")
		if ret>0 {
			// 保存成功！
			Set Count = Count+1
		}else{
			//记录错误日志
			d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.HospitalSrv","Update",InputStr)
		}
	}
	Set return = Count
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询用户
/// Table：       CT.IPMR.DP.SSUser
/// Input：       
/// output:       用户列表
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.SSUserSrv","QryUser","Y")
Query QryUser(aKeyword As %String = "") As %Query(ROWSPEC = "ID:%String,SysCode:%String,SysDesc:%String,DicID:%String,UserID:%String,Code:%String,Desc:%String,Password:%String,LocID:%String,CPTInternalType:%String,CPTDesc:%String,Unit:%String,IsActive:%String,Spell:%String") [ SqlProc ]
{
}

ClassMethod QryUserExecute(ByRef qHandle As %Binary, aKeyword As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.DP.SSUserD(xID))
		Quit:xID=""
		Set obj = ##class(CT.IPMR.DP.SSUser).GetObjById(xID)
		Continue:'$isobject(obj)
		
		Set objSys = obj.DSSysDr 
		Continue:'$isobject(objSys)
		
		Set SysCode = objSys.DSSysCode
		Set SysDesc = objSys.DSSysDesc
		
		Set DicID = obj.DSDicID
		Set UserID = obj.DSUserID
		Set Code = obj.DSCode
		Set Desc = obj.DSDesc
		Set Password = obj.DSPassword
		Set LocID = obj.DSLocID
		Set CPTInternalType = obj.DCCPTInternalType
		Set CPTDesc = obj.DCCPTDesc
		Set Unit = obj.DCUnit
		Set IsActive = obj.DSIsActive
		Set Spell = obj.DSSpell
		if aKeyword'="" {
			Continue:($zcvt(Desc,"U")'[$zcvt(aKeyword,"U"))&&($zcvt(Code,"U")'[$zcvt(aKeyword,"U"))&&($zcvt(Spell,"U")'[$zcvt(aKeyword,"U"))
		}
		
		Set Data=$lb(xID,SysCode,SysDesc,DicID,UserID,Code,Desc,Password,LocID,CPTInternalType,CPTDesc,Unit,IsActive,Spell)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserExecute ]
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
