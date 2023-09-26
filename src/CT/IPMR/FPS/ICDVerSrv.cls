/// 名称: CT.IPMR.FPS.ICDVerSrv
/// 描述: ICD版本服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FPS.ICDVerSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2023-02-21
/// Description:  根据版本代码获取基础平台该版本是否同步到病案系统版本
/// Table：       
/// Input：       aVerCode：ICD版本代码
/// output:       Y/N
/// w ##class(CT.IPMR.FPS.ICDVerSrv).getICDSyncFlg("test")
ClassMethod getICDSyncFlg(aVerCode As %String) As %String
{
	New (aVerCode)
	Set return=0
	Set SyncFlg=""
	Set xID = ""
	For {
		Set xID = $o(^CT.IPMR.DP.SystemD(xID))
		Quit:xID=""
		Set objsys = ##class(CT.IPMR.DP.System).GetObjById(xID)
		Continue:'$isobject(objsys)
		Set ExCode = objsys.DSExCode
		Continue:ExCode=""
		
		Set request = ##class(MA.IPMR.IOModel.ENS.Request).Create()
		Set request.Header.SourceSystem="EM"
		Set request.Header.MessageID=""
		Set request.Body.Arguments.ExCode=ExCode
		Set request.Body.Arguments.FromVer=aVerCode
		If ExCode="localhost"{
			Set xml = ##class(MA.IPMR.IOiMedical.Srv.WebService.Server.ForMR).GetSyncICDFlg(request.ToXML())
		}else{
			//暂时只考虑localhost
			//Set xml = ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(objsys.%Id(),"SignFlg",request.ToXML())
		}
		set response=##class(MA.IPMR.IOModel.ENS.Response).CloneFromXML(xml,"Model","MA.IPMR.IOModel.SignFlg")
		set Models = response.Body.ResultStruct.Models
		while (Models.GetNext(.key))
		{
			set model = Models.GetAt(key)
			Set SyncFlg = model.Flg
		}
	}
	Set return=SyncFlg
	Quit return
}

/// Creator：     chenPJ
/// CreatDate：   2019-10-20
/// Description:  查询ICD版本
/// Table：       CT.IPMR.FP.ICDVer
/// Input：       
/// output:       ICD版本列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDVerSrv","QryICDVer")
Query QryICDVer() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ActDate:%String,EndDate:%String,Resume:%String,EditionID:%String,EditionCode:%String,EditionDesc:%String,ICDTypeID:%String,ICDTypeCode:%String,ICDTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryICDVerExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
		Set xID=$O(^CT.IPMR.FP.ICDVerD(xID))
		Quit:xID=""
		
		Set objICDVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(xID)
		Continue:'$IsObject(objICDVer)
		
		Set Code = objICDVer.FICode
		//Set Desc = objICDVer.FIDesc
		Set Desc =objICDVer.FIEdition.BDDesc_" "_objICDVer.FIICDType.BDDesc_" "_objICDVer.FIVersion
		Set ActDate = objICDVer.FIActDate
		Set ActDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(ActDate)
		Set EndDate = objICDVer.FIEndDate
		Set EndDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(EndDate)
		Set Resume = objICDVer.FIResume
		Set objEdition = objICDVer.FIEdition
		Set EditionID = objEdition.%Id()
		Set EditionCode = objEdition.BDCode
		Set EditionDesc = objEdition.BDDesc
		Set objICDType = objICDVer.FIICDType
		Set ICDTypeID = objICDType.%Id()
		Set ICDTypeCode = objICDType.BDCode
		Set ICDTypeDesc = objICDType.BDDesc
		Set Data=$lb(xID,Code,Desc,ActDate,EndDate,Resume,EditionID,EditionCode,EditionDesc,ICDTypeID,ICDTypeCode,ICDTypeDesc)
		Set arry(EditionID,ICDTypeID,xID) = Data	// 分组排序
	}
	Set xEditionID=""
	For {
		Set xEditionID = $o(arry(xEditionID))
		Quit:xEditionID=""
		Set xICDTypeID=""
		For {
			Set xICDTypeID = $o(arry(xEditionID,xICDTypeID))
			Quit:xICDTypeID=""
			Set xID = ""
			For {
				Set xID = $o(arry(xEditionID,xICDTypeID,xID))
				Quit:xID=""
				set Data = $g(arry(xEditionID,xICDTypeID,xID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryICDVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDVerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDVerExecute ]
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  导入版本
/// Table：       CT.IPMR.FPS.ICDVerSrv
/// Input：       编码库版本
/// w ##class("CT.IPMR.FPS.ICDVerSrv").ImportICDVer("")
ClassMethod ImportICDVer(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return = 0
	Quit:aInput="" return
	Set EditionDesc = $p(aInput,aSeparate,7)
	Set objEdition = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDEdition",EditionDesc)
	Quit:'$IsObject(objEdition) return
	
	Set ICDTypeDesc = $p(aInput,aSeparate,8)
	Set objICDType = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("ICDType",ICDTypeDesc)
	Quit:'$IsObject(objICDType) return
	
	Set $p(aInput,aSeparate,7)=objEdition.%Id()
	Set $p(aInput,aSeparate,8)=objICDType.%Id()
	Set return = ##class(CT.IPMR.FP.ICDVer).Update(aInput,aSeparate)
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2021-08-10
/// Description:  根据版本源查询ICD版本
/// Table：       CT.IPMR.FP.ICDVer
/// Input：       aEditionID : 版本源ID
/// output:       ICD版本列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDVerSrv","QryICDVerEdition","","375")
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDVerSrv","QryICDVerEdition","","387")
Query QryICDVerEdition(aEditionID As %String, aICDType As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ActDate:%String,EndDate:%String,Resume:%String,EditionID:%String,EditionCode:%String,EditionDesc:%String,ICDTypeID:%String,ICDTypeCode:%String,ICDTypeDesc:%String,Version:%String") [ SqlProc ]
{
}

ClassMethod QryICDVerEditionExecute(ByRef qHandle As %Binary, aEditionID As %String, aICDType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEditionID="")&&(aICDType="") $$$OK
 	Set xID=""
 	For {
		Set xID=$O(^CT.IPMR.FP.ICDVerD(xID))
		Quit:xID=""
		
		Set objICDVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(xID)
		Continue:'$IsObject(objICDVer)
		
		Set Code = objICDVer.FICode
		Set Desc = objICDVer.FIEdition.BDDesc_" "_objICDVer.FIICDType.BDDesc_" "_objICDVer.FIVersion
		Set ActDate = objICDVer.FIActDate
		Set ActDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(ActDate)
		Set EndDate = objICDVer.FIEndDate
		Set EndDate=##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(EndDate)
		Set Resume = objICDVer.FIResume
		Set Version= objICDVer.FIVersion
		Set objEdition = objICDVer.FIEdition
		Set EditionID = objEdition.%Id()
		Set EditionCode = objEdition.BDCode
		Set EditionDesc = objEdition.BDDesc
		Set objICDType = objICDVer.FIICDType
		Set ICDTypeID = objICDType.%Id()
		Set ICDTypeCode = objICDType.BDCode
		Set ICDTypeDesc = objICDType.BDDesc
		Continue:(aICDType'="")&&(aICDType'=ICDTypeID)
		Continue:(aEditionID'="")&&(aEditionID'=EditionID)
		Set Data=$lb(xID,Code,Desc,ActDate,EndDate,Resume,EditionID,EditionCode,EditionDesc,ICDTypeID,ICDTypeCode,ICDTypeDesc,Version)
		Set arry(EditionID,ICDTypeID,xID) = Data	// 分组排序
	}
	Set xEditionID=""
	For {
		Set xEditionID = $o(arry(xEditionID))
		Quit:xEditionID=""
		Set xICDTypeID=""
		For {
			Set xICDTypeID = $o(arry(xEditionID,xICDTypeID))
			Quit:xICDTypeID=""
			Set xID = ""
			For {
				Set xID = $o(arry(xEditionID,xICDTypeID,xID))
				Quit:xID=""
				set Data = $g(arry(xEditionID,xICDTypeID,xID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryICDVerEditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDVerEditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDVerEditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDVerEditionExecute ]
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
