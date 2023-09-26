/// 名称: DHCMA.Util.IO.EnsSyncLis1Srv
/// 描述: 东华数据中心--检验结果接口服务
/// 编写者：zhufei
/// 编写日期: 2019-09-24
Class DHCMA.Util.IO.EnsSyncLis1Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-09-25
/// Description:  查询检验结果信息
/// Table：       无
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.IO.EnsSyncLis1Srv","QryLabVisitRepItem","13","2019-09-01","2019-09-26")
Query QryLabVisitRepItem(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTCCodes As %String = "") As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String,TCResultID:%String,TCID:%String,TCCode:%String,TCDesc:%String,TCRstFormat:%String,TCResult:%String,TCUnit:%String,TCTextRes:%String,TCAbFlag:%String,TCRefRanges:%String")
{
}

ClassMethod QryLabVisitRepItemExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTCCodes As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aTCCodes=$g(aTCCodes)
	
	Set AdmStr=$g(^PAADM(aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E")&(AdmType'="O") $$$OK
	
	// 文档类型:【肿瘤】01代表检验,02代表检查、【华西】02代表检验,00代表检查
 	Set DocumentType="01"             //文档类型代码
 	Set DocumentTypeDesc="检验报告"   //文档类型名称
	
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
		
		Set ReportInfo=..GetLabReportInfo(aEpisodeID,DocmentType,DocmentID)
		Continue:ReportInfo=""
		Continue:ReportInfo.Count()<1
		
		Set ReportCnt=ReportInfo.Count()
		For indRep=1:1:ReportCnt {
			Set tReport=ReportInfo.GetAt(indRep)
			Continue:tReport=""
			
			Set TestSetCode   = $lg(tReport,1)	// 检验医嘱代码
			Set TestSetDesc   = $lg(tReport,2)	// 检验医嘱名称
			Set CollDate      = $lg(tReport,3)	// 采集日期/送检日期
			Set CollTime      = $lg(tReport,4)	// 采集日期/送检时间
			Set SpecCode      = $lg(tReport,5)	// 标本代码
			Set SpecDesc      = $lg(tReport,6)	// 标本名称
			Set LabEpisodeNo  = $lg(tReport,7)	// 标本号
			Set LabResume     = $lg(tReport,8)	// 检验备注
			Set CollDocCode   = $lg(tReport,9)	// 采集人代码
			Set CollDocDesc   = $lg(tReport,10)	// 采集人名称
			Set RecDate       = $lg(tReport,11)	// 接收日期
			Set RecTime       = $lg(tReport,12)	// 接收时间
			Set RecDocCode    = $lg(tReport,13)	// 接收人代码
			Set RecDocDesc    = $lg(tReport,14)	// 接收人姓名
			Set RegDate       = $lg(tReport,15)	// 报告日期/录入日期
			Set RegTime       = $lg(tReport,16)	// 报告时间/录入时间
			Set AuthDate      = $lg(tReport,17)	// 审核日期
			Set AuthTime      = $lg(tReport,18)	// 审核时间
			Set AuthUserCode  = $lg(tReport,19)	// 审核人代码
			Set AuthUserDesc  = $lg(tReport,20)	// 审核人姓名
			Set RepResume     = $lg(tReport,21)	// 报告备注
			Set LabPurpose    = $lg(tReport,22)	// 检验目的
			Set LabResult     = $lg(tReport,23)	// 检验结果/鉴定结果
			Set LabRepNo      = $lg(tReport,24)	// 报告号
			Set TestSetRow    = $lg(tReport,25)	// 医嘱号
			Set RepDepCode    = $lg(tReport,26)	// 报告科室代码
			Set RepDepDesc    = $lg(tReport,27)	// 报告科室名称
			Set StatusCode    = $lg(tReport,28) // 报告状态代码
			Set StatusDesc    = $lg(tReport,29) // 报告状态名称
			Set ResultInfo    = $lg(tReport,30)	// 检验项目结果
			
			Set OEItemID=TestSetRow
			Set TestSetInfo=..GetVisitTestSet(TestSetDesc,OEItemID)
			Set ArcimCode=$lg(TestSetInfo,4)
			Set ArcimDesc=$lg(TestSetInfo,5)
			Set HISOrderID=$lg(TestSetInfo,7)
			Set TestSetStr=TestSetCode_"#"_TestSetDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_HISOrderID
			
			//取HIS的医嘱科室
			If RepDepDesc="" {
				Set RepDepID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1)),"^",3)
				If RepDepID'="" {
					Set RepDepCode=$p($g(^CTLOC(RepDepID)),"^",1)
					Set RepDepDesc=$p($g(^CTLOC(RepDepID)),"^",2)
				}
			}
			
			Set ReportID      = ""
			Set VisitNumberID = ""
			Set EpisodeNo     = LabRepNo
			
			Set ReportData=$lb(ReportID)                  // 报告ID
			Set ReportData=ReportData_$lb(VisitNumberID)  // 接收标本ID
			Set ReportData=ReportData_$lb(aEpisodeID)     // 就诊号
			Set ReportData=ReportData_$lb(LabEpisodeNo)   // 标本号
			Set ReportData=ReportData_$lb(SpecCode)       // 标本代码
			Set ReportData=ReportData_$lb(SpecDesc)       // 标本名称
			Set ReportData=ReportData_$lb(RepDepCode)     // 科室代码
			Set ReportData=ReportData_$lb(RepDepDesc)     // 科室名称
			Set ReportData=ReportData_$lb(CollDate)       // 采集日期
			Set ReportData=ReportData_$lb(CollTime)       // 采集时间
			Set ReportData=ReportData_$lb(CollDocCode)    // 采集人代码
			Set ReportData=ReportData_$lb(CollDocDesc)    // 采集人名称
			Set ReportData=ReportData_$lb(RecDate)        // 接收日期
			Set ReportData=ReportData_$lb(RecTime)        // 接收时间
			Set ReportData=ReportData_$lb(RecDocCode)     // 接收人代码
			Set ReportData=ReportData_$lb(RecDocDesc)     // 接收人名称
			Set ReportData=ReportData_$lb("")             // 病区代码
			Set ReportData=ReportData_$lb("")             // 病区名称
			Set ReportData=ReportData_$lb(TestSetStr)     // 检验医嘱信息
			Set ReportData=ReportData_$lb(OEItemID)       // 医嘱号
			Set ReportData=ReportData_$lb(indRep)         // 报告顺序号 Order
			Set ReportData=ReportData_$lb(StatusCode)     // 报告状态代码
			Set ReportData=ReportData_$lb(RegDate)        // 录入日期
			Set ReportData=ReportData_$lb(RegTime)        // 录入时间
			Set ReportData=ReportData_$lb("")             // 录入人代码
			Set ReportData=ReportData_$lb("")             // 录入人名称
			Set ReportData=ReportData_$lb(AuthDate)       // 审核日期
			Set ReportData=ReportData_$lb(AuthTime)       // 审核时间
			Set ReportData=ReportData_$lb(AuthUserCode)   // 审核人代码
			Set ReportData=ReportData_$lb(AuthUserName)   // 审核人姓名
			
			For indRst=1:1:$ll(ResultInfo) {
				Set tResult=$lg(ResultInfo,indRst)
				Continue:tResult=""
				
				Set TCCode    = $lg(tResult,1)         // 检验项目代码
				Set TCDesc    = $lg(tResult,2)         // 检验项目名称
				Continue:(aTCCodes'="")&((","_aTCCodes_",")'[(","_TCCode_","))  //根据项目过滤
				Set RstFormat = $lg(tResult,3)         // 结果类型
				Set Result    = $lg(tResult,4)         // 定量结果
				Set Unit      = $lg(tResult,5)         // 结果单位
				Set TextRes   = $lg(tResult,6)         // 定性结果
				Set RefRanges = $lg(tResult,7)         // 参考值范围
				Set AbFlag    = $lg(tResult,8)         // 异常标志
				Continue:Result=""
				Set ResultID  = LabRepNo_"||"_TCCode   // 检验结果ID
				
				Set ResultData=$lb(ResultID)                   // xResultID
				Set ResultData=ResultData_$lb("")              // xTID
				Set ResultData=ResultData_$lb(TCCode)          // 检验项目代码
				Set ResultData=ResultData_$lb(TCDesc)          // 检验项目名称
				Set ResultData=ResultData_$lb(RstFormat)       // 结果类型
				Set ResultData=ResultData_$lb(Result)          // 定量结果
				Set ResultData=ResultData_$lb(Unit)            // 结果单位
				Set ResultData=ResultData_$lb(TextRes)         // 定性结果
				Set ResultData=ResultData_$lb(AbFlag)          // 异常标志
				Set ResultData=ResultData_$lb(RefRanges)       // 参考值范围
			    
				Set ^CacheTemp(repid,ind)=ReportData_ResultData
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabVisitRepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitRepItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitRepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitRepItemExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2019-03-14
/// Description:  通过标本ID取检验医嘱信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// d ##class(DHCMA.Util.IO.EnsSyncLis1Srv).GetVisitTestSet("血细胞分析(五分类)","89415316||13||")
ClassMethod GetVisitTestSet(TSDesc As %String, HISOrdItemDr As %String) As %List
{
	New (TSDesc,HISOrdItemDr)
	Set return=""
	Quit:TSDesc="" return
    
	//HIS医嘱
	Set ArcimCode="",ArcimDesc=""
	If HISOrdItemDr'="" {
		Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
		If ArcimID'="" {
			Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
			Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
		}
	}
	Set Data=$lb(1,TSDesc,TSDesc,ArcimCode,ArcimDesc,"",HISOrdItemDr)
	Set return=return_$lb(Data)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-24
/// Description:  取检验报告列表
/// Table：       PA_Adm、OE_OrdItem
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
///               aDocumentType   ：文档类型  【肿瘤】01代表检验,02代表检查、【华西】02代表检验,00代表检查
/// Output：      平台组文档ID
/// zw ##class(DHCMA.Util.IO.EnsSyncLis1Srv).GetDocumentList("13","2019-06-01","2019-09-26","01")
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
	
 	// 获取检验报告入参xml
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
/// CreatDate：   2019-09-24
/// Description:  取检验报告信息
/// Table：       PA_Adm、OE_OrdItem
/// Input：       aEpisodeID    ：就诊ID
///               aDocumentType ：文档类型代码
///               aDocumentID   ：文档ID
/// Output：      平台组文档ID
/// zw ##class(DHCMA.Util.IO.EnsSyncLis1Srv).GetLabReportInfo("13","01","29")
ClassMethod GetLabReportInfo(aEpisodeID As %String, aDocumentType As %String, aDocumentID As %String, aRootPath As %String = "") As %GlobalCharacterStream
{
	New (aEpisodeID,aDocumentType,aDocumentID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aDocumentType="")||(aDocumentID="") return
	
	Set $ZT="GetLabReportInfoErr"
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("LIS01")
	
 	// 获取检验报告入参xml
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
	// 取值节点路径
	Set xmlPath="/clinicalDocument/structuredBody"	// 取值节点路径
	
	Set ReportCnt=$$GetRepNodeData(xmlPath,"count(section[@code='S0061'])")
	Quit:ReportCnt="" return  //无结果
	Quit:ReportCnt<1 return   //返回记录数为0
	
	// 1基本信息
	Set DepDesc=$$GetRepNodeData(xmlPath_"/E0077","")               //就诊科室
	
	// 2报告信息
	Set Count=0
	For repIdx=1:1:ReportCnt{
		// 取值节点路径
		Set xmlPath="/clinicalDocument/structuredBody/section[@code='S0061']["_repIdx_"]"
		
		// 2.1检验报告信息
		Set TestSetCode  = $$GetRepNodeData(xmlPath_"/E01","")	// 检验医嘱代码
		Set TestSetDesc  = $$GetRepNodeData(xmlPath_"/E02","")	// 检验医嘱名称
		Set CollDate     = $$GetRepNodeData(xmlPath_"/E03","")	// 采集日期/送检日期
		Set CollTime     = $$GetRepNodeData(xmlPath_"/E04","")	// 采集日期/送检时间
		Set SpecCode     = $$GetRepNodeData(xmlPath_"/E05","")	// 标本代码
		Set SpecDesc     = $$GetRepNodeData(xmlPath_"/E06","")	// 标本名称
		Set:SpecDesc="" SpecDesc="其它"
		Set LabEpisodeNo = $$GetRepNodeData(xmlPath_"/E07","")	// 标本号
		Set LabResume    = $$GetRepNodeData(xmlPath_"/E08","")	// 检验备注
		Set CollDocCode  = $$GetRepNodeData(xmlPath_"/E09","")	// 采集人代码
		Set CollDocDesc  = $$GetRepNodeData(xmlPath_"/E10","")	// 采集人名称
		Set RecDate      = $$GetRepNodeData(xmlPath_"/E11","")	// 接收日期
		Set RecTime      = $$GetRepNodeData(xmlPath_"/E12","")	// 接收时间
		Set RecDocCode   = $$GetRepNodeData(xmlPath_"/E13","")	// 接收人代码
		Set RecDocDesc   = $$GetRepNodeData(xmlPath_"/E14","")	// 接收人姓名
		Set RegDate      = $$GetRepNodeData(xmlPath_"/E15","")	// 报告日期/录入日期
		Set RegTime      = $$GetRepNodeData(xmlPath_"/E16","")	// 报告时间/录入时间
		Set AuthDate     = $$GetRepNodeData(xmlPath_"/E17","")	// 审核日期
		Set AuthTime     = $$GetRepNodeData(xmlPath_"/E18","")	// 审核时间
		Set AuthUserCode = $$GetRepNodeData(xmlPath_"/E19","")	// 审核人代码
		Set AuthUserDesc = $$GetRepNodeData(xmlPath_"/E20","")	// 审核人姓名
		Set RepResume    = $$GetRepNodeData(xmlPath_"/E21","")	// 报告备注
		Set LabPurpose   = $$GetRepNodeData(xmlPath_"/E22","")	// 检验目的
		Set LabResult    = $$GetRepNodeData(xmlPath_"/E23","")	// 检验结果/鉴定结果
		Set LabRepNo     = $$GetRepNodeData(xmlPath_"/E24","")	// 报告号
		Set TestSetRow   = $$GetRepNodeData(xmlPath_"/E25","")	// 医嘱号
		Set:TestSetRow["^" TestSetRow =$tr(TestSetRow,"^","")
		Set:TestSetRow'="" TestSetRow=$p(TestSetRow,"_",1)_"||"_$p(TestSetRow,"_",2)
		Set RepDepCode   = $$GetRepNodeData(xmlPath_"/E26","")	// 报告科室代码
		Set RepDepDesc   = $$GetRepNodeData(xmlPath_"/E27","")	// 报告科室名称
		
		Set:TestSetCode="" TestSetCode=TestSetDesc
		Set:SpecCode="" SpecCode=SpecDesc
		
		Set ReportInfo=""
		Set $list(ReportInfo,1)  = TestSetCode  	// 检验医嘱代码
		Set $list(ReportInfo,2)  = TestSetDesc  	// 检验医嘱名称
		Set $list(ReportInfo,3)  = CollDate     	// 采集日期/送检日期
		Set $list(ReportInfo,4)  = CollTime     	// 采集日期/送检时间
		Set $list(ReportInfo,5)  = SpecCode     	// 标本代码
		Set $list(ReportInfo,6)  = SpecDesc     	// 标本名称
		Set $list(ReportInfo,7)  = LabEpisodeNo 	// 标本号
		Set $list(ReportInfo,8)  = LabResume    	// 检验备注
		Set $list(ReportInfo,9)  = CollDocCode  	// 采集人代码
		Set $list(ReportInfo,10) = CollDocDesc  	// 采集人名称
		Set $list(ReportInfo,11) = RecDate      	// 接收日期
		Set $list(ReportInfo,12) = RecTime      	// 接收时间
		Set $list(ReportInfo,13) = RecDocCode   	// 接收人代码
		Set $list(ReportInfo,14) = RecDocDesc   	// 接收人姓名
		Set $list(ReportInfo,15) = RegDate      	// 报告日期/录入日期
		Set $list(ReportInfo,16) = RegTime      	// 报告时间/录入时间
		Set $list(ReportInfo,17) = AuthDate     	// 审核日期
		Set $list(ReportInfo,18) = AuthTime     	// 审核时间
		Set $list(ReportInfo,19) = AuthUserCode 	// 审核人代码
		Set $list(ReportInfo,20) = AuthUserDesc 	// 审核人姓名
		Set $list(ReportInfo,21) = RepResume    	// 报告备注
		Set $list(ReportInfo,22) = LabPurpose   	// 检验目的
		Set $list(ReportInfo,23) = LabResult    	// 检验结果/鉴定结果
		Set $list(ReportInfo,24) = LabRepNo     	// 报告号
		Set $list(ReportInfo,25) = TestSetRow   	// 医嘱号
		Set $list(ReportInfo,26) = RepDepCode   	// 报告科室代码
		Set $list(ReportInfo,27) = RepDepDesc   	// 报告科室名称
		Set $list(ReportInfo,28) = "R"           	// 报告状态代码
		Set $list(ReportInfo,29) = "审核"           // 报告状态名称
		Set $list(ReportInfo,30) = ""            	// 检验项目结果
		
		// 2.2检验结果信息
		Set ResultInfo=""
		Set ResultCnt=$$GetRepNodeData(xmlPath,"count(section[@code='S0063'])")
		If (ResultCnt>0) {
			// 微生物报告
			For rstIdx=1:1:ResultCnt {
				Quit:ResultCnt<1
				// 取值节点路径
				Set xmlPath="/clinicalDocument/structuredBody/section[@code='S0061']["_repIdx_"]/section[@code='S0063']["_rstIdx_"]"
				
				// 2.2.1细菌结果
				Set RstFormat    = "V"                              // 细菌培养 结果类型为V或M
				Set BactCode     = $$GetRepNodeData(xmlPath_"/E01","")	// 细菌代码
				Set BactDesc     = $$GetRepNodeData(xmlPath_"/E02","")	// 细菌名称
				Set RstBactCnt   = $$GetRepNodeData(xmlPath_"/E03","")	// 细菌计数
				Set RuleNote     = $$GetRepNodeData(xmlPath_"/E04","")	// 专家规则
				Set RstResume    = $$GetRepNodeData(xmlPath_"/E05","")	// 备注(致病菌、多耐)
				
				Set ResultRowInfo=""
				Set $list(ResultRowInfo,1)  = "细菌"_rstIdx  // 检验项目代码
				Set $list(ResultRowInfo,2)  = "细菌"_rstIdx  // 检验项目名称
				Set $list(ResultRowInfo,3)  = RstFormat      // 结果类型
				Set $list(ResultRowInfo,4)  = BactDesc       // 定量结果
				Set $list(ResultRowInfo,5)  = ""             // 结果单位
				Set $list(ResultRowInfo,6)  = BactDesc       // 定性结果
				Set $list(ResultRowInfo,7)  = ""             // 参考值范围
				Set $list(ResultRowInfo,8)  = ""             // 异常标志
				Set $list(ResultRowInfo,9)  = BactCode       // 细菌代码
				Set $list(ResultRowInfo,10) = BactDesc       // 细菌名称
				Set $list(ResultRowInfo,11) = RstBactCnt     // 细菌计数
				Set $list(ResultRowInfo,12) = RuleNote       // 专家规则
				Set $list(ResultRowInfo,13) = RstResume      // 备注(致病菌、多耐)
				Set $list(ResultRowInfo,14) = ""             // 药敏结果
				
				// 2.2.2药敏结果
				Set SenTestInfo=""
				Set SenRstCnt=$$GetRepNodeData(xmlPath,"count(section[@code='S0064'])")
				For senIdx=1:1:SenRstCnt {
					// 取值节点路径
					Set xmlPath="/clinicalDocument/structuredBody/section[@code='S0061']["_repIdx_"]/section[@code='S0063']["_rstIdx_"]/section[@code='S0064']["_senIdx_"]"
					
					Set AntiCode   = $$GetRepNodeData(xmlPath_"/E01","")	// 抗生素代码
					Set AntiDesc   = $$GetRepNodeData(xmlPath_"/E02","")	// 抗生素名称
					Set DNValue    = $$GetRepNodeData(xmlPath_"/E03","")	// 最低抑菌浓度
					Set SenRstCode = $$GetRepNodeData(xmlPath_"/E04","")	// 药敏结果代码
					Set SenRstDesc = $$GetRepNodeData(xmlPath_"/E05","")	// 药敏结果名称
					Set IBreakRange= $$GetRepNodeData(xmlPath_"/E08","")	// I折点范围(中介)
					Set SBreakRange= $$GetRepNodeData(xmlPath_"/E09","")	// S折点范围(敏感)
					Set RBreakRange= $$GetRepNodeData(xmlPath_"/E10","")	// R折点范围(耐药)
					Set SenTestType= $$GetRepNodeData(xmlPath_"/E11","")	// 试验方法
					
					Set SenTestRowInfo=""
					Set $list(SenTestRowInfo,1) = AntiCode   	// 抗生素代码
					Set $list(SenTestRowInfo,2) = AntiDesc   	// 抗生素名称
					Set $list(SenTestRowInfo,3) = DNValue    	// 最低抑菌浓度
					Set $list(SenTestRowInfo,4) = SenRstCode 	// 药敏结果代码
					Set $list(SenTestRowInfo,5) = SenRstDesc 	// 药敏结果名称
					Set $list(SenTestRowInfo,6) = IBreakRange	// I折点范围(中介)
					Set $list(SenTestRowInfo,7) = SBreakRange	// S折点范围(敏感)
					Set $list(SenTestRowInfo,8) = RBreakRange	// R折点范围(耐药)
					Set $list(SenTestRowInfo,9) = SenTestType	// 试验方法
					
					Set SenTestInfo=SenTestInfo_$lb(SenTestRowInfo)
				}
				Set $list(ResultRowInfo,6) = SenTestInfo  // 药敏结果
				
				Set ResultInfo=ResultInfo_$lb(ResultRowInfo)
			}
		} Else {
			// 常规检验项目
			Set ResultCnt=$$GetRepNodeData(xmlPath,"count(section[@code='S0062'])")
			For rstIdx=1:1:ResultCnt {
				Quit:ResultCnt<1
				// 取值节点路径
				Set xmlPath="/clinicalDocument/structuredBody/section[@code='S0061']["_repIdx_"]/section[@code='S0062']["_rstIdx_"]"
				
				// 2.2.3常规检验结果
				Set RstFormat  = "T"                                // 常规检验 默认结果类型为T
				Set TCCode     = $$GetRepNodeData(xmlPath_"/E01","")	// 检验项目代码
				Set TCDesc     = $$GetRepNodeData(xmlPath_"/E02","")	// 检验项目名称
				Set Result     = $$GetRepNodeData(xmlPath_"/E03","")	// 定量结果
				Set Unit       = $$GetRepNodeData(xmlPath_"/E04","")	// 结果单位
				Set TextRes    = $$GetRepNodeData(xmlPath_"/E05","")	// 定性结果
				Set RefRanges  = $$GetRepNodeData(xmlPath_"/E06","")	// 参考值范围
				Set AbFlag     = $$GetRepNodeData(xmlPath_"/E07","")	// 异常标志
				
				Set:TCCode="" TCCode=TCDesc
				
				Set OID=TCCode_"!!"_SYSDr
				Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(OID)
				If $IsObject(objTC){
					Set RstFormat=objTC.BTRstFormat
				} Else {
					Set RstFormat="T"
				}
				
				Set ResultRowInfo=""
				Set $list(ResultRowInfo,1) = TCCode            	// 检验项目代码
				Set $list(ResultRowInfo,2) = TCDesc            	// 检验项目名称
				Set $list(ResultRowInfo,3) = RstFormat          // 结果类型
				Set $list(ResultRowInfo,4) = Result            	// 定量结果
				Set $list(ResultRowInfo,5) = Unit            	// 结果单位
				Set $list(ResultRowInfo,6) = TextRes            // 定性结果
				Set $list(ResultRowInfo,7) = RefRanges          // 参考值范围
				Set $list(ResultRowInfo,8) = AbFlag             // 异常标志
				
				Set ResultInfo=ResultInfo_$lb(ResultRowInfo)
			}
		}
		Set $list(ReportInfo,30)=ResultInfo
		
		Set Count=Count+1
		Do return.SetAt(ReportInfo,Count)
	}
	
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
	
GetLabReportInfoErr
	//w $ZError,!
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-25
/// Description:  生成新的检验项目、检验医嘱字典
/// Table：       DHCMA.Util.EPx.TestCode、DHCMA.Util.EPx.TestSet
/// Input：       aInputStr    ：检验项目与检验医嘱信息
/// Output：      返回结果类型
/// w ##class(DHCMA.Util.IO.EnsSyncLis1Srv).NewTSAndTCDic(3,"D0700116^抗酸染色(直接涂片)^^^SP146^CVC(中心静脉导管)-C^细菌4^细菌4^V^^")
ClassMethod NewTSAndTCDic(aSYSDr As %String, aInputStr As %String) As %String
{
	New (aSYSDr,aInputStr)
	Set return=""
	Quit:(aSYSDr="")||(aInputStr="") return
	
	Set TSCode    = $p(aInputStr,"^",1)
	Set TSDesc    = $p(aInputStr,"^",2)
	Set:TSDesc="" TSDesc=TSCode
	Set:TSCode="" TSCode=TSDesc
	Set ARCCode   = $p(aInputStr,"^",3)
	Set ARCDesc   = $p(aInputStr,"^",4)
	Set SpecCode  = $p(aInputStr,"^",5)
	Set SpecDesc  = $p(aInputStr,"^",6)
	Set:SpecDesc="" SpecDesc=SpecCode
	Set:SpecCode="" SpecCode=SpecDesc
	Set TCCode    = $p(aInputStr,"^",7)
	Set TCDesc    = $p(aInputStr,"^",8)
	Set:TCDesc="" TCDesc=TCCode
	Set:TCCode="" TCCode=TCDesc
	Set RstFormat = $p(aInputStr,"^",9)
	Set AbFlag    = $p(aInputStr,"^",10)
	Set RefRanges = $p(aInputStr,"^",11)
	If (RstFormat="")||(RstFormat="T") {
		Set RstFormat="T"
		If RefRanges'="" {
			If $l(RefRanges,"-")=2 {
				If (RefRanges'["(-)"){
					Set RstFormat="N"
				}
			}
		}
	}
	Quit:(TCCode="") return
	
	Set $ZT="NewTSAndTCDicErr"
	
	TStart
	
	//生成检验项目字典
	Set TCOID=TCCode_"!!"_aSYSDr
	Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TCOID)
	If $IsObject(objTC) {
		Set TCDr=objTC.%Id()
		Set AbFlagS=objTC.BTAbFlagS
		If (AbFlagS'[AbFlag)&&(AbFlag'="") {
			//处理异常标志
			If AbFlagS'="" {
				Set AbFlagS=AbFlagS_","_AbFlag
			} Else {
				Set AbFlagS=AbFlag
			}
			Set TCCode=objTC.BTCode
			Set TCDesc=objTC.BTDesc
			Set ClDiagnos=objTC.BTClDiagnos
			Set RefRanges=objTC.BTRefRanges
			Set RstFormat=objTC.BTRstFormat
			Set WCode=objTC.BTWCode
			Set IsActive=objTC.BTIsActive
			Set ActUserID=objTC.BTActUserID
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=TCDr       //ID
			Set $p(InputStr,"^",2)=TCOID      //OID
			Set $p(InputStr,"^",3)=TCCode     //项目代码
			Set $p(InputStr,"^",4)=TCDesc     //项目名称
			Set $p(InputStr,"^",5)=RstFormat  //结果类型
			Set $p(InputStr,"^",6)=AbFlagS    //异常标志
			Set $p(InputStr,"^",7)=ClDiagnos  //临床意义
			Set $p(InputStr,"^",8)=RefRanges  //参考值范围
			Set $p(InputStr,"^",9)=WCode      //缩写码
			Set $p(InputStr,"^",10)=+IsActive //是否有效
			Set $p(InputStr,"^",11)=ActUserID //更新人
			Set flg=##class(DHCMA.Util.EPx.TestCode).Update(InputStr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
		}
	} Else {
		Set InputStr=""
		Set $p(InputStr,"^",1)=""         //ID
		Set $p(InputStr,"^",2)=TCOID      //OID
		Set $p(InputStr,"^",3)=TCCode     //项目代码
		Set $p(InputStr,"^",4)=TCDesc     //项目名称
		Set $p(InputStr,"^",5)=RstFormat  //结果类型
		Set $p(InputStr,"^",6)=AbFlag     //异常标志
		Set $p(InputStr,"^",7)=""         //临床意义
		Set $p(InputStr,"^",8)=RefRanges  //参考值范围
		Set $p(InputStr,"^",9)=""         //唯一码
		Set $p(InputStr,"^",10)=1         //是否有效
		Set $p(InputStr,"^",11)=""        //更新人
		Set flg=##class(DHCMA.Util.EPx.TestCode).Update(InputStr,"^")
		If (+flg)<1 {
			TRollback
			Quit return
		}
		Set TCDr=+flg
	}
	
	//生成检验医嘱字典
	Set TSDr=""
	If TSCode'="" {
		Set TSOID=TSCode_"!!"_aSYSDr
		Set objTS=##class(DHCMA.Util.EP.TestSet).xGetByOID(TCOID)
		If $IsObject(objTS) {
			Set TSDr=objTS.%Id()
		} Else {
			Set InputStr=""
			Set $p(InputStr,"^",1)=""        //ID
			Set $p(InputStr,"^",2)=TSOID     //OID
			Set $p(InputStr,"^",3)=TSCode    //检验医嘱代码
			Set $p(InputStr,"^",4)=TSDesc    //检验医嘱名称
			Set $p(InputStr,"^",5)=ARCCode   //医嘱代码
			Set $p(InputStr,"^",6)=ARCDesc   //医嘱名称
			Set $p(InputStr,"^",7)=1         //是否有效
			Set $p(InputStr,"^",8)=""        //更新人
			Set flg=##class(DHCMA.Util.EPx.TestSet).Update(InputStr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
			Set TSDr=+flg
		}
	}
	
	//生成检验项目与检验医嘱对照关系
	If (TSDr'="")&&(TCDr'="") {
		If '$d(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestSetTC",TSDr,TCDr)){
			Set flg=##class(DHCMA.Util.EPx.TestSetTC).Update("^"_TSDr_"^"_TCDr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
		}
	}
	
	//生成送检标本字典
	If SpecCode'="" {
		Set SpecOID=SpecCode_"!!"_aSYSDr
		Set objSpec=##class(DHCMA.Util.EP.Specimen).xGetByOID(SpecOID)
		If $IsObject(objSpec) {
			Set SpecDr=objSpec.%Id()
		} Else {
			Set InputStr=""
			Set $p(InputStr,"^",1)=""        //ID
			Set $p(InputStr,"^",2)=SpecOID   //OID
			Set $p(InputStr,"^",3)=SpecCode  //标本代码
			Set $p(InputStr,"^",4)=SpecDesc  //标本名称
			Set $p(InputStr,"^",5)=1         //是否有效
			Set $p(InputStr,"^",6)=""        //更新人
			Set flg=##class(DHCMA.Util.EPx.Specimen).Update(InputStr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
			Set SpecDr=+flg
		}
	}
	
	TCommit
	
	Set return=TCDr
	Quit return
	
NewTSAndTCDicErr
	TRollback
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2019-09-25
/// Description:  自动批量生成新的检验项目、检验医嘱字典
/// Table：       DHCMA.Util.EPx.TestCode、DHCMA.Util.EPx.TestSet
/// Input：       aInputStr    ：检验项目与检验医嘱信息
/// Output：      返回结果类型
/// w ##class(DHCMA.Util.IO.EnsSyncLis1Srv).AutoNewTSAndTCDic("2019-09-01","2019-09-26")
ClassMethod AutoNewTSAndTCDic(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("LIS01")
	Quit:SYSDr="" return
	
	Set aQueueType="NewTestCodeDic"  //生成检验项目+检验医嘱字典
	//出院患者就诊队列
	Do ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateDischQueue("",aQueueType,aDateFrom,aDateTo)
	//在院患者就诊队列
	Do ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateAdmitQueue("",aQueueType,aDateFrom,aDateTo)
	//门急诊患者就诊队列
	Do ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateOPEPQueue("",aQueueType,aDateFrom,aDateTo)
	
	For {
		//改写状态
		Set obj=##class(DHCMA.Util.EPx.EpisQueue).FetchTask(aQueueType)
		quit:'$IsObject(obj)
		Set OID=obj.EQEpisID
		Continue:OID=""
		
		;Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(OID) //完整性检查
		Set EpisodeID=$p(OID,"!!",1)
		Continue:EpisodeID=""
		
		// 文档类型:【肿瘤】01代表检验,02代表检查、【华西】02代表检验,00代表检查
	 	Set DocumentType="01"             //文档类型代码
	 	Set DocumentTypeDesc="检验报告"   //文档类型名称
		
		// 根据就诊号获取报告列表
		Set ReportList=..GetDocumentList(EpisodeID,aDateFrom,aDateTo,DocumentType)
		Continue:ReportList.Count()<1
		
		// 根据报告ID获取报告信息
		Set Cnt=ReportList.Count()
		For indDoc=1:1:Cnt {
			Set tDocment=ReportList.GetAt(indDoc)
			Continue:tDocment=""
			
			Set DocmentID=$lg(tDocment,1)
			Set DocmentType=$lg(tDocment,2)
			Set DocmentTitle=$lg(tDocment,3)
			
			Set ReportInfo=..GetLabReportInfo(EpisodeID,DocmentType,DocmentID)
			Continue:ReportInfo=""
			Continue:ReportInfo.Count()<1
			
			Set ReportCnt=ReportInfo.Count()
			For indRep=1:1:ReportCnt {
				Set tReport=ReportInfo.GetAt(indRep)
				Continue:tReport=""
				
				Set TestSetCode   = $lg(tReport,1)	// 检验医嘱代码
				Set TestSetDesc   = $lg(tReport,2)	// 检验医嘱名称
				Set SpecCode      = $lg(tReport,5)	// 标本代码
				Set SpecDesc      = $lg(tReport,6)	// 标本名称
				Set TestSetRow    = $lg(tReport,25)	// 医嘱号
				Set ResultInfo    = $lg(tReport,30)	// 检验项目结果
				
				Set OEItemID=TestSetRow
				Set TestSetInfo=..GetVisitTestSet(TestSetDesc,OEItemID)
				Set ArcimCode=$lg(TestSetInfo,4)
				Set ArcimDesc=$lg(TestSetInfo,5)
				Set HISOrderID=$lg(TestSetInfo,7)
				
				For indRst=1:1:$ll(ResultInfo) {
					Set tResult=$lg(ResultInfo,indRst)
					Continue:tResult=""
					
					Set TCCode    = $lg(tResult,1)         // 检验项目代码
					Set TCDesc    = $lg(tResult,2)         // 检验项目名称
					Set RstFormat = $lg(tResult,3)         // 结果类型
					Set Result    = $lg(tResult,4)         // 定量结果
					Set Unit      = $lg(tResult,5)         // 结果单位
					Set TextRes   = $lg(tResult,6)         // 定性结果
					Set RefRanges = $lg(tResult,7)         // 参考值范围
					Set AbFlag    = $lg(tResult,8)         // 异常标志
					
					Set TSAndTCInfo=TestSetCode_"^"_TestSetDesc_"^"_ArcimCode_"^"_ArcimDesc  //检验医嘱
					Set TSAndTCInfo=TSAndTCInfo_"^"_SpecCode_"^"_SpecDesc  //送检标本
					Set TSAndTCInfo=TSAndTCInfo_"^"_TCCode_"^"_TCDesc_"^"_RstFormat_"^"_AbFlag_"^"_RefRanges  //检验项目
					Set flg=..NewTSAndTCDic(SYSDr,TSAndTCInfo)
					If (+flg)<1 {
						w TSAndTCInfo,!
					} Else {
						Set Count=Count+1
					}
				}
			}
		}
	}
	Set return=Count
	Quit return
}

}
