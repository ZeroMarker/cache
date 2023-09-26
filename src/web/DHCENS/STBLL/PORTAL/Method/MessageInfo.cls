Class web.DHCENS.STBLL.PORTAL.Method.MessageInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—10-14
/// Description：信息
/// Table：
/// Input：admRowId:就诊RowId
/// Return：信息集合
/// Others: w ##class(web.DHCENS.STBLL.PORTAL.Method.MessageInfo).MessageInfoContent("373^1^SpecailMark^34||4")
ClassMethod MessageInfoContent(messageInfo As %String) As %GlobalCharacterStream
{
	set $zt="Exception" 
	set admRowId=$p(messageInfo,"^",1)
	set state=$p(messageInfo,"^",2)
	set type=$p(messageInfo,"^",3) 
	set infoId=$p(messageInfo,"^",4)
	set processId=$p(messageInfo,"^",5)
	set messObj=##class(web.DHCENS.STBLL.PORTAL.Model.MessageInfo).%New()
	set messObj.EpisodeID=admRowId
	set messObj.State=state
	set messObj.CreateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	set messObj.Type=type
	set messObj.PKID=infoId
	set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	set:AdmDoctorRowID'="" messObj.AttendDoc=$p($g(^CTPCP(AdmDoctorRowID,1)),"^",1)	
	set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	set:AdmDoctorRowID'="" messObj.DepID=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)	
	set CurrentWardRowID=$P($g(^PAADM(admRowId)),"^",70)
	set:CurrentWardRowID'="" messObj.WardID=$p($g(^PAWARD(CurrentWardRowID)),"^",1)	
	set dhcAdmRowId=$o(^DHCPAAdm("0","PAAdm",admRowId,""))
	if dhcAdmRowId'="" {
		set CurrentNurseRowID=$p($g(^DHCPAAdm(dhcAdmRowId)),"^",2)
		set:CurrentNurseRowID messObj.NurseCode=$p($g(^CTPCP(CurrentNurseRowID,1)),"^",1)	
	}
	
	//特殊患者消息
	if type="SpecailMarkM"{
		set mark= ##class("DHCMed.SPEService.PatientsSrv").GetNewsType(infoId)
		set messObj.AttendDoc=$p(mark,"^",1)
		set messObj.DepID=$p(mark,"^",2)
	} elseif type="UndoConsultation"{ //被邀会诊
		set mark= ##class("DtPortal.Doctor.ClinicPrompt.UndoConsultation").getConsultInfo(infoId)
		set messObj.AttendDoc=$p(mark,"^",2)
		set messObj.DepID=$p(mark,"^",1)
	} 

	b ;
	set messObj.ApplyDoc=""
	set messObj.Info=""
	set messObj.UpdateTime=""
	set messObj.ProcessID=processId
	d messObj.XMLExportToStream(.stream)
	Quit stream	
Exception
	set messObj=##class(web.DHCENS.STBLL.PORTAL.Model.MessageInfo).%New()
	d messObj.XMLExportToStream(.stream)
	Quit stream
}

}
