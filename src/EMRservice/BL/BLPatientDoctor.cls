Class EMRservice.BL.BLPatientDoctor Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLPatientDoctor).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.PatientDoctor).%BuildIndices()
	
	s LevelCode = "intern"
	s LevelDesc = "实习医师"
	s RoleLevel = "0"
	d ..InsertRule(LevelCode, LevelDesc, RoleLevel)
	
	s LevelCode = "Resident"
	s LevelDesc = "住院医师"
	s RoleLevel = "1"
	d ..InsertRule(LevelCode, LevelDesc, RoleLevel)
	
	s LevelCode = "Attending"
	s LevelDesc = "主治医师"
	s RoleLevel = "2"
	d ..InsertRule(LevelCode, LevelDesc, RoleLevel)
	
	s LevelCode = "Chief"
	s LevelDesc = "主任医师"
	s RoleLevel = "3"
	d ..InsertRule(LevelCode, LevelDesc, RoleLevel)
}

/// Debug: d ##Class(EMRservice.BL.BLPatientDoctor).InsertRule("","","")
ClassMethod InsertRule(ALevelCode As %String, ALevelDesc As %String, ARoleLevel As %String) As %String
{
	s id=$O(^DHCEMRM.PatientDoctorI("IdxLevelCode"," "_$zcvt(ALevelCode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.PatientDoctor).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.PatientDoctor).%OpenId(id)
	}
	
	s obj.LevelCode = ALevelCode
	s obj.LevelDesc = ALevelDesc
	s obj.RoleLevel = ARoleLevel
	d obj.%Save()
}

/// Desc:       取上级医生
/// CreateDate: 2016-9-22
/// Creator:    Candy
/// Debug:      w ##Class(EMRservice.BL.BLSuperDoctor).GetDoctors(6)
ClassMethod GetDoctors(ALocID As %String) As %String
{
	s json = ""
	s count = 0
	s rowId = ""
	for
	{
		s rowId = $o(^RB("RES",0,"CTLOC",ALocID,rowId))
		q:(rowId = "")
		s userPvId = $p(^RB("RES",rowId),"^",2)
		continue:(userPvId = "")
		s carprvtpId = $p(^CTPCP(userPvId,1),"^",4)
		s usertype = $p(^CT("CPT",carprvtpId),"^",4)
		continue:(usertype '= "DOCTOR")
		s userId = $o(^SSU("SSUSR",0,"CTPCP",userPvId,""))
		continue:(userId = "")
		s userins = $p(^SSU("SSUSR",userId),"^",1)
		s userName = $p(^SSU("SSUSR",userId),"^",2)
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""userId"":"""_userId_""""
		s json = json_",""userCode"":"""_userins_""""
		s json = json_",""userName"":"""_userName_"""" 
		s json = json_"}"
		s count = count + 1
	}
	q "["_json_"]"
}

/// Desc:    查找当前设置患者医师
/// Creator: Donglulu
/// Input:   AUserID 用户ID
/// Debug:    w ##Class(EMRservice.BL.BLPatientDoctor).GetCurrentPatientDoctor(22)
ClassMethod GetCurrentPatientDoctor(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s rowId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_AEpisodeID,""))
	q:(rowId = "") result
	s practiceId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_AEpisodeID," INTERN",""))
	s residentId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_AEpisodeID," RESIDENT",""))
	s attendingId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_AEpisodeID," ATTENDING",""))
	s chiefId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_AEpisodeID," CHIEF",""))
	s json = "{"
	s json = json_"""practiceId"":"""_practiceId_""""
	s json = json_",""residentId"":"""_residentId_""""
	s json = json_",""attendingId"":"""_attendingId_""""
	s json = json_",""chiefId"":"""_chiefId_"""" 
	s json = json_"}"
	s json = $tr(json," ","")
	q "["_json_"]"
}

/// Desc:       设置患者医师
/// CreateDate: 2017-7-1
/// Creator:    Donglulu
/// Debug:   w ##Class(EMRservice.BL.BLPatientDoctor).SetPatientDoctor(22,359,6,768,128,367,359)
ClassMethod SetPatientDoctor(AEpisodeID As %String, AUserID As %String, ALocID As %String, APracticeID As %String, AResidentID As %String, AAttendingID As %String, AChiefID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AUserID = "")||(ALocID = "") result
	TStart
	s practiceFlag = ##Class(EMRservice.BL.BLPatientDoctor).UpdatePatientDoctor(AEpisodeID,AUserID,ALocID,APracticeID,"intern")
	s residentFlag = ##Class(EMRservice.BL.BLPatientDoctor).UpdatePatientDoctor(AEpisodeID,AUserID,ALocID,AResidentID,"Resident")
	s attendingFlag = ##Class(EMRservice.BL.BLPatientDoctor).UpdatePatientDoctor(AEpisodeID,AUserID,ALocID,AAttendingID,"Attending")
	s chiefFlag = ##Class(EMRservice.BL.BLPatientDoctor).UpdatePatientDoctor(AEpisodeID,AUserID,ALocID,AChiefID,"Chief")
	if ((practiceFlag = "1")&&(residentFlag = "1")&&(attendingFlag = "1")&&(chiefFlag = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
	q result
}

/// Desc:       增加或修改患者医师信息
/// CreateDate: 2019-11-29
/// Creator:    Donglulu
/// Debug:   w ##Class(EMRservice.BL.BLPatientDoctor).UpdatePatientDoctor(105,359,6,100)
ClassMethod UpdatePatientDoctor(AEpisodeID As %String, AUserID As %String, ALocID As %String, ADoctorID As %String, ALevelCode As %String) As %String
{
	s result = "1"
	q:(AEpisodeID = "")||(AUserID = "")||(ALocID = "")||(ALevelCode = "") result
	s rowId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelCode"," "_AEpisodeID," "_$zcvt(ALevelCode,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(EMRinstance.PatientDoctor).%New()
	}
	else
	{
		s obj =  ##Class(EMRinstance.PatientDoctor).%OpenId(rowId)
	}
	s obj.EpisodeID = AEpisodeID
	s obj.DoctorUserID = ADoctorID
	s obj.UserID = AUserID
	s obj.DoctorLevelCode = ALevelCode
	s obj.AppDate = $p($h,",",1)
	s obj.AppTime = $p($h,",",2)
	s obj.LocID = ALocID
	
	s sc = obj.%Save()
	s result = $case($$$ISOK(sc),1:"1",0:"0")
	q result
}

}
