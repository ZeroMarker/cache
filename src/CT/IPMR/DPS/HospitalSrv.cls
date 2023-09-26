/// 名称: CT.IPMR.DPS.HospitalSrv
/// 描述: DP包医院服务方法
/// 创建者：liyi
/// 创建日期: 2019-10-28
Class CT.IPMR.DPS.HospitalSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 系统代码
Parameter SourceSystem = "EM";

Parameter ContentNode = "Model";

Parameter HospitalModel = "MA.IPMR.IOModel.Base.Hospital";

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  同步医院字典
/// Table：       CT.IPMR.DP.Hospital
/// Return：      
/// w ##class(CT.IPMR.DPS.HospitalSrv).SyncHosp()
ClassMethod SyncHosp() As %String
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
		Set ret = ..SyncHospByExCode(ExCode)
		Set return=return+(+ret)
	}
	w "共计：同步医院数据"_return_"条！",!
	Set ret = ##class(CT.IPMR.DPS.HospitalSrv).InsertMAData()
	w "共计：新生成MA医院数据"_ret_"条！",!
	Set ret = ##class(CT.IPMR.DPS.HospitalMapSrv).AutoMap()
	w "共计：自动对照医院数据"_ret_"条！",!
	Quit "OK"
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  根据DP医院数据生成MA医院数据
/// Table：       
/// Input：		  
/// Return：      
/// w ##class(CT.IPMR.DPS.HospitalSrv).InsertMAData()
ClassMethod InsertMAData()
{
	New
	Set return=0
	Set xDpID = ""
	For {
		Set xDpID=$o(^CT.IPMR.DP.HospitalD(xDpID))
		Quit:xDpID=""
		Set objDp = ##class(CT.IPMR.DP.Hospital).GetObjById(xDpID)
		Continue:'$isobject(objDp)
		Set dpcode = objDp.DHCode
		
		if '$d(^MA.IPMR.BT.HospitalI("IdxOfCode"," "_$zcvt(dpcode,"U"))) {
			Set InputStr=""
			Set InputStr=InputStr_"^"_objDp.DHCode
			Set InputStr=InputStr_"^"_objDp.DHDesc
			Set InputStr=InputStr_"^"_objDp.DHIsActive
			Set ret =  ##class(MA.IPMR.BT.Hospital).Update(InputStr,"^")
			if ret>0 {
				Set return = return+1
			}else{
				d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.HospitalSrv","InsertMAData",InputStr)
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-28
/// Description:  同步医院字典到DP包
/// Table：       CT.IPMR.DP.Hospital
/// Input：		  aExCode：约定的系统外部代码
/// Return：      
/// w ##class(CT.IPMR.DPS.HospitalSrv).SyncHospByExCode("localhost")
ClassMethod SyncHospByExCode(aExCode)
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
		Set xml = ##class(MA.IPMR.IOiMedical.Srv.WebService.Server.ForMR).GetHospital(request.ToXML())
	}else{	// 接口获取数据
		Set xml = ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(objsys.%Id(),"Hospital",request.ToXML()) 
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
/// w ##class(CT.IPMR.DPS.HospitalSrv).Update("<BaseDic><SysCode>HIS01</SysCode><Hospital><Items><ID>1</ID><Code>HID0101</Code><Desc>四川大学华西医院</Desc><DateFrom>60812</DateFrom></Items><Items><ID>2</ID><Code>HID0201</Code><Desc>绵阳肿瘤</Desc></Items><Items><ID>3</ID><Code>HID0301</Code><Desc>绵阳骨科</Desc></Items><Items><ID>4</ID><Code>PORTAL01</Code><Desc>华西一院PORTAL</Desc></Items><Items><ID>5</ID><Code>F0002</Code><Desc>四川大学华西医院温江院区</Desc><DateFrom>62997</DateFrom></Items><Items><ID>6</ID><Code>F0003</Code><Desc>四川省第五人民医院/四川大学华西医院老年医学中心</Desc><DateFrom>64491</DateFrom></Items><Items><ID>7</ID><Code>F0004</Code><Desc>四川大学华西医院特需医疗中心</Desc><DateFrom>64826</DateFrom></Items></Hospital></BaseDic>")
ClassMethod Update(xml As %GlobalCharacterStream) As %String
{
	New (xml)
	Set return=""
	Quit:(xml="") return
	Set Count = 0
	set response=##class(MA.IPMR.IOModel.ENS.Response).CloneFromXML(xml,..#ContentNode,..#HospitalModel)
	set Models = response.Body.ResultStruct.Models
	while (Models.GetNext(.key))
	{
		set model = Models.GetAt(key)
		set ExCode   = model.ExCode
		Set HospID   = model.ID
		Set Code     = model.Code
		Set Desc     = model.Desc
		Set DateFrom = model.DateFrom
		Set DateTo   = model.DateTo
		Set objSYS=##class(CT.IPMR.DP.System).GetObjByExCode(ExCode)
		continue:'$IsObject(objSYS)
		Set SYSDr=objSYS.%Id()
		Set SYSExCode=objSYS.DSExCode
	
		Set IsActive=1
		Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
		Set:(DateTo'="")&(DateTo<+$h) IsActive=0
		
		Set OID = ##class(CT.IPMR.DPS.Common).GetIdString(HospID,SYSDr)
		Set ID=""
		Set objTmp=##class(CT.IPMR.DP.Hospital).GetObjByOID(OID)
		If $IsObject(objTmp){
			Set ID        = objTmp.%Id()
			Set Desc      = objTmp.DHDesc
			Set Code      = objTmp.DHCode
		}
		Set InputStr=ID
		Set InputStr=InputStr_"^"_SYSDr
		Set InputStr=InputStr_"^"_HospID
		Set InputStr=InputStr_"^"_OID
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_IsActive
		Set ret=##class(CT.IPMR.DP.Hospital).Update(InputStr,"^")
		if ret>0 {
			// 保存成功！
			Set Count = Count+1
		}else{
			d ##Class(MA.IPMR.SSService.CommonSrv).SaveErrLog("CT.IPMR.DPS.HospitalSrv","Update",InputStr)
		}
	}
	Set return = Count
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询已医院
/// Table：       CT.IPMR.DP.Hospital
/// Input：       
/// output:       医院列表
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.DPS.HospitalSrv","QryHosp")
Query QryHosp() As %Query(ROWSPEC = "ID:%String,SysCode:%String,SysDesc:%String,DicID:%String,HospID:%String,HospCode:%String,HospDesc:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryHospExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.DP.HospitalD(xID))
		Quit:xID=""
		Set obj = ##class(CT.IPMR.DP.Hospital).GetObjById(xID)
		Continue:'$isobject(obj)
		
		Set objSys = obj.DHSysDr 
		Continue:'$isobject(objSys)
		
		Set SysCode = objSys.DSSysCode
		Set SysDesc = objSys.DSSysDesc
		Set DicID = obj.DHDicID
		Set HospID = obj.DHHospID
		Set HospCode = obj.DHCode
		Set HospDesc = obj.DHDesc
		Set IsActive = obj.DHIsActive
		Set Data=$lb(xID,SysCode,SysDesc,DicID,HospID,HospCode,HospDesc,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospExecute ]
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
