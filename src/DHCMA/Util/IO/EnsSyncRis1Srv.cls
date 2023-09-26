/// 名称: DHCMA.Util.IO.EnsSyncRis1Srv
/// 描述: 东华数据中心--检查结果接口服务
/// 编写者：zhufei
/// 编写日期: 2019-09-24
Class DHCMA.Util.IO.EnsSyncRis1Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2019-09-26
/// Description:   根据就诊号查询检查报告信息
/// Table：        无
/// Input：        aEpisodeID ：就诊号
///                aDateFrom  ：开始日期
///                aDateTo    ：截止日期
/// Output：       ROWSPEC=检查报告信息
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.EnsSyncRis1Srv","QryRisReportInfo","939","2019-09-01","2019-09-18")
Query QryRisReportInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aARCCodes As %String = "") As %Query(ROWSPEC = "ID:%String,StatusCode:%String,StatusDesc:%String,StudyNo:%String,OEItemID:%String,OrdItemCode:%String,OrdItemDesc:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String,ExamDesc:%String,ExamResult:%String,Memo:%String")
{
}

ClassMethod QryRisReportInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aARCCodes As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aARCCodes=$g(aARCCodes)
	
	Set AdmStr=$g(^PAADM(aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E")&(AdmType'="O")&(AdmType'="H") $$$OK
	
	// 文档类型:【肿瘤】01代表检验,02代表检查、【华西】02代表检验,00代表检查
 	Set DocumentType="02"             //文档类型代码
 	Set DocumentTypeDesc="检查报告"   //文档类型名称
	
	// 根据就诊号获取报告列表
	Set ReportList=..GetDocumentList(aEpisodeID,aDateFrom,aDateTo,DocumentType)
	Quit:ReportList.Count()<1 $$$OK
	
	// 根据报告ID获取报告信息
	Set Cnt=ReportList.Count()
	For indDoc=1:1:Cnt {
		Set tDocment=ReportList.GetAt(indDoc)
		Continue:tDocment=""
		
		Set DocmentID=$lg(tDocment,1)
		Set DocmentType=$lg(tDocment,2)
		Set DocmentTitle=$lg(tDocment,3)
		
		Set ReportInfo=..GetRisReportInfo(aEpisodeID,DocmentType,DocmentID)
		Continue:ReportInfo=""
		Continue:ReportInfo.Count()<1
		
		Set tReport=ReportInfo.GetAt(1)  //检查报告不存在一次申请多份报告的情况
		Continue:tReport=""
		
		Set StudyNo      = $lg(tReport,1)  // 检查单号
		Set ExamDesc     = $lg(tReport,2)  // 检查所见
		Set ExamResult   = $lg(tReport,3)  // 诊断意见
		Set RepUserCode  = $lg(tReport,4)  // 检查医师代码
		Set RepUserDesc  = $lg(tReport,5)  // 检查医师姓名
		Set CheckDocCode = $lg(tReport,6)  // 审核医师代码
		Set CheckDocDesc = $lg(tReport,7)  // 审核医师姓名
		Set RegUserCode  = $lg(tReport,8)  // 登记医师代码
		Set RegUserDesc  = $lg(tReport,9)  // 登记医师姓名
		Set RegDate      = $lg(tReport,10) // 登记日期
		Set RegTime      = $lg(tReport,11) // 登记时间
		Set ReportID     = $lg(tReport,12) // 报告号
		Set CheckDate    = $lg(tReport,13) // 审核日期
		Set CheckTime    = $lg(tReport,14) // 审核时间
		Set ExamItem     = $lg(tReport,15) // 检查项目描述
		Set RepDate      = $lg(tReport,16) // 报告日期
		Set RepTime      = $lg(tReport,17) // 报告时间
		Set StatusCode   = $lg(tReport,18) // 报告状态代码
		Set StatusDesc   = $lg(tReport,19) // 报告状态名称
		
		Set OEItemID     = ""              // 医嘱ID
		Set OrdItemCode  = ExamItem        // 医嘱代码
		Set OrdItemDesc  = ExamItem        // 医嘱名称
		Set Memo         = ""              // 备注信息
		
		Set Data=$lb(ReportID,StatusCode,StatusDesc,StudyNo,OEItemID,OrdItemCode,OrdItemDesc,RegDate,RegTime,RegUserCode,RegUserDesc,CheckDate,CheckTime,CheckDocCode,CheckDocDesc,ExamDesc,ExamResult,Memo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRisReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRisReportInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryRisReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRisReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2019-09-26
/// Description:  取检查报告列表
/// Table：       PA_Adm、OE_OrdItem
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
///               aDocumentType   ：文档类型  【肿瘤】01代表检验,02代表检查、【华西】02代表检验,00代表检查
/// Output：      平台组文档ID
/// zw ##class(DHCMA.Util.IO.EnsSyncRis1Srv).GetDocumentList("939","2019-09-01","2019-09-18","02")
ClassMethod GetDocumentList(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aDocumentType As %String) As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aDocumentType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="")||(aDocumentType="") return
	
	Set $ZT="GetDocumentListErr"
	
	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	
 	// 获取检查报告入参xml
	Set xmlInput="<Request><Header><SourceSystem>TJ</SourceSystem><MessageID></MessageID></Header>"
	Set xmlInput=xmlInput_"<Body>"
	Set xmlInput=xmlInput_"<DocumentRetrievalRt>"
	Set xmlInput=xmlInput_"<PATPatientID>"_PatientID_"</PATPatientID>"           //病人ID
	Set xmlInput=xmlInput_"<PAADMVisitNumber>"_aEpisodeID_"</PAADMVisitNumber>"  //就诊ID
	Set xmlInput=xmlInput_"<DocumentType>"_aDocumentType_"</DocumentType>"       //文档类型
	Set xmlInput=xmlInput_"<StartDate>"_$zd(aDateFrom,3)_"</StartDate>"          //开始日期
	Set xmlInput=xmlInput_"<EndDate>"_$zd(aDateTo,3)_"</EndDate>"                //结束日期
	Set xmlInput=xmlInput_"<DocumentFormat>xml</DocumentFormat>"                 //文档格式
	Set xmlInput=xmlInput_"</DocumentRetrievalRt>"
	Set xmlInput=xmlInput_"</Body>"
	Set xmlInput=xmlInput_"</Request>"
	
	// xml字符转换为xml对象
	Set xmlStream=##class(%GlobalCharacterStream).%New()
  	Do xmlStream.Rewind()
	Do xmlStream.Write(xmlInput)
	Do xmlStream.%Close()
	
	// 调用平台接口，解析Xml结果
	Set xmlReportList=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",xmlStream)
	// 解析Xml,获取报告列表信息
	Set sc=##class(%XML.XPATH.Document).CreateFromStream(xmlReportList,.tDocument)
	If $$$ISERR(sc){
  		Do $system.OBJ.DisplayError(sc)
		Write "调用平台接口，解析Xml结果：打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Quit return
  	}
	// 取值节点路径
	Set xmlPath="/Response/Body/DocumentRetrievalRp"	// 取值节点路径
	
	Set DocumentCnt=$$GetDocumentData(xmlPath,"count(Documents)")
	Quit:DocumentCnt="" return  //无结果
	Quit:DocumentCnt<1 return   //返回记录数为0
	
	// 文档信息
	Set Count=0
	For docIdx=1:1:DocumentCnt{
		// 取值节点路径
		Set xmlPath="/Response/Body/DocumentRetrievalRp/Documents["_docIdx_"]/Document"
		
		Set DocumentID    = $$GetDocumentData(xmlPath_"/DocumentID","")	    // 文档ID
		Continue:DocumentID=""
		Set DocumentType  = $$GetDocumentData(xmlPath_"/DocumentType","")	// 文档类型
		Set DocumentTitle = $$GetDocumentData(xmlPath_"/DocumentTitle","")	// 检查项目（检查医嘱名称）
		
		Set Count=Count+1
		Set DocumentInfo=$lb(DocumentID,DocumentType,DocumentTitle)
		Do return.SetAt(DocumentInfo,Count)
	}
	Quit return
	
GetDocumentData(xmlPath,nodeType)
	Set nodeValue=""
	Set:nodeType="" nodeType="text()"
	Set tsc=tDocument.EvaluateExpression(xmlPath,nodeType,.tres)
	If $$$ISOK(tsc){
		If $IsObject(tres.GetAt(1)) {
			Set nodeValue=tres.GetAt(1).Value
			Set nodeValue=$tr(nodeValue,$c(0),"")
		}
	}
	Quit nodeValue
	
GetDocumentListErr
	//w $ZError,!
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-26
/// Description:  取检查报告信息
/// Table：       PA_Adm、OE_OrdItem
/// Input：       aEpisodeID    ：就诊ID
///               aDocumentType ：文档类型代码
///               aDocumentID   ：文档ID
/// Output：      平台组文档ID
/// zw ##class(DHCMA.Util.IO.EnsSyncRis1Srv).GetRisReportInfo("939","02","54")
ClassMethod GetRisReportInfo(aEpisodeID As %String, aDocumentType As %String, aDocumentID As %String, aRootPath As %String = "") As %GlobalCharacterStream
{
	New (aEpisodeID,aDocumentType,aDocumentID,aRootPath)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aDocumentType="")||(aDocumentID="") return
	
	Set $ZT="GetRisReportInfoErr"
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("LIS01")
	
 	// 获取检查报告入参xml
	Set InputXml="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header>"
	Set InputXml=InputXml_"<Body>"
	Set InputXml=InputXml_"<DocumentSearchRt>"
	Set InputXml=InputXml_"<PATPatientID>"_PatientID_"</PATPatientID>"           //病人ID
	Set InputXml=InputXml_"<PAADMVisitNumber>"_aEpisodeID_"</PAADMVisitNumber>"  //就诊ID
	Set InputXml=InputXml_"<DocumentType>"_aDocumentType_"</DocumentType>"       //文档类型
	Set InputXml=InputXml_"<DocumentID>"_aDocumentID_"</DocumentID>"             //文档ID
	Set InputXml=InputXml_"</DocumentSearchRt>"
	Set InputXml=InputXml_"</Body>"
	Set InputXml=InputXml_"</Request>"
	
	// xml字符转换为xml对象
	Set xmlStream=##class(%GlobalCharacterStream).%New()
  	Do xmlStream.Rewind()
	Do xmlStream.Write(InputXml)
	Do xmlStream.%Close()
	
	// 调用平台接口，解析Xml结果
	Set xmlReportInfo=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000045",xmlStream)
	// 解析Xml,获取报告信息
	Set sc=##class(%XML.XPATH.Document).CreateFromStream(xmlReportInfo,.tReport)
	If $$$ISERR(sc){
  		Do $system.OBJ.DisplayError(sc)
		Write "调用平台接口，解析Xml结果：打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Quit return
  	}
  	Set Count=0
	// 取值节点路径
	Set xmlPath="/clinicalDocument/structuredBody/section[@code='S0076']"
	
	Set StudyNo      = $$GetRepNodeData(xmlPath_"/E01","")	// 检查单号
	Set ExamDesc     = $$GetRepNodeData(xmlPath_"/E08","")	// 检查所见
	Set ExamResult   = $$GetRepNodeData(xmlPath_"/E09","")	// 诊断意见
	If $p(ExamDesc,"@@",2)'="" {
		Set ExamResult=$p(ExamDesc,"@@",2)
		Set ExamDesc=$p(ExamDesc,"@@",1)
	}
	Set RepUserCode  = $$GetRepNodeData(xmlPath_"/E10","")	// 检查医师代码
	Set RepUserDesc  = $$GetRepNodeData(xmlPath_"/E11","")	// 检查医师姓名
	Set CheckDocCode = $$GetRepNodeData(xmlPath_"/E12","")	// 审核医师代码
	Set CheckDocDesc = $$GetRepNodeData(xmlPath_"/E13","")	// 审核医师姓名
	Set RegUserDesc  = $$GetRepNodeData(xmlPath_"/E14","")	// 登记医师代码
	Set RegUserDesc  = $$GetRepNodeData(xmlPath_"/E15","")	// 登记医师姓名
	Set RegDate      = $$GetRepNodeData(xmlPath_"/E16","")	// 登记日期
	Set RegTime      = $$GetRepNodeData(xmlPath_"/E17","")	// 登记时间
	Set ReportID     = $$GetRepNodeData(xmlPath_"/E18","")	// 报告号
	Set CheckDate    = $$GetRepNodeData(xmlPath_"/E19","")	// 审核日期
	Set CheckTime    = $$GetRepNodeData(xmlPath_"/E20","")	// 审核时间
	Set ExamItem     = $$GetRepNodeData(xmlPath_"/E21","")	// 检查项目描述
	Set RepDate      = $$GetRepNodeData(xmlPath_"/E23","")	// 报告日期
	Set RepTime      = $$GetRepNodeData(xmlPath_"/E24","")	// 报告时间
	
	Set ReportInfo=""
	Set $list(ReportInfo,1)  = StudyNo       // 检查单号
	Set $list(ReportInfo,2)  = ExamDesc      // 检查所见
	Set $list(ReportInfo,3)  = ExamResult    // 诊断意见
	Set $list(ReportInfo,4)  = RepUserCode   // 检查医师代码
	Set $list(ReportInfo,5)  = RepUserDesc   // 检查医师姓名
	Set $list(ReportInfo,6)  = CheckDocCode  // 审核医师代码
	Set $list(ReportInfo,7)  = CheckDocDesc  // 审核医师姓名
	Set $list(ReportInfo,8)  = RegUserDesc   // 登记医师代码
	Set $list(ReportInfo,9)  = RegUserDesc   // 登记医师姓名
	Set $list(ReportInfo,10) = RegDate       // 登记日期
	Set $list(ReportInfo,11) = RegTime       // 登记时间
	Set $list(ReportInfo,12) = ReportID      // 报告号
	Set $list(ReportInfo,13) = CheckDate     // 审核日期
	Set $list(ReportInfo,14) = CheckTime     // 审核时间
	Set $list(ReportInfo,15) = ExamItem      // 检查项目描述
	Set $list(ReportInfo,16) = RepDate       // 报告日期
	Set $list(ReportInfo,17) = RepTime       // 报告时间
	Set $list(ReportInfo,18) = "V"           // 报告状态代码
	Set $list(ReportInfo,19) = "已审核"      // 报告状态描述
	
	Set Count=Count+1
	Do return.SetAt(ReportInfo,Count)
	Quit return
	
GetRepNodeData(xmlPath,nodeType)
	Set nodeValue=""
	Set:nodeType="" nodeType="text()"
	Set tsc=tReport.EvaluateExpression(xmlPath,nodeType,.tres)
	If $$$ISOK(tsc){
		If $IsObject(tres.GetAt(1)) {
			Set nodeValue=tres.GetAt(1).Value
			Set nodeValue=$tr(nodeValue,$c(0),"")
		}
	}
	Quit nodeValue
	
GetRisReportInfoErr
	//w $ZError,!
	Do return.Clear()
	Quit return
}

}
