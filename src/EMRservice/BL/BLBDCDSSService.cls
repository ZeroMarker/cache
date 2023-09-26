/// 百度CDSS逻辑处理类
Class EMRservice.BL.BLBDCDSSService Extends %RegisteredObject
{

ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
	s resultStream = ##class(%GlobalBinaryStream).%New()
	s episodeType=##class(EMRservice.BL.BLCDSSServiceQueryGlobal).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	s type =..GetScene(AParamArray.GetAt("AEpisodeID"),"num")
	d resultStream.Write("{""success"":""1""")
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""BD""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""")
	d resultStream.Write(",""CDSSEpisodeType"":"""_type_"""}}")
	q resultStream
}

/// desc 取传给百度CDSS的JSON数据
/// input 参数拼接成字符串的形式"AEpisodeID:4,AUserID:95,ADocID:58,AInstanceID:56||4,AType:1,AAction:save"
///       AEpisodeID 就诊号
///       AUserID 登陆用户ID
///       ADocID  
///       AInstanceID 病历实例ID
///       AType  1 住院  2门诊  3住院门诊通用
///       AAction  save保存  delete删除  all(保存删除通用)
/// output  JSON数据结构
/// debug  s obj = ##class(EMRservice.BL.BLBDCDSSService).GetBDJsonData("AEpisodeID:12083201,AUserLocID:157,AHospitalID:2,AUserID:6,AInstanceID:4335327||1,ADocID:51,AAction:save,AType:2")
ClassMethod GetBDJsonData(AParamArray As %ArrayOfDataTypes)
{
	//s ^Temp("duan","GetBDJsonDataAParam")=AParam
	//定义错误处理函数
	s $ZT="ERROR"
	s resultStream = ##class(%GlobalBinaryStream).%New()
	d resultStream.Write("{""success"":0,""message"":""""}")
	q:(((AParamArray.GetAt("AEpisodeID")="")||(AParamArray.GetAt("AUserID")="")||(AParamArray.GetAt("ADocID")="")||(AParamArray.GetAt("AInstanceID")="")||(AParamArray.GetAt("AType")="")||(AParamArray.GetAt("AAction")=""))) resultStream
	//检查模板是否关联CDSS
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
	q:connectCDSS=0 resultStream
	s action = $ZCVT(AParamArray.GetAt("AAction"),"U")
	s type = AParamArray.GetAt("AType")
	s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("",type,action,AParamArray)	
	q:(stream.IsNull()=1) resultStream
	d resultStream.Clear()
	d resultStream.Write("{""success"":""1"",""message"":")
	d resultStream.CopyFrom(stream)
	d resultStream.Write("}")
	q resultStream
ERROR
	d resultStream.Clear()
	d resultStream.Write("{""success"":""0"",""message"":"""_$zerror_"""}")
	q resultStream
}

/// desc 根据患者就诊号判断患者就诊类型  返回场景值
/// debug  result=##class(EMRservice.BL.BLBDCDSSService).GetScene(AEpisodeID,"scene")
ClassMethod GetScene(AEpisodeID As %String, AParamter As %String = "")
{
	q:((AEpisodeID="")||(AParamter="")) ""
	s (result,scene,episodeType,type,num) = ""
	s episodeType = $ZCVT($p($G(^PAADM(AEpisodeID)),"^",2),"U")
	//默认住院类型
	q:episodeType="" "" 
	if (episodeType="I"){
		s scene = "入院记录"
		s type = "住院"
		s num=1
	}elseif(episodeType="O"){
		s scene = "门诊场景"
		s type = "门诊"
		s num=2
	}elseif(episodeType="E"){
		s scene = "急诊场景"
		s type = "急诊"
		s num=3
	}
	s:AParamter="scene" result=scene
	s:AParamter="type" result=type
	s:AParamter="num" result=num
	q result
}

/// desc 根据就诊号取患者年龄
/// debug result=##class(EMRservice.BL.BLBDCDSSService).GetAge(AEpisodeID)
ClassMethod GetAge(AEpisodeID As %String)
{
	s (age,ArgBirthday,AdmDate,AdmDate,Hospital)=""
	q:AEpisodeID="" age
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s Birthday=##Class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientId)
 	if Birthday'=""
 	{
   		// 出生日期内部格式 PA_Person.PAPER_Dob 
   		s ArgBirthday=Birthday
   		// 出生日期外部格式 PA_Person.PAPER_Dob
   		s Birthday=$zd(Birthday,3)
 	}
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID,Hospital)
	if AdmDateTime'="" 
	{ 
		  // 入院日期内部格式
		  s AdmDate = $P($G(AdmDateTime),",",1)
		  // 入院时间内部格式 
		  s AdmTime = $P($G(AdmDateTime),",",2)
	}
	s age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(AEpisodeID,ArgBirthday,AdmDate,1) 
	q age
}

/// Desc:       取病历章节及内容
/// Creator:    Candy
/// CreateDate: 2018-10-19
/// Input:      AEpisodeID 就诊号
///             ADocID 病历目录展现结构第三层ID
/// Output:     result 章节及内容 2223,2494,51670||7
/// Debug       d ##Class(EMRservice.BL.BLBDCDSSService).GetSectionInfo(102,1020,"61||1","2")
/// Debug  住院d ##Class(EMRservice.BL.BLBDCDSSService).GetSectionInfo(64,881,"60||9","1","messagelist")
/// debug result=##Class(EMRservice.BL.BLBDCDSSService).GetSectionInfo(AEpisodeID,ADocID,AInstanceID,AType,"messagelist")
ClassMethod GetSectionInfoEPR(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, AType As %String, AParamter As %String = "") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:((AEpisodeID="")||(ADocID="")||(AInstanceID="")||(AType="")) result
	s resultDiagnosis = ##Class(%GlobalBinaryStream).%New()
	s objInstance=""
	//s ^Temp("duan","GetSectionInfoEpr")=AEpisodeID_","_ADocID_","_AInstanceID_","_AType_","_AParamter
	s instanceIDFlag = $P(AInstanceID,"||",2)
	s:instanceIDFlag'="" objInstance=##Class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:((instanceIDFlag'="")&&(objInstance="")) result
	s recordType="SINGLE"
	if ((AInstanceID'="") && (instanceIDFlag'=""))
	{
		s recordType ="MULTI"
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_ADocID," "_objInstance.Title,""))
	}
	else
	{
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_ADocID,""))
	}
	s hdsdcode = $tr(hdsdcode," ","")
	q:hdsdcode="" result
	if (recordType="MULTI")
	{
		//可重复模板取值
		s arr = ##Class(EPRservice.BIL.BIToHIP).GetDataByGlossaryCategory(AEpisodeID,hdsdcode,AInstanceID)
	}else
	{
		//唯一模板取值
		s arr =##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(AEpisodeID,hdsdcode)
	}
	q:arr.Count()=0 result
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
				s valueI=arr.GetAt(specialCode)
				s valueI = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($ZSTRIP(valueI,"*C"))
				s:keySpecial'="" valueDesc=keySpecial_":"_valueI
				s:keySpecial="" valueDesc=valueI
				s value=value_" "_valueDesc
			}
			s key = $P(key,"^",1)
		}else{
			s value = arr.GetAt(sectionCode)
		}
		s value=$ZSTRIP(value,"*C")
		s value=##Class(EMRservice.BL.BLCDSSServiceQueryGlobal).JsonEscape(value)
		continue:(value="")
		if (diagnosisType=1){
			if (diagnosisCount=0) {
				d resultDiagnosis.Write("""诊断"":")
				d resultDiagnosis.Write("[")
			}
			d:diagnosisCount>0 resultDiagnosis.Write(",")
			s diagnosisCount=diagnosisCount+1
			d resultDiagnosis.Write("{")
			d resultDiagnosis.Write("""诊断类型"":"""_key_"""")
			d resultDiagnosis.Write(",""诊断项"":"""_value_"""")
			d resultDiagnosis.Write(",""主要诊断"":""是""")
			d resultDiagnosis.Write("}")
		}else{
			d:(result.Size > 1) result.Write(",")
			d result.Write(""""_key_""":"""_value_"""")
		}
	}
	if (diagnosisCount>0){
		d resultDiagnosis.Write("]")
		d result.Write(",")
		d result.CopyFrom(resultDiagnosis)
	}
	q result
}

/// Desc:       取病历章节及内容
/// Creator:    Candy
/// CreateDate: 2018-10-19
/// Input:      AEpisodeID 就诊号
///             ADocID 病历目录展现结构第三层ID
/// Output:     result 章节及内容 2223,2494,51670||7
/// Debug       d ##Class(EPRservice.BL.BLBaiDuCDSSCservice).GetSectionInfo(102,1020,"61||1","2")
/// Debug  住院d ##Class(EPRservice.BL.BLBaiDuCDSSCservice).GetSectionInfo(64,881,"60||9","1","messagelist")
/// debug result=##Class(EPRservice.BL.BLBaiDuCDSSCservice).GetSectionInfo(AEpisodeID,ADocID,AInstanceID,AType,"messagelist")
ClassMethod GetSectionInfoEMR(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, AType As %String, AParamter As %String = "") As %GlobalBinaryStream
{
	//s ^Temp("GetSectionInfo")=AEpisodeID_"^"_ADocID_"^"_AInstanceID_"^"_AType
	s result = ##Class(%GlobalBinaryStream).%New()
	q:((AEpisodeID="")||(ADocID="")||(AInstanceID="")||(AType="")) result
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
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,hdsdcode,AInstanceID)
	q:arr.Count()=0 result
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
		}
		elseif (ConfigSpecial="CACHE"){
			//走接口取诊断
			//b ;1
			s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagRefFormatData:DiagnosList")
	 		d rSC.Execute(AEpisodeID)
	 		s result1=""
			while rSC.Next(){
				//b ;2
		 		s value = value_" "_rSC.Data("DiagnosICDDesc")
		 		d:(resultDiagnosis.Size > 1) resultDiagnosis.Write(",")
				d resultDiagnosis.Write("{")
				d resultDiagnosis.Write("""id"":"""_rSC.Data("MRCIDRowId")_"""")
				d resultDiagnosis.Write(",""name"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(rSC.Data("DiagnosICDDesc"))_"""")
				d resultDiagnosis.Write(",""diseaseType"":"""_diagnosisType_"""")
				d resultDiagnosis.Write(",""recordTime"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(rSC.Data("DiagnosDate"))_"""")
				d resultDiagnosis.Write("}")
			}
		
		}else{
			s value = arr.GetAt(sectionCode)
		}
		s value=$ZSTRIP(value,"*C")
		s value=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
		continue:(value="")
		if (diagnosisType=1){
			if (diagnosisCount=0) {
				d resultDiagnosis.Write("""诊断"":")
				d resultDiagnosis.Write("[")
			}
			d:diagnosisCount>0 resultDiagnosis.Write(",")
			s diagnosisCount=diagnosisCount+1
			d resultDiagnosis.Write("{")
			d resultDiagnosis.Write("""诊断类型"":"""_key_"""")
			d resultDiagnosis.Write(",""诊断项"":"""_value_"""")
			d resultDiagnosis.Write(",""主要诊断"":""是""")
			d resultDiagnosis.Write("}")
		}else{
			d:(result.Size > 1) result.Write(",")
			d result.Write(""""_key_""":"""_value_"""")
		}
	}
	if (diagnosisCount>0){
		d resultDiagnosis.Write("]")
		d result.Write(",")
		d result.CopyFrom(resultDiagnosis)
	}
	q result
}

}
