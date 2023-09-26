/// 名称: DHCHAI.RMES.AnalyDHCUpSrv
/// 描述: 语义分析服务类
/// 编写者：zhufei
/// 编写日期: 2020-05-19
Class DHCHAI.RMES.AnalyDHCUpSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2020-05-19
/// Description:  病程语义分析
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalyDHCUpSrv).EmrAnalysisByEpis("5493","2016-10-01","2016-10-12","","1")
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
			
			//保存语义分析结果
			Set flg=##class(DHCHAI.RMES.AnalyDHCUpSrv).SaveJsonResult("INF-HAI",EpisodeDr,DocNumber,DocTitle,DocContent)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2020-05-19
/// Description:  检查结果语义分析
/// Table：       DHCHAI.DP.RBReport
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalyDHCUpSrv).RISAnalysisByEpis("4670","2017-08-01","2017-08-15","","1")
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
			
			//保存语义分析结果
			Set flg=##class(DHCHAI.RMES.AnalyDHCUpSrv).SaveJsonResult("INF-RIS",EpisodeDr,DocNumber,DocTitle,DocContent)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2020-05-19
/// Description:  获取语义分析结果
/// Table：       无
/// Input：       aInputStr ：调用接口入参拼接(json)串
/// Return：      返回解析结果
/// w ##class(DHCHAI.RMES.AnalyDHCUpSrv).GetJsonResult("{""Doc_Title"":""日常病程记录"",""Patient_Id"":5493,""Hospital_Id"":""EMR01"",""Doc_Content"":""患者诉近日除原发症状外无其他特殊不适，查体同前。""}")
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
	Set aInputStr=$zcvt(aInputStr,"O","UTF8")   //update 20200825 转化编码格式为utf-8
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.InsertParam("data",aInputStr)
	Set sc=httpRequest.Post("/tag")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
		Set ^DHCHAI.Task.TaskManager("NLPStatus")=1
		Quit return
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
	Set ^DHCHAI.Task.TaskManager("NLPStatus")=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2020-05-19
/// Description:  存储东华NLP筛查结果
/// Table：       DHCHAI.RME.DocMaster
/// Input：       原始文本
/// Return：      成功：返回主记录id，失败：返回<0的代码
/// w ##class(DHCHAI.RMES.AnalyDHCUpSrv).SaveJsonResult("INF-HAI",5493,"EMR01||1","测试","患者今日体温正常，一般情况好，右膝创面部分同前，痂皮已脱落，创面周围无明显渗出及红肿，余症状查体同前。赵宇教授、盛林主治医师查房：观察患者一般情况变化。遵嘱执行。")
ClassMethod SaveJsonResult(aThemeCode As %String, aEpisodeDr As %String, aDocNumber As %String, aDocTitle As %String, aDocContent As %String) As %String
{
	New (aThemeCode,aEpisodeDr,aDocNumber,aDocTitle,aDocContent)
	Set return=0
	Quit:(aThemeCode="")||(aEpisodeDr="")||(aDocNumber="")||(aDocContent="") return
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjByCode(aThemeCode)
	Quit:'$IsObject(objThemeType) return
	Quit:'$IsObject(objThemeType.BTVersionDr) return
	Set VersionDr=objThemeType.BTVersionDr.%Id()
	
	Set DocMasterDr=""
	Set DocContent=aDocContent
	Set DocContent=##class(DHCHAI.Utils.CommonSrv).Replace(DocContent,$c(13,10),"|") //处理回车换行
	Set DocContent=$tr(DocContent,"。","|")
	Set DocContent=$tr(DocContent,"；","|")
	Set DocContent=$tr(DocContent,"？","|")
	Set DocContent=$tr(DocContent,"！","|")
	Set DocContent=$tr(DocContent,"，","|")
	Set DocContent=$tr(DocContent,"：","|")
	For indS=1:1:$l(DocContent,"|") {
		Set tSection=$p(DocContent,"|",indS)
		Continue:tSection=""
		Set tSection=##class(DHCHAI.Utils.CommonSrv).MoveSpaceKey(tSection)
		Continue:tSection=""
		
		//存储语义分析结果
		If DocMasterDr="" {
			//唯一索引
			Set DocMasterDr=$o(^DHCHAI.RME.DocMasterI("IndexDocNumber",VersionDr," "_aDocNumber,0))
			
			//保存文档
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocMasterDr
			Set $p(InputStr,"^",2)=aDocNumber
			Set $p(InputStr,"^",3)=aEpisodeDr
			Set $p(InputStr,"^",4)=$s($l(aDocContent)>1000:$e(aDocContent,1,1000),1:aDocContent)
			Set $p(InputStr,"^",5)=aDocTitle
			Set $p(InputStr,"^",6)=VersionDr
			Set $p(InputStr,"^",7)=""
			Set $p(InputStr,"^",8)="1"          //是否有效
			Set DocMasterDr=##class(DHCHAI.RME.DocMaster).Update(InputStr)
			Quit:(+DocMasterDr)<1
			Set return=DocMasterDr
			
			//清空原有文档段落
			Set flg=##class(DHCHAI.RME.DocMaster).ClearSection(DocMasterDr)
		}
		
		Set tStructResult=..GetJsonResult(tSection)
		Continue:tStructResult=""
		Continue:tStructResult.Count()<1
		
		//保存段落
		Set InputStr=""
		Set $p(InputStr,"^",1)=DocMasterDr
		Set $p(InputStr,"^",2)=""             //ChildSub
		Set $p(InputStr,"^",3)=""
		Set $p(InputStr,"^",4)=$s($l(tSection)>1000:$e(tSection,1,1000),1:tSection)
		Set $p(InputStr,"^",5)=1
		Set DocSectionDr=##class(DHCHAI.RME.DocSection).Update(InputStr)
		Continue:(+DocSectionDr)<1
		
		For indJS=1:1:tStructResult.Count() {
			//关键词节点
			Set objResult=tStructResult.GetAt(indJS)
			Continue:'$IsObject(objResult)
			
			Set OneWord     = objResult.GetAt("name")       //归一词
			Set ResultType  = objResult.GetAt("type")       //结果类型
			Set Context     = objResult.GetAt("context")    //上下文
			Set Position    = objResult.GetAt("position")   //部位
			Set:Position'="" Position = Position.GetAt("name")
			Set Disease     = objResult.GetAt("disease")    //疾病
			Set:Disease'="" Disease = Disease.GetAt("name")
			Set Symptom     = objResult.GetAt("symptom")    //症状或体征
			Set:Symptom'="" Symptom = Symptom.GetAt("name")
			Set DRFormal    = OneWord                       //上位词
			Set ParserWords = ""                            //同义词
			Set:Position'="" ParserWords = ParserWords_";"_Position
			Set:Disease'="" ParserWords = ParserWords_";"_Disease
			Set:Symptom'="" ParserWords = ParserWords_";"_Symptom
			Set:ParserWords'="" ParserWords=$e(ParserWords,2,$l(ParserWords))
			
			//结果类型(<HAI_RESULT(+)>表示阳性、<HAI_RESULT(-)>表示阴性、<HAI_RESULT(?)>表示疑似阳性)
			Set ResultTypeDr=""
			Set ResultCatDr=""
			Set objResultType=##class(DHCHAI.RME.ResultType).GetObjByCode(ResultType)
			If $IsObject(objResultType){
				Set ResultTypeDr=objResultType.%Id()
				If $IsObject(objResultType.BTCatDr){
					Set ResultCatDr=objResultType.BTCatDr.%Id()
				}
			} Else {
				Set ResultTypeStr="^"_ResultType_"^"_ResultType_"^"_""
				Set ResultTypeDr=##class(DHCHAI.RME.ResultType).Update(ResultTypeStr)
			}
			Continue:ResultTypeDr=""
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocSectionDr   //ID
			Set $p(InputStr,"^",2)=""             //ChildSub
			Set $p(InputStr,"^",3)=ResultTypeDr   //结果类型
			Set $p(InputStr,"^",4)=OneWord        //归一词
			Set $p(InputStr,"^",5)=tSection       //上下文
			Set $p(InputStr,"^",6)=""             //属性
			Set $p(InputStr,"^",7)=""             //Offset
			Set $p(InputStr,"^",8)=ParserWords    //同义词词组
			Set $p(InputStr,"^",9)=DRFormal       //上位词
			Set DocResultDr=##class(DHCHAI.RME.DocResult).Update(InputStr)
		}
	}
	Quit return
}

}
