Class EMRservice.BL.BLCDSSRJService Extends %RegisteredObject
{

ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
	s $ZT="ERROR"
	s resultStream = ##class(%GlobalBinaryStream).%New()	
	d resultStream.Write("{""success"":0,""message"":""锐捷初始化参数为空，检查结构化数据配置""}")
	s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	s cdssApiUrl=..GetcdssApiUrl()
	s cdssType = ##class(EMRservice.BL.BLCDSSTool).GetCDSSTool()
	s type=1
	s:(episodeType=1) type=2 
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""CDSSRJ""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""")
	d resultStream.Write(",""cdssApiUrl"":"""_cdssApiUrl_"""}}")
	q resultStream
ERROR
	d resultStream.Clear()
	d resultStream.Write("{""success"":""0"",""message"":"_$zerror_"")
	q resultStream
}

ClassMethod GetCDSSRJXmlData(AParamArray As %ArrayOfDataTypes)
{
	s resultStream = ##class(%GlobalBinaryStream).%New()
	d resultStream.Write("{""success"":0,""message"":""检查前端接口参数""}")
	q:(((AParamArray.GetAt("AEpisodeID")="")||(AParamArray.GetAt("AUserID")="")||(AParamArray.GetAt("ADocID")="")||(AParamArray.GetAt("AInstanceID")="")||(AParamArray.GetAt("AType")="")||(AParamArray.GetAt("AAction")=""))) resultStream
	//判断当前模板是否关联CDSS
	s connectCDSS=0
	s count = ##class(EMRservice.BL.BLCDSSService).GetOldRecCount(AParamArray.GetAt("AEpisodeID"))
	if (count>0){
		if (paramArray.GetAt("AInstanceID")=""){
			s ECRecordID =##Class(EMRservice.BL.BLCDSSService).GetECRecordID(AParamArray.GetAt("AEpisodeID"),paramArray.GetAt("ADocID"))	
			d AParamArray.SetAt(ECRecordID,"AInstanceID")
		}
		s connectCDSS = ##class(EMRservice.BL.BLCDSSService).isConnectCDSSEPR(AParamArray)	
	}else{
		s connectCDSS = ##class(EMRservice.BL.BLCDSSService).isConnectCDSSEMR(AParamArray)	
	}
	d resultStream.Clear()
	d resultStream.Write("{""success"":0,""message"":""检查术语集-模板相关配置""}")
	q:connectCDSS=0 resultStream
	s action = $ZCVT(AParamArray.GetAt("AAction"),"U")
	s type = $ZCVT(AParamArray.GetAt("AType"),"U")
	s stream=##class(EMRservice.BL.BLCDSSService).GetXMLDataByKey("CDSSRJ","",type,action,AParamArray)	
	q:(stream.IsNull()=1) resultStream
	d resultStream.Clear()
	d resultStream.Write("{""success"":""1"",""message"":""")
	d resultStream.CopyFrom(stream)
	d resultStream.Write("""}")
	q resultStream
}

/// desc 取睿杰服务器地址
ClassMethod GetcdssApiUrl()
{
	s $ZT="ERROR"
	s (Id,cdssApiUrl,httpUrl,CDSSObj)=""
	s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," CDSSRJ"," 1",Id))
	q:Id="" cdssApiUrl
	s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
	s:CDSSObj'="" paramter = CDSSObj.Paramter
	q:paramter="" cdssApiUrl 
	s httpUrl = $P(paramter,"^",1)
	s cdssApiUrl = "http://"_httpUrl_"/api/rule/cdssApi"
	q cdssApiUrl
ERROR
	q
}

/// desc 根据就诊号取性别
/// debug result=##class(EMRservice.BL.BLCDSSRJService).GetGender(AEpisodeID)
ClassMethod GetGender(AEpisodeID As %String)
{
	q:(AEpisodeID = "") ""
	s (gender,patientId) =""
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s:patientId'="" gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
	s:gender'="" gender = $P(gender, "^", 3)
	s:gender'="" gender = $case(gender,"男":"M","女":"F",:"未知")
	q gender
}

/// desc 取病历内容
ClassMethod GetSectionInfo(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, AType As %String, AParamter As %String = "", ACDSSTool As %String = "CDSSRJ") As %GlobalBinaryStream
{
	;b ;1
	//s ^Temp("GetSectionInfo")=AEpisodeID_"^"_ADocID_"^"_AInstanceID_"^"_AType
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "")||(ADocID = "") result
	s:(ACDSSTool="") ACDSSTool="CDSSRJ"
	s objIstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objIstance = "") ""
	if (objIstance.TitleCode '= "")&&(objIstance.TheECRecord.ChartItemType = "Multiple")
	{
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_ACDSSTool," "_ADocID," "_$zcvt(objIstance.TitleCode,"u"),""))
	}
	else
	{
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_ACDSSTool," "_ADocID,""))
	}
	s hdsdcode = $tr(hdsdcode," ","")
	q:hdsdcode="" ""
	//s arrInstanceID=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,hdsdcode)
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,hdsdcode,AInstanceID)
	/*q:arrInstanceID.Count()=0 result
	s arr = arrInstanceID.GetAt(AInstanceID)*/
	q:arr.Count()=0 ""
	s sectionRowId = ""
	s title=result=##class(EMRservice.BL.BLCDSSService).GetCDSSMessage(ADocID,AInstanceID,"title")
	d result.Write("<doc_type>"_title_"</doc_type>")
	for
	{
		s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sectionRowId))
		q:(sectionRowId = "")
		s objSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(sectionRowId)
		q:(objSection = "")
		s sectionCode = objSection.HDSDSectionCode
		s key = objSection.SectionDesc
		s sectionKeyDesc = objSection.SectionKeyDesc
		s diagnosisType = objSection.DiagnosisType
		s ConfigSpecial = $P(objSection.ConfigSpecial,"^",1)
		s CacheDiagnosisType = $P(objSection.ConfigSpecial,"^",2)
		continue:((AParamter="definitediagnosis")&&(diagnosisType=""))
		s value = arr.GetAt(sectionCode)
		s value=$ZSTRIP(value,"*C")
		s value=##Class(EMRservice.BL.BLCDSSService).XmlEscape(value)
		continue:(value="")
		d result.Write("<paragraph>")
		d result.Write("<title>"_key_"</title>")
		d result.Write("<content>"_value_"</content>")
		d result.Write("</paragraph>")
	}
	q result
}

}
