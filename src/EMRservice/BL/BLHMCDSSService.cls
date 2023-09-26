/// 惠每CDSS逻辑处理类
/// creator duan
/// createDate 2020-06-03
Class EMRservice.BL.BLHMCDSSService Extends %RegisteredObject
{

/// desc 获取惠每初始化数据和需要的公共参数
/// input "AEpisodeID:4,AUserLocID:,AHospitalID:,AUserID:"
/// debug s obj = ##class(EMRservice.BL.BLHMCDSSService).GetInitData("AEpisodeID:4,AUserLocID:23,AHospitalID:2,AUserID:20")
ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
 	//定义错误处理函数
	s $ZT="ERROR"
	s resultStream = ##class(%GlobalBinaryStream).%New()
	s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("init","3","all",AParamArray)
	q:(stream.IsNull()=1) resultStream	
	d resultStream.Write("{""success"":""1"",""message"":")
	d resultStream.CopyFrom(stream)
	s cdssHMUrl = ..GetJSDKUrl()
	s loadType = ..GetLoadType()
	s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	s type=..GetFlagAndCustomEnv(AParamArray.GetAt("AEpisodeID"),"customenv")
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""HM""")
	d resultStream.Write(",""loadType"":"""_loadType_"""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""")
	d resultStream.Write(",""cdssHMUrl"":"""_##class(EMRservice.BL.BLCDSSService).JsonEscape(cdssHMUrl)_"""")
	d resultStream.Write(",""CDSSEpisodeType"":"""_type_"""}}")
	q resultStream
ERROR
	d resultStream.Clear()
	d resultStream.Write("{""success"":""0"",""message"":"_$zerror_"")
	q resultStream
}

/// desc 取传给惠每JSON数据
/// input 参数拼接成字符串的形式"AEpisodeID:4,AUserID:95,ADocID:58,AInstanceID:56||4,AType:1,AAction:save"
///       AEpisodeID 就诊号
///       AUserID 登陆用户ID
///       ADocID  
///       AInstanceID 病历实例ID
///       AType  1 住院  2门诊  3住院门诊通用
///       AAction  save保存  delete删除  all(保存删除通用)
/// output  JSON数据结构
/// debug  s obj = ##class(EMRservice.BL.BLHMCDSSService).GetHMJsonData("AEpisodeID:4,AUserID:95,ADocID:58,AInstanceID:56||4,AType:1,AAction:save")
ClassMethod GetHMJsonData(AParamArray As %ArrayOfDataTypes)
{
	//定义错误处理函数
	s resultStream = ##class(%GlobalBinaryStream).%New()
	d resultStream.Write("{""success"":0,""message"":""""}")
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
	q:connectCDSS=0 resultStream
	s action = $ZCVT(AParamArray.GetAt("AAction"),"U")
	s type = $ZCVT(AParamArray.GetAt("AType"),"U")
	s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("",type,action,AParamArray)	
	q:(stream.IsNull()=1) resultStream
	d resultStream.Clear()
	d resultStream.Write("{""success"":""1"",""message"":")
	d resultStream.CopyFrom(stream)
	d resultStream.Write("}")
	q resultStream
}

/// desc 根据患者就诊号判断患者就诊类型 返回初始化信息 
/// debug result=##class(EMRservice.BL.BLHMCDSSService).GetFlagAndCustomEnv(AEpisodeID,"flag")
ClassMethod GetFlagAndCustomEnv(AEpisodeID As %String, AParamter As %String = "")
{
	q:((AEpisodeID="")||(AParamter="")) ""
	s (result,flag,customEnv)=""
	s episodeType = $ZCVT($p($G(^PAADM(AEpisodeID)),"^",2),"U")
	//默认住院类型
	q:episodeType="" result
	if (episodeType="I"){
		s flag = "m"
		s customEnv=1
	}elseif(episodeType="O"){
		s flag = "c"
		s customEnv=2
	}elseif(episodeType="E"){
		s flag = "c"
		s customEnv=3	
	}
	s:AParamter="flag" result=flag
	s:AParamter="customenv" result=customEnv
	q result
}

/// desc 根据就诊号取患者入院时间
/// debug result=##class(EMRservice.BL.BLHMCDSSService).GetAdmDateTime(AEpisodeID)
ClassMethod GetAdmDateTime(AEpisodeID As %String)
{
	q:(AEpisodeID="") ""
	//入院时间
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
	s:admDateTime'="" admDateTime = $ZDateTime(admDateTime,3)
	q admDateTime
}

/// desc 根据就诊号取性别
/// debug result=##class(EMRservice.BL.BLHMCDSSService).GetGender(AEpisodeID)
ClassMethod GetGender(AEpisodeID As %String)
{
	q:(AEpisodeID = "") ""
	s (gender,patientId) =""
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s:patientId'="" gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
	s:gender'="" gender = $P(gender, "^", 3)
	s:gender'="" gender = $case(gender,"男":1,"女":0,:2)
	q gender
}

/// desc 根据就诊号取患者年龄
/// debug result=##class(EMRservice.BL.BLHMCDSSService).GetAge(AEpisodeID)
ClassMethod GetAge(AEpisodeID As %String)
{
	s age=""
	q:AEpisodeID="" age
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
		//s age = ##Class(web.YGRHCommon).GetAgeDaysByEpisodeID(AEpisodeID)
	s admDate = $P(admDateTime,",",1)
	s admTime = $P(admDateTime,",",2)
	s age= ##Class(EMRservice.HISInterface.PatientInfoAssist).Age(patientId,AEpisodeID,admDate,admTime)
	s:age'="" age=$Replace(age,"岁","")
	q age
}

/// Desc:       取病历章节及内容
/// Creator:    Candy
/// CreateDate: 2018-10-19
/// Input:      AEpisodeID 就诊号
///             ADocID 病历目录展现结构第三层ID
/// Output:     result 章节及内容 2223,2494,51670||7
/// Debug       d ##Class(EMRservice.BL.BLHMCDSSService).GetSectionInfo(102,1020,"61||1","2")
/// Debug  住院d ##Class(EMRservice.BL.BLHMCDSSService).GetSectionInfo(64,881,"60||9","1","messagelist")
/// debug result=##Class(EMRservice.BL.BLHMCDSSService).GetSectionInfo(AEpisodeID,ADocID,AInstanceID,AType,"messagelist")
ClassMethod GetSectionInfo(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, AType As %String, AParamter As %String = "") As %GlobalBinaryStream
{
	;b ;1
	//s ^Temp("GetSectionInfo")=AEpisodeID_"^"_ADocID_"^"_AInstanceID_"^"_AType
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
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,hdsdcode,AInstanceID)
	/*q:arrInstanceID.Count()=0 result
	s arr = arrInstanceID.GetAt(AInstanceID)*/
	q:arr.Count()=0 result
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
		s ConfigSpecial = $P(objSection.ConfigSpecial,"^",1)
		s CacheDiagnosisType = $P(objSection.ConfigSpecial,"^",2)
		continue:((AParamter="definitediagnosis")&&(diagnosisType=""))
		s value=""
		//诊断类型变更
		//吉大三院  可以在签名单元中修改类型
		if ((ConfigSpecial = "Y")&&(diagnosisType'="")){
			s diagnosisTypeCode = $P(sectionCode,"^",2)
			s diagnosisValueCode = $P(sectionCode,"^",1)
			s diagnosisTypeValue = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,diagnosisTypeCode,AInstanceID)
			s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,diagnosisValueCode,AInstanceID)
			s diagnosis = $extract(diagnosisTypeValue,1,4)
			if (key '= diagnosis)&(diagnosisTypeValue '= ""){
				s diagnosisType=$case(diagnosis,"入院诊断":"1","初步诊断":"5","确定诊断":"6","补充诊断":"7","更正诊断":"8","出院诊断":"9","死亡诊断":"10","留观诊断":"11",:0)
				s:diagnosisType'=0 key = diagnosis 
			}
		
		}elseif (ConfigSpecial = "CONNECT"){
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
			s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagnos:GetMRDiagnosList")
	 		d rSC.Execute(AEpisodeID,"")
	 		s result1=""
			while rSC.Next(){
				//b ;2
				continue:((CacheDiagnosisType'="")&&'(CacheDiagnosisType[rSC.Data("ADiagnosType")))
		 		s value = value_" "_rSC.Data("ADiagnosName")
		 		d:(resultDiagnosis.Size > 1) resultDiagnosis.Write(",")
				d resultDiagnosis.Write("{")
				d resultDiagnosis.Write("""id"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(rSC.Data("ARowID"))_"""")
				d resultDiagnosis.Write(",""name"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(rSC.Data("ADiagnosName"))_"""")
				d resultDiagnosis.Write(",""diseaseType"":"""_diagnosisType_"""")
				d resultDiagnosis.Write(",""recordTime"":"""_rSC.Data("ADateTime")_"""")
				d resultDiagnosis.Write("}")
			}
		}elseif (ConfigSpecial="CACHEOUT"){
			s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagnos:GetMRDiagnosList")
	 		d rSC.Execute(AEpisodeID,"")
	 		s diagCount=0
			while rSC.Next(){
				continue:((CacheDiagnosisType'="")&&'(CacheDiagnosisType[rSC.Data("ADiagnosType")))
				d:(resultDiagnosis.Size =0) resultDiagnosis.Write("[")
				d:(resultDiagnosis.Size > 1) resultDiagnosis.Write(",")
				d resultDiagnosis.Write("{")
				d resultDiagnosis.Write("""kicdCodeey"":"""_rSC.Data("AICDCode")_"""")
				d resultDiagnosis.Write(",""key"":"""_rSC.Data("ADiagnosTypeID")_"""")
				d resultDiagnosis.Write(",""value"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(rSC.Data("ADiagnosName"))_"""")
				d resultDiagnosis.Write("}")	
			}
			d:(resultDiagnosis.Size > 1) resultDiagnosis.Write("]")
			d:(result.Size > 1) result.Write(",")
			d result.Write(""""_sectionKeyDesc_""":")
			d result.CopyFrom(resultDiagnosis)
		}else{
			//s value=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,sectionCode,AInstanceID)
			s value = arr.GetAt(sectionCode)
		}
		s value=$ZSTRIP(value,"*C")
		s value=##Class(EMRservice.BL.BLCDSSService).JsonEscape(value)
		continue:(value="")
		if (AType="2"){
			//门诊 章节关联关键字
			s key = sectionKeyDesc
			continue:key=""
			//门诊诊断处理
			if (((ConfigSpecial="OUT")&&(diagnosisType'=""))){
				d resultDiagnosis.Write("[{")
				d resultDiagnosis.Write("""kicdCodeey"":"""_""_"""")
				d resultDiagnosis.Write(",""key"":"""_""_"""")
				d resultDiagnosis.Write(",""value"":"""_value_"""")
				d resultDiagnosis.Write("}]")
				d:(result.Size > 1) result.Write(",")
				d result.Write(""""_key_""":""")
				d result.CopyFrom(resultDiagnosis)	
			}else{
				d:(result.Size > 1) result.Write(",")
				d result.Write(""""_key_""":"""_value_"""")
			}
			
		}else{
			//其他参数
			d:(result.Size > 1) result.Write(",")
			d result.Write("{")
			d result.Write("""key"":"""_key_"""")
			d result.Write(",""value"":"""_value_"""")
			d result.Write("}")
		}
	}
	q:AParamter="messagelist" result
	q:AParamter="definitediagnosis" resultDiagnosis
	q result
}

/// Desc:       取病历文书与CDSS系统的对照ID
/// Creator:    Candy
/// CreateDate: 2018-10-19
/// Input:      ADocID ADocID 病历目录展现结构第三层ID
/// Output:     CDSS对应文档代码
/// Debug:      result=##Class(EMRservice.BL.BLHMCDSSService).GetCDSSCode(ADocID,AInstanceID,"progressType")
ClassMethod GetCDSSCode(ADocID As %String, AInstanceID As %String, AParamterType As %String) As %String
{
	;b ;1
	q:((ADocID = "")||(AInstanceID = "")||(AParamterType="")) ""
	s (result,Id,objInstance,titleCode,cdssInstance) = ""
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	if (objInstance.TitleCode '= "")&&(objInstance.TheECRecord.ChartItemType = "Multiple")
	{
		s titleCode = $zcvt(objInstance.TitleCode,"u")
		
		s Id = $o(^DHCEMRM.CDSS.HDSDLinkCDSSI("IdxHDSDCDSSMul"," "_ADocID," "_$zcvt(objInstance.TitleCode,"u"),""))
	}
	else
	{
		s Id = $o(^DHCEMRM.CDSS.HDSDLinkCDSSI("IdxHDSDCDSSSin"," "_ADocID,""))
	}	
	q:(Id = "") result
	s cdssInstance = ##class(EMRmeta.CDSS.HDSDLinkCDSS).%OpenId(Id)
	q:cdssInstance="" result
	s progressType = $tr(cdssInstance.CDSSCode," ","")
	s progressTypeName = cdssInstance.DocumentDesc
	s:AParamterType="progresstype" result= progressType
	s:AParamterType="progresstypename" result= progressTypeName
	q result
}

/// desc 取惠每JSDK下载地址
/// debug  w ##Class(EMRservice.BL.BLHMCDSSService).GetUrl()
ClassMethod GetJSDKUrl()
{
	s $ZT="ERROR"
	s (Id,HMUrl,loadType,autherKey,httpUrl,CDSSObj)=""
	s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," 1",Id))
	q:Id="" HMUrl
	s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
	s:CDSSObj'="" paramter = CDSSObj.Paramter
	q:paramter="" HMUrl 
	s httpUrl = $P(paramter,"^",1)
	s autherKey = $P(paramter,"^",2)
	s loadType=$P(paramter,"^",3)
	if (loadType="m"){
		s HMUrl="http://"_httpUrl_"/cdss/jssdk?v=1.0&t=pro&ak="_autherKey_"&p=cdss"
	}else{
		s HMUrl="http://"_httpUrl_"/cdss/jssdk?v=4.0&ak="_autherKey
	}
	q HMUrl
ERROR
	q ""
}

/// desc 取惠每唯一密匙
/// debug  w result=##Class(EMRservice.BL.BLHMCDSSService).GetAutherKey()
ClassMethod GetAutherKey()
{
	s $ZT="ERROR"
	s (Id,autherKey,CDSSObj)=""
	s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," 1",Id))
	q:Id="" autherKey
	s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
	s:CDSSObj'="" paramter = CDSSObj.Paramter
	q:paramter="" autherKey 
	s autherKey = $P(paramter,"^",2)
	q autherKey
ERROR
	q ""
}

/// desc 取惠每对接方式
/// debug  w ##Class(EMRservice.BL.BLHMCDSSService).GetLoadType()
ClassMethod GetLoadType()
{
	s (Id,loadType,CDSSObj,paramter)=""
	s Id = $O(^DHCEMRM.CDSSToolI("CDSSToolActive"," 1",Id))
	q:Id="" loadType
	s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
	s:CDSSObj'="" paramter = CDSSObj.Paramter
	s:paramter'="" loadType = $P(paramter,"^",3)
	q loadType
}

}
