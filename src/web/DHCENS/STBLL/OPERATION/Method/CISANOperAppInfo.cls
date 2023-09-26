Class web.DHCENS.STBLL.OPERATION.Method.CISANOperAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020—02-19
/// Description:手术申请信息(对应临床组新版)
/// Table：CIS_AN.OperSchedule
/// Input：手术申请ID
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.CISANOperAppInfo).SendOperApp("183").Read()
ClassMethod SendOperApp(opRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	if opRowId=""{
		set stream=##class(%GlobalCharacterStream).%New()
		d stream.Write("手术申请ID不能为空")
		Quit stream
	}
	set request=##class(web.DHCENS.STBLL.OPERATION.Model.Request).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.OPERATION.Model.Body).%New()
	set opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_opRowId,""))
	set obj= ##class(CIS.AN.SRV.OperService).GetOperInfoByID(opsId)
	
	set OperApps=##class(web.DHCENS.STBLL.OPERATION.Model.OperAppInfo).%New()
	set OperApps.PATPatientID = obj.RegNo
	set admRowid=obj.EpisodeID
	set OperApps.PAADMVisitNumber=admRowid
	set OperApps.SCHEDULEID=opRowId
	set LocDr=obj.PatDeptID //rowid
	set OperApps.DEPTSTAYED=$p($g(^CTLOC(LocDr)),"^",1)
	set OperApps.BEDNO=obj.PatBedCode
	set OperApps.SCHEDULEDDATETIME=obj.AppDateTime
	set OperApps.SEQUENCE=obj.OperSeq
	set OperApps.OPERATINGROOMNO=obj.OperRoom
	set OpaEmergencyFlage=obj.SourceType
	set OperApps.EMERGENCYINDICATOR=$case(OpaEmergencyFlage,"B":"0","E":"1",:"0")
	set OperRoomLoc=obj.OperDeptID
	set:OperRoomLoc'="" OperApps.OPERATINGROOM=$p($g(^CTLOC(OperRoomLoc)),"^",1)
	set OperApps.DIAGBEFOREOPERATION=obj.PrevDiagnosis
	;set opaId=##class(CIS.AN.SRV.OperService).GetOpaIdByOrd(opRowId)
	&SQL(select ExternalID into :opaId from CIS_AN.OperSchedule where RowId=:opsId)
	set objList=##class(CIS.AN.SRV.OperService).GetSurgeryInfoList(opaId)
	set count=objList.Count()
	for i=1:1:count
	{
		set OperationDetailObj=##class(web.DHCENS.STBLL.OPERATION.Model.OperDetail).%New()
		set objSurgery=objList.GetAt(i)
		set OperDesc=objSurgery.OperDesc
		set OperationDetailObj.OPERATIONCODE=..GetOperationCodeByDesc(OperDesc)	
		set OperationDetailObj.OPERATION=OperDesc
		set OperationDetailObj.OPERATIONNO=i
		set OperationDetailObj.OPERATIONSCALE=objSurgery.OperClass
		set OperationDetailObj.OPERATIONPositionCode=objSurgery.BodySite
		set OperationDetailObj.OPERATIONCutType=objSurgery.BladeType
		do OperApps.OPERATIONS.Insert(OperationDetailObj)
	}
	b ;apps
	set OperApps.PATIENTCONDITION=obj.SpecialCondition
	set OperApps.ISOLATIONINDICATOR=obj.IsoOperation
	set OperApps.SURGEON=..GetDocCodeByDesc(obj.SurgeonDesc)
	set OperApps.OPERATINGDEPT=..GetLocCodeByUserDesc(obj.SurgeonDesc)
	set OperApps.ANESTHESIAMETHOD=obj.AnaMethod
	set OperApps.ANESTHESIADOCTOR=obj.Anesthesiologist
	set OperApps.FIRSTASSISTANT=""
	set OperApps.SECONDASSISTANT=""
	set OperApps.THIRDASSISTANT=""
	set OperApps.FOURTHASSISTANT=""
	set OperApps.SECONDANESTHESIADOCTOR=""
	set OperApps.THIRDANESTHESIADOCTOR=""
	set OperApps.ANESTHESIAASSISTANT=..GetDocCodeByDesc(obj.AnaAssistantDesc)
	set OperApps.BLOODTRANDOCTOR="" ;输血医生
	set OperApps.FIRSTOPERATIONNURSE=..GetDocCodeByDesc(obj.FirstCircualNurseDesc)
	set OperApps.SECONDOPERATIONNURSE=..GetDocCodeByDesc(obj.SecCircualNurseDesc)
	set OperApps.FIRSTSUPPLYNURSE=..GetDocCodeByDesc(obj.FirstScrubNurseDesc)
	set OperApps.SECONDSUPPLYNURSE=..GetDocCodeByDesc(obj.SecScrubNurseDesc)
	set OperApps.THIRDSUPPLYNURSE=""
	set OperApps.NOTESONOPERATION=obj.OperNote
	set OperApps.REQDATETIME=obj.AppDateTime
	set OperApps.ENTEREDBY="" 
	set OperApps.STATUS=obj.Status
	set OperApps.AdmTypeCode=obj.AdmReason
	set AdmTypeCode=$p($g(^PAADM(admRowid)),"^",2)
	set OperApps.AdmTypeCode=AdmTypeCode
	set OperApps.AdmTypeDesc=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	set AdmStatusCode=$p($g(^PAADM(admRowid)),"^",20)
	set:AdmStatusCode'="" OperApps.AdmStatusCode=AdmStatusCode
	set:AdmStatusCode'="" OperApps.AdmStatusDesc=$case(AdmStatusCode,"A":"在就诊","C":"取消就诊","D":"出院","P":"预约")

	set body.OperApps=OperApps
	
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
	
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// 通过就诊rowid得到病人Rowid^登记号^就诊号
ClassMethod GetPatNoByAdmID(adm As %String) As %String
{
	q:adm="" ""
	s RegisterNo=""
	s patId=$p(^PAADM(adm),"^",1)
	s RegisterNo=$p($g(^PAPER(patId,"PAT",1)),"^",1)
	s Ret=patId_"^"_RegisterNo_"^"_adm
	q Ret
}

/// 通过就诊rowid得到病人就诊信息
ClassMethod GetAdmInfoByRowid(adm As %String) As %String
{
	q:adm="" ""
	s AdmDeptCode=""
	s AdmDetpRowID=$P($g(^PAADM(adm)),"^",4)
	s:AdmDetpRowID'="" AdmDeptCode=$p($g(^CTLOC(AdmDetpRowID)),"^",1)
	
	s CurrentBedNo=""
	s CurrentBedRowID=$P($g(^PAADM(adm)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			s CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	q AdmDeptCode_"^"_CurrentBedNo
}

/// 通过姓名获取工号
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.CISANOperAppInfo).GetDocCodeByDesc("")
ClassMethod GetDocCodeByDesc(Desc As %String) As %String
{
	q:Desc="" ""
	s UserID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Desc),""))
	q:UserID="" ""
	s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	q UserCode
}

/// 通过姓名获取实施手术的医生所在的科室代码
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.CISANOperAppInfo).GetLocCodeByUserDesc("")
ClassMethod GetLocCodeByUserDesc(Desc As %String) As %String
{
	q:Desc="" ""
	s UserID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Desc),""))
	q:UserID="" ""
	s DeptRowid=$p($g(^SSU("SSUSR",UserID)),"^",4)
	s:DeptRowid'="" DeptCode=$p(^CTLOC(DeptRowid),"^",1)
	q DeptCode
}

ClassMethod GetOperationCodeByDesc(Desc As %String) As %String
{
	q:Desc="" ""
	s ICD=""
	&SQL(select Code into :ICD from CT_AN.Operation where Description=:Desc)
	q ICD
}

}
