/// desc 东华CDSS服务
/// creator duan
/// createDate 2020-06-03
Class EMRservice.BL.BLDHCDSSService Extends %RegisteredObject
{

/// desc 获取东华CDSS初始化需要的公共参数
ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
 	//定义错误处理函数
	s $ZT="ERROR"
	s resultStream = ##class(%GlobalBinaryStream).%New()	
	d resultStream.Write("{""success"":""1"",""message"":""""")
	s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	s cdssType=..GetCDSSType(AParamArray.GetAt("AEpisodeID"),"flag")
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""DH""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""")
	d resultStream.Write(",""CDSSEpisodeType"":"""_cdssType_"""}}")
	q resultStream
ERROR
	d resultStream.Clear()
	d resultStream.Write("{""success"":""0"",""message"":"_$zerror_"")
	q resultStream
}

/// desc 取结构化数据
/// input 参数拼接成字符串的形式"AEpisodeID:4,AUserID:95,ADocID:58,AInstanceID:56||4,AType:1,AAction:save"
///       AEpisodeID 就诊号
///       AUserID 登陆用户ID
///       ADocID  
///       AInstanceID 病历实例ID
///       AType  1 住院  2门诊  3住院门诊通用
///       AAction  save保存  delete删除  all(保存删除通用)
/// output  JSON数据结构
/// debug  s obj = ##class(EMRservice.BL.BLDHCDSSService).GetJsonData("AEpisodeID:9536453,AUserLocID:193,AHospitalID:1,AuserID:15117")
ClassMethod GetDHJsonData(AParamArray As %ArrayOfDataTypes)
{
	//定义错误处理函数
	s $ZT="ERROR"
	s resultStream = ##class(%GlobalBinaryStream).%New()
	d resultStream.Write("{""success"":0,""message"":""""}")
	q:(((AParamArray.GetAt("AEpisodeID")="")||(AParamArray.GetAt("AUserID")="")||(AParamArray.GetAt("ADocID")="")||(AParamArray.GetAt("AInstanceID")="")||(AParamArray.GetAt("AType")="")||(AParamArray.GetAt("AAction")=""))) resultStream
	s connectCDSS=0
	s count = ##class(EMRservice.BL.BLCDSSService).GetOldRecCount(AParamArray.GetAt("AEpisodeID"))
	//判断当前模板是否关联CDSS
	if (count>0){
		if (paramArray.GetAt("AInstanceID")=""){
			s ECRecordID =##Class(EMRservice.BL.BLCDSSService).GetECRecordID(AParamArray.GetAt("AEpisodeID"),paramArray.GetAt("ADocID"))	
			d AParamArray.SetAt(ECRecordID,"AInstanceID")
		}
		s connectCDSS = ##class(EMRservice.BL.BLCDSSService).isConnectCDSSEPR(AParamArray)	
	}else{
		s connectCDSS = ##class(EMRservice.BL.BLCDSSService).isConnectCDSSEMR(AParamArray)	
	}
	q:connectCDSS=0 resultStream
	s action = $ZCVT(AParamArray.GetAt("AAction"),"U")
	s type = $ZCVT(AParamArray.GetAt("AType"),"U")
	s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("",type,action,AParamArray)	
	q:(stream.IsNull()=1) resultStream
	d resultStream.Clear()
	d resultStream.Write("{""success"":""1"",""message"":[")
	d resultStream.CopyFrom(stream)
	d resultStream.Write("]}")
	q resultStream
ERROR
	d resultStream.Clear()
	d resultStream.Write("{""success"":""0"",""message"":"""_$zerror_"""}")
	q resultStream
}

/// desc 根据患者就诊号判断患者就诊类型 返回初始化信息 
/// debug result=##class(EMRservice.BL.BLDHCDSSService).GetCDSSType(AEpisodeID)
ClassMethod GetCDSSType(AEpisodeID As %String, AParamter As %String = "")
{
	s (result,flag,type)=""
	s episodeType = $ZCVT($p(^PAADM(AEpisodeID),"^",2),"U")
	//默认住院类型
	s:episodeType="" episodeType="I"
	if (episodeType="I"){
		s type="住院"
		s flag =1
	}elseif(episodeType="O"){
		s type="门诊"
		s flag=2
	}elseif(episodeType="E"){
		s type="急诊"	
		s flag = 3
	}
	s result=type
	s:AParamter="flag" result=flag
	q result
}

/// desc 根据患者就诊号判断患者就诊类型 返回初始化信息 
/// debug result=##class(EMRservice.BL.BLDHCDSSService).GetChildren(AEpisodeID,AInstanceID,ADocID,AAction,AType)
ClassMethod GetChildren(AEpisodeID As %String, AInstanceID As %String, ADocID As %String, AAction As %String, AType As %String)
{
	s result = ##class(%GlobalBinaryStream).%New()
	s paramArray= ##class(%ArrayOfDataTypes).%New()
	d paramArray.SetAt(AEpisodeID,"AEpisodeID")
	d paramArray.SetAt(AInstanceID,"AInstanceID")
	d paramArray.SetAt(ADocID,"ADocID")
	d paramArray.SetAt(AAction,"AAction")
	d paramArray.SetAt(AType,"AAtype")
	d result.Write("{")
	d result.Write("""DataClass"":""DHCDSSPatientMaster"",")
	d result.Write("""children"":[")
	s patientMasterStream = ##class(EMRservice.BL.BLCDSSService).GetDataByKey("master",AType,AAction,paramArray)
	d result.CopyFrom(patientMasterStream)
	d result.Write("]")
	d result.Write("}")
	d result.Write(",{")
	d result.Write("""DataClass"":""DHCDSSPatientVisit"",")
	d result.Write("""children"":[")
	s patientVisitStream = ##class(EMRservice.BL.BLCDSSService).GetDataByKey("visit",AType,AAction,paramArray)
	d result.CopyFrom(patientVisitStream)
	d result.Write("]")
	d result.Write("}")
	q result
}

/// desc 根据就诊号取性别
/// debug result=##class(EMRservice.BL.BLDHCDSSService).GetGender(AEpisodeID)
ClassMethod GetGender(AEpisodeID As %String)
{
	q:(AEpisodeID = "") ""
	s (gender,patientId) =""
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s:patientId'="" gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
	s:gender'="" gender = $P(gender, "^", 3)
	q gender
}

ClassMethod GetSectionInfo(AEpisodeID As %String, AInstanceID As %String, ADocID As %String, AAction As %String, AType As %String)
{
	s result = ##Class(%GlobalBinaryStream).%New()
	s resultDiagnosis = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "")||(ADocID = "") ""
	s objIstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objIstance = "") ""
	if (objIstance.TitleCode '= "")&&(objIstance.TheECRecord.ChartItemType = "Multiple")
	{
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_ADocID," "_$zcvt(objIstance.TitleCode,"u"),""))
	}
	else
	{
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_ADocID,""))
	}
	s hdsdcode = $tr(hdsdcode," ","")
	q:hdsdcode="" ""
	//s arrInstanceID=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,hdsdcode)
	//q:arrInstanceID="" resultStream
	//s arr = arrInstanceID.GetAt(AInstanceID)
	//q:arr="" resultStream
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,hdsdcode,AInstanceID)
	s diagnosisCount=0
	s sectionRowId = ""
	for
	{
		s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_hdsdcode,sectionRowId))
		q:(sectionRowId = "")
		s objSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(sectionRowId)
		q:(objSection = "")
		s sectionCode = objSection.HDSDSectionCode
		s key = objSection.SectionDesc
		s sectionKeyDesc = objSection.SectionKeyDesc
		s diagnosisType = objSection.DiagnosisType
		s ConfigSpecial = objSection.ConfigSpecial
		s value=""
		//诊断类型变更
		if (ConfigSpecial = "CONNECT"){
			//多个单元数据拼在一起
			s len = $L(sectionCode,"^")
			s kenLen =$L(key,"^")
			f i=1:1:len
			{
				s keySpecial=""
				s:kenLen>1 keySpecial = $P(key,"^",(i+1))
				s specialCode = $P(sectionCode,"^",i)
				//s valueI=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,sectionCode,AInstanceID)
				s valueI=$ZSTRIP(arr.GetAt(specialCode),"*C")
				s:keySpecial'="" valueDesc=keySpecial_":"_valueI
				s:keySpecial="" valueDesc=valueI
				s value=value_" "_valueDesc
			}
			s key = $P(key,"^",1)
		
		}else{
			s value = arr.GetAt(sectionCode)
		}
		s value=$ZSTRIP(value,"*C")
		s value=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
		continue:(value="")
		d:(result.Size > 1) result.Write(",")
		d result.Write(""""_sectionKeyDesc_""":"""_value_"""")
	
	}
	q result
}

}
