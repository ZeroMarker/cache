/// 名称: CT.IPMR.DPS.LocationSrv
/// 描述: DP包科室服务方法
/// 创建者：liyi
/// 创建日期: 2019-10-28
Class CT.IPMR.DPS.LocationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 系统代码
Parameter SourceSystem = "EM";

Parameter ContentNode = "Model";

Parameter DepartmentModel = "MA.IPMR.IOModel.Base.Department";

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  同步科室字典
/// Table：       CT.IPMR.DP.Location
/// Return：      
/// w ##class(CT.IPMR.DPS.LocationSrv).SyncLoc()
ClassMethod SyncLoc() As %String
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
		Set ret = ..SyncLocByExCode(ExCode)
		Set return=return+(+ret)
	}
	w "共计：同步科室数据"_return_"条！",!
	Set ret = ##class(CT.IPMR.DPS.LocationSrv).InsertMAData()
	w "共计：新生成MA科室数据"_ret_"条！",!
	Set ret = ##class(CT.IPMR.DPS.LocationMapSrv).AutoMap()
	w "共计：自动对照科室数据"_ret_"条！",!
	// 处理关联科室
	do ##class(CT.IPMR.DPS.LocationSrv).InsertMALinkLoc()
	
	Quit "OK"
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  根据DP科室数据生成MA科室数据
/// Table：       
/// Input：		  
/// Return：      
/// w ##class(CT.IPMR.DPS.LocationSrv).InsertMAData()
ClassMethod InsertMAData()
{
	New
	Set return=0
	// 自动生成基础数据
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.LocationD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.Location).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		Set dpcode = objDp.DLCode
		Set dpHospID = objDp.DLHospID
		Set objHospMap = ##class(CT.IPMR.DP.HospitalMap).GetObjByHisHospID(dpHospID)
		Set HospID =""
		Set:$isobject(objHospMap) HospID=objHospMap.DHIpmrHospID
		Set dpLinkLoc = objDp.DLLinkLoc
		// 无对应代码数据插入 MA.IPMR.BT.Hospital
		if '$d(^MA.IPMR.BT.LocationI("IdxOfCode"," "_$zcvt(dpcode,"U"))) {
			Set InputStr=""
			Set InputStr=InputStr_"^"_objDp.DLCode
			Set InputStr=InputStr_"^"_objDp.DLDesc
			Set InputStr=InputStr_"^"_objDp.DLDesc2
			Set InputStr=InputStr_"^"_objDp.DLType
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_objDp.DLAdmType
			Set InputStr=InputStr_"^"_HospID
			Set InputStr=InputStr_"^"_objDp.DLIsActive
			Set ret =  ##class(MA.IPMR.BT.Location).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.LocationSrv","InsertMAData",InputStr)
			}
		}else{	// 存在对应代码数据进行修改
			Set InputStr=$o(^MA.IPMR.BT.LocationI("IdxOfCode"," "_$zcvt(dpcode,"U"),""))
			Set InputStr=InputStr_"^"_objDp.DLCode
			Set InputStr=InputStr_"^"_objDp.DLDesc
			Set InputStr=InputStr_"^"_objDp.DLDesc2
			Set InputStr=InputStr_"^"_objDp.DLType
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_objDp.DLAdmType
			Set InputStr=InputStr_"^"_HospID
			Set InputStr=InputStr_"^"_objDp.DLIsActive
			Set ret =  ##class(MA.IPMR.BT.Location).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.LocationSrv","InsertMAData",InputStr)
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  根据DP科室数据生成MA科室数据的关联科室数据
/// Table：       
/// Input：		  
/// Return：      
/// w ##class(CT.IPMR.DPS.LocationSrv).InsertMALinkLoc()
ClassMethod InsertMALinkLoc()
{
	New
	Set return = 0
	// 生成关联科室数据
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.LocationD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.Location).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		Set dpcode = objDp.DLCode
		Set dpLinkLoc = objDp.DLLinkLoc
		
		Set LinkLoc = ""
		For ind = 1:1:$length(dpLinkLoc,",") {
			Set tmpLinkLoc = $p(dpLinkLoc,",",ind)
			Set objLocMap = ##class(CT.IPMR.DP.LocationMap).GetObjByHisLocID(tmpLinkLoc)
			Continue:'$isobject(objLocMap)
			Set xLinkLoc = objLocMap.DLIpmrLocID
			Set LinkLoc = $s(LinkLoc="":xLinkLoc,1:LinkLoc_","_xLinkLoc)
		}
		Set ID = $o(^MA.IPMR.BT.LocationI("IdxOfCode"," "_$zcvt(dpcode,"U"),""))
	
		Set obj=##class(MA.IPMR.BT.Location).GetObjById(ID)
		Continue:'$isobject(obj)
		Set InputStr=ID
		Set InputStr=InputStr_"^"_obj.BLCode
		Set InputStr=InputStr_"^"_obj.BLDesc
		Set InputStr=InputStr_"^"_obj.BLDesc2
		Set InputStr=InputStr_"^"_obj.BLType
		Set InputStr=InputStr_"^"_LinkLoc
		Set InputStr=InputStr_"^"_obj.BLAdmType
		Set InputStr=InputStr_"^"_obj.BLHospID
		Set InputStr=InputStr_"^"_obj.BLIsActive
		Set ret =  ##class(MA.IPMR.BT.Location).Update(InputStr,"^")
		if ret>0 {
				Set return = return+1
		}else{
			d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.LocationSrv","InsertMALinkLoc",InputStr)
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  同步科室字典到DP包
/// Table：       CT.IPMR.DP.Hospital
/// Input：		  aExCode：约定的系统外部代码
/// Return：      
/// w ##class(CT.IPMR.DPS.LocationSrv).SyncLocByExCode("HIS01")
ClassMethod SyncLocByExCode(aExCode)
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
		Set xml = ##class(MA.IPMR.IOiMedical.Srv.WebService.Server.ForMR).GetDepartment(request.ToXML())
	}else{	// 接口获取数据
		Set xml = ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(objsys.%Id(),"Department",request.ToXML()) 
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
/// w ##class(CT.IPMR.DPS.LocationSrv).Update("")
ClassMethod Update(xml As %GlobalCharacterStream) As %String
{
	New (xml)
	Set return=""
	Quit:(xml="") return
	
	Set Count = 0
	set response=##class(MA.IPMR.IOModel.ENS.Response).CloneFromXML(xml,..#ContentNode,..#DepartmentModel)
	set Models = response.Body.ResultStruct.Models
	while (Models.GetNext(.key))
	{
		set model = Models.GetAt(key)
		set ExCode   = model.ExCode
		Set LocID    = model.ID
		Set Code     = model.Code
		Set Desc     = model.Desc
		Set Type     = model.Type
		Set HospID   = model.HospID
		Set DateFrom = model.DateFrom
		Set DateTo   = model.DateTo
		Set AdmType  = model.AdmType
		Set LinkLoc  = model.LinkLoc
		Set objSYS=##class(CT.IPMR.DP.System).GetObjByExCode(ExCode)
		continue:'$IsObject(objSYS)
		Set SYSDr=objSYS.%Id()
		Set SYSExCode=objSYS.DSExCode
		Set IsActive=1
		Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
		Set:(DateTo'="")&(DateTo<+$h) IsActive=0
		Set Type=$s(Type="E":"E",Type="W":"W",Type="O":"O",1:"")
		
		
		Set OID = ##class(CT.IPMR.DPS.Common).GetIdString(LocID,SYSDr)
		Set HospID = ##class(CT.IPMR.DPS.Common).GetIdString(HospID,SYSDr)
		Set ID="",Desc2="",RangeID="",ActUserID=""
		
		Set objTmp=##class(CT.IPMR.DP.Location).GetObjByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
		}
		Set tmpLinkLoc=""
		For ind = 1:1:$length(LinkLoc,",") {
			Set xLinkLoc = $p(LinkLoc,",",ind)
			continue:xLinkLoc=""
			Set xLinkLoc = ##class(CT.IPMR.DPS.Common).GetIdString(xLinkLoc,SYSDr)
			Set tmpLinkLoc=$s(tmpLinkLoc="":xLinkLoc,1:tmpLinkLoc_","_xLinkLoc)
		}
		Set LinkLoc = tmpLinkLoc
		Set InputStr=ID
		Set InputStr=InputStr_"^"_SYSDr
		Set InputStr=InputStr_"^"_LocID
		Set InputStr=InputStr_"^"_OID
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_Desc2
		Set InputStr=InputStr_"^"_Type
		Set InputStr=InputStr_"^"_AdmType
		Set InputStr=InputStr_"^"_HospID
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_LinkLoc
		Set ret=##class(CT.IPMR.DP.Location).Update(InputStr,"^")
		
		if ret>0 {
			// 保存成功！
			Set Count = Count+1
		}else{
			d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.LocationSrv","Update",InputStr)
		}
	}
	Set return = Count
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询科室
/// Table：       CT.IPMR.DP.Location
/// Input：       
/// output:       科室列表
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.LocationSrv","QryLoc")
Query QryLoc(aLocType As %String, aAdmType As %String, aKeyword As %String = "") As %Query(ROWSPEC = "ID:%String,SysCode:%String,SysDesc:%String,DicID:%String,LocID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,LocType:%String,AdmType:%String,HospID:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryLocExecute(ByRef qHandle As %Binary, aLocType As %String, aAdmType As %String, aKeyword As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.DP.LocationD(xID))
		Quit:xID=""
		Set obj = ##class(CT.IPMR.DP.Location).GetObjById(xID)
		Continue:'$isobject(obj)
		
		Set objSys = obj.DLSysDr 
		Continue:'$isobject(objSys)
		
		Set SysCode = objSys.DSSysCode
		Set SysDesc = objSys.DSSysDesc
		
		Set DicID = obj.DLDicID
		Set LocID = obj.DLLocID
		Set LocCode = obj.DLCode
		Set LocDesc = obj.DLDesc
		Set LocDesc2 = obj.DLDesc2
		Set LocType = obj.DLType
		Set AdmType = obj.DLAdmType
		Set HospID = obj.DLHospID
		Set IsActive = obj.DLIsActive
		Continue:(aLocType'="")&&(aLocType'=LocType)
		Continue:(aAdmType'="")&&(aAdmType'=AdmType)
		Continue:(aKeyword'="")&&(LocDesc'[aKeyword)
		
		Set Data=$lb(xID,SysCode,SysDesc,DicID,LocID,LocCode,LocDesc,LocDesc2,LocType,AdmType,HospID,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocExecute ]
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
