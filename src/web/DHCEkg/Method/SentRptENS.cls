Class web.DHCEkg.Method.SentRptENS Extends %RegisteredObject
{

/// Creator：      yangyali
/// CreatDate：    2022-6-23
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   job方式调用
/// 					发布报告时调用平台接口发送检查报告
/// Table：       
/// Input：        医嘱号
/// Output：       调用结果
/// w ##class(web.DHCEkg.Method.SentRptENS).SentReportDelay("699||178")
ClassMethod SentReportJob(OrdId) As %String
{
	job ..SentReportDelay(OrdId)
	q ""
}

/// Creator：      yangyali
/// CreatDate：    2022-6-23
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   延迟调用，防止filepath未保存的情况
/// 					发布报告时调用平台接口发送检查报告
/// Table：       
/// Input：        医嘱号
/// Output：       调用结果
/// w ##class(web.DHCEkg.Method.SentRptENS).SentReportDelay("32061481||29")
ClassMethod SentReportDelay(OrdId) As %String
{
	h 60
	s rtnSendRpt=..SentReport(OrdId)
	q rtnSendRpt
}

/// Creator：      yangyali
/// CreatDate：    2019-9-20
/// ModifyDate：   2019-9-20
/// ModifyDesc：   
/// Description:   发布报告时调用平台接口发送检查报告
/// Table：       
/// Input：        医嘱号
/// Output：       调用结果
/// w ##class(web.DHCEkg.Method.SentRptENS).SentReport("586||116")
/// w ##class(web.DHCEkg.Method.SentRptENS).SentReport("30971616||34")
/// w ##class(web.DHCEkg.Method.SentRptENS).SentReport("34665230||19")
ClassMethod SentReport(OrdId) As %String
{
	s $zt="GetErroMSG"
	s ^DHCEKGYYL("SentReport")=OrdId
	s rtnSent=""
	s jsonStr=##class(%GlobalCharacterStream).%New()
	;s infoStr=""
	d GetExamInfo
	b ; zw jsonStr
	i (jsonStr.Size>1)
	{
		;b ; w 
		//记录日志，便于追踪
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.Method.SentRptENS","SentReport",
			$zd($h,3),$zt($p($h,",",2),1)_"."_$p($Now(),".",2),jsonStr.Read(),"Json")
		d jsonStr.Rewind()
		s rtnStream=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendRISReport",jsonStr)
		b ;w rtnStream
		if ($IsObject(rtnStream)) s rtnSent=rtnStream.Read()
		else  s rtnSent=rtnStream
	}
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.Method.SentRptENS","SentReport",
			$zd($h,3),$zt($p($h,",",2),1)_"."_$p($Now(),".",2),rtnSent,"Rtn")
		s ^DHCEKGYYL("SentReport","rtn")=rtnSent
	q rtnSent
GetExamInfo
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s (RptID,ExamNo,PatNo,AdmNo,ReportDocCode,ReportDate,ReportTime,ArbiterDocCode,ArbiterDate,ArbiterTime)=""
	s (ExamDate,ExamTime,ExamDocCode,ExamDocName)=""
	s (ExamItem,ExamDesc,Diagnosis,Print,ReportDocName,ArbiterDocName,ImgUrl,PdfUrl,IsPositive)=""
	s (ItemCode,ItemDesc,Result,Ranges,High,Low,Unit)=""
	s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_OrdId,""))
	i reqId'=""
	{
		s examId=""
		s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId))
		while(examId'="")
		{
			s examInfo=$g(^dbo.tblExaminationD(examId))
			s statuscode=$listget(examInfo,20,"")
			i (statuscode="15")!(statuscode="17") ;审核状态
			{
				s reqInfo=$g(^dbo.tblRequestD(reqId))
				s examModel=$listget(reqInfo,26,"")
				i examModel'="手动检查"
				{
					s patId=$listget(reqInfo,16,"")
					s patInfo=$g(^dbo.tblPatientD(patId))
					s RptID="EKG"_examId ;加EKG前缀
					s ExamNo="EKG||"_OrdId
					s PatNo=$listget(patInfo,20,"")
					s AdmNo=$listget(reqInfo,3,"")
					s examItemCode=$listget(reqInfo,11,"")
					s examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_examItemCode,""))
					s examItemInfo=$g(^dbo.tblDictExamItemD(examItemId))
					s ExamItem=$listget(examItemInfo,6,"")
					s ExamDesc=$lg(examInfo,32)
					s IsPositive="N"
					s positive=$listget(examInfo,30,"")
					i (positive="阳性") s IsPositive="Y"
					s Diagnosis=$listget(examInfo,11,"")
					i Diagnosis'[$c(10) s Diagnosis=Diagnosis_$c(10) 
					s D=""
					s i=1
					while(i<=$l(Diagnosis,$c(10)))
					{
						s tmpD=$p(Diagnosis,$c(10),i)
						i (tmpD'="")
						{
							i (D="") s D=tmpD
							else  s D=D_","_tmpD
						}
						s i=i+1
					}
					set Diagnosis=D
					i (Diagnosis="") s Diagnosis="详见报告"
					i (ExamDesc="") s ExamDesc=Diagnosis
					i (ExamDesc="") s ExamDesc=Diagnosis
					b ; w (ExamDesc[$c(34))
					i (Diagnosis["""") s Diagnosis=$replace(Diagnosis,"""","\""")
					i (ExamDesc["""") s ExamDesc=$replace(ExamDesc,"""","\""")
					s Diagnosis=$replace(Diagnosis,":","：")
					s ExamDesc=$replace(ExamDesc,":","：")
					s printTime=$listget(examInfo,16,"")
					i printTime'="9999-12-31 23:59:59"
					{
						s Print="是"
					}
					//s ekgReportTime=$listget(examInfo,17,"")
					s ekgReportTime=$listget(examInfo,6,"")
					s ekgArbiterTime=$listget(examInfo,6,"")
					s ekgOperateTime=$listget(examInfo,13,"")
					//i ekgReportTime="9999-12-31 23:59:59" s ekgReportTime=ekgArbiterTime
					s ReportDate=$p(ekgReportTime," ",1)
					s ReportTime=$p(ekgReportTime," ",2)
					s ArbiterDate=$p(ekgArbiterTime," ",1)
					s ArbiterTime=$p(ekgArbiterTime," ",2)
					s ExamDate=$p(ekgOperateTime," ",1)
					s ExamTime=$p(ekgOperateTime," ",2)
					s operaterId=$listget(examInfo,14,"")
					//s reporterId=$listget(examInfo,18,"")
					s reporterId=$listget(examInfo,7,"")
					s arbiterId=$listget(examInfo,7,"")
					i reporterId="" s reporterId=arbiterId
					s operaterInfo=$g(^dbo.tblUserD(operaterId))
					s reporterInfo=$g(^dbo.tblUserD(reporterId))
					s arbiterInfo=$g(^dbo.tblUserD(arbiterId))
					s ExamDocCode=$listget(operaterInfo,8,"")
					s ExamDocName=$listget(operaterInfo,11,"")
					s ReportDocCode=$listget(reporterInfo,8,"")
					s ReportDocName=$listget(reporterInfo,11,"")
					s ArbiterDocCode=$listget(arbiterInfo,8,"")
					s ArbiterDocName=$listget(arbiterInfo,11,"")
					;b ;111
					s devId=$listget(examInfo,10,"")
	
					s devInfo=$g(^dbo.tblDeviceD(devId))
					s testTypeId=$listget(devInfo,3,"")
					s httpUrl=""			
					s configId=$o(^dbo.tblConfigureI("idxKey"," FTPHTTPURL",""))					
					i (configId'="") 
					{
						s configInfo=^dbo.tblConfigureD(configId)
						i (configInfo'="") s httpUrl=$listget(configInfo,6,"")
					}
					;b ; w testTypeId
					i (testTypeId="1")
					{
						;静息类设备，取所有数据记录
						s filepathId=""
						s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId))
						while (filepathId'="")
						{
							s filepathInfo=$g(^dbo.tblFilePathD(filepathId))
							s pdfPath=$listget(filepathInfo,6,"")
							i (pdfPath'="")
							{
								s pdfPath=$replace(pdfPath,".jpg",".pdf")
								s pdfPath=httpUrl_pdfPath
								i (PdfUrl'="") s PdfUrl=PdfUrl_"#"_pdfPath
								e  s PdfUrl=pdfPath								
							}
							s imgId=""
							s imgId=$o(^dbo.tblImgReportI("idxFilePathID",filepathId,imgId))
							while (imgId'="")
							{
								s imgInfo=^dbo.tblImgReportD(imgId)
								s ekgIsValid=$lg(imgInfo,9)
								i (ekgIsValid'="1")
								{
									s imgPath=$listget(imgInfo,6,"")
									i (imgPath'="")
									{
										s imgPath=httpUrl_imgPath
										i (ImgUrl'="") s ImgUrl=ImgUrl_"#"_imgPath
										e  s ImgUrl=imgPath
										q:(ImgUrl'="")
									}
								}
								s imgId=$o(^dbo.tblImgReportI("idxFilePathID",filepathId,imgId))
							}
							s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId))
						}
					}
					else
					{
						;非静息类，只取最新的一条数据
						s filepathId=""
						s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId))
						s avlFilepathId="" ;有效数据
						while (filepathId'="")
						{
							s avlFilepathId=filepathId
							s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId))
						}
					
						i (avlFilepathId'="")
						{
							s filepathInfo=$g(^dbo.tblFilePathD(avlFilepathId))
							s pdfPath=$listget(filepathInfo,6,"")
							i (pdfPath'="")
							{
								s pdfPath=$replace(pdfPath,".jpg",".pdf")
								s pdfPath=httpUrl_pdfPath
								s PdfUrl=pdfPath								
							}
							s imgId=""
							s imgId=$o(^dbo.tblImgReportI("idxFilePathID",avlFilepathId,imgId))
							while (imgId'="")
							{
								s imgInfo=^dbo.tblImgReportD(imgId)
								s ekgIsValid=$lg(imgInfo,9)
								i (ekgIsValid'="1")
								{
									s imgPath=$listget(imgInfo,6,"")
									i (imgPath'="")
									{
										s imgPath=httpUrl_imgPath
										i (ImgUrl'="") s ImgUrl=ImgUrl_"#"_imgPath
										e  s ImgUrl=imgPath
										q:(ImgUrl'="")
									}
								}
								s imgId=$o(^dbo.tblImgReportI("idxFilePathID",avlFilepathId,imgId))
							}
						}
					}
					;b ; 333
					s hrInfo=..getHRRangeInfo(examId)
					b ; w hrInfo
					d jsonStr.Write("[{""RISR_ReportID"":"""_RptID_""",""RISR_ExamID"":"""_ExamNo_""",")
					d jsonStr.Write("""RISR_OrderItemID"":"""_OrdId_""",""RISR_PatientID"":"""_PatNo_""",")
					d jsonStr.Write("""RISR_VisitNumber"":"""_AdmNo_""",""RISR_SysCode"":""EKG"",")
					d jsonStr.Write("""RISR_ReportDocCode"":"""_ReportDocCode_""",""RISR_ReportDate"":"""_ReportDate_""",")
					d jsonStr.Write("""RISR_ReportTime"":"""_ReportTime_""",""RISR_CheckDocCode"":"""_ExamDocCode_""",")
					d jsonStr.Write("""RISR_CheckDate"":"""_ExamDate_""",""RISR_CheckTime"":"""_ExamTime_""",")
					d jsonStr.Write("""RISR_FinalCheckDocCode"":"""_ArbiterDocCode_""",")
					d jsonStr.Write("""RISR_FinalCheckDate"":"""_ArbiterDate_""",")
					d jsonStr.Write("""RISR_FinalCheckTime"":"""_ArbiterTime_""",")
					d jsonStr.Write("""RISR_ItemDesc"":"""_ExamItem_""",")
					d jsonStr.Write("""RISR_BACode"":"""","_"""RISR_BADesc"":"""","_"""RISR_Method"":"""",")
					d jsonStr.Write("""RISR_ExamDesc"":"""_ExamDesc_""",")
					d jsonStr.Write("""RISR_DiagDesc"":"""_Diagnosis_""",")
					d jsonStr.Write("""RISR_ACRCode"":"""","_"""RISR_AdviseDesc"":"""",")
					d jsonStr.Write("""RISR_IsGet"":"""_Print_""",")
					d jsonStr.Write("""UpdateDate"":"""_$p($zdt($h,3)," ",1)_""",")
					d jsonStr.Write("""UpdateTime"":"""_$p($zdt($h,3)," ",2)_""",")
					d jsonStr.Write("""RISR_ReportDocDesc"":"""_ReportDocName_""",")
					d jsonStr.Write("""RISR_CheckDocDesc"":"""_ExamDocName_""",")
					d jsonStr.Write("""RISR_FinalCheckDocDesc"":"""_ArbiterDocName_""",")
					d jsonStr.Write("""RISR_OrderItemDesc"":""1"",")
					d jsonStr.Write("""RISR_ImageSrc"":"""_ImgUrl_""",")
					d jsonStr.Write("""RISR_ReportImageSrc"":"""_PdfUrl_""",")
					d jsonStr.Write("""RISR_WarnCode"":"""_""",")
					d jsonStr.Write("""RISR_Status"":""1"",")
					d jsonStr.Write("""RISR_IsPositive"":"""_IsPositive_""",")
					 
					d jsonStr.Write(hrInfo)  
					;d jsonStr.Write("""RISItemResult"":[{")
					;d jsonStr.Write("""RISIR_ItemCode"":"""_ItemCode_""",")
					;d jsonStr.Write("""RISIR_ItemDesc"":"""_ItemDesc_""",")
					;d jsonStr.Write("""RISIR_Result"":"""_Result_""",")
					;d jsonStr.Write("""RISIR_Ranges"":"""_Ranges_""",")
					;d jsonStr.Write("""RISIR_High"":"""_High_""",")
					;d jsonStr.Write("""RISIR_Low"":"""_Low_""",")
					;d jsonStr.Write("""RISIR_Unit"":"""_Unit_"""")
					;d jsonStr.Write("}]}]")
					d jsonStr.Write("}]")
				}
			}
			s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId))
		}
	}
	zn "dhc-app"
	;b ; q examInfo
	q
GetErroMSG
	s $zt=""
	b ; w $ze	
	Set ErrorMsg=$ZE
	zn "DHC-APP"
	i (OrdId=$c(0))!(OrdId=$c(-1)) s OrdId=1
	s ^tmpDHCEKG("SentEkgReportToENS","ERROR",OrdId,$zd($h,3),$zt($p($h,",",2)))=ErrorMsg
	
	q "-666"
}

/// Creator：      yangyali
/// CreatDate：    2019-10-31
/// ModifyDate：   2019-10-31
/// ModifyDesc：   
/// Description:   获取参考值信息
/// Table：       
/// Input：        exam.id
/// Output：       参考值信息json串
/// w ##class(web.DHCEkg.Method.SentRptENS).getHRRangeInfo("423")
ClassMethod getHRRangeInfo(ExamId) As %GlobalCharacterStream [ WebMethod ]
{
	new $namespace
	zn "dhc-app"
	s rtnResultInfo=""
	s rtnResultInfo="""RISItemResult"":["
	s paadmdr=..GetAdmNo(ExamId)
	s (Gender,Age,ClinicDiagnose,PhysicPeriod)="" ;性别，年龄，临床诊断，生理周期
	i paadmdr'="" ;his患者，获取临床诊断和生理周期
	{
		s ClinicDiagnose=..GetClinicDiag(paadmdr)	
		try
		{	
			s PhysicPeriod=##class(DHCDoc.Interface.Inside.Service).GetPhysiologicalCycle(paadmdr)
		}
		catch
		{
		}
	}
	s Gender=..GetGender(ExamId)
	s Age=..GetAge(ExamId)
	s (hrRangeInfo,prRangeInfo,qrsRangeInfo,qtRangeInfo,qtcRangeInfo,pxRangeInfo,rxRangeInfo,txRangeInfo,rv5RangeInfo,sv1RangeInfo,RV5PlusSV1RangeInfo)=""
	d GetRefrenceRange
	
	
	s (hr,pr,qrs,qt,qtc,px,rx,tx,rv5,sv1,rv5PlusSv1)=""
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""	
	s devId=$listget(examInfo,10,"")
	q:(devId="") ""
	s devInfo=$g(^dbo.tblDeviceD(devId))
	q:(devInfo="") ""
	s testTypeId=$listget(devInfo,3,"")
	s noHr=1
	i (testTypeId="1")  ;静息类设备，取参数进行比对
	{
		s HRInfo=""
		s filepathId=""
		s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",ExamId,filepathId))
		while (filepathId'="")
		{
			s paramId=$o(^dbo.tblParamRestI("idxFilePathId",filepathId,""))
			i (paramId'="")
			{
				s paramInfo=$g(^dbo.tblParamRestD(paramId))
				s hr=$listget(paramInfo,17,"")
				 i (hr'="")
				 {
					s hrNormalLow=$listget(hrRangeInfo,7,"")
					s hrNormalHigh=$listget(hrRangeInfo,8,"")
					s hrNormalRange=hrNormalLow_"-"_hrNormalHigh
					s hrCrisisLow=$listget(hrRangeInfo,9,"")
					s hrCrisisHigh=$listget(hrRangeInfo,10,"")
					i (hrNormalRange="") s hrNormalRange="-"
					i (hrCrisisHigh="") s hrCrisisHigh="-"
					i (hrCrisisLow="") s hrCrisisLow="-"
					s rtnJsHRInfo="{"
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_ItemCode"":"""_"HR"_""","
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_ItemDesc"":"""_"心率"_""","
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_Ranges"":"""_hrNormalRange_""","
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_High"":"""_hrCrisisHigh_""","
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_Low"":"""_hrCrisisLow_""","
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_Unit"":"""_"bpm"_""","
					s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_Result"":"""_hr_""""
					s rtnJsHRInfo=rtnJsHRInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsHRInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsHRInfo
				 }
				s pr=$listget(paramInfo,7,"")
				 i (pr'="")
				 {
					s prNormalLow=$listget(prRangeInfo,7,"")
					s prNormalHigh=$listget(prRangeInfo,8,"")
					s prNormalRange=prNormalLow_"-"_prNormalHigh
					s prCrisisLow=$listget(prRangeInfo,9,"")
					s prCrisisHigh=$listget(prRangeInfo,10,"")
					i (prNormalRange="") s prNormalRange="-"
					i (prCrisisHigh="") s prCrisisHigh="-"
					i (prCrisisLow="") s prCrisisLow="-"
					s rtnJsPRInfo="{"
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_ItemCode"":"""_"PR"_""","
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_ItemDesc"":"""_"PR间期"_""","
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_Ranges"":"""_prNormalRange_""","
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_High"":"""_prCrisisHigh_""","
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_Low"":"""_prCrisisLow_""","
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_Unit"":"""_"ms"_""","
					s rtnJsPRInfo=rtnJsPRInfo_"""RISIR_Result"":"""_pr_""""
					s rtnJsPRInfo=rtnJsPRInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsPRInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsPRInfo
				 }
				s qrs=$listget(paramInfo,9,"")
				 i (qrs'="")
				 {
					s qrsNormalLow=$listget(qrsRangeInfo,7,"")
					s qrsNormalHigh=$listget(qrsRangeInfo,8,"")
					s qrsNormalRange=qrsNormalLow_"-"_qrsNormalHigh
					s qrsCrisisLow=$listget(qrsRangeInfo,9,"")
					s qrsCrisisHigh=$listget(qrsRangeInfo,10,"")
					i (qrsNormalRange="") s qrsNormalRange="-"
					i (qrsCrisisHigh="") s qrsCrisisHigh="-"
					i (qrsCrisisLow="") s qrsCrisisLow="-"
					s rtnJsQRSInfo="{"
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_ItemCode"":"""_"QRS"_""","
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_ItemDesc"":"""_"QRS"_""","
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_Ranges"":"""_qrsNormalRange_""","
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_High"":"""_qrsCrisisHigh_""","
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_Low"":"""_qrsCrisisLow_""","
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_Unit"":"""_"ms"_""","
					s rtnJsQRSInfo=rtnJsQRSInfo_"""RISIR_Result"":"""_qrs_""""
					s rtnJsQRSInfo=rtnJsQRSInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsQRSInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsQRSInfo
				 }
				s qt=$listget(paramInfo,10,"")
				 i (qt'="")
				 {
					s qtNormalLow=$listget(qtRangeInfo,7,"")
					s qtNormalHigh=$listget(qtRangeInfo,8,"")
					s qtNormalRange=qtNormalLow_"-"_qtNormalHigh
					s qtCrisisLow=$listget(qtRangeInfo,9,"")
					s qtCrisisHigh=$listget(qtRangeInfo,10,"")
					i (qtNormalRange="") s qtNormalRange="-"
					i (qtCrisisHigh="") s qtCrisisHigh="-"
					i (qtCrisisLow="") s qtCrisisLow="-"
					s rtnJsQTInfo="{"
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_ItemCode"":"""_"QT"_""","
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_ItemDesc"":"""_"QT"_""","
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_Ranges"":"""_qtNormalRange_""","
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_High"":"""_qtCrisisHigh_""","
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_Low"":"""_qtCrisisLow_""","
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_Unit"":"""_"ms"_""","
					s rtnJsQTInfo=rtnJsQTInfo_"""RISIR_Result"":"""_qt_""""
					s rtnJsQTInfo=rtnJsQTInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsQTInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsQTInfo
				 }
				s qtc=$listget(paramInfo,11,"")
				 i (qtc'="")
				 {
					s qtcNormalLow=$listget(qtcRangeInfo,7,"")
					s qtcNormalHigh=$listget(qtcRangeInfo,8,"")
					s qtcNormalRange=qtcNormalLow_"-"_qtcNormalHigh
					s qtcCrisisLow=$listget(qtcRangeInfo,9,"")
					s qtcCrisisHigh=$listget(qtcRangeInfo,10,"")
					i (qtcNormalRange="") s qtcNormalRange="-"
					i (qtcCrisisHigh="") s qtcCrisisHigh="-"
					i (qtcCrisisLow="") s qtcCrisisLow="-"
					s rtnJsQTcInfo="{"
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_ItemCode"":"""_"QTc"_""","
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_ItemDesc"":"""_"QTc"_""","
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_Ranges"":"""_qtcNormalRange_""","
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_High"":"""_qtcCrisisHigh_""","
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_Low"":"""_qtcCrisisLow_""","
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_Unit"":"""_"ms"_""","
					s rtnJsQTcInfo=rtnJsQTcInfo_"""RISIR_Result"":"""_qtc_""""
					s rtnJsQTcInfo=rtnJsQTcInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsQTcInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsQTcInfo
				 }
				s px=$listget(paramInfo,8,"")
				 i (px'="")
				 {
					s pxNormalRange=$lg(pxRangeInfo,7)_"-"_$lg(pxRangeInfo,8)
					s pxCrisisLow=$listget(pxRangeInfo,9,"")
					s pxCrisisHigh=$listget(pxRangeInfo,10,"")
					i (pxCrisisHigh="") s pxCrisisHigh="-"
					i (pxCrisisLow="") s pxCrisisLow="-"
					s rtnJsPXInfo="{"
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_ItemCode"":"""_"PX"_""","
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_ItemDesc"":"""_"PX"_""","
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_Ranges"":"""_pxNormalRange_""","
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_High"":"""_pxCrisisHigh_""","
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_Low"":"""_pxCrisisLow_""","
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_Unit"":"""_"degree"_""","
					s rtnJsPXInfo=rtnJsPXInfo_"""RISIR_Result"":"""_px_""""
					s rtnJsPXInfo=rtnJsPXInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsPXInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsPXInfo
				 }
				s rx=$listget(paramInfo,13,"")
				 i (rx'="")
				 {
					s rxNormalRange=$lg(rxRangeInfo,7)_"-"_$lg(rxRangeInfo,8)
					s rxCrisisLow=$listget(rxRangeInfo,9,"")
					s rxCrisisHigh=$listget(rxRangeInfo,10,"")
					i (rxCrisisHigh="") s rxCrisisHigh="-"
					i (rxCrisisLow="") s rxCrisisLow="-"
					s rtnJsRXInfo="{"
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_ItemCode"":"""_"RX"_""","
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_ItemDesc"":"""_"RX"_""","
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_Ranges"":"""_rxNormalRange_""","
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_High"":"""_rxCrisisHigh_""","
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_Low"":"""_rxCrisisLow_""","
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_Unit"":"""_"degree"_""","
					s rtnJsRXInfo=rtnJsRXInfo_"""RISIR_Result"":"""_rx_""""
					s rtnJsRXInfo=rtnJsRXInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsRXInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsRXInfo
				 }
				s tx=$listget(paramInfo,16,"")
				 i (tx'="")
				 {
					s txNormalRange=$lg(txRangeInfo,7)_"-"_$lg(txRangeInfo,8)
					s txCrisisLow=$listget(txRangeInfo,9,"")
					s txCrisisHigh=$listget(txRangeInfo,10,"")
					i (txCrisisHigh="") s txCrisisHigh="-"
					i (txCrisisLow="") s txCrisisLow="-"
					s rtnJsTXInfo="{"
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_ItemCode"":"""_"TX"_""","
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_ItemDesc"":"""_"TX"_""","
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_Ranges"":"""_txNormalRange_""","
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_High"":"""_txCrisisHigh_""","
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_Low"":"""_txCrisisLow_""","
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_Unit"":"""_"degree"_""","
					s rtnJsTXInfo=rtnJsTXInfo_"""RISIR_Result"":"""_tx_""""
					s rtnJsTXInfo=rtnJsTXInfo_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsTXInfo
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsTXInfo
				 }
				s rv5=$listget(paramInfo,12,"")
				 i (rv5'="")
				 {
					s rv5NormalRange=$lg(rv5RangeInfo,7)_"-"_$lg(rv5RangeInfo,8)
					s rv5CrisisLow=$listget(rv5RangeInfo,9,"")
					s rv5CrisisHigh=$listget(rv5RangeInfo,10,"")
					i (rv5CrisisHigh="") s rv5CrisisHigh="-"
					i (rv5CrisisLow="") s rv5CrisisLow="-"
					s rtnJsRV5Info="{"
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_ItemCode"":"""_"RV5"_""","
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_ItemDesc"":"""_"RV5"_""","
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_Ranges"":"""_rv5NormalRange_""","
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_High"":"""_rv5CrisisHigh_""","
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_Low"":"""_rv5CrisisLow_""","
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_Unit"":"""_"mv"_""","
					s rtnJsRV5Info=rtnJsRV5Info_"""RISIR_Result"":"""_rv5_""""
					s rtnJsRV5Info=rtnJsRV5Info_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsRV5Info
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsRV5Info
				 }
				s sv1=$listget(paramInfo,14,"")
				 i (sv1'="")
				 {
					s sv1NormalRange=$lg(sv1RangeInfo,7)_"-"_$lg(sv1RangeInfo,8)
					s sv1CrisisLow=$listget(sv1RangeInfo,9,"")
					s sv1CrisisHigh=$listget(sv1RangeInfo,10,"")
					i (sv1CrisisHigh="") s sv1CrisisHigh="-"
					i (sv1CrisisLow="") s sv1CrisisLow="-"
					s rtnJsSV1Info="{"
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_ItemCode"":"""_"SV1"_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_ItemDesc"":"""_"SV1"_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Ranges"":"""_sv1NormalRange_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_High"":"""_sv1CrisisHigh_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Low"":"""_sv1CrisisLow_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Unit"":"""_"mv"_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Result"":"""_sv1_""""
					s rtnJsSV1Info=rtnJsSV1Info_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsSV1Info
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsSV1Info
				 }
				s rv5PlusSv1=$zabs(rv5)+$zabs(sv1)
				 i (rv5PlusSv1'="")
				 {
					s RPSNormalRange=$lg(RV5PlusSV1RangeInfo,7)_"-"_$lg(RV5PlusSV1RangeInfo,8)
					s RPSCrisisLow=$lg(RV5PlusSV1RangeInfo,9,"")
					s RPSCrisisHigh=$lg(RV5PlusSV1RangeInfo,10,"")
					i (RPSCrisisHigh="") s RPSCrisisHigh="-"
					i (RPSCrisisLow="") s RPSCrisisLow="-"
					s rtnJsSV1Info="{"
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_ItemCode"":"""_"SV1"_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_ItemDesc"":"""_"SV1"_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Ranges"":"""_RPSNormalRange_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_High"":"""_RPSCrisisHigh_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Low"":"""_RPSCrisisLow_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Unit"":"""_"mv"_""","
					s rtnJsSV1Info=rtnJsSV1Info_"""RISIR_Result"":"""_rv5PlusSv1_""""
					s rtnJsSV1Info=rtnJsSV1Info_"}"
					i (rtnResultInfo'["RISIR_Result") s rtnResultInfo=rtnResultInfo_rtnJsSV1Info
					e  s rtnResultInfo=rtnResultInfo_","_rtnJsSV1Info
				 }
				
				
				;i (noHr=0) s rtnJsHRInfo=rtnJsHRInfo_","
				;s rtnJsHRInfo=rtnJsHRInfo_"""RISIR_Result"":"""_HR_""""
				s noHr=0
			}
			
			s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",ExamId,filepathId))
		}
	}
	zn "dhc-app"
	;b ; w noHr
	i (noHr) s rtnResultInfo=rtnResultInfo_"{""RISIR_Result"":"""_"无"_"""}"
	s rtnResultInfo=rtnResultInfo_"]"
	
	q rtnResultInfo
	
	
GetRefrenceRange
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	i (ClinicDiagnose'="") ;按诊断查询
	{
		s refId=""
		s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 诊断",refId))
		while refId'=""
		{
			s refInfo=$g(^dbo.tblReferenceRangeD(refId))
			i refInfo'=""
			{
				s PhysValue=$listget(refInfo,3,"")
				i PhysValue'=""
				{
					i ClinicDiagnose[PhysValue ;临床诊断包含
					{
						s RefrenceName=$listget(refInfo,6,"")
						if ($zcvt(RefrenceName,"u")="HR") 
						{
							s hrRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PR")
						{
							S prRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QRS")
						{
							S qrsRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QT")
						{
							S qtRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QTC")
						{
							s qtcRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PX")
						{
							s pxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RX")
						{
							s rxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="TX")
						{
							s txRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5")
						{
							s rv5RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="SV1")
						{
							s sv1RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5PLUSSV1")
						{
							s RV5PlusSV1RangeInfo=refInfo
						}
					}
				}
				
			}
			s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 诊断",refId))
		}
	}
	i (hrRangeInfo="")&&(PhysicPeriod'="") ;按生理周期查询
	{
		s refId=""
		s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 生理周期",refId))
		while refId'=""
		{
			s refInfo=$g(^dbo.tblReferenceRangeD(refId))
			i refInfo'=""
			{
				s PhysValue=$listget(refInfo,3,"")
				i PhysValue'=""
				{
					i PhysicPeriod[PhysValue ;临床诊断包含
					{
						s RefrenceName=$listget(refInfo,6,"")
						;i (RefrenceName="HR") s hrRangeInfo=refInfo
						
						if ($zcvt(RefrenceName,"u")="HR") 
						{
							s hrRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PR")
						{
							S prRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QRS")
						{
							S qrsRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QT")
						{
							S qtRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QTC")
						{
							s qtcRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PX")
						{
							s pxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RX")
						{
							s rxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="TX")
						{
							s txRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5")
						{
							s rv5RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="SV1")
						{
							s sv1RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5PLUSSV1")
						{
							s RV5PlusSV1RangeInfo=refInfo
						}
					}
				}
				
			}
			s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 诊断",refId))
		}
	}
	i (hrRangeInfo="")&&(Age'="") ;按年龄查询
	{
		if Age["天"
		{
			s Age=$p(Age,"天",1)
			s refId=""
			s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 天",refId))
			while refId'=""
			{
				s refInfo=$g(^dbo.tblReferenceRangeD(refId))
				i refInfo'=""
				{
					s PhysLow=$listget(refInfo,5,"")
					s PhysHigh=$listget(refInfo,4,"")
					i ((PhysLow="")!(PhysLow<=Age))&&((PhysHigh="")!(PhysHigh>Age))&&((PhysHigh'="")!(PhysLow'=""))
					{
						s RefrenceName=$listget(refInfo,6,"")
						;i (RefrenceName="HR") s hrRangeInfo=refInfo
						if ($zcvt(RefrenceName,"u")="HR") 
						{
							s hrRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PR")
						{
							S prRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QRS")
						{
							S qrsRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QT")
						{
							S qtRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QTC")
						{
							s qtcRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PX")
						{
							s pxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RX")
						{
							s rxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="TX")
						{
							s txRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5")
						{
							s rv5RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="SV1")
						{
							s sv1RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5PLUSSV1")
						{
							s RV5PlusSV1RangeInfo=refInfo
						}
					}					
				}
				s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 天",refId))
			}
			
		}
		elseif Age["月"
		{
			s Age=$p(Age,"月",1)
			s refId=""
			s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 月",refId))
			while refId'=""
			{
				s refInfo=$g(^dbo.tblReferenceRangeD(refId))
				i refInfo'=""
				{
					s PhysLow=$listget(refInfo,5,"")
					s PhysHigh=$listget(refInfo,4,"")
					i ((PhysLow="")!(PhysLow<=Age))&&((PhysHigh="")!(PhysHigh>Age))&&((PhysHigh'="")!(PhysLow'=""))
					{
						s RefrenceName=$listget(refInfo,6,"")
						;i (RefrenceName="HR") s hrRangeInfo=refInfo 
						if ($zcvt(RefrenceName,"u")="HR") 
						{
							s hrRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PR")
						{
							S prRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QRS")
						{
							S qrsRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QT")
						{
							S qtRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QTC")
						{
							s qtcRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PX")
						{
							s pxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RX")
						{
							s rxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="TX")
						{
							s txRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5")
						{
							s rv5RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="SV1")
						{
							s sv1RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5PLUSSV1")
						{
							s RV5PlusSV1RangeInfo=refInfo
						}
					}					
				}
				s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 月",refId))
			}
		}
		else ;按岁处理
		{
			s Age=$p(Age,"岁",1)
			s refId=""
			s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 岁",refId))
			while refId'=""
			{
				s refInfo=$g(^dbo.tblReferenceRangeD(refId))
				i refInfo'=""
				{
					s PhysLow=$listget(refInfo,5,"")
					s PhysHigh=$listget(refInfo,4,"")
					i ((PhysLow="")!(PhysLow<=Age))&&((PhysHigh="")!(PhysHigh>Age))&&((PhysHigh'="")!(PhysLow'=""))
					{
						s RefrenceName=$listget(refInfo,6,"")
						;i (RefrenceName="HR") s hrRangeInfo=refInfo
						if ($zcvt(RefrenceName,"u")="HR") 
						{
							s hrRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PR")
						{
							S prRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QRS")
						{
							S qrsRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QT")
						{
							S qtRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QTC")
						{
							s qtcRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PX")
						{
							s pxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RX")
						{
							s rxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="TX")
						{
							s txRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5")
						{
							s rv5RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="SV1")
						{
							s sv1RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5PLUSSV1")
						{
							s RV5PlusSV1RangeInfo=refInfo
						}
					}					
				}
				s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 岁",refId))
			}
		}
		
	}
	i (hrRangeInfo="")&&(Gender'="") ;按性别查询
	{
		s refId=""
		s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 性别"," "_Gender,refId))
		i refId'=""
		{
			s refInfo=$g(^dbo.tblReferenceRangeD(refId))
			s RefrenceName=$listget(refInfo,6,"")
			;i (RefrenceName="HR") s hrRangeInfo=refInfo
						if ($zcvt(RefrenceName,"u")="HR") 
						{
							s hrRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PR")
						{
							S prRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QRS")
						{
							S qrsRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QT")
						{
							S qtRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="QTC")
						{
							s qtcRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="PX")
						{
							s pxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RX")
						{
							s rxRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="TX")
						{
							s txRangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5")
						{
							s rv5RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="SV1")
						{
							s sv1RangeInfo=refInfo
						}
						elseif ($zcvt(RefrenceName,"u")="RV5PLUSSV1")
						{
							s RV5PlusSV1RangeInfo=refInfo
						}
		}		
	}
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据就诊号获取临床诊断
/// Table：       
/// Input：        就诊号
/// Output：       临床诊断详情
/// w ##class(yangyali.test1).GetClinicDiag("45")
ClassMethod GetClinicDiag(paadmdr) As %String
{
	s diagInfo=""
	s mradmid=$p($g(^PAADM(paadmdr)),"^",61)
	q:(mradmid="") ""
	s rs=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	d rs.Execute(mradmid, "", "")
	while(rs.Next())
	{
		s code=$g(rs.Data("DiagnosICDCode"))
		s desc=$g(rs.Data("DiagnosDesc"))
		i code'=""
		{
			i diagInfo'="" s diagInfo=diagInfo_code_":"_desc_";"
			else  s diagInfo=code_":"_desc_";"
		}
	}
	q diagInfo
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取年龄
/// Table：       
/// Input：        exam.Id
/// Output：       就诊号
/// w ##class(yangyali.test1).GetGender("179||122")
ClassMethod GetGender(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s patId=$listget(reqInfo,16,"")
	q:(patId="") ""
	s patInfo=$g(^dbo.tblPatientD(patId))
	q:(patInfo="") ""
	
	s Gender=$listget(patInfo,8,"")
	i (Gender="m") s Gender="男"
	i (Gender="f") s Gender="女"
	q Gender
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取年龄
/// Table：       
/// Input：        exam.Id
/// Output：       就诊号
/// w ##class(yangyali.test1).GetAge("179||122")
ClassMethod GetAge(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Age=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s Age=$listget(examInfo,34,"")
	i Age="" s Age=$listget(examInfo,5,"")_"岁"
	q Age
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取就诊号
/// Table：       
/// Input：        exam.Id
/// Output：       就诊号
/// w ##class(yangyali.test1).GetAdmNo("179||122")
ClassMethod GetAdmNo(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s AdmNo=$listget(reqInfo,3,"")
	zn "dhc-app"
	q AdmNo
}

/// w ##class(web.DHCEkg.Method.SentRptENS).ReSendEkgToENS("2021-07-16")
ClassMethod ReSendEkgToENS(Date) As %String
{
	
	s OrdItem="",sum=0
	FOR {
		S OrdItem=$O(^tmpDHCEKG("SentEkgReportToENS",OrdItem))
		q:OrdItem=""
		s SendDate=""
		for {
		S SendDate=$O(^tmpDHCEKG("SentEkgReportToENS",OrdItem,SendDate))
		q:SendDate=""
		continue:SendDate'="2021-07-16"
		d ..SentReport(OrdItem)
		s sum=sum+1
		}
	}
	q sum
}

}
