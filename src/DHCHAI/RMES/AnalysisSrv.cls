/// 名称: DHCHAI.RMES.AnalysisSrv
/// 描述: 语义分析服务类
/// 编写者：zhufei
/// 编写日期: 2017-06-10
Class DHCHAI.RMES.AnalysisSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-08-29
/// Description:  病程语义分析
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisSrv).EmrAnalysisByEpis("5673","2018-04-05","2016-04-05","","0")
ClassMethod EmrAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aDocType As %String = "", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xDocDate=$s(aSttDate'="":aSttDate-1,1:0)
	For {
		Set xDocDate=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",EpisodeDr,xDocDate))
		Quit:xDocDate=""
		Quit:(aEndDate'="")&(xDocDate>aEndDate)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",EpisodeDr,xDocDate,xID))
			Quit:xID=""
			
			Set objRec=##class(DHCHAI.DP.EmrRecord).GetObjById(xID)
			Continue:'$Isobject(objRec)
			Continue:objRec.EmrIsActive'=1
			Continue:'$Isobject(objRec.EmrDocTypeDr)
			Set DocTypeCode=objRec.EmrDocTypeDr.BTCode
			Continue:(aDocType'="")&(aDocType'=DocTypeCode)
			Set SCode=objRec.EmrSCode
			Set DocTitle=objRec.EmrDocTitle
			Set DocHospital=SCode
			Set DocContent=objRec.EmrDocContent
			//处理文本中有上箭头 ^
			Set:DocContent["^" DocContent = $tr(DocContent,"^","ˋ")
			Set DocNumber=SCode_"||"_objRec.%Id()
			
			//文本数据脱敏(默认不脱敏)
			If aDesenFlag=1 {
				Set DocContent=##class(DHCHAI.RMES.AnalysisSrv).GetDesensitizeData(DocContent)
			}
			
			//组织语义分析参数（转换为Json串）
			Set objToJSON=##class(%DynamicObject).%New()
			Set objToJSON=objToJSON.%Set("Doc_Title",DocTitle)
			Set objToJSON=objToJSON.%Set("Patient_Id",DocNumber)  //文档编号
			Set objToJSON=objToJSON.%Set("Hospital_Id",DocHospital)
			Set objToJSON=objToJSON.%Set("Doc_Content",DocContent)
			Set jsonStr=objToJSON.%ToJSON()
			
			//语义分析接口调用
			//w jsonStr,!
			Set jsonResult=..GetJsonResult(jsonStr)
			Continue:jsonResult=""
			Continue:jsonResult.Count()<1
			
			//保存语义分析结果
			Set flg=##class(DHCHAI.RMES.SaveResultSrv).SaveJsonResult("INF-HAI",EpisodeDr,DocNumber,jsonResult)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2017-10-15
/// Description:  检查结果语义分析
/// Table：       DHCHAI.DP.RBReport
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisSrv).RISAnalysisByEpis("4670","2017-08-01","2017-08-15","","1")
ClassMethod RISAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aDocType As %String = "", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xRepDate=$s(aSttDate'="":aSttDate-1,1:0)
	For {
		Set xRepDate=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",EpisodeDr,xRepDate))
		Quit:xRepDate=""
		Quit:(aEndDate'="")&(xRepDate>aEndDate)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",EpisodeDr,xRepDate,xID))
			Quit:xID=""
			
			Set objRep=##class(DHCHAI.DP.RBReport).GetObjById(xID)
			Continue:'$Isobject(objRep)
			Set SCode=objRep.RBSCode
			Set ChkStatus=objRep.RBChkStatus
			Set IsActive=objRep.RBIsActive
			Continue:IsActive=0
			Set CheckItem=objRep.RBCheckItem
			Set ExamDesc=objRep.RBExamDesc
			Set ResultDesc=objRep.RBResultDesc
			Continue:(ExamDesc="")&&(ResultDesc="")
			Set DocTitle=CheckItem
			Set DocHospital=SCode
			Set DocContent=ExamDesc_"!!"_ResultDesc
			//处理文本中有上箭头 ^
			Set:DocContent["^" DocContent = $tr(DocContent,"^","ˋ")
			Set DocNumber=SCode_"||"_objRep.%Id()
			
			//文本数据脱敏(默认不脱敏)
			If aDesenFlag=1 {
				Set DocContent=##class(DHCHAI.RMES.AnalysisSrv).GetDesensitizeData(DocContent)
			}
			
			//组织语义分析参数（转换为Json串）
			Set objToJSON=##class(%DynamicObject).%New()
			Set objToJSON=objToJSON.%Set("Doc_Title",DocTitle)
			Set objToJSON=objToJSON.%Set("Patient_Id",DocNumber)  //文档编号
			Set objToJSON=objToJSON.%Set("Hospital_Id",DocHospital)
			Set objToJSON=objToJSON.%Set("Doc_Content",DocContent)
			Set jsonStr=objToJSON.%ToJSON()
			
			//语义分析接口调用
			//w jsonStr,!
			Set jsonResult=..GetJsonResult(jsonStr)
			Continue:jsonResult=""
			Continue:jsonResult.Count()<1
			
			//保存语义分析结果
			Set flg=##class(DHCHAI.RMES.SaveResultSrv).SaveJsonResult("INF-RIS",EpisodeDr,DocNumber,jsonResult)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     pylian
/// CreatDate：   2019-09-10
/// Description:  出院诊断语义分析
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       患者就诊号
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisSrv).DiagAnalysisByEpis("109687","2019-05-01","2019-06-15","","1")
ClassMethod DiagAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, MRDiagSource As %String = "E", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xDiagID=""
	For {
		Set xDiagID=$o(^DHCHAI.DP.MRDiagnosI("IndexSourceEpis","E",EpisodeDr,xDiagID))
		Quit:xDiagID=""
	
		Set objDiag=##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagID)
		Continue:'$Isobject(objDiag)
		Continue:objDiag.MRIsActive'=1
		Set Admission = objDiag.MRAdmission
		Set DiagDesc =objDiag.MRDiagDesc
		Continue:((DiagDesc'["切口")&&(DiagDesc'["伤口"))&&(Admission'="无")    //入院无，出院有
		Set SCode=objDiag.MRSCode
		Set DocTitle="出院记录"
		Set DocHospital=SCode
		Set DocContent=objDiag.MRDiagDesc
		Set DocNumber=SCode_"||"_objDiag.%Id()

		//文本数据脱敏(默认不脱敏)
		If aDesenFlag=1 {
			Set DocContent=##class(DHCHAI.RMES.AnalysisSrv).GetDesensitizeData(DocContent)
		}
		
		//组织语义分析参数（转换为Json串）
		Set objToJSON=##class(%DynamicObject).%New()
		Set objToJSON=objToJSON.%Set("Doc_Title",DocTitle)
		Set objToJSON=objToJSON.%Set("Patient_Id",DocNumber)  //文档编号
		Set objToJSON=objToJSON.%Set("Hospital_Id",DocHospital)
		Set objToJSON=objToJSON.%Set("Doc_Content",DocContent)
		Set jsonStr=objToJSON.%ToJSON()
		
		//语义分析接口调用
		//w jsonStr,!
		Set jsonResult=..GetJsonResult(jsonStr)
		Continue:jsonResult=""
		Continue:jsonResult.Count()<1
		
		//保存语义分析结果
		Set flg=##class(DHCHAI.RMES.SaveResultSrv).SaveJsonResult("INF-HAI",EpisodeDr,DocNumber,jsonResult)  //返回最后主记录id
		Continue:(+flg)<1
		Set Count=Count+1
	
	}
	Quit Count
}

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  入院诊断语义分析
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       患者就诊号
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisSrv).AdmDiagAnalysisByEpis("109687","2019-05-01","2019-06-15","","1")
ClassMethod AdmDiagAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, MRDiagSource As %String = "A", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xDiagID=""
	For {
		Set xDiagID=$o(^DHCHAI.DP.MRDiagnosI("IndexSourceEpis","A",EpisodeDr,xDiagID))
		Quit:xDiagID=""
	
		Set objDiag=##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagID)
		Continue:'$Isobject(objDiag)
		Continue:objDiag.MRIsActive'=1
		Set Admission = objDiag.MRAdmission
		Set DiagDesc =objDiag.MRDiagDesc

		Set SCode=objDiag.MRSCode
		Set DocTitle="首次病程记录"
		Set DocHospital=SCode
		Set DocContent=objDiag.MRDiagDesc
		Set DocNumber=SCode_"||"_objDiag.%Id()

		//文本数据脱敏(默认不脱敏)
		If aDesenFlag=1 {
			Set DocContent=##class(DHCHAI.RMES.AnalysisSrv).GetDesensitizeData(DocContent)
		}
		
		//组织语义分析参数（转换为Json串）
		Set objToJSON=##class(%DynamicObject).%New()
		Set objToJSON=objToJSON.%Set("Doc_Title",DocTitle)
		Set objToJSON=objToJSON.%Set("Patient_Id",DocNumber)  //文档编号
		Set objToJSON=objToJSON.%Set("Hospital_Id",DocHospital)
		Set objToJSON=objToJSON.%Set("Doc_Content",DocContent)
		Set jsonStr=objToJSON.%ToJSON()
		
		//语义分析接口调用
		//w jsonStr,!
		Set jsonResult=..GetJsonResult(jsonStr)
		Continue:jsonResult=""
		Continue:jsonResult.Count()<1
		
		//保存语义分析结果
		Set flg=##class(DHCHAI.RMES.SaveResultSrv).SaveJsonResult("INF-HAI",EpisodeDr,DocNumber,jsonResult)  //返回最后主记录id
		Continue:(+flg)<1
		Set Count=Count+1
	
	}
	Quit Count
}

/// Creator：     pylian
/// CreatDate：   2019-09-18
/// Description:  会诊意见语义分析
/// Table：       DHCHAI.DP.EmConsult
/// Input：       患者就诊号,记录索引码 XCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisSrv).OECAnalysisByEpis("123659","2019-07-01","2019-08-15","","1")
ClassMethod OECAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, MRDiagSource As %String = "E", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xEmCID=""
	For {
		Set xEmCID=$o(^DHCHAI.DP.EmConsultI("IndexEpisodeDr",EpisodeDr,xEmCID))
		Quit:xEmCID=""
	
		Set objEmC=##class(DHCHAI.DP.EmConsult).GetObjById(xEmCID)
		Continue:'$Isobject(objEmC)
		Continue:objEmC.ECIsActive'=1
	
		Set SCode=objEmC.ECSCode
		Set DocTitle="会诊记录"
		Set DocHospital=SCode
		Set DocContent=objEmC.ECOpintion
		Set DocNumber="OEC"_"||"_SCode_"||"_objEmC.%Id()   //增加标记，防止检索ID错误

		//文本数据脱敏(默认不脱敏)
		If aDesenFlag=1 {
			Set DocContent=##class(DHCHAI.RMES.AnalysisSrv).GetDesensitizeData(DocContent)
		}
		
		//组织语义分析参数（转换为Json串）
		Set objToJSON=##class(%DynamicObject).%New()
		Set objToJSON=objToJSON.%Set("Doc_Title",DocTitle)
		Set objToJSON=objToJSON.%Set("Patient_Id",DocNumber)  //文档编号
		Set objToJSON=objToJSON.%Set("Hospital_Id",DocHospital)
		Set objToJSON=objToJSON.%Set("Doc_Content",DocContent)
		Set jsonStr=objToJSON.%ToJSON()
		
		//语义分析接口调用
		//w jsonStr,!
		Set jsonResult=..GetJsonResult(jsonStr)
		Continue:jsonResult=""
		Continue:jsonResult.Count()<1
		
		//保存语义分析结果
		Set flg=##class(DHCHAI.RMES.SaveResultSrv).SaveJsonResult("INF-HAI",EpisodeDr,DocNumber,jsonResult)  //返回最后主记录id
		Continue:(+flg)<1
		Set Count=Count+1
	
	}
	Quit Count
}

/// Creator：     chenjb
/// CreatDate：   2017-08-29
/// Description:  获取语义分析结果
/// Table：       无
/// Input：       aInputStr ：调用接口入参拼接(json)串
/// Return：      返回解析结果
/// w ##class(DHCHAI.RMES.AnalysisSrv).GetJsonResult()
ClassMethod GetJsonResult(aInputStr As %String) As %ArrayOfDataTypes
{
	New (aInputStr)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:aInputStr="" return
	
	Set $ZT="GetJsonResultErr"
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToMain")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7707
	Quit:(Server="")||(Port="") return
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
    Do jsonStream.Rewind()
	Do jsonStream.Write(aInputStr)
	
	//获取测试Json数据流 输入
	//Do ##Class(DHCHAI.Utils.FromJSON).SetTestData(jsonStream,"In")
	
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.EntityBody.CopyFrom(jsonStream)
	Set sc=httpRequest.Post("/")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//获取测试Json数据流 输出
	//Do ##Class(DHCHAI.Utils.FromJSON).SetTestData(jsonStream,"Out")
	
	//解析Json数据流
	Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set return=..ChangeJsonObject(jsonObject)
	Quit return
	
GetJsonResultErr
	//w $ZError,!
	Quit return
}

/// Do ##class(DHCHAI.RMES.AnalysisSrv).ChangeJsonObject()
ClassMethod ChangeJsonObject(jsonObject As %DynamicObject) As %ArrayOfDataTypes
{
	New (jsonObject)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:jsonObject="" return
	
	set iter=jsonObject.%GetIterator()
	While iter.%GetNext(.key,.value) {
		Set type=jsonObject.%GetTypeOf(key)
		If type="object" {
			Set obj=..ChangeJsonObject(value)
			Do return.SetAt(obj,key)
		} ElseIf type="array" {
			Set arr=..ChangeJsonArray(value)
			Do return.SetAt(arr,key)
		} Else {
			Do return.SetAt(value,key)
		}
	}
	Quit return
}

/// Do ##class(DHCHAI.RMES.AnalysisSrv).ChangeJsonArray()
ClassMethod ChangeJsonArray(jsonArray As %DynamicArray) As %ArrayOfDataTypes
{
	New (jsonArray)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:jsonArray="" return
	
	For indCnt=0:1:(jsonArray.%Size()-1){
		Set type=jsonArray.%GetTypeOf(indCnt)
		Set value=jsonArray.%Get(indCnt)
		If type="object" {
			Set obj=..ChangeJsonObject(value)
			Set cnt=return.Count()
			Do return.SetAt(obj,cnt+1)
		} ElseIf type="array" {
			Set arr=..ChangeJsonArray(value)
			Set cnt=return.Count()
			Do return.SetAt(arr,cnt+1)
		} Else {
			Set cnt=return.Count()
			Do return.SetAt(value,cnt+1)
		}
	}
	Quit return
}

/// Input：       调用接口入参拼接(json)串
/// w ##class(DHCHAI.RMES.AnalysisSrv).UpdateRMEModel("中心静脉导管感染","中心静脉导管感染","SYMPTOM")
ClassMethod UpdateRMEModel(aTerm As %String, aFormal As %String, aType As %String) As %String
{
	New (aTerm,aFormal,aType)
	Set return=0
	Quit:(aTerm="")||(aType="") return
	
	Set $ZT="UpdateRMEModelErr"
	
	//2016Cache以下不支持%DynamicObject
	Set RMEFlag=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
	If RMEFlag="no" {
		Quit ##class(DHCHAI.RMES.AnalysisUpSrv).UpdateRMEModel(aTerm,aFormal,aType)
	}
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToBase")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7702
	Quit:(Server="")||(Port="") return
	
	//组织数据脱敏参数（转换为Json串）
	Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=objToJSON.%Set("action","add")          //添加
	Set objToJSON=objToJSON.%Set("raw_term",aTerm)
	Set objToJSON=objToJSON.%Set("formal_term",aFormal)
	Set objToJSON=objToJSON.%Set("type",aType)            // SYMPTOM 表示症状, DISEASE 表示疾病
	Set objToJSON=objToJSON.%Set("user_id","00000000")
	Set objToJSON=objToJSON.%Set("version","v1.0.0.0")
	Set jsonStr=objToJSON.%ToJSON()
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
    Do jsonStream.Rewind()
	Do jsonStream.Write(jsonStr)
	
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.EntityBody.CopyFrom(jsonStream)
	Set sc=httpRequest.Post("/")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	/* 查看接口返回Stream
	Set jsonStr=""
	While ('jsonStream.AtEnd){
		Set jsonStr=jsonStream.ReadLine()  //Read(1000)
	}
	w jsonStr,!
	*/
	
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set Status=jsonObject.GetAt("status")
	Quit:Status'=0 return
	Set return=1
	Quit return
	
UpdateRMEModelErr
	//w $ZError,!
	Quit return
}

/// Input：       调用接口入参拼接(json)串
/// w ##class(DHCHAI.RMES.AnalysisSrv).UpdateRMEModel("拉肚子","XXX","SYMPTOM")
ClassMethod DeleteRMEModel(aTerm As %String, aFormal As %String, aType As %String) As %String
{
	New (aTerm,aFormal,aType)
	Set return=0
	Quit:(aTerm="")||(aType="") return
	
	Set $ZT="DeleteRMEModelErr"
	
	//2016Cache以下不支持%DynamicObject
	Set RMEFlag=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
	If RMEFlag="no" {
		Quit ##class(DHCHAI.RMES.AnalysisUpSrv).DeleteRMEModel(aTerm,aFormal,aType)
	}
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToBase")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7702
	Quit:(Server="")||(Port="") return
	
	//组织数据脱敏参数（转换为Json串）
	Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=objToJSON.%Set("action","delete")       //删除
	Set objToJSON=objToJSON.%Set("raw_term",aTerm)
	Set objToJSON=objToJSON.%Set("formal_term",aFormal)
	Set objToJSON=objToJSON.%Set("type",aType)            // SYMPTOM 表示症状, DISEASE 表示疾病
	Set objToJSON=objToJSON.%Set("user_id","00000000")
	Set objToJSON=objToJSON.%Set("version","v1.0.0.0")
	Set jsonStr=objToJSON.%ToJSON()
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
    Do jsonStream.Rewind()
	Do jsonStream.Write(jsonStr)
	
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.EntityBody.CopyFrom(jsonStream)
	Set sc=httpRequest.Post("/")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	/* 查看接口返回Stream 
	Set jsonStr=""
	While ('jsonStream.AtEnd){
		Set jsonStr=jsonStream.ReadLine()  //Read(1000)
	}
	w jsonStr,!
	*/
	
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set Status=jsonObject.GetAt("status")
	Quit:Status'=0 return
	Set return=1
	Quit return
	
DeleteRMEModelErr
	//w $ZError,!
	Quit return
}

/// Input：       调用接口入参拼接(json)串
/// w ##class(DHCHAI.RMES.AnalysisSrv).CheckRMEModel("腹痛","SYMPTOM")
ClassMethod CheckRMEModel(aTerm As %String, aType As %String) As %ArrayOfDataTypes
{
	New (aTerm,aType)
	Set return=##class(%ArrayOfDataTypes).%New()
	Quit:(aTerm="")||(aType="") return
	
	Set $ZT="CheckRMEModelErr"
	
	//2016Cache以下不支持%DynamicObject
	Set RMEFlag=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
	If RMEFlag="no" {
		Quit ##class(DHCHAI.RMES.AnalysisUpSrv).CheckRMEModel(aTerm,aType)
	}
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToBase")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7702
	Quit:(Server="")||(Port="") return
	
	//组织数据脱敏参数（转换为Json串）
	Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=objToJSON.%Set("action","check")        //检查
	Set objToJSON=objToJSON.%Set("raw_term",aTerm)
	Set objToJSON=objToJSON.%Set("type",aType)            // SYMPTOM 表示症状, DISEASE 表示疾病
	Set objToJSON=objToJSON.%Set("user_id","00000000")
	Set objToJSON=objToJSON.%Set("version","v1.0.0.0")
	Set jsonStr=objToJSON.%ToJSON()
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
    Do jsonStream.Rewind()
	Do jsonStream.Write(jsonStr)
	
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.EntityBody.CopyFrom(jsonStream)
	Set sc=httpRequest.Post("/")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	/* 查看接口返回Stream 
	Set jsonStr=""
	While ('jsonStream.AtEnd){
		Set jsonStr=jsonStream.ReadLine()  //Read(1000)
	}
	w jsonStr,!
	*/
	
	Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set Status=jsonObject.%Get("status")
	Quit:Status'=0 return
	Set return=..ChangeJsonObject(jsonObject)
	Quit return
	
CheckRMEModelErr
	//w $ZError,!
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-08-29
/// Description:  数据脱敏api
/// Table：       无
/// Input：       aInputStr：输入内容
///               aType: 类型（1文本解析、2文件解析）
/// Return：      返回String
/// w ##class(DHCHAI.RMES.AnalysisSrv).GetDesensitizeData("姓名:邱艳凤性别:女年龄:72岁职业:其他")
ClassMethod GetDesensitizeData(aInputStr As %String, aType As %String = "1") As %String
{
	New (aInputStr,aType)
	Set return=""
	Quit:(aInputStr="")||(aType="") return
	
	Set $ZT="GetDesensitizeDataErr"
	
	//2016Cache以下不支持%DynamicObject
	Set RMEFlag=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
	If RMEFlag="no" {
		Quit ##class(DHCHAI.RMES.AnalysisUpSrv).GetDesensitizeData(aInputStr,aType)
	}
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToDesens")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7704
	Quit:(Server="")||(Port="") return
	
	Set inputStr=""
	If (aType=2) {  //读文件内容
		Quit:'##class(%File).Exists(aInputStr) return
		Set Stream2=##class(%FileCharacterStream).%New()
		Set Stream2.Filename=aInputStr
		While 'Stream2.AtEnd {
			Set inputStr=inputStr_Stream2.ReadLine()
		}
	} Else {        //读文本内容
		Set inputStr=aInputStr
	}
	Quit:inputStr="" return
	
	//组织数据脱敏参数（转换为Json串）
	Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=objToJSON.%Set("doc",inputStr)
	Set jsonStr=objToJSON.%ToJSON()
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
    Do jsonStream.Rewind()
	Do jsonStream.Write(jsonStr)
	
	//HttpRequest调用,结果输出流数据
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.EntityBody.CopyFrom(jsonStream)
	Set sc=httpRequest.Post("/")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	/* 查看接口返回Stream
	Set jsonStr=""
	While ('jsonStream.AtEnd){
		Set jsonStr=jsonStream.ReadLine()  //Read(1000)
	}
	w jsonStr,!
	*/
	
	Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set Status=jsonObject.%Get("status")
	Quit:Status'=0 return
	Set return=jsonObject.%Get("rst")  //字符串
	Quit return
	
GetDesensitizeDataErr
	//w $ZError,!
	Quit return
}

}
