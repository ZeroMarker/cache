/// 名称: DHCHAI.RMES.AnalysisUpSrv
/// 描述: 语义分析服务类
/// 编写者：zhufei
/// 编写日期: 2017-06-10
Class DHCHAI.RMES.AnalysisUpSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-08-29
/// Description:  病程语义分析
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).EmrAnalysisByEpis("5493","2016-10-01","2016-10-12","","1")
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
			Set DocNumber=SCode_"||"_objRec.%Id()
			
			//文本数据脱敏(默认不脱敏)
			If aDesenFlag=1 {
				Set DocContent=##class(DHCHAI.RMES.AnalysisUpSrv).GetDesensitizeData(DocContent)
			}
			
			//组织语义分析参数（转换为Json串）
			//Set objToJSON=##class(%DynamicObject).%New()
			Set objToJSON=##class(DHCHAI.Utils.ToJSON).%New()
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
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).RISAnalysisByEpis("4670","2017-08-01","2017-08-15","","1")
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
			Set DocNumber=SCode_"||"_objRep.%Id()
			
			//文本数据脱敏(默认不脱敏)
			If aDesenFlag=1 {
				Set DocContent=##class(DHCHAI.RMES.AnalysisUpSrv).GetDesensitizeData(DocContent)
			}
			
			//组织语义分析参数（转换为Json串）
			//Set objToJSON=##class(%DynamicObject).%New()
			Set objToJSON=##class(DHCHAI.Utils.ToJSON).%New()
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

/// Creator：     chenjb
/// CreatDate：   2017-08-29
/// Description:  获取语义分析结果
/// Table：       无
/// Input：       aInputStr ：调用接口入参拼接(json)串
/// Return：      返回解析结果
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).GetJsonResult("{""Doc_Title"":""日常病程记录"",""Patient_Id"":5493,""Hospital_Id"":""EMR01"",""Doc_Content"":""患者诉近日除原发症状外无其他特殊不适，查体同前。""}")
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
	Do jsonStream.Clear()
    Do jsonStream.Rewind()
	Do jsonStream.Write(aInputStr)
	
	//获取测试Json数据流 输入
	//Do ##Class(DHCHAI.Utils.FromJSON).SetTestData(jsonStream,"In2")
	
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.EntityBody.CopyFrom(jsonStream)
	Set sc=httpRequest.Post("/")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Do jsonStream.Clear()
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//获取测试Json数据流 输出
	//Do ##Class(DHCHAI.Utils.FromJSON).SetTestData(jsonStream,"Out2")
	
	//解析Json数据流
	//Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Set jsonObject=##class(DHCHAI.Utils.FromJSON).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set return=jsonObject
	Quit return
	
GetJsonResultErr
	//w $ZError,!
	Quit return
}

/// Input：       调用接口入参拼接(json)串
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).UpdateRMEModel("拉肚子","XXX","SYMPTOM")
ClassMethod UpdateRMEModel(aTerm As %String, aFormal As %String, aType As %String) As %String
{
	New (aTerm,aFormal,aType)
	Set return=0
	Quit:(aTerm="")||(aType="") return
	
	Set $ZT="UpdateRMEModelErr"
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToBase")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7702
	Quit:(Server="")||(Port="") return
	
	//组织数据脱敏参数（转换为Json串）
	//Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=##class(DHCHAI.Utils.ToJSON).%New()
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
	Do jsonStream.Clear()
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
	Do jsonStream.Clear()
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Set jsonObject=##class(DHCHAI.Utils.FromJSON).%FromJSON(jsonStream)
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
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).DeleteRMEModel("拉肚子","XXX","SYMPTOM")
ClassMethod DeleteRMEModel(aTerm As %String, aFormal As %String, aType As %String) As %String
{
	New (aTerm,aFormal,aType)
	Set return=0
	Quit:(aTerm="")||(aType="") return
	
	Set $ZT="DeleteRMEModelErr"
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToBase")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7702
	Quit:(Server="")||(Port="") return
	
	//组织数据脱敏参数（转换为Json串）
	//Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=##class(DHCHAI.Utils.ToJSON).%New()
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
	Do jsonStream.Clear()
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
	Do jsonStream.Clear()
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Set jsonObject=##class(DHCHAI.Utils.FromJSON).%FromJSON(jsonStream)
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
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).CheckRMEModel("腹痛","SYMPTOM")
ClassMethod CheckRMEModel(aTerm As %String, aType As %String) As %ArrayOfDataTypes
{
	New (aTerm,aType)
	Set return=##class(%ArrayOfDataTypes).%New()
	Quit:(aTerm="")||(aType="") return
	
	Set $ZT="CheckRMEModelErr"
	
	Set ServerStr=##class(DHCHAI.BT.Config).GetValByCode("RMEServerToBase")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7702
	Quit:(Server="")||(Port="") return
	
	//组织数据脱敏参数（转换为Json串）
	//Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=##class(DHCHAI.Utils.ToJSON).%New()
	Set objToJSON=objToJSON.%Set("action","check")        //检查
	Set objToJSON=objToJSON.%Set("raw_term",aTerm)
	Set objToJSON=objToJSON.%Set("type",aType)            // SYMPTOM 表示症状, DISEASE 表示疾病
	Set objToJSON=objToJSON.%Set("user_id","00000000")
	Set objToJSON=objToJSON.%Set("version","v1.0.0.0")
	Set jsonStr=objToJSON.%ToJSON()
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
	Do jsonStream.Clear()
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
	Do jsonStream.Clear()
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Set jsonObject=##class(DHCHAI.Utils.FromJSON).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set Status=jsonObject.GetAt("status")
	Quit:Status'=0 return
	Set return=jsonObject
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
/// w ##class(DHCHAI.RMES.AnalysisUpSrv).GetDesensitizeData("姓名:邱艳凤性别:女年龄:72岁职业:其他")
ClassMethod GetDesensitizeData(aInputStr As %String, aType As %String = "1") As %String
{
	New (aInputStr,aType)
	Set return=""
	Quit:(aInputStr="")||(aType="") return
	
	Set $ZT="GetDesensitizeDataErr"
	
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
	//Set objToJSON=##class(%DynamicObject).%New()
	Set objToJSON=##class(DHCHAI.Utils.ToJSON).%New()
	Set objToJSON=objToJSON.%Set("doc",inputStr)
	Set jsonStr=objToJSON.%ToJSON()
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
	Do jsonStream.Clear()
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
	Do jsonStream.Clear()
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Set jsonObject=##class(DHCHAI.Utils.FromJSON).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set Status=jsonObject.GetAt("status")
	Quit:Status'=0 return
	Set return=jsonObject.GetAt("rst")
	Quit return
	
GetDesensitizeDataErr
	//w $ZError,!
	Quit return
}

}
