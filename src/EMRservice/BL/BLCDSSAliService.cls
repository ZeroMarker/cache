Class EMRservice.BL.BLCDSSAliService Extends %RegisteredObject
{

/// Desc: 取病历章节及内容
/// Creator: Candy
/// CreateDate: 2018-10-19
/// Input: argEpisodeID 就诊号
///             argDocID 病历目录展现结构第三层ID
/// Output: result 章节及内容 2223,2494,51670||7
/// Debug d ##Class(EMRservice.BL.BLCDSSAliService).GetSectionInfo(12152463,153,"321||1","2")
/// Debug 男 住院s obj = ##Class(EMRservice.BL.BLCDSSAliService).GetSectionInfo(7705387,879,"11429704||2","inhos","4133")
/// Debug 女 住院s obj = ##Class(EMRservice.BL.BLCDSSAliService).GetSectionInfo(4428027,879,"9976846||1","inhos","4133")
/// Debug 日常病程记录s obj = ##Class(EMRservice.BL.BLCDSSAliService).GetSectionInfo(4428027,881,"6011231||2","inhos","4133")
ClassMethod GetSectionInfo(argEpisodeID As %String, argDocID As %String, argInstanceID As %String, Atype As %String, userID As %String) As %GlobalBinaryStream
{
	//s ^Temp("GetSectionInfo")=argEpisodeID_"^"_argDocID_"^"_argInstanceID_"^"_userID
	s result = ##Class(%GlobalBinaryStream).%New()
	s diagnosisStream = ##Class(%GlobalBinaryStream).%New()
	d result.Write("{}")
	q:(argEpisodeID = "")||(argDocID = "") result
	s objIstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objIstance = "") result
	if (objIstance.TitleCode '= "")&&(objIstance.TheECRecord.ChartItemType = "Multiple")
	{
		s hdsdcode = $o(^DHCEMRM.AliHDSDLinkEMRDocI("IdxEMRDocCode"," "_argDocID," "_$zcvt(objIstance.TitleCode,"u"),""))
	}
	else
	{
		s hdsdcode = $o(^DHCEMRM.AliHDSDLinkEMRDocI("IdxEMRDocHDSD"," "_argDocID,""))
	}
	s hdsdcode = $tr(hdsdcode," ","")
	q:hdsdcode="" result
	s Atype=$zcvt(Atype,"U")
	d result.Clear()
	d result.Write("[")
	d result.Write("{")
	s sectionRowId = ""
	S count = 0
	s diagnosisCount=0
	s emrDocCount=0
	s recordTime = $H
	s recordTime = $ZDateTime(recordTime,3)
	s progressContent=""
	s progressType = ..GetCDSSCode(argDocID,argInstanceID)
	if (Atype = "INHOS"){
		if (progressType="1"){
			s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
			s admDateTime = $ZDateTime(admDateTime,3)
			s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
			s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
			s gender = $P(gender, "^", 3)
			s gender = $case(gender,"男":1,"女":0,:"")
		
			d result.Write("""inHosRecord"":{")
			d result.Write("""progressId"":"""_argInstanceID_"""")
			d result.Write(",""inhosDate"":"""_admDateTime_"""")
			d result.Write(",""gender"":"""_gender_"""")
			d result.Write(",""recordTime"":"""_recordTime_"""")
				
		}else{
			d result.Write("""progressList"":[{")
			d result.Write("""progressId"":"""_argInstanceID_"""")
			d result.Write(",""progressType"":"""_progressType_"""")
			d result.Write(",""recordTime"":"""_recordTime_"""")
			d result.Write(",""docotorId"":"""_userID_"""")
			d result.Write(",""progressContent"":""<EMRDoc>")
		}
	}
		
	for
	{
		s sectionRowId = $o(^DHCEMRM.AliHDSDSectionI("IdxHDSD"," "_hdsdcode,sectionRowId))
		q:(sectionRowId = "")
		s objSection = ##Class(EMRmeta.CDSS.AliHDSDSection).%OpenId(sectionRowId)
		q:(objSection = "")
		s sectionCode = objSection.HDSDSectionCode
		s key = objSection.SectionDesc
		s sectionKeyDesc = objSection.SectionKeyDesc
		s ConfigSpecial = objSection.ConfigSpecial
		s diagnosisType = objSection.DiagnosisType
		s value=##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryAndInstanceIdNew(argEpisodeID,sectionCode,argInstanceID)
		s value = $ZSTRIP(value,"*C")
		continue:(value="")
		//门诊传参
		if (Atype = "OUTHOS"){
			d:count>0 result.Write(",")
			d result.Write(""""_sectionKeyDesc_""":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)_"""")
			s count=count+1
		}else{
			//诊断
			if (diagnosisType'=""){
				d:diagnosisCount=0 diagnosisStream.Write(",""diagnosisList"":[{")
				d:diagnosisCount>0 diagnosisStream.Write(",")
				d diagnosisStream.Write("""diagName"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)_"""")
				d diagnosisStream.Write(",""diagType"":"""_diagnosisType_"""")
				d diagnosisStream.Write(",""recordTime"":"""_recordTime_"""")
				d diagnosisStream.Write("}")
				s diagnosisCount = diagnosisCount+1
			}
			if (progressType="1")	
			{
				d result.Write(",")
				d result.Write(""""_sectionKeyDesc_""":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)_"""")
				s count=count+1	
			}else{
				s item=""
				s:emrDocCount>0 item=","
				s item =item_"<"_key_">"_value_"</"_key_">"
				d result.Write(item)
			}

		}
	
	}
	d:((Atype="INHOS")&(progressType=1)) result.Write("}")
	d:((Atype="INHOS")&(progressType'=1)) result.Write("</RMRDoc>""}]")
	d:(diagnosisCount>0) diagnosisStream.Write("]")
	d:(diagnosisCount>0) result.CopyFrom(diagnosisStream)
	d result.Write("}")
	d result.Write("]")
	/*s stream = ##class(%FileBinaryStream).%New()
	s stream.Filename="d:\11.xml"
	d stream.CopyFrom(result)
	d stream.SaveStream()
	d stream.%Close()*/
	q result
}

/// Desc: 取病历文书与CDSS系统的对照ID
/// Creator: Candy
/// CreateDate: 2018-10-19
/// Input: argDocID argDocID 病历目录展现结构第三层ID
/// Output: CDSS对应文档代码
/// Debug: w ##Class(EMRservice.BL.BLCDSSService).GetCDSSCode(88,"10799||1")
ClassMethod GetCDSSCode(argDocID As %String, argInstanceID As %String) As %String
{
	s result = ""
	q:(argDocID = "")||(argInstanceID = "") result
	s objIstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objIstance = "") result
	if (objIstance.TitleCode '= "")&&(objIstance.TheECRecord.ChartItemType = "Multiple")
	{
		s hdsdcode = $o(^DHCEMRM.AliHDSDLinkEMRDocI("IdxEMRDocCode"," "_argDocID," "_$zcvt(objIstance.TitleCode,"u"),""))
	}
	else
	{
		s hdsdcode = $o(^DHCEMRM.AliHDSDLinkEMRDocI("IdxEMRDocHDSD"," "_argDocID,""))
	}	
	s hdsdcode = $tr(hdsdcode," ","")
	q:(hdsdcode = "") result
	s cdssCode = $o(^DHCEMRM.AliHDSDLinkCDSSI("IdxHDSDCDSSCode"," "_hdsdcode,""))
	s result = $tr(cdssCode," ","")
	q result
}

/// debug w ##class(EMRservice.BL.BLCDSSAliService).GetPatientInfo(793)
ClassMethod GetPatientInfo(argEpisodeID As %String)
{
	//s ^Temp("GetPatientInfo")=argEpisodeID
	s result = ""
	q:(argEpisodeID = "") result
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
	s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)
	s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
	s gender = $P(gender, "^", 3)
	s genderType = $case(gender,"男":1,"女":2,:0)
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
	//s age = ##Class(web.YGRHCommon).GetAgeDaysByEpisodeID(argEpisodeID)
	s admDate = $p(admDateTime,",",1)
	s admTime = $p(admDateTime,",",2)
	s birthDay = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientId)
	s age= ##Class(EMRservice.HISInterface.PatientInfoAssist).Age(patientId,argEpisodeID,admDate,admTime)
	s admDateTime = $ZDateTime(admDateTime,3)
	s:birthDay'="" birthDay=$ZDateTime(birthDay,3)
    s ageType = "年"	
	s result = "{"
	s result = result_"""name"":"""_name_"""" 
	s result = result_",""genderType"":"""_genderType_""""
	s result = result_",""gender"":"""_gender_""""
	s result = result_",""age"":"""_age_"""" 
	s result = result_",""ageType"":"""_ageType_"""" 
	s result = result_",""birthday"":"""_birthDay_""""
	s result = result_"}"
	q result
}

}
