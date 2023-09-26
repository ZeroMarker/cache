/// Name:         DHCHAI.DI.DWS.GetLisXml
/// Creator：     liyi
/// CreatDate：   2018-08-21
/// Description:  东华集成平台-检验数据解析并存储到院感结构
Class DHCHAI.DI.DWS.GetLisXml Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2018-08-21
/// Description:  根据就诊获取检验报告数据
/// 			  aSCode：检验子系统代码
/// 			  aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      处理报告数
/// d ##class(DHCHAI.DI.DWS.GetLisXml).SyncLabRepByDate("LIS01","HIS01||19194658",$zdh("2017-01-01",3),$zdh("2017-08-15",3))
ClassMethod SyncLabRepByDate(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return

	Set aEpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	
	Set EpisodeDr=objAdm.%Id()
	Set aPatientID=objAdm.PAPapmiNo
	
	/// 获取检验报告列表
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DWS.GetLisXml:QryLabVisitReport")
	Set sc=rs.Execute(aPatientID,aEpisodeID,aDateFrom,aDateTo)
	If $$$ISERR(sc) {
  		Do $System.Status.DisplayError(sc)
  		Quit return
	}
	While (rs.Next()){		// 循环报告
    	Set DocumentID=rs.Data("DocumentID")
    	Set DocTypeDesc=rs.Data("DocTypeDesc")
    	Set DocTypeCode=rs.Data("DocTypeCode")
    	/// 获取检验报告结果
    	Set ReportInfo = ##class(DHCHAI.DI.DWS.GetLisXml).GetRepResult(aPatientID,aEpisodeID,DocTypeCode,DocumentID)
    	Continue:ReportInfo=""
    
	    Do ReportInfo.Rewind()
    	Set sc =##class(%XML.XPATH.Document).CreateFromStream(ReportInfo,.tReport)
    	Do ReportInfo.Rewind()
    	If $$$ISERR(sc){
	  		Continue
	  	}else{
			Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0061'])",.tres)
			If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
				Set tresCount = tres.GetAt(1).Value
				If tresCount=0{
					Continue
				}else{
					For Indx = 1:1:tresCount{
						// 科室ID
						Set DepID=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/E0156","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set DepID = $tr(Value,$c(0),"")
						}
						// 科室
						Set DepDesc=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/E0077","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set DepDesc = $tr(Value,$c(0),"")
						}
						// 检验医嘱代码
						Set LabTestSetCode=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E01","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabTestSetCode = $tr(Value,$c(0),"")
						}
						// 检验医嘱名称
						Set LabTestSetDesc=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E02","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabTestSetDesc = $tr(Value,$c(0),"")
						}
						// 送检日期
						Set CollDate=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E03","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set CollDate = $tr(Value,$c(0),"")
						}
						// 送检时间
						Set CollTime=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E04","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set CollTime = $tr(Value,$c(0),"")
						}
						// 标本代码
						Set SpenCode=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E05","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set SpenCode = $tr(Value,$c(0),"")
						}
						// 标本名称
						Set SpenDesc=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E06","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set SpenDesc = $tr(Value,$c(0),"")
						}
						
						// 标本号
						Set LabEpisodeNo=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E07","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabEpisodeNo = $tr(Value,$c(0),"")
						}
						// 检验备注
						Set LabResume=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E08","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabResume = $tr(Value,$c(0),"")
						}
						// 送检医师代码
						Set CollDocCode=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E09","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set CollDocCode = $tr(Value,$c(0),"")
						}
						// 送检医师名称
						Set CollDocDesc=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E10","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set CollDocDesc = $tr(Value,$c(0),"")
						}
						// 检验日期/接收日期
						Set RecDate=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E11","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RecDate = $tr(Value,$c(0),"")
						}
						// 检验时间/接收时间
						Set RecTime=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E12","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RecTime = $tr(Value,$c(0),"")
						}
						// 检验日期/接收日期
						Set RecDate=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E11","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RecDate = $tr(Value,$c(0),"")
						}
						// 检验时间/接收时间
						Set RecTime=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E12","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RecTime = $tr(Value,$c(0),"")
						}
						// 检验者代码
						Set RecDocCode=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E13","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RecDocCode = $tr(Value,$c(0),"")
						}
						// 检验者姓名
						Set RecDocDesc=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E14","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RecDocDesc = $tr(Value,$c(0),"")
						}
						// 报告日期/录入日期
						Set RegDate=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E15","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RegDate = $tr(Value,$c(0),"")
						}
						// 报告时间/录入时间
						Set RegTime=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E16","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RegTime = $tr(Value,$c(0),"")
						}
						// 审核日期
						Set AuthDate=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E17","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set AuthDate = $tr(Value,$c(0),"")
						}
						// 审核时间
						Set AuthTime=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E18","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set AuthTime = $tr(Value,$c(0),"")
						}
						// 审核者代码
						Set AuthUserCode=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E19","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set AuthUserCode = $tr(Value,$c(0),"")
						}
						// 审核者姓名
						Set AuthUser=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E20","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set AuthUser = $tr(Value,$c(0),"")
						}
						// 报告备注
						Set RepResume=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E21","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set RepResume = $tr(Value,$c(0),"")
						}
						// 报告备注
						Set LabPurpose=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E22","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabPurpose = $tr(Value,$c(0),"")
						}
						// 检验结果
						Set LabResult=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E23","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabResult = $tr(Value,$c(0),"")
						}
						// 报告号
						Set LabRepNo=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E24","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set LabRepNo = $tr(Value,$c(0),"")
						}
						// 医嘱号
						Set TestSetRow=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E25","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set TestSetRow = $tr(Value,$c(0),"")
						}
						Set:TestSetRow'="" TestSetRow=$p(TestSetRow,"_",1)_"||"_$p(TestSetRow,"_",2)
						
						// 报告科室代码
						Set ReportDepCode=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E26","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set ReportDepCode = $tr(Value,$c(0),"")
						}
						// 报告科室
						Set ReportDepDesc=""
						Set tsc = tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E27","text()",.tres)
						If ($$$ISOK(tsc)&&(tres.GetAt(1)'="")) {
							Set Value = tres.GetAt(1).Value
							Set ReportDepDesc = $tr(Value,$c(0),"")
						}
						
						Set LabTestSetStr = ..BuildVisitNumber(LabTestSetDesc,TestSetRow)
						
						// 存储标本信息
						Set rowData=##Class(%ArrayOfDataTypes).%New()
						If rowData'="" Do rowData.%Close()
					    Do rowData.Clear()  //清空数组
					    Do rowData.SetAt(LabEpisodeNo,"VisitNumberID")
					    Do rowData.SetAt(aEpisodeID,"EpisodeID")
						Do rowData.SetAt(EpisodeDr,"EpisodeDr")
					    Do rowData.SetAt(LabEpisodeNo,"EpisodeNo")
					    Do rowData.SetAt(SpenCode,"SpecCode")
					    Do rowData.SetAt(SpenDesc,"SpecDesc")
					    Do rowData.SetAt(ReportDepCode,"LocCode")
					    Do rowData.SetAt(ReportDepDesc,"LocDesc")
					    Do rowData.SetAt(CollDate,"CollDate")
					    Do rowData.SetAt(CollTime,"CollTime")
					    Do rowData.SetAt(CollDocCode,"CollUserCode")
					    Do rowData.SetAt(CollDocDesc,"CollUserName")
					    Do rowData.SetAt(RecDate,"RecDate")
					    Do rowData.SetAt(RecTime,"RecTime")
					    Do rowData.SetAt(RecDocCode,"RecUserCode")
					    Do rowData.SetAt(RecDocDesc,"RecUserName")
					    Do rowData.SetAt("","WardCode")
					    Do rowData.SetAt("","WardDesc")
					    Do rowData.SetAt(LabTestSetStr,"TestSetStr")
					    Set IsActive=1 //是否有效
					    Do rowData.SetAt(IsActive,"IsActive")
					    
						//保存标本记录
						Set VisitNumberDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitNumber(rowData,aSCode)
						Continue:(+VisitNumberDr)<1
						Do rowData.SetAt(VisitNumberDr,"VisitNumberDr")
						//保存检验医嘱
						Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitTestSet(rowData,aSCode)
					    // 存储报告信息
					    Set rowData=##Class(%ArrayOfDataTypes).%New()
						If rowData'="" Do rowData.%Close()
					    Do rowData.Clear()  //清空数组
					    Do rowData.SetAt(LabEpisodeNo,"VisitNumberID")
					    Do rowData.SetAt(aEpisodeID,"EpisodeID")
						Do rowData.SetAt(EpisodeDr,"EpisodeDr")
					    Do rowData.SetAt(LabEpisodeNo,"EpisodeNo")
					    Do rowData.SetAt(SpenCode,"SpecCode")
					    Do rowData.SetAt(SpenDesc,"SpecDesc")
					    Do rowData.SetAt(ReportDepCode,"LocCode")
					    Do rowData.SetAt(ReportDepDesc,"LocDesc")
					    Do rowData.SetAt(CollDate,"CollDate")
					    Do rowData.SetAt(CollTime,"CollTime")
					    Do rowData.SetAt(CollDocCode,"CollUserCode")
					    Do rowData.SetAt(CollDocDesc,"CollUserName")
					    Do rowData.SetAt(RecDate,"RecDate")
					    Do rowData.SetAt(RecTime,"RecTime")
					    Do rowData.SetAt(RecDocCode,"RecUserCode")
					    Do rowData.SetAt(RecDocDesc,"RecUserName")
					    Do rowData.SetAt("","WardCode")
					    Do rowData.SetAt("","WardDesc")
					    Do rowData.SetAt(LabTestSetStr,"TestSetStr")
					    Do rowData.SetAt(LabRepNo,"ReportID")
					    Do rowData.SetAt(TestSetRow,"TestSetRow")
					    Do rowData.SetAt(1,"Order")
					    Do rowData.SetAt("审核","RepStatus")
					    Do rowData.SetAt(RegDate,"RegDate")
					    Do rowData.SetAt(RegTime,"RegTime")
					    Do rowData.SetAt("","RegUserCode")
					    Do rowData.SetAt("","RegUserName")
					    Do rowData.SetAt(AuthDate,"AuthDate")
					    Do rowData.SetAt(AuthTime,"AuthTime")
					    Do rowData.SetAt(AuthUserCode,"AuthUserCode")
					    Do rowData.SetAt(AuthUser,"AuthUserName")
					    Do rowData.SetAt(1,"IsActive")  //是否有效
					    
						//标本记录检查
						Set XCode=rowData.GetAt("VisitNumberID")
						Set VisitNumberDr=""
						Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjByXCode(aSCode,XCode)
						If $IsObject(objVisitNumber){
							Set VisitNumberDr=objVisitNumber.%Id()
						} Else {
							//保存标本记录
							Set VisitNumberDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitNumber(rowData,aSCode)
							Continue:(+VisitNumberDr)<1
						}
						Continue:(+VisitNumberDr)<1
						Do rowData.SetAt(VisitNumberDr,"VisitNumberDr")
						
						//保存检验医嘱
						Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitTestSet(rowData,aSCode)
						
						//保存检验报告
						Set ReportDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitReport(rowData,aSCode)
						Continue:(+ReportDr)<1
						Set Count = Count+1
						
						// 区别普通报告和微生物报告
						Set RepType=""
						set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]","count(section[@code='S0063'])",.tres)
						if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){		
							set IsMcRep=tres.GetAt(1).Value
							if IsMcRep{
								Set RepType = "V"
								Set Identifition=""		//鉴定结果
								set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/E23","text()",.tres)					
								if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
									set Value=tres.GetAt(1).Value
									set Identifition=$tr(Value,$c(0),"")
								}
							}
						}
						If RepType="V"{	// 微生物报告
							set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]","count(section[@code='S0063'])",.tres)
							if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){		
								Set tResultCount = tres.GetAt(1).Value
								If tResultCount'=0{
									For IndR = 1:1:tResultCount {
										Set BactCode=""		// 细菌代码
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/E01","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set BactCode=$tr(Value,$c(0),"")
										}
										// 细菌名称
										Set BactDesc=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/E02","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set BactDesc=$tr(Value,$c(0),"")
										}
										// 细菌计数
										Set BactCount=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/E03","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set BactCount=$tr(Value,$c(0),"")
										}
										// 专家规则（多耐结果？）
										Set MDRResult=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/E04","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set MDRResult=$tr(Value,$c(0),"")
										}
										// 备注
										Set VResume=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/E05","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set VResume=$tr(Value,$c(0),"")
										}
										// 保存检验结果
										// 取检验医嘱与HIS医嘱
										Set TestSetStr=""
										Set TestSetInfo=..GetVisitTestSet(LabTestSetDesc,TestSetRow)
										For indTS=1:1:$ll(TestSetInfo) {
											Set tData=$listget(TestSetInfo,indTS)
											Continue:tData=""
											Set TSCode=$listget(tData,2)
											Set TSDesc=$listget(tData,3)
											Continue:TSDesc=""
											Set ArcimCode=$listget(tData,4)
											Set ArcimDesc=$listget(tData,5)
											Set HISOrderID=$listget(tData,7)
											Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
											Quit
										}
										Set TSCode=$p(TestSetStr,"^",1)     //TSCode
										Set TSDesc=$p(TestSetStr,"^",2)     //TSDesc
										Set ArcimCode=$p(TestSetStr,"^",3)  //ArcimCode
										Set ArcimDesc=$p(TestSetStr,"^",4)  //ArcimDesc
										Set TestSetData=TSDesc_$c(1)_ArcimDesc
										
										Set ResultInfo=""
										Set $p(ResultInfo,"^",1)=ReportDr
										Set $p(ResultInfo,"^",2)=LabTestSetDesc   //TCCode
										Set $p(ResultInfo,"^",3)=LabTestSetDesc   //TCDesc
										Set $p(ResultInfo,"^",4)="M"   //RstFormat
										Set $p(ResultInfo,"^",5)=BactDesc   //Result
										Set $p(ResultInfo,"^",6)=BactDesc   //TextRes
										Set $p(ResultInfo,"^",7)=VResume   //ResNoes
										Set $p(ResultInfo,"^",8)=""   //AbFlag
										Set $p(ResultInfo,"^",9)=""   //Unit
										Set $p(ResultInfo,"^",10)="" //RefRanges
										Set $p(ResultInfo,"^",11)=MDRResult //MDRResult
										Set $p(ResultInfo,"^",12)=TestSetData           //TestSetData
										Set $p(ResultInfo,"^",13)=EpisodeDr             //EpisodeDr
										Set ResultDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepResult(ResultInfo,aSCode)
										
										Continue:(+ResultDr)<1
										// 药敏信息
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]","count(section[@code='S0064'])",.tres)
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){		
											Set tSenCount = tres.GetAt(1).Value
											If tSenCount'=0{
												For Inds = 1:1:tSenCount{
													// 抗生素代码
													Set AntCode=""
													set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/section[@code='S0064']["_Inds_"]/E01","text()",.tres)					
													if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
														set Value=tres.GetAt(1).Value
														set AntCode=$tr(Value,$c(0),"")
													}
													// 抗生素
													Set AntDesc=""
													set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/section[@code='S0064']["_Inds_"]/E02","text()",.tres)					
													if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
														set Value=tres.GetAt(1).Value
														set AntDesc=$tr(Value,$c(0),"")
													}
													// 药敏结果代码
													Set SensitivityCode=""
													set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/section[@code='S0064']["_Inds_"]/E04","text()",.tres)					
													if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
														set Value=tres.GetAt(1).Value
														set SensitivityCode=$tr(Value,$c(0),"")
													}
													// 药敏结果
													Set Sensitivity=""
													set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0063']["_IndR_"]/section[@code='S0064']["_Inds_"]/E05","text()",.tres)					
													if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
														set Value=tres.GetAt(1).Value
														set Sensitivity=$tr(Value,$c(0),"")
													}
													//保存药敏试验结果
													Set TestSenInfo=""
													Set $p(TestSenInfo,"^",1)=ResultDr
													Set $p(TestSenInfo,"^",2)=AntCode   //AntCode
													Set $p(TestSenInfo,"^",3)=AntDesc   //AntDesc
													Set $p(TestSenInfo,"^",4)=Sensitivity   //SenDesc
													Set $p(TestSenInfo,"^",5)=EpisodeDr               //EpisodeDr
													Set TestSenDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepRstSen(TestSenInfo,aSCode)
													Continue:(+TestSenDr)<1
												}
											}
										}
									}
								}
							}
						}else{		// 普通报告
							set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]","count(section[@code='S0062'])",.tres)
							if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){		
								Set tResultCount = tres.GetAt(1).Value
								If tResultCount'=0{
									For IndR = 1:1:tResultCount {
										// 检验项目代码
										Set LabTestCode=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E01","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set LabTestCode=$tr(Value,$c(0),"")
										}
										// 检验项目
										Set LabTestDesc=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E02","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set LabTestDesc=$tr(Value,$c(0),"")
										}
										// 定量结果
										Set Result=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E03","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set Result=$tr(Value,$c(0),"")
										}
										// 结果单位
										Set Unit=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E04","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set Unit=$tr(Value,$c(0),"")
										}
										// 定性结果
										Set TextRes=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E05","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set TextRes=$tr(Value,$c(0),"")
										}
										// 参考值范围
										Set RefRanges=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E06","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set RefRanges=$tr(Value,$c(0),"")
										}
										// 异常标志
										Set AbFlag=""
										set tsc=tReport.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_Indx_"]/section[@code='S0062']["_IndR_"]/E07","text()",.tres)					
										if ($$$ISOK(tsc)&&(tres.GetAt(1)'="")){					
											set Value=tres.GetAt(1).Value
											set AbFlag=$tr(Value,$c(0),"")
										}
										// 保存检验结果
										Set TestSetData=""  ///TODO
										Set ResultInfo=""
										Set $p(ResultInfo,"^",1)=ReportDr
										Set $p(ResultInfo,"^",2)=LabTestCode   //TCCode
										Set $p(ResultInfo,"^",3)=LabTestDesc   //TCDesc
										Set $p(ResultInfo,"^",4)="T"   //RstFormat
										Set $p(ResultInfo,"^",5)=Result   //Result
										Set $p(ResultInfo,"^",6)=TextRes   //TextRes
										Set $p(ResultInfo,"^",7)=""   //ResNoes
										Set $p(ResultInfo,"^",8)=AbFlag   //AbFlag
										Set $p(ResultInfo,"^",9)=Unit   //Unit
										Set $p(ResultInfo,"^",10)=RefRanges //RefRanges
										Set $p(ResultInfo,"^",11)="" //MDRResult
										Set $p(ResultInfo,"^",12)=TestSetData           //TestSetData
										Set $p(ResultInfo,"^",13)=EpisodeDr             //EpisodeDr
										Set ResultDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepResult(ResultInfo,aSCode)
										Continue:(+ResultDr)<1
									}
								}
							}
						}
						Set Count = Count+1
					}
				}
			}
		}
	}
	Quit Count
}

/// Creator：      liyi
/// CreatDate：    2018-08-27
/// Description:   查询检验字典xml
/// Input：        DicName：平台约定的固定参数，目前就只有"CTAntibiotics，CTLisItem"
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DWS.GetLisXml","GetLisDic","CTAntibiotics")
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DWS.GetLisXml","GetLisDic","CTLisItem") 
Query GetLisDic(aDicName As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetLisDicExecute(ByRef qHandle As %Binary, aDicName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	Quit:aDicName="" $$$OK
 	
 	set AntiDic = ##class(web.DHCENS.BLL.Empi.Method.GetReportInfo).GetLabDict(aDicName,"")
	Set sc =##class(%XML.TextReader).ParseStream(AntiDic,.reader)
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Write "打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Quit $$$OK
	}
	Do reader.Rewind()
	Set DicCount=0
	Kill ArrayDic
	While (reader.Read()) {
		Set (Code,Name)=""
		If (reader.NodeType="element") {
			Set node=reader.Name
			if node = "DictItems"{
				s DicCount = DicCount+1
			}
		}elseif (reader.NodeType="chars"){
			if reader.Path["DictItems"{
				if reader.Value'=""{
					Set ArrayDic(DicCount,reader.Path)=reader.Value
				}
			}
		}
		
	}
	For xind=1:1:DicCount{
		Set DicCode ="",DicDesc=""
		Set xPath=""
		For {
			Set xPath=$o(ArrayDic(xind,xPath))
			Quit:xPath=""
			
			If xPath["ItemCode"{
				Set DicCode = $g(ArrayDic(xind,xPath))
			}
			If xPath["ItemName"{
				Set DicDesc = $g(ArrayDic(xind,xPath))
			}
		}
		if ((DicCode="")&&(DicDesc="")) Continue
		Set xID = DicCode  // DicCode is ID
		Set IsActive =1			// IsActive default is 1
		set Data=$lb(xID,DicCode,DicDesc,IsActive)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Kill ArrayDic
	
	Quit $$$OK
}

ClassMethod GetLisDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLisDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisDicExecute ]
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

/// Creator：      liyi
/// CreatDate：    2018-08-27
/// Description:   查询单个就诊检验报告列表
/// Input：        aPatientID, aEpisodeID, aDateFrom, aDateTo
/// Output：       平台组文档ID
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DWS.GetLisXml","QryLabVisitReport","0000525915","95585","","")
Query QryLabVisitReport(aPatientID As %String, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "DocumentID:%String,DocTypeDesc:%String,DocTypeCode:%String")
{
}

ClassMethod QryLabVisitReportExecute(ByRef qHandle As %Binary, aPatientID As %String, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	Quit:(aEpisodeID="")||(aPatientID="") $$$OK
 	
 	Set:(aDateFrom'="")&&(aDateFrom'["-") aDateFrom=$zd(aDateFrom,3)
 	Set:(aDateTo'="")&&(aDateTo'["-") aDateTo=$zd(aDateTo,3)
 	
 	// 普通检验报告
	Set InputXml="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode>XJZZQZYYY</HospitalCode>"
	Set InputXml=InputXml_"<PATPatientID>"_aPatientID_"</PATPatientID>"
	Set InputXml=InputXml_"<PAADMVisitNumber>"_aEpisodeID_"</PAADMVisitNumber>"
	Set InputXml=InputXml_"<DocumentType>01</DocumentType>"
	Set InputXml=InputXml_"<StartDate>"_aDateFrom_"</StartDate>"
	Set InputXml=InputXml_"<EndDate>"_aDateTo_"</EndDate>"
	Set InputXml=InputXml_"<DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	
	// xml字符转换为xml对象
	Set xmlStream=##class(%GlobalCharacterStream).%New()
  	Do xmlStream.Rewind()
	Do xmlStream.Write(InputXml)
	Do xmlStream.%Close()
	// 调用平台接口
	Set DocumentRetrieval=##class(web.DHCENS.BLL.Empi.Method.GetReportInfo).DocumentRetrieval(xmlStream)
	Set sc =##class(%XML.TextReader).ParseStream(DocumentRetrieval,.reader)
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Write "打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Quit $$$OK
	}
	Do reader.Rewind()
	Set Count=0
	Set DiagCount=0
	While (reader.Read()) {
		if (reader.NodeType="chars"){
			if reader.Path["DocumentID"{
				if reader.Value'=""{
					Set DocumentID =reader.Value
					set Data=$lb(DocumentID,"检验结果","01")
			 		Set ^CacheTemp(repid,ind)=Data
			 		Set ind=ind+1
				}
			}
		}
	}
	// 微生物检验报告
	Set InputXml="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode>XJZZQZYYY</HospitalCode>"
	Set InputXml=InputXml_"<PATPatientID>"_aPatientID_"</PATPatientID>"
	Set InputXml=InputXml_"<PAADMVisitNumber>"_aEpisodeID_"</PAADMVisitNumber>"
	Set InputXml=InputXml_"<DocumentType>15</DocumentType>"
	Set InputXml=InputXml_"<StartDate>"_aDateFrom_"</StartDate>"
	Set InputXml=InputXml_"<EndDate>"_aDateTo_"</EndDate>"
	Set InputXml=InputXml_"<DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	
	// xml字符转换为xml对象
	Set xmlStream=##class(%GlobalCharacterStream).%New()
  	Do xmlStream.Rewind()
	Do xmlStream.Write(InputXml)
	Do xmlStream.%Close()
	// 调用平台接口
	Set DocumentRetrieval=##class(web.DHCENS.BLL.Empi.Method.GetReportInfo).DocumentRetrieval(xmlStream)
	Set sc =##class(%XML.TextReader).ParseStream(DocumentRetrieval,.reader)
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Write "打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Quit $$$OK
	}
	Do reader.Rewind()
	Set Count=0
	Set DiagCount=0
	While (reader.Read()) {
		if (reader.NodeType="chars"){
			if reader.Path["DocumentID"{
				if reader.Value'=""{
					Set DocumentID =reader.Value
					set Data=$lb(DocumentID,"微生物结果","15")
			 		Set ^CacheTemp(repid,ind)=Data
			 		Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryLabVisitReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryLabVisitReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
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

/// Creator：      liyi
/// CreatDate：    2018-08-27
/// Description:   查询检验报告列表
/// Input：        aPatientID, aEpisodeID, aDateFrom, aDateTo
/// Output：       平台组文档ID
/// d ##class(DHCHAI.DI.DWS.GetLisXml).GetRepResult("0000399435","95029","01","2298966")
ClassMethod GetRepResult(aPatientID As %String, aEpisodeID As %String, aDocTypeCode As %String, aDocumentID As %String) As %GlobalCharacterStream
{
	New (aDocTypeCode,aDocumentID,aEpisodeID,aPatientID)
	Set return=""
	Quit:(aDocTypeCode="")||(aDocumentID="")||(aEpisodeID="")||(aPatientID="") return
	
	Set InputXml="<Request><Header><SourceSystem>DHEMR</SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode>XJZZQZYYY</HospitalCode>"
	Set InputXml=InputXml_"<PATPatientID>"_aPatientID_"</PATPatientID>"
	Set InputXml=InputXml_"<PAADMVisitNumber>"_aEpisodeID_"</PAADMVisitNumber>"
	Set InputXml=InputXml_"<DocumentType>"_aDocTypeCode_"</DocumentType>"
	Set InputXml=InputXml_"<DocumentID>"_aDocumentID_"</DocumentID>"
	Set InputXml=InputXml_"</DocumentSearchRt></Body></Request>"
	// xml字符转换为xml对象
	Set xmlStream=##class(%GlobalCharacterStream).%New()
  	Do xmlStream.Rewind()
	Do xmlStream.Write(InputXml)
	Do xmlStream.%Close()
	// 调用平台接口
	Set HOSDocumentSearch=##class(web.DHCENS.BLL.Empi.Method.GetReportInfo).HOSDocumentSearch(xmlStream)
	Set sc =##class(%XML.TextReader).ParseStream(HOSDocumentSearch,.reader)
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Write "打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Quit ""
	}
	Do reader.Rewind()
	Quit HOSDocumentSearch
}

/// Creator：     liyi
/// CreatDate：   2018-08-21
/// Description:  组织Query输出标本记录
/// Input：       aVisitNumberID : 标本ID
/// Return：      返回List
ClassMethod BuildVisitNumber(TSDesc As %String, HISOrdItemDr As %String, ByRef errMsg As %String = "") As %List
{
	New (TSDesc,HISOrdItemDr,errMsg)
	Set return=""
	Quit:(TSDesc="") return
	
	Set $ZT="BuildVisitNumberErr"
	//取检验医嘱与HIS医嘱
	Set TestSetStr=""
	Set TestSetInfo=..GetVisitTestSet(TSDesc,HISOrdItemDr)

	For indTS=1:1:$ll(TestSetInfo) {
		Set tData=$listget(TestSetInfo,indTS)
		Continue:tData=""
		Set TSCode=$listget(tData,2)
		Set TSDesc=$listget(tData,3)
		Set ArcimCode=$listget(tData,4)
		Set ArcimDesc=$listget(tData,5)
		If TestSetStr="" {
			Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		} Else {
			Set TestSetStr=TestSetStr_"!!"_TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		}
	}
	Quit:TestSetStr="" return
	
	Set return=TestSetStr
	Quit return
	
BuildVisitNumberErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-08-21
/// Description:  通过标本ID取检验医嘱信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
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

/// 以下是测试程序************************************************************************
/// d ##class(DHCHAI.DI.DWS.GetLisXml).test()
ClassMethod test()
{
	Set arrEpisodeID=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate("2018-08-01","2018-08-07")
	Set Count=arrEpisodeID.Count()
	For indEpis=1:1:Count {
		Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
		Continue:xEpisodeID=""
		w ##class(DHCHAI.DI.DWS.GetLisXml).SyncLabRepByDate("LIS01",xEpisodeID,"2018-08-01","2018-08-07"),!
	}
}

/// w ##class(DHCHAI.DI.DWS.GetLisXml).ReadXMLString("CTAntibiotics")
ClassMethod ReadXMLString(aDicName As %String)
{
	set AntiDic = ##class(web.DHCENS.BLL.Empi.Method.GetReportInfo).GetLabDict(aDicName,"")
	Set sc =##class(%XML.TextReader).ParseStream(AntiDic,.reader)
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Write "打开XML文件失败,请检查文件是否为格式良好的XML文件!",!
		Set return=$Lb("")
		Quit return
	}
	Do reader.Rewind()
	Set Count=0
	Set DiagCount=0
	Kill ArrayDic
	While (reader.Read()) {
		Set (Code,Name)=""
		If (reader.NodeType="element") {
			Set node=reader.Name
			if node = "DictItems"{
				s Count = Count+1
			}
		}elseif (reader.NodeType="chars"){
			if reader.Path["DictItems"{
				if reader.Value'=""{
					Set ArrayDic(Count,reader.Path)=reader.Value
				}
			}
		}
		
	}
	For xind=1:1:Count{
		Set DicCode ="",DicName=""
		Set xPath=""
		For {
			Set xPath=$o(ArrayDic(xind,xPath))
			Quit:xPath=""
			
			If xPath["ItemCode"{
				Set DicCode = $g(ArrayDic(xind,xPath))
			}
			If xPath["ItemName"{
				Set DicName = $g(ArrayDic(xind,xPath))
			}
		}
		if ((DicCode="")&&(DicName="")) Continue
	}
	Kill ArrayDic
	Quit Count
}

}
