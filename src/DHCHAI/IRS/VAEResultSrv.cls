/// 名称: DHCHAI.IRS.VAEResultSrv
/// 描述: VAE统计相关服务
/// 编写者: zhoubo
/// 编写日期: 2022-05-07
Class DHCHAI.IRS.VAEResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-05-07
/// Description:  VAE感染病例统计
/// Table：       DHCHAI.IR.VAEResult
/// Input:        aHospIDs   : 多个医院用"|"连接
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aLocID     : 护理单元
///               aVAItmCode : VAE类型
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.VAEResultSrv","QryVAEInfDist","1|3|4","2018-10-02","2022-07-20","","")
Query QryVAEInfDist(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aVAItmCode As %String = "") As %Query(ROWSPEC = "RstID:%String,LocID:%String,LocDesc:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,DischDate:%String,VAItmCode:%String,VAItmDesc:%String,VAEDate:%String,MonitVAEDate:%String,VAEType:%String,ActStatus:%String,ActStatusDesc:%String,SItmDescs:%String,ExclReason:%String,VAEActDate:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVAEInfDistExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aVAItmCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QryVAEInfDist"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.IR.VAEResultI("IndexMonitVAEDate",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexMonitVAEDate",xDate,xRstID))
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			
			Continue:'$IsObject(objRst.EpisodeDr)
			Set EpisodeID = objRst.EpisodeDr.%Id()
			Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeID))
			Continue:PAAdmData=""
			Set LocID=$li(PAAdmData,23)
			Continue:LocID=""
			Continue:(aLocID'="")&&(aLocID'=LocID)
			Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
			Continue:(AdmLocData="")
			Set LocDesc=$li(AdmLocData,3)
			Set LocDesc2=$li(AdmLocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			
			Set HospID=$li(AdmLocData,8)
			Continue:HospID=""
			Set HospData = $g(^DHCHAI.BT.HospitalD(HospID))
			Set HospDesc=$li(HospData,3)
			Set HospDesc2=$li(HospData,4)
			Set:HospDesc2'="" HospDesc=HospDesc2
			Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1)	
			Set VAEDate      = objRst.VAEDate
			Set MonitVAEDate = objRst.MonitVAEDate
			Set VAEType      = objRst.VAEType
			Set ActStatus    = objRst.ActStatus  //处置状态 1：确诊 2：排除
			Continue:ActStatus'=1
			Set ActStatusDesc= $s(ActStatus=1:"确诊",ActStatus=1:"排除",1:"")
			
			//获取触发项目 多值#分割--DHCHAI.IR.VAESubItem
			Set VAEItemIDs = objRst.VAEItemIDs
			Set SItmDescs=""
			For xSubInd=1:1:$l(VAEItemIDs,"#"){
				Set xSubID=$p(VAEItemIDs,"#",xSubInd)
				Continue:xSubID=""
				Set objSub=##class(DHCHAI.IR.VAESubItem).GetObjById(xSubID)
				Set VASItmDesc = objSub.VASItmDesc  // 项目名称
				Set SItmDescs=SItmDescs_"，"_VASItmDesc
			}
			Set:SItmDescs'="" SItmDescs=$e(SItmDescs,2,$l(SItmDescs))
			Set ExclReason   = objRst.ExclReason
			Set VAEActDate   = objRst.VAEActDate
			Set VAEActUserDr = objRst.VAEActUserDr
			Set ActUser="",ActUserDesc=""
			If $IsObject(VAEActUserDr) {
				Set ActUser     = VAEActUserDr.BTCode
				Set ActUserDesc = VAEActUserDr.BTDesc
			}
			
			Set VAEMonitItemDr = objRst.VAEMonitItemDr
			Set VAItmCode="",VAItmDesc=""
			If $IsObject(VAEMonitItemDr) {
				Set VAItmCode = VAEMonitItemDr.VAItmCode
				Set VAItmDesc = VAEMonitItemDr.VAItmDesc
			}
			Continue:(aVAItmCode'="")&&(aVAItmCode'=VAItmCode)
			Set:VAEType="" VAEType=VAItmCode
			Set:MonitVAEDate="" MonitVAEDate=VAEDate
			Set:MonitVAEDate'="" MonitVAEDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitVAEDate)
			Set:VAEDate'="" VAEDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAEDate)
			Set:VAEActDate'="" VAEActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAEActDate)
			
			
			Set PapmiNo=$li(PAAdmData,4)     //登记号
			Set MrNo=$li(PAAdmData,5)        //病案号
			Set PatName=$li(PAAdmData,6)     //姓名
			Set Sex=$li(PAAdmData,7)             //性别
			Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
			Set Birthday=$li(PAAdmData,9)   //出生日期
			Set Age=$li(PAAdmData,37)             //年龄
			Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
			Set AdmDate=$li(PAAdmData,20)     //就诊日期
			Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
			Set AdmTime=$li(PAAdmData,21)     //就诊时间
			Set:AdmTime'="" AdmTime=$zt(AdmTime)
			Set DischDate=$li(PAAdmData,26) //出院日期
			Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set OutHospDate = ""
			If DischDate'=""{
				Set OutHospDate = DischDate
			}
			Set DischTime=$li(PAAdmData,27) //出院时间
			Set:DischTime'="" DischTime=$zt(DischTime)
	
			Set Data=$lb(xRstID,LocID,LocDesc,PapmiNo,PatName,Sex,Age,AdmDate,DischDate,VAItmCode,VAItmDesc,VAEDate,MonitVAEDate,VAEType,ActStatus,ActStatusDesc,SItmDescs,ExclReason,VAEActDate,ActUserDesc)
		
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
	   	}
	}
   	Quit $$$OK
}

ClassMethod QryVAEInfDistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVAEInfDistExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVAEInfDistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVAEInfDistExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
