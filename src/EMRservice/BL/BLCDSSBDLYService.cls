Class EMRservice.BL.BLCDSSBDLYService Extends %RegisteredObject
{

ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
	s resultStream = ##class(%GlobalBinaryStream).%New()
	s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
	d resultStream.Write("{""success"":""1""")
	d resultStream.Write(",""args"":{")
	d resultStream.Write("""cdssType"":""CDSSBD""")
	d resultStream.Write(",""episodeType"":"""_episodeType_"""}}")
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
/// debug  s obj = ##class(EMRservice.BL.BLCDSSBDLYService).GetBDLYJsonData("AEpisodeID:12083201,AUserLocID:157,AHospitalID:2,AUserID:6,AInstanceID:4335327||1,ADocID:51,AAction:save,AType:2")
ClassMethod GetBDLYJsonData(AParamArray As %ArrayOfDataTypes)
{
	//s ^Temp("duan","GetBDLYJsonDataAParam")=AParam
	//定义错误处理函数
	s resultStream = ##class(%GlobalBinaryStream).%New()
	d resultStream.Write("{""success"":0,""message"":""检查前端接口参数""}")
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
	
	d resultStream.Clear()
	d resultStream.Write("{""success"":0,""message"":""检查术语集-模板相关配置""}")
	q:connectCDSS=0 resultStream
	s action = $ZCVT(AParamArray.GetAt("AAction"),"U")
	s:action="CREATE" action="SAVE"
	s type = AParamArray.GetAt("AType")
	
	s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("CDSSBD","",type,action,AParamArray)	
	
	q:(stream.IsNull()=1) resultStream
	d resultStream.Clear()
	d resultStream.Write("{""success"":""1"",""message"":")
	d resultStream.CopyFrom(stream)
	d resultStream.Write("}")
	
	d resultStream.Rewind()
	q resultStream
}

/// desc 根据患者就诊号判断患者就诊类型  返回场景值
/// debug  result=##class(EMRservice.BL.BLCDSSBDLYService).GetScene(AEpisodeID,"scene")
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
/// debug result=##class(EMRservice.BL.BLCDSSBDLYService).GetAge(AEpisodeID)
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
/// Debug       d ##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfo(102,1020,"61||1","2")
/// Debug  住院d ##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfo(64,881,"60||9","1","messagelist")
/// debug result=##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfo(AEpisodeID,ADocID,AInstanceID,AType,"messagelist")
ClassMethod GetSectionInfoEPR(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, AType As %String, AParamter As %String = "", ACdssTool As %String = "CDSSBD") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:((AEpisodeID="")||(ADocID="")||(AInstanceID="")||(AType="")) result
	s:ACdssTool="" ACdssTool="CDSSBD"
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
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_ACdssTool," "_ADocID," "_objInstance.Title,""))
	}
	else
	{
		s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_ACdssTool," "_ADocID,""))
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
		s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACdssTool," "_hdsdcode,sectionRowId))
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
/// Debug       d ##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfo(102,1020,"61||1","2")
/// Debug  住院d ##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfo("302167",102,"7||1",1)
/// /// Debug  住院
/// d ##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfoEMR("302167",102,"395009||1")
/// debug result=##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfoEMR(AEpisodeID,ADocID,AInstanceID,AType,"messagelist")
/// s result=##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfoEMR(84542988,58,"8885089||1")
/// s result=##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfoEMR(83808311,52,"8798606||1")
/// s result=##Class(EMRservice.BL.BLCDSSBDLYService).GetSectionInfoEMR(82573026,66,"8327267||24")
ClassMethod GetSectionInfoEMR(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, AParamter As %String = "", ACDSSTool As %String = "CDSSBD") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:((AEpisodeID="")||(ADocID="")||(AInstanceID="")) ""
	s resultDiagnosis = ##Class(%GlobalBinaryStream).%New()
	s:(ACDSSTool="") ACDSSTool="CDSSBD"
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
	
	//s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,hdsdcode,AInstanceID)
	//s arr=##Class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,hdsdcode,AInstanceID)
	//q:arrInstanceID.Count()=0 result
	//s arr = arrInstanceID.GetAt(AInstanceID)
	
		//唯一模板取值
	//s arr =##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory(AEpisodeID,hdsdcode)
	
	//q:arr.Count()=0 result
	s diagnosisCount=0
	s sectionRowId = ""
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
		s ConfigSpecial = objSection.ConfigSpecial
		
		s MRADMID = ""
		s MRADMID = $p(^PAADM(AEpisodeID),"^",61)
		if (sectionCode = "HDSD00.13.106")
		{
			s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(+$g(^PAADM(AEpisodeID)))
			
			continue:(gender["男")
		}
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
				s valueI=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,specialCode,AInstanceID,hdsdcode)
				s valueI=$ZSTRIP(valueI,"*C")
				
				
				s:keySpecial'="" valueDesc=keySpecial_":"_valueI
				s:keySpecial="" valueDesc=valueI
				s value=value_" "_valueDesc
			}
			
			s key = $P(key,"^",1)
		}
		elseif (ConfigSpecial="CACHE"){
			//走接口取诊断
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
		
		}
		elseif (ConfigSpecial="DiagnosFromHDSD")
		{
			s resultDiag = []
			//1 西医  2 中医
			if (diagnosisType=1)
			{
				for num = 1:1:$l(sectionCode,"$")
				{
					s curInfo = $p(sectionCode,"$",num)
					s diagnosType = $p(curInfo,":",1)
					s diagnosSectionCode = $p(curInfo,":",2)
					
					s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,diagnosSectionCode,AInstanceID,hdsdcode)
					s valuelength = $l(value,".")
					for vi=1:1:valuelength
					{
						s curValue = $p(value,".",vi)
						continue:(curValue=+curValue)
						if (valuelength>1)
						{
							s:($e(curValue,*)=+$e(curValue,*)) curValue = $e(curValue,1,*-1)
						
						}
						s tmpDiag={}
						s tmpDiag."诊断类型" = diagnosType
						s tmpDiag."诊断项" = curValue
						s tmpDiag."主要诊断" = "否"
						d resultDiag.%Push(tmpDiag)
					}
				}
			}
			if (diagnosisType=2)
			{
				for num = 1:1:$l(sectionCode,"$")
				{
					s curInfo = $p(sectionCode,"$",num)
					s diagnosType = $p(curInfo,":",1)
					s diagnosSectionCode = $p(curInfo,":",2)
					
					s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,diagnosSectionCode,AInstanceID,hdsdcode)
					s valuelength = $l(value,".")
					for vi=1:1:valuelength
					{
						s curValue = $p(value,".",vi)
						continue:(curValue=+curValue)
						if (valuelength>1)
						{
							s:($e(curValue,*)=+$e(curValue,*)) curValue = $e(curValue,1,*-1)
						
						}
						s tmpDiag={}
						s tmpDiag."诊断类型" = diagnosType
						s tmpDiag."诊断项" = curValue
						d resultDiag.%Push(tmpDiag)
					}
				}
			}
			
			s value = resultDiag.%ToJSON()
		}
		elseif (ConfigSpecial="DiagnosFromCache"){
			s resultDiag = []
			//1 西医  2 中医
			if (diagnosisType=1)
			{
				//走接口取诊断
				s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagRefFormatData:DiagnosList")
		 		d rSC.Execute(MRADMID)
		 		
				while rSC.Next(){
					s diagnosCat = rSC.Data("DiagnosCat")
					s diagnosType = rSC.Data("DiagnosType")
					s diagnosICDDesc = rSC.Data("DiagnosICDDesc")
					s mainDiagFlag = rSC.Data("MainDiagFlag")
					s MRCIDCode = rSC.Data("MRCIDCode")
					
					s diagnosICDDesc = $replace(diagnosICDDesc,"&nbsp","")

					if ((diagnosCat = "中医")||(diagnosCat = "证型"))
					{
						continue
					}
					else
					{
						s tmpXYDiag={}
						s tmpXYDiag."诊断类型" = diagnosType
						s tmpXYDiag."诊断项" = diagnosICDDesc
						s tmpXYDiag."主要诊断" = mainDiagFlag
						d resultDiag.%Push(tmpXYDiag)
					
					}
				}
			}
			//1 西医  2 中医
			if (diagnosisType=2)
			{
				//走接口取诊断
				s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagRefFormatData:DiagnosList")
	 			d rSC.Execute(MRADMID)
	 			
	 			s tmpZYDiag={}
	 			
				while rSC.Next()
				{
					s diagnosCat = rSC.Data("DiagnosCat")
					s diagnosType = rSC.Data("DiagnosType")
					s diagnosICDDesc = rSC.Data("DiagnosICDDesc")
					s mainDiagFlag = rSC.Data("MainDiagFlag")
					s MRCIDCode = rSC.Data("MRCIDCode")
					
					s diagnosICDDesc = $replace(diagnosICDDesc,"&nbsp","")
					
					if ((tmpZYDiag.%Size()>0)&&(diagnosCat = "中医"))
					{
						d resultDiag.%Push(tmpZYDiag)
						s tmpZYDiag={}
					}
					
					if ((diagnosCat = "中医")||(diagnosCat = "证型"))
					{
						s tmpZYDiag."诊断类型" = diagnosType
						s tmpZYDiag."主要诊断" = mainDiagFlag
						if (diagnosCat = "中医")
						{
							s tmpdiag={}
							s tmpdiag."名称" = diagnosICDDesc
							s tmpdiag."代码" = MRCIDCode
							s tmpZYDiag."中医疾病" = tmpdiag
							s tmpZYDiag."中医证候" = []
						}
						
						if (diagnosCat = "证型")
						{
							s tmpdiag={}
							s tmpdiag."名称" = diagnosICDDesc
							s tmpdiag."代码" = MRCIDCode
							d tmpZYDiag."中医证候".%Push(tmpdiag)
						}
					}
				}
				
				//最后一次
				d resultDiag.%Push(tmpZYDiag)
			
			}
			s value = resultDiag.%ToJSON()
			
			
		}
		elseif(ConfigSpecial="param")
		{
			s:(sectionCode="AInstanceID") value= AInstanceID
			s:(sectionCode="HappenDateTime") value= $zdt(objIstance.HappenDate_","_objIstance.HappenTime,3,1)
		}
		elseif(ConfigSpecial="document")
		{
			s value = ##class(EMRservice.BL.BLCDSSService).GetDocumentContent(AInstanceID)
		}
		elseif (ConfigSpecial="object")
		{
			s localobj={}
			s localsectionRowId = sectionRowId
			for 
			{
				s localsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,localsectionRowId))
				q:(localsectionRowId = "")
				
				s localObjSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(localsectionRowId)
				q:(localObjSection = "")
				s localsectionCode = localObjSection.HDSDSectionCode
				s localkey = localObjSection.SectionDesc
				s localsectionKeyDesc = localObjSection.SectionKeyDesc
				s localdiagnosisType = localObjSection.DiagnosisType
				s localConfigSpecial = localObjSection.ConfigSpecial
				if (localConfigSpecial="objproperty")
				{
				
					if (localsectionCode["HDSD")
					{
						s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,localsectionCode,AInstanceID,hdsdcode)
					}
					else
					{
						s value = subsectionCode
					}
					
					d localobj.%Set(localkey,value)
						
				}
				elseif (localConfigSpecial="subobject")
				{
					
					s sublocalobj={}
					s sublocalsectionRowId = localsectionRowId
					
					for
					{
						s sublocalsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sublocalsectionRowId))
						q:(sublocalsectionRowId = "")
						
						s sublocalObjSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(sublocalsectionRowId)
						q:(sublocalObjSection = "")
						
						s sublocalsectionCode = sublocalObjSection.HDSDSectionCode
						s sublocalkey = sublocalObjSection.SectionDesc
						s sublocalsectionKeyDesc = sublocalObjSection.SectionKeyDesc
						s sublocaldiagnosisType = sublocalObjSection.DiagnosisType
						s sublocalConfigSpecial = sublocalObjSection.ConfigSpecial
						
						if (sublocalConfigSpecial="subobjproperty")
						{
							if (sublocalsectionCode["HDSD")
							{
								s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,sublocalsectionCode,AInstanceID,hdsdcode)
							}
							else
							{
								s value = sublocalsectionCode
							}
							
							d sublocalobj.%Set(sublocalkey,value)
						}
						else
						{
							q
						}
					}
					
					
					d localobj.%Set(localkey,sublocalobj)
						
					s localsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sublocalsectionRowId),-1)
					continue
				}
				else
				{
					q
				}
			}
			
			d:(result.Size > 1) result.Write(",")
			d result.Write(""""_key_""":"_localobj.%ToJSON())
			
			s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,localsectionRowId),-1)
			continue	
		}
		elseif ((ConfigSpecial="arrobject")&&(diagnosisType="single"))
		{
			
			s arrobj=[]
			s localsectionRowId = sectionRowId
			s localjson={}
			k tmpjsonObj
			
			for {
				s localsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,localsectionRowId))
				q:(localsectionRowId = "")
				
				s localObjSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(localsectionRowId)
				q:(localObjSection = "")
				s localsectionCode = localObjSection.HDSDSectionCode
				s localkey = localObjSection.SectionDesc
				s localsectionKeyDesc = localObjSection.SectionKeyDesc
				s localdiagnosisType = localObjSection.DiagnosisType
				s localConfigSpecial = localObjSection.ConfigSpecial
				if (localConfigSpecial="objproperty")
				{
					s splitI=""
					for splitI=1:1:$l(localsectionCode,"/")
					{
						s subsectionCode = $p(localsectionCode,"/",splitI)
						
						if (subsectionCode["HDSD")
						{
							s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,subsectionCode,AInstanceID,hdsdcode)
						}
						else
						{
							s value = subsectionCode
						}
						
						if ($d(tmpjsonObj(splitI))=0)
						{
							s tmpjsonObj(splitI) = {}
						}
						d tmpjsonObj(splitI).%Set(localkey,value)
						
					}
					
					
				}
				elseif (localConfigSpecial="arrobjsubobj")
				{
					s sublocalobj={}
					s sublocalsectionRowId = localsectionRowId
					
					for
					{
						s sublocalsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sublocalsectionRowId))
						q:(sublocalsectionRowId = "")
						
						s sublocalObjSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(sublocalsectionRowId)
						q:(sublocalObjSection = "")
						s sublocalsectionCode = sublocalObjSection.HDSDSectionCode
						s sublocalkey = sublocalObjSection.SectionDesc
						s sublocalsectionKeyDesc = sublocalObjSection.SectionKeyDesc
						s sublocaldiagnosisType = sublocalObjSection.DiagnosisType
						s sublocalConfigSpecial = sublocalObjSection.ConfigSpecial
						
						if (localConfigSpecial="objproperty")
						{
							if (subsectionCode["HDSD")
							{
								s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,subsectionCode,AInstanceID,hdsdcode)
							}
							else
							{
								s value = subsectionCode
							}
							
							d sublocalobj.%Set(sublocalkey,value)
						}
						else
						{
							q
						}
					}
					s subNum=$o(tmpjsonObj(""),-1)
					if (subNum="")
					{
						s subNum=1
						s tmpjsonObj(subNum) = {}
					}
					
					d tmpjsonObj(subNum).%Set(localkey,sublocalobj.%ToJSON())
						
					s localsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sublocalsectionRowId),-1)
					continue
					
				}
				elseif (localConfigSpecial="arrobjsubarrobj")
				{
					s subarrobj=[]
					s sublocalsectionRowId = localsectionRowId
					
					s sublocalobj={}
					for
					{
						s sublocalsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sublocalsectionRowId))
						q:(sublocalsectionRowId = "")
						
						s sublocalObjSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(sublocalsectionRowId)
						q:(sublocalObjSection = "")
						s sublocalsectionCode = sublocalObjSection.HDSDSectionCode
						s sublocalkey = sublocalObjSection.SectionDesc
						s sublocalsectionKeyDesc = sublocalObjSection.SectionKeyDesc
						s sublocaldiagnosisType = sublocalObjSection.DiagnosisType
						s sublocalConfigSpecial = sublocalObjSection.ConfigSpecial
						
						if (localConfigSpecial="objproperty")
						{
							if (subsectionCode["HDSD")
							{
								s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,subsectionCode,AInstanceID,hdsdcode)
							}
							else
							{
								s value = subsectionCode
							}
							
							d sublocalobj.%Set(sublocalkey,value)
						}
						else
						{
							q
						}
					}
					
					d subarrobj.%Push(sublocalobj)
					
					s subNum=$o(tmpjsonObj(""),-1)
					if (subNum="")
					{
						s subNum=1
						s tmpjsonObj(subNum) = {}
					}
					
					d tmpjsonObj(subNum).%Set(localkey,subarrobj.%ToJSON())
						
					s localsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sublocalsectionRowId),-1)
					continue
					
				}
				else
				{
					q
				}	
		
			}
			
			s sub=""
			for 
			{
				s sub = $o(tmpjsonObj(sub))
				q:(sub="")
						
				d arrobj.%Push(tmpjsonObj(sub))
			}
			
			d:(result.Size > 1) result.Write(",")	
			d result.Write(""""_key_""":"_arrobj.%ToJSON())
			
			s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,localsectionRowId),-1)
			continue
		}
		elseif ((ConfigSpecial="arrobject")&&(diagnosisType["multiple4"))
		{
			s propertycount=$zstrip(diagnosisType,"*","multiple")
			
			s arrobj=[]
			s localsectionRowId = sectionRowId
			s localjson={}
			k tmpjsonObj
			s propertyTotal=""
			for {
				s localsectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,localsectionRowId))
				q:(localsectionRowId = "")
				s propertyTotal=+$g(propertyTotal)+1
				
				s localObjSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(localsectionRowId)
				q:(localObjSection = "")
				s localsectionCode = localObjSection.HDSDSectionCode
				s localkey = localObjSection.SectionDesc
				s localsectionKeyDesc = localObjSection.SectionKeyDesc
				s localdiagnosisType = localObjSection.DiagnosisType
				s localConfigSpecial = localObjSection.ConfigSpecial
				if (localConfigSpecial="objproperty")
				{
					
						
					if (localsectionCode["HDSD")&&(localdiagnosisType="FeePlus")
					{
						s value=0
						for i=1:1:$l(localsectionCode,"/")
						{
							s tmplocalsectionCode = $p(localsectionCode,"^",i)
							s tmpValue = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,tmplocalsectionCode,AInstanceID,hdsdcode)
							s value = value + tmpValue
						}
						
					}
					elseif (localsectionCode["HDSD")&&(localdiagnosisType'="FeePlus")
					{
						s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,localsectionCode,AInstanceID,hdsdcode)
					}
					else
					{
						s value = localsectionCode
					}
					
					s subNum = (propertyTotal-1)\4
					
					if ($d(tmpjsonObj(subNum))=0)
					{
						s tmpjsonObj(subNum) = {}
					}
					d tmpjsonObj(subNum).%Set(localkey,value)	
				}
				else
				{
					
					q
				}
			}
			b ;901
			s sub=""
			for 
			{
				s sub = $o(tmpjsonObj(sub))
				q:(sub="")	
				d arrobj.%Push(tmpjsonObj(sub))
			}
			
			d:(result.Size > 1) result.Write(",")
			d result.Write(""""_key_""":"_arrobj.%ToJSON())
			s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,localsectionRowId),-1)
			continue

		}
		else{
			
			s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,sectionCode,AInstanceID,hdsdcode)
		}
		
		s value=$ZSTRIP(value,"*C")
		s value=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(value)
		//应百度灵慧要求返回所有数据节点，不做空值过滤。
		//continue:(value="")
		if (ConfigSpecial["format")
		{
			
			if (diagnosisType = "DateTime")
			{
				if ((value["年")&&(value["月")&&(value["日")&&(value["时")&&(value["分"))
				{
					s value = $replace(value,"年","-")
					s value = $replace(value,"月","-")
					s value = $replace(value,"日","")
					s value = $replace(value,"时",":")
					s value = $replace(value,"分","")
					s value = $zdt($zdth(value,3,2),3,1)
				}
			}
			
			if (diagnosisType = "Pay")
			{
				s value = $e(value,2)
			}
		}
		d:(result.Size > 1) result.Write(",")
		
		
		if (ConfigSpecial["DiagnosFrom")
		{
			s value=$replace(value,"\""","""")
			d result.Write(""""_key_""":"_value)
		}
		else
		{
			d result.Write(""""_key_""":"""_value_"""")
		}
	}
	
	q result
}

/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetSenceByEpisodeID(AEpisodeID,ADocID,)
ClassMethod GetSenceByEpisodeID(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance="") result
	s curTitleCode= objInstance.TitleCode
	s tmpid=""
	for
	{
		s tmpid = $o(^DHCEMRM.CDSS.HDSDLinkCDSSI("IdxHDSDCDSSSin"," "_ACDSSTool," "_ADocID,tmpid))
		q:(tmpid="")
		s obj = ##class(EMRmeta.CDSS.HDSDLinkCDSS).%OpenId(tmpid)
		s docTileCode = obj.TitleCode
		continue:((curTitleCode'="")&&(docTileCode'="")&&(curTitleCode'=docTileCode))
		s result = obj.DocumentDesc
		d obj.%Close()
		q:(result'="")
	}
	q result
}

/// 登记号
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetRegNo(AEpisodeID)
/// w ##class(EMRservice.BL.BLCDSSBDLYService).GetRegNo(302167)
ClassMethod GetRegNo(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)

 	s result = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
 	
	q result
}

/// 职业
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetOccupation(AEpisodeID)
/// w ##class(EMRservice.BL.BLCDSSBDLYService).GetOccupation(302167)
ClassMethod GetOccupation(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s result = $p(##class(EMRservice.HISInterface.PatientInfoAssist).Occupation(PatientID),"^",3)
	
	q result
}

/// 民族
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetNation(AEpisodeID)
/// w ##class(EMRservice.BL.BLCDSSBDLYService).GetNation(302167)
ClassMethod GetNation(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s result = $p(##class(EMRservice.HISInterface.PatientInfoAssist).Nation(PatientID),"^",3)
	
	q result
}

/// 出生地
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetBirthPlace(AEpisodeID)
ClassMethod GetBirthPlace(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s Native = ##class(EMRservice.HISInterface.PatientInfoAssist).Native(PatientID)
	
	s result = $p(Native,"^",3)
	q result
}

/// 现住址
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetCurAddr(302167)
ClassMethod GetCurAddr(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s tmpcuraddr = ##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(PatientID)
	
	i tmpcuraddr'=""
 	{
 		// 现住址城市 
   		s tmpcurCity = $p($g(tmpcuraddr),"!",2)
   		s curCityDict = tmpcurCity
   		s curCityDesc = $p(curCityDict,"^",3)
 
   		// 现住址省份 
   		s tmpcurProvince = $p($g(tmpcuraddr),"!",1)
   		s curProvinceDict = tmpcurProvince
   		s curProvinceDesc = $p(tmpcurProvince,"^",3)
   		
   		// 现住址区县 
   		s tmpcurBlock = $p($g(tmpcuraddr),"!",3)
   		s curBlockDict = tmpcurBlock
   		s curBlockDesc = $p(curBlockDict,"^",3)
   		
		s curStreet= $p($g(tmpcuraddr),"!",4)
   		// 现住址
   		// 20180312 标准地址存储，目前填写的现住址返回完整的数据。
   		// 依据项目实际情况调整返回值。lifb
   		//s CurAddress = $p($g(tmpcurProvince),"^",3)_$p($g(tmpcurCity),"^",3)_$p($g(tmpcurBlock),"^",3)_curStreet
 		s result = curStreet
 
 	}
	q result
}

/// 费用类型
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetPayType(AEpisodeID)
ClassMethod GetPayType(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	//s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s PayType = ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(AEpisodeID)
	
	s result = $p(PayType,"^",3)
	q result
}

/// 身高
/// 体重
/// ABO血型
/// Rh血型
/// 婚姻状态
/// result=##class(EMRservice.BL.BLCDSSBDLYService).GetMarriage(AEpisodeID)
ClassMethod GetMarriage(AEpisodeID As %String, ACDSSTool As %String = "CDSSBD") As %String
{
	s result = ""
	
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s result = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).Marriage(PatientID),"^",3)
	
	q result
}

/// 增加诊断
/// 
ClassMethod InterfaceDiagnoses(AEpisodeID As %String, ICDDesc As %String, ICDCode As %String, AOperCode As %String) As %String
{
	s ret=""
	q:(AEpisodeID="") ret
	
	s icdstr = ICDDesc_"^"_ICDCode
	
	s LocID = %session.Get("LOGON.CTLOCID")
	s UserID = %session.Get("LOGON.USERID")
	
	if (AOperCode="Insert")
	{
		s ret = ##class(DHCDoc.Interface.Inside.Service).InsertMRDiagnos(AEpisodeID,icdstr,LocID,UserID)
	}
	if (AOperCode="Delete")
	{
		s ret = ##class(DHCDoc.Interface.Inside.Service).DeleteDiagnos(AEpisodeID,icdstr,LocID,UserID)
	}
	
	q ret
}

}
