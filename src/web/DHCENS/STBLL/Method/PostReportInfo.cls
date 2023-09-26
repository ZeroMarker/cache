Class web.DHCENS.STBLL.Method.PostReportInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：平台提供保存检查报告的入口【包括超声、放射、病理、心电等】
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：Json报告串
/// Return：Json应答串
/// Others：w ##class(web.DHCENS.STBLL.Method.PostReportInfo).RISReportInfo("{""RISR_ACRCode"":"""",""RISR_AdviseDesc"":"""",""RISR_CheckDate"":"""",""RISR_CheckDocCode"":""RIS"",""RISR_CheckDocDesc"":""ris"",""RISR_CheckTime"":"""",""RISR_DiagDesc"":""胃壁未见明显异常声像\n"",""RISR_ExamDesc"":""内镜下见：胃窦、胃体、胃底粘膜光滑，未见明显糜烂、溃疡及肿物。胃窦、                                   胃体、胃底前壁/后壁/小弯侧/大弯侧粘膜稍隆起，大小约0.0cmx0.0cmx0.0cm，表面粘膜光                              滑,用活检钳触之软,于超声扫描后取组织 块。\n超声下见：胃壁层次结构清晰完整，反复                                      探扫胃窦、胃体、胃底，胃壁未见明显增厚、破坏及肿瘤占位征像。其周边肝左叶、脾脏及                                        胰腺体尾部均未见明显异常征像。  \n\n\n"",""RISR_FinalCheckDate"":"""",""RISR_FinalCheckDocCode"":"""",""RISR_FinalCheckDocDesc"":"""",""RISR_FinalCheckTime"":"""",""RISR_ImageSrc"":"""",""RISR_IsGet"":"""",""RISR_ItemDesc"":""心脏彩色多普勒       超声+左心功能测定"",""RISR_Method"":"""",""RISR_OrderItemDesc"":""心脏彩色多普勒               超声+左心功能测定"",""RISR_PatientID"":""0000000037"",""RISR_ReportDate"":""2019-09-12"",""RISR_ReportDocCode"":""RIS"",""RISR_ReportDocDesc"":""ris"",""RISR_ReportID"":""U20190912001"",""RISR_ReportImageSrc"":"""",""RISR_ReportTime"":""15:03:44"",""RISR_VisitNumber"":""24"",""RISR_WarnCode"":"""",""UpdateDate"":""2019-09-12"",""UpdateTime"":""15:03:45""}")
/// 入参示例：[{""RISR_ACRCode"":"""",""RISR_AdviseDesc"":"""",""RISR_CheckDate"":"""",""RISR_CheckDocCode"":""RIS"",""RISR_CheckDocDesc"":""ris"",""RISR_CheckTime"":"""",""RISR_DiagDesc"":""胃壁未见明显异常声像\n"",""RISR_ExamDesc"":""内镜下见：胃窦、胃体、胃底粘膜光滑，未见明显糜烂、溃疡及肿物。胃窦、胃体、胃底前壁/后壁/小弯侧/大弯侧粘膜稍隆起，大小约0.0cmx0.0cmx0.0cm，表面粘膜光                              滑,用活检钳触之软,于超声扫描后取组织 块。\n超声下见：胃壁层次结构清晰完整，反复                                      探扫胃窦、胃体、胃底，胃壁未见明显增厚、破坏及肿瘤占位征像。其周边肝左叶、脾脏及                                        胰腺体尾部均未见明显异常征像。  \n\n\n"",""RISR_FinalCheckDate"":"""",""RISR_FinalCheckDocCode"":"""",""RISR_FinalCheckDocDesc"":"""",""RISR_FinalCheckTime"":"""",""RISR_ImageSrc"":"""",""RISR_IsGet"":"""",""RISR_ItemDesc"":""心脏彩色多普勒       超声+左心功能测定"",""RISR_Method"":"""",""RISR_OrderItemDesc"":""心脏彩色多普勒               超声+左心功能测定"",""RISR_PatientID"":""0000000037"",""RISR_ReportDate"":""2019-09-12"",""RISR_ReportDocCode"":""RIS"",""RISR_ReportDocDesc"":""ris"",""RISR_ReportID"":""U20190912001"",""RISR_ReportImageSrc"":"""",""RISR_ReportTime"":""15:03:44"",""RISR_VisitNumber"":""24"",""RISR_WarnCode"":"""",""UpdateDate"":""2019-09-12"",""UpdateTime"":""15:03:45""}]
/// 返回值格式：[{"ResultCode":"结果代码","ResultContent":"结果描述"}]
/// 返回值示例：[{"ResultCode":"0","ResultContent":"成功"}]
/// 返回值说明：结果代码 0成功 非0失败；结果描述 错误信息
ClassMethod RISReportInfo(InputStr As %Stream.GlobalCharacter, DocumentID As %String = "") As %Stream.GlobalCharacter
{
	s $zt="GetErroMSG"
	set tmpJSONs={}.%FromJSON(InputStr)
	s ResultStr=##class(%Stream.GlobalCharacter).%New()
	s MainErroString=""
	s count=tmpJSONs.%Size()
	f i=1:1:count
	{
		s ErroString=""
		s tmpJSON=tmpJSONs.%Get(i-1)
		//报告ID		
		s RISRReportID=tmpJSON.%Get("RISR_ReportID")
		i (RISRReportID="")
		{
			s ErroString=ErroString_";检查报告ID不能为空"
		}
		//检查号
		s RISRExamID=tmpJSON.%Get("RISR_ExamID")
		i (RISRExamID="")
		{
			s ErroString=ErroString_";检查号不能为空"
		}
		//医嘱ID
		s RISROrderItemID=tmpJSON.%Get("RISR_OrderItemID")
		i (RISROrderItemID="")
		{
			s ErroString=ErroString_";医嘱ID不能为空"
		}
		//患者ID 
		s RISRPatientID=tmpJSON.%Get("RISR_PatientID")
		i (RISRPatientID="")
		{
			s ErroString=ErroString_";患者ID不能为空"
		}
		//就诊号码
		s RISRVisitNumber=tmpJSON.%Get("RISR_VisitNumber")
		i (RISRVisitNumber="")
		{
			s ErroString=ErroString_";就诊号不能为空"
		}
		//系统类型代码
		s RISRSysCode=tmpJSON.%Get("RISR_SysCode")
		i (RISRSysCode="")
		{
			s ErroString=ErroString_";系统类型不能为空"
		}
		//报告医生代码
		s RISRReportDocCode=tmpJSON.%Get("RISR_ReportDocCode")
		i (RISRReportDocCode="")
		{
			s ErroString=ErroString_";报告医生代码不能为空"
		}
		//报告医生描述
		s RISRReportDocDesc=tmpJSON.%Get("RISR_ReportDocDesc")
		//报告日期
		s RISRReportDate=tmpJSON.%Get("RISR_ReportDate")
		i (RISRReportDate="")
		{
			s ErroString=ErroString_";报告日期不能为空"
		}
		s:RISRReportDate'="" RISRReportDate=$zdh(RISRReportDate,3)
		//报告时间
		s RISRReportTime=tmpJSON.%Get("RISR_ReportTime")
		i (RISRReportTime="")
		{
			s ErroString=ErroString_";报告时间不能为空"
		}
		s:RISRReportTime'="" RISRReportTime=$zth(RISRReportTime)
		//审核医生代码
		s RISRCheckDocCode=tmpJSON.%Get("RISR_CheckDocCode")
		//审核医生描述
		s RISRCheckDocDesc=tmpJSON.%Get("RISR_CheckDocDesc")
		//审核日期
		s RISRCheckDate=tmpJSON.%Get("RISR_CheckDate")
		s:RISRCheckDate'="" RISRCheckDate=$zdh(RISRCheckDate,3)
		//审核时间
		s RISRCheckTime=tmpJSON.%Get("RISR_CheckTime")
		s:RISRCheckTime'="" RISRCheckTime=$zth(RISRCheckTime)
		//终审医生代码
		s RISRFinalCheckDocCode=tmpJSON.%Get("RISR_FinalCheckDocCode")
		//终审医生描述
		s RISRFinalCheckDocDesc=tmpJSON.%Get("RISR_FinalCheckDocDesc")
		//终审日期
		s RISRFinalCheckDate=tmpJSON.%Get("RISR_FinalCheckDate")
		s:RISRFinalCheckDate'="" RISRFinalCheckDate=$zdh(RISRFinalCheckDate,3)
		//终审时间
		s RISRFinalCheckTime=tmpJSON.%Get("RISR_FinalCheckTime")
		s:RISRFinalCheckTime'="" RISRFinalCheckTime=$zth(RISRFinalCheckTime)
		//检查项目描述
		s RISRItemDesc=tmpJSON.%Get("RISR_ItemDesc")
		i (RISRItemDesc="")
		{
			s ErroString=ErroString_";检查项目描述不能为空"
		}
		//检查部位代码
		s RISRBACode=tmpJSON.%Get("RISR_BACode")
		//检查部位描述
		s RISRBADesc=tmpJSON.%Get("RISR_BADesc")
		//检查方法
		s RISRMethod=tmpJSON.%Get("RISR_Method")
		//检查所见
		s RISRExamDesc=tmpJSON.%Get("RISR_ExamDesc")
		//诊断意见
		s RISRDiagDesc=tmpJSON.%Get("RISR_DiagDesc")
		i (RISRDiagDesc="")
		{
			s ErroString=ErroString_";诊断意见不能为空"
		}
		//ACR代码
		s RISRACRCode=tmpJSON.%Get("RISR_ACRCode")
		//报告建议
		s RISRAdviseDesc=tmpJSON.%Get("RISR_AdviseDesc")
		//是否已领取
		s RISRIsGet=tmpJSON.%Get("RISR_IsGet")
		//时间戳日期
		s RISRUpdateDate=tmpJSON.%Get("UpdateDate")
		s:RISRUpdateDate'="" RISRUpdateDate=$zdh(RISRUpdateDate,3)
		s:RISRUpdateDate="" RISRUpdateDate=+$h
		//时间戳时间
		s RISRUpdateTime=tmpJSON.%Get("UpdateTime")
		s:RISRUpdateTime'="" RISRUpdateTime=$zth(RISRUpdateTime)
		s:RISRUpdateTime="" RISRUpdateTime=$p($h,",",2)
		//医嘱描述
		s RISROrderItemDesc=tmpJSON.%Get("RISR_OrderItemDesc")
		//图像链接
		s RISRImageSrc=tmpJSON.%Get("RISR_ImageSrc")
		//图片报告链接
		s RISRReportImageSrc=tmpJSON.%Get("RISR_ReportImageSrc")
		//是否危急
		s RISRWarnCode=tmpJSON.%Get("RISR_WarnCode")	
		//是否阳性	
		s RISRIsPositive=tmpJSON.%Get("RISR_IsPositive")
		//异常标记
		s RISRAbnormalFlags=tmpJSON.%Get("RISR_AbnormalFlags")	
		//麻醉医师工号	
		s RISRAnesDocCode=tmpJSON.%Get("RISR_AnesDocCode")
		//麻醉医师姓名
		s RISRAnesDocName=tmpJSON.%Get("RISR_AnesDocName")	
		//麻醉方式代码	
		s RISRAnesMethodCode=tmpJSON.%Get("RISR_AnesMethodCode")
		//麻醉方式描述
		s RISRAnesMethodDesc=tmpJSON.%Get("RISR_AnesMethodDesc")	
		//麻醉分级代码
		s RISRAnesLevelCode=tmpJSON.%Get("RISR_AnesLevelCode")
		//麻醉分级描述
		s RISRAnesLevelDesc=tmpJSON.%Get("RISR_AnesLevelDesc")	
		//麻醉开始时间	
		s RISRAnesStartDateTime=tmpJSON.%Get("RISR_AnesStartDateTime")
		//麻醉结束时间
		s RISRAnesEndDateTime=tmpJSON.%Get("RISR_AnesEndDateTime")	
		//冰冻号
		s RISRSliceFrozenNo=tmpJSON.%Get("RISR_SliceFrozenNo")	
		//送检材料	
		s RISRInspMaterials=tmpJSON.%Get("RISR_InspMaterials")
		//免疫组化
		s RISRImmuneGrpNo=tmpJSON.%Get("RISR_ImmuneGrpNo")
		//报告状态	
		s RISRStatus=tmpJSON.%Get("RISR_Status")	
		//检查医生工号
		s RISRExamDocCode=tmpJSON.%Get("RISR_ExamDocCode")	
		//检查医生姓名	
		s RISRExamDocDesc=tmpJSON.%Get("RISR_ExamDocDesc")	
		//检查日期
		s RISRExamDate=tmpJSON.%Get("RISR_ExamDate")	
		//检查时间
		s RISRExamTime=tmpJSON.%Get("RISR_ExamTime")	
		
		s OEOrdID=+RISROrderItemID,OESubOrdID=""
		s:RISROrderItemID["_" OESubOrdID=+$p(RISROrderItemID,"_",2)
		s:RISROrderItemID["||" OESubOrdID=+$p(RISROrderItemID,"||",2)
		i (OEOrdID=0)||(OESubOrdID=0)||($D(^OEORD(OEOrdID,"I",OESubOrdID))=0)
		{
			s ErroString=ErroString_";RISROrderItemID="_RISROrderItemID_" 医嘱号格式不合法或不存在此医嘱"
		}
		i (RISRReportID="")
		{
			s ErroString=ErroString_";RISRReportID="_RISRReportID_" 报告ID为空"
		}
		q:RISRReportID=""
		
		s RISROrderItemID=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(RISROrderItemID,"_","||")
		s:RISRPatientID'="" PatientDr=$o(^PAPERi("PAPMI_PatNo",RISRPatientID,""))
		i (PatientDr="")
		{
			s ErroString=ErroString_";患者基本信息在系统内不存在！"
		}
		q:PatientDr=""
		ts
		s:RISRReportDate="" RISRReportDate=RISRCheckDate
		s:RISRReportTime="" RISRReportTime=RISRCheckTime
		s:RISROrderItemDesc="" RISROrderItemDesc=RISRItemDesc
		s RptID=""
		&sql(select %id into :RptID from SqlUser.Ens_RISReportResult where RISR_ReportID=:RISRReportID)
		if RptID=""
		{
			&sql(Insert into SqlUser.Ens_RISReportResult(RISR_ReportID,RISR_ExamID,RISR_OrderItemID,RISR_PatientID,RISR_VisitNumber,RISR_SysCode,RISR_ReportDocCode,RISR_ReportDocDesc,RISR_ReportDate,RISR_ReportTime,RISR_CheckDocCode,RISR_CheckDocDesc,RISR_CheckDate,RISR_CheckTime,RISR_FinalCheckDocCode,RISR_FinalCheckDocDesc,RISR_FinalCheckDate,RISR_FinalCheckTime,RISR_ItemDesc,RISR_BACode,RISR_BADesc,RISR_Method,RISR_ExamDesc,RISR_DiagDesc,
			RISR_ACRCode,RISR_AdviseDesc,RISR_IsGet,RISR_UpdateDate,RISR_UpdateTime,RISR_OrderItemDesc,RISR_ImageSrc,RISR_ReportImageSrc,RISR_WarnCode,RISR_IsPositive,RISR_AbnormalFlags,RISR_AnesDocCode,RISR_AnesDocName,RISR_AnesMethodCode,RISR_AnesMethodDesc,RISR_AnesLevelCode,RISR_AnesLevelDesc,RISR_AnesStartDateTime,RISR_AnesEndDateTime,RISR_SliceFrozenNo,RISR_InspMaterials,RISR_ImmuneGrpNo,RISR_Status,RISR_ExamDocCode,RISR_ExamDocDesc,RISR_ExamDate,RISR_ExamTime)
			Values (:RISRReportID,:RISRExamID,:RISROrderItemID,:PatientDr,:RISRVisitNumber,:RISRSysCode,:RISRReportDocCode,:RISRReportDocDesc,:RISRReportDate,:RISRReportTime,:RISRCheckDocCode,:RISRCheckDocDesc,:RISRCheckDate,:RISRCheckTime,:RISRFinalCheckDocCode,:RISRFinalCheckDocDesc,:RISRFinalCheckDate,:RISRFinalCheckTime,:RISRItemDesc,:RISRBACode,:RISRBADesc,:RISRMethod,:RISRExamDesc,:RISRDiagDesc
			,:RISRACRCode,:RISRAdviseDesc,:RISRIsGet,:RISRUpdateDate,:RISRUpdateTime,:RISROrderItemDesc,:RISRImageSrc,:RISRReportImageSrc,:RISRWarnCode,:RISRIsPositive,:RISRAbnormalFlags,:RISRAnesDocCode,:RISRAnesDocName,:RISRAnesMethodCode,:RISRAnesMethodDesc,:RISRAnesLevelCode,:RISRAnesLevelDesc,:RISRAnesStartDateTime,:RISRAnesEndDateTime,:RISRSliceFrozenNo,:RISRInspMaterials,:RISRImmuneGrpNo,:RISRStatus,:RISRExamDocCode,:RISRExamDocDesc,:RISRExamDate,:RISRExamTime))
			if SQLCODE'=0
			{
				tro	
				s ErroString=ErroString_" "_$g(%msg)
			}
		}
		else
		{
			&sql(Update SqlUser.Ens_RISReportResult set RISR_ReportID=:RISRReportID,RISR_ExamID=:RISRExamID,RISR_OrderItemID=:RISROrderItemID,RISR_PatientID=:PatientDr,RISR_VisitNumber=:RISRVisitNumber,RISR_SysCode=:RISRSysCode,RISR_ReportDocCode=:RISRReportDocCode,RISR_ReportDocDesc=:RISRReportDocDesc,RISR_ReportDate=:RISRReportDate,RISR_ReportTime=:RISRReportTime,RISR_CheckDocCode=:RISRCheckDocCode,RISR_CheckDocDesc=:RISRCheckDocDesc,RISR_CheckDate=:RISRCheckDate,RISR_CheckTime=:RISRCheckTime,RISR_FinalCheckDocCode=:RISRFinalCheckDocCode,RISR_FinalCheckDocDesc=:RISRFinalCheckDocDesc,RISR_FinalCheckDate=:RISRFinalCheckDate,RISR_FinalCheckTime=:RISRFinalCheckTime,RISR_ItemDesc=:RISRItemDesc,
			RISR_BACode=:RISRBACode,RISR_BADesc=:RISRBADesc,RISR_Method=:RISRMethod,RISR_ExamDesc=:RISRExamDesc,RISR_DiagDesc=:RISRDiagDesc,RISR_ACRCode=:RISRACRCode,RISR_AdviseDesc=:RISRAdviseDesc,RISR_IsGet=:RISRIsGet,RISR_UpdateDate=:RISRUpdateDate,RISR_UpdateTime=:RISRUpdateTime,RISR_OrderItemDesc=:RISROrderItemDesc,RISR_ImageSrc=:RISRImageSrc,RISR_ReportImageSrc=:RISRReportImageSrc,RISR_WarnCode=:RISRWarnCode,RISR_IsPositive=:RISRIsPositive,RISR_AbnormalFlags=:RISRAbnormalFlags,RISR_AnesDocCode=:RISRAnesDocCode,RISR_AnesDocName=:RISRAnesDocName,RISR_AnesMethodCode=:RISRAnesMethodCode,RISR_AnesMethodDesc=:RISRAnesMethodDesc,RISR_AnesLevelCode=:RISRAnesLevelCode,RISR_AnesLevelDesc=:RISRAnesLevelDesc,RISR_AnesStartDateTime=:RISRAnesStartDateTime,RISR_AnesEndDateTime=:RISRAnesEndDateTime,RISR_SliceFrozenNo=:RISRSliceFrozenNo,RISR_InspMaterials=:RISRInspMaterials,RISR_ImmuneGrpNo=:RISRImmuneGrpNo,RISR_Status=:RISRStatus,RISR_ExamDocCode=:RISRExamDocCode,RISR_ExamDocDesc=:RISRExamDocDesc,RISR_ExamDate=:RISRExamDate,RISR_ExamTime=:RISRExamTime where %id=:RptID)
			if SQLCODE'=0
			{
				tro	
				s ErroString=ErroString_" "_$g(%msg)
			}
		}
		s len=$l(RISROrderItemID,"^")
		f ij=1:1:len
		{
			s OeoriRowid=$p(RISROrderItemID,"^",ij)
			s OeoriRowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(OeoriRowid,"_","||")
			s EnsStatusDr=""
			&sql(select %id into :EnsStatusDr from SqlUser.Ens_Status where ES_OrdItemID=:OeoriRowid and ES_ExamID=:RISRExamID and ES_StatusCode='RP')
			if (EnsStatusDr="")&&(DocumentID'="")
			{
				//写入状态表
				&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode) 
			    Values ('Y',:RISRExamID,:RISRBADesc,:RISRCheckDate,:RISRCheckTime,:RISRCheckDocCode,:RISRCheckDocDesc,:OeoriRowid,'Y','RP',:RISRSysCode))
				if SQLCODE'=0
				{
					tro	
					s ErroString=ErroString_" "_$g(%msg)
				}
				s CurStatusCode="",StatusLogID=""
				s StatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemIDExamID"," "_OeoriRowid," "_RISRExamID,""),-1)
				s CurStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),11)
				//写入日志表
				&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_ExamPart,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode) 
			    Values (:RISRExamID,:RISRBADesc,:RISRCheckDate,:RISRCheckTime,:RISRCheckDocCode,:RISRCheckDocDesc,:OeoriRowid,'RP',:RISRSysCode,'RP',:CurStatusCode))
				if SQLCODE'=0
				{
					tro	
					s ErroString=ErroString_" "_$g(%msg)
				}	
			}	
		}
		
		//检查结果测值list
		s RISItemResult=tmpJSON.%Get("RISItemResult")
		if RISItemResult'=""
		{
			s RISItemResNum=RISItemResult.%Size()
			for j=1:1:RISItemResNum
			{
				s tmpRISResJSON=RISItemResult.%Get(j-1)
				s RISIRItemCode=tmpRISResJSON.%Get("RISIR_ItemCode")
				s RISIRItemDesc=tmpRISResJSON.%Get("RISIR_ItemDesc")
				q:RISIRItemDesc=""
				s RISIRRanges=tmpRISResJSON.%Get("RISIR_Ranges")
				s RISIRHigh=tmpRISResJSON.%Get("RISIR_High")
				s RISIRLow=tmpRISResJSON.%Get("RISIR_Low")
				s RISIRUnit=tmpRISResJSON.%Get("RISIR_Unit")
				s RISIRResult=tmpRISResJSON.%Get("RISIR_Result")
				s RISIRowId=""
				&sql(select %id into :RISIRowId from SqlUser.Ens_RISItemResult where RISIR_ReportID=:RISRReportID and RISIR_ItemCode=:RISIRItemCode)
				if (RISIRowId="")
				{
					&sql(Insert into SqlUser.Ens_RISItemResult(RISIR_ReportID,RISIR_PatientID,RISIR_VisitNumber,RISIR_ItemCode,RISIR_ItemDesc,RISIR_Result,RISIR_Ranges,RISIR_High,RISIR_Low,RISIR_Unit)
					Values(:RISRReportID,:PatientDr,:RISRVisitNumber,:RISIRItemCode,:RISIRItemDesc,:RISIRResult,:RISIRRanges,:RISIRHigh,:RISIRLow,:RISIRUnit))
					if SQLCODE'=0
					{
						tro	
						s ErroString=ErroString_" "_$g(%msg)
					}
				}
				else
				{
					&sql(Update SqlUser.Ens_RISItemResult set RISIR_ReportID=:RISRReportID,RISIR_PatientID=:PatientDr,RISIR_VisitNumber=:RISRVisitNumber,RISIR_ItemCode=:RISIRItemCode,RISIR_ItemDesc=:RISIRItemDesc,RISIR_Result=:RISIRResult,RISIR_Ranges=:RISIRRanges,RISIR_High=:RISIRHigh,RISIR_Low=:RISIRLow,RISIR_Unit=:RISIRUnit where %id=:RISIRowId)
					if SQLCODE'=0
					{
						tro	
						s ErroString=ErroString_" "_$g(%msg)
					}
				}
			}
		}
		
		s len=$l(RISROrderItemID,"^")
		for ii=1:1:len
		{
			s ExamRepID=""
			s OrderItemID=$p(RISROrderItemID,"^",ii)
			&sql(select %id into :ExamRepID from SqlUser.Ens_RISExamReport where RISSR_ReportID=:RISRReportID and RISSR_ExamID=:RISRExamID and RISSR_OrderItemID=:OrderItemID)
			if ExamRepID=""
			{
				&sql(insert into SqlUser.Ens_RISExamReport(RISSR_ReportID,RISSR_ExamID,RISSR_OrderItemID,RISSR_PatientID,RISSR_VisitNumber) values(:RISRReportID,:RISRExamID,:OrderItemID,:PatientDr,:RISRVisitNumber))
				if SQLCODE'=0 
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)
				}
			}
			else
			{  
				&sql(update SqlUser.Ens_RISExamReport set RISSR_ReportID=:RISRReportID,RISSR_ExamID=:RISRExamID,RISSR_OrderItemID=:OrderItemID,RISSR_PatientID=:PatientDr,RISSR_VisitNumber=:RISRVisitNumber where ID=:ExamRepID)
				if SQLCODE'=0 
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)
				}
			}
		}
				
		;s RISDocumentId=..SaveRISDocument(RISRExamID,DocumentID)
		s RISDocumentId=..SaveRISDocumentByRptID(RISRReportID,DocumentID)
		if RISDocumentId'=""
		{
			s DocumentId="",RISRelDocumentId=""
			&sql(select HOSD_DocumentID into :DocumentId from SqlUser.Ens_HOSDocument where %id=:RISDocumentId)
			q:DocumentId="" 
			&sql(select %id into :RISRelDocumentId from SqlUser.Ens_RelOrderDocument where RelOD_DocumentID=:DocumentId)
			
			set RelODOrderItemID=..GetOrdIDByRptExamNo(RISRReportID,RISRExamID)
			
			if RISRelDocumentId=""
			{
				s len=$l(RelODOrderItemID,"^")
				for ij=1:1:len
				{
					set OrderItemID=$p(RelODOrderItemID,"^",ij),RelRisReportId=""
					
				 	if '$d(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,RISRVisitNumber,OrderItemID))
					{
						&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_RisExamID,RelOD_RisReportID,RelOD_OrderItemID)values(:PatientDr,:RISRVisitNumber,:DocumentId,'xml',:RISRExamID,:RISRReportID,:OrderItemID))
						
						if SQLCODE'=0
						{
							tro	
							s ErroString=ErroString_" "_$g(%msg)
						}
					}
					else
					{
						s rowid="",relrisFlag=0 
						for { 
						   s rowid=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,RISRVisitNumber,OrderItemID,rowid)) 
						   q:rowid=""  
						   set RelRisReportId = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),4)
						   set RelODDocumentType = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),5)
						   continue:RelODDocumentType'="xml"
						   if RelRisReportId=RISRReportID {
						        &sql(update SqlUser.Ens_RelOrderDocument set RelOD_PatientID=:PatientDr,RelOD_VisitNumber=:RISRVisitNumber,RelOD_DocumentID=:DocumentId,RelOD_RisExamID=:RISRExamID,RelOD_RisReportID=:RISRReportID,RelOD_OrderItemID=:OrderItemID where %id=:rowid)
								
								if (SQLCODE'=0)
								{
									tro	
									s ErroString=ErroString_" "_$g(%msg)
								}		
								set relrisFlag=1			   
						   }
      					}
      					if relrisFlag=0
						{
											   
							&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_RisExamID,RelOD_RisReportID,RelOD_OrderItemID)values(:PatientDr,:RISRVisitNumber,:DocumentId,'xml',:RISRExamID,:RISRReportID,:OrderItemID))
							
							if SQLCODE'=0
							{
								tro	
								s ErroString=ErroString_" "_$g(%msg)
							}  
						}	
					}
				}
					
				if (SQLCODE=0)&&($TLEVEL>0)
				{
					tc	
				}
			}
		else
		{
			s len=$l(RelODOrderItemID,"^")
			for ij=1:1:len
			{
				set OrderItemID=$p(RelODOrderItemID,"^",ij),RelRisReportId=""
			 	if '$d(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,RISRVisitNumber,OrderItemID))
				{
					&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_RisExamID,RelOD_RisReportID,RelOD_OrderItemID)values(:PatientDr,:RISRVisitNumber,:DocumentId,'xml',:RISRExamID,:RISRReportID,:OrderItemID))
					if SQLCODE'=0
					{
						tro	
						s ErroString=ErroString_" "_$g(%msg)
					}
				}
				else
				{
					s rowid="",relrisFlag=0 
					for { 
						 s rowid=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,RISRVisitNumber,OrderItemID,rowid)) 
						 q:rowid=""  
						 set RelRisReportId = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),4)
						 set RelODDocumentType = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),5)
						 continue:RelODDocumentType'="xml"
					     if RelRisReportId=RISRReportID {
					        &sql(update SqlUser.Ens_RelOrderDocument set RelOD_PatientID=:PatientDr,RelOD_VisitNumber=:RISRVisitNumber,RelOD_DocumentID=:DocumentId,RelOD_RisExamID=:RISRExamID,RelOD_RisReportID=:RISRReportID,RelOD_OrderItemID=:OrderItemID where %id=:rowid)
							
							if (SQLCODE'=0)
							{
								tro	
								s ErroString=ErroString_" "_$g(%msg)
							}		
							set relrisFlag=1				   
					      }
      					}
      				if relrisFlag=0
					{
					   &sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_RisExamID,RelOD_RisReportID,RelOD_OrderItemID)values(:PatientDr,:RISRVisitNumber,:DocumentId,'xml',:RISRExamID,:RISRReportID,:OrderItemID))
					   if SQLCODE'=0
					   {
							tro	
							s ErroString=ErroString_" "_$g(%msg)
					   }  
					}
				  }
				}
				if (SQLCODE=0)&&($TLEVEL>0)
				{
					tc	
				}			
			
			}	
		}
	}
	i ErroString'=""
	{
		s MainErroString=MainErroString_"##"_ErroString
	}
	i MainErroString=""
	{	
		d ResultStr.Write("[{""ResultCode"":""0"",""ResultContent"":""成功""}]")
		s AdmType=$p($g(^PAADM(RISRVisitNumber)),"^",2) //病人就诊类型，记录就诊类型为体检的医嘱号，体检需要统计实时的工作量
		if (##class(websys.Conversions).IsValidMethodName("web.DHCPE.TransResult","TransResultByOEID"))&&(AdmType="H")
		{
			s lenH=$l(RISROrderItemID,"^")
			for h=1:1:lenH
			{
				s OrderItemIDH=$p(RISROrderItemID,"^",h)
				d ##class(web.DHCPE.TransResult).TransResultByOEID(OrderItemIDH)
			}
		}
		s rRptID=""
		&sql(select %id into :rRptID from SqlUser.Ens_RISReportResult where RISR_ReportID=:RISRReportID)
		d ##class(web.DHCENS.EnsHISService).DHCHisInterface("SendRISReportStruc",rRptID)
		q ResultStr
	}
	else
	{
		if $TLEVEL>0
		{
	 		tro	
		}	
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":"""_MainErroString_"""}]")
		q ResultStr
	}
	
GetErroMSG
	if $TLEVEL>0
	{
	 	tro	
	}
	s ResultStr=##class(%Stream.GlobalCharacter).%New()
	d ResultStr.Write("[{""ResultCode"":""-2"",""ResultContent"":""程序内部错误"_$ze_$g(ErroString)_"""}]")
	q ResultStr
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：平台提供保存检验报告的入口
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_LISSpecimenReport、Ens_LISItemResRst、Ens_HOSDocument、Ens_RelOrderDocument
/// Input：Json报告串
/// Return：Json应答串
/// Others：w ##class(web.DHCENS.STBLL.Method.PostReportInfo).LISReportInfo("[{""LISRR_ReportID"":""81"",""LISRR_PatientID"":""0000000089"",""LISRR_VisitNumber"":""1000004205"",""LISRR_PatientName"":""myh预住院2"",""LISRR_Sex"":""女"",""LISRR_DOB"":19970202,""LISRR_ABO"":"""",""LISRR_RH"":"""",""LISRR_MobileNo"":""18756856565"",""LISRR_PhoneNo"":"""",""LISRR_Email"":"""",""LISRR_Address"":"""",""LISRR_MachineDate"":"""",""LISRR_MachineTime"":"""",""LISRR_TestDate"":20190927,""LISRR_TestTime"":33329,""LISRR_CancelDate"":"""",""LISRR_CancelTime"":"""",""LISRR_CancelUserCode"":"""",""LISRR_CancelReason"":"""",""LISRR_ReprotXml"":"""",""LISRR_ReprotPdf"":"""",""LISRR_ReprotType"":1,""LISRR_Remarks"":"""",""LISRR_ISMcroorganism"":1,""LISRR_UpdateDate"":"""",""LISRR_UpdateTime"":"""",""LISRR_Identifition"":"""",""LISRR_HosCode"":""DHSZHYYZY"",""LISRR_CheckDate"":20190927,""LISRR_CheckTime"":33438,""LISRR_CheckUserCode"":""LIS01"",""LISRR_CheckUserDesc"":""检验管理员"",""LISRR_FirstCheckUserCode"":""LIS01"",""LISRR_FirstCheckUserDesc"":""检验管理员"",""LISRR_CancelUserDesc"":"""",""LISRR_OrderItemDesc"":""痰培养药敏"",""LISRR_WarnCode"":"""",""LISRR_ReportClass"":1,""LISRR_Status"":1,""LISRR_AuthType"":1,""LISSR_OrderItemID"":"""",""LISRR_TransmitDate"":20190927,""LISRR_WorkGroupCode"":""WSW"",""LISRR_WorkGroupDesc"":""VITEK2-compact"",""LISRR_Order"":1,""LISRR_SpecimenID"":""SP009"",""LISRR_AccessionNo"":"""",""LISRR_ReceiveDate"":20190927,""LISRR_ReceiveTime"":33321,""LISRR_ReceiveUserCode"":""LIS01"",""LISRR_ReceiveUserDesc"":""检验管理员"",""LISRR_AcceptDate"":20190927,""LISRR_AcceptTime"":33329,""LISRR_AcceptUserCode"":""LIS01"",""LISRR_AcceptUserDesc"":""检验管理员"",""LISRR_ReCheckDate"":"""",""LISRR_ReCheckTime"":"""",""LISRR_ReCheckUserCode"":"""",""LISRR_ReCheckUserDesc"":"""",""LISRR_AutoCheck"":"""",""LISRR_DigitSign"":"""",""LISRR_DigitSignString"":"""",""LISRR_DigitSignTime"":"""",""LISRR_Printed"":"""",""LISRR_Readed"":"""",""LISRR_FirstReadDate"":"""",""LISRR_FirstReadTime"":"""",""LISRR_FirstReadUserCode"":"""",""LISRR_FirstReadUserDesc"":"""",""LISRR_MainConclusion"":"""",""LISRR_MinorConclusion"":"""",""LISRR_SpecimenQuality"":"""",""LISRR_ReAssayNumber"":"""",""LISRR_AddDate"":20190927,""LISRR_AddTime"":33321,""LISRR_AddUserCode"":""LIS01"",""LISRR_AddUserDesc"":""检验管理员"",""LISRR_ArriveDate"":"""",""LISRR_ArriveTime"":"""",""LISRR_ArriveUserCode"":"""",""LISRR_ArriveUserDesc"":"""",""LISRR_CollectDate"":"""",""LISRR_CollectTime"":"""",""LISRR_CollectUserCode"":"""",""LISRR_CollectUserDesc"":"""",""LISRR_CarryDate"":"""",""LISRR_CarryTime"":"""",""LISRR_CarryUserCode"":"""",""LISRR_CarryUserDesc"":"""",""LISRR_ItemResult"":[{""LISIR_ItemCode"":""W0013"",""LISIR_ItemDesc"":""细菌2"",""LISIR_Result"":""2162"",""LISIR_Uint"":""X10^4CFU/ml"",""LISIR_TextResult"":""金黄色葡萄球菌"",""LISIR_ExtraResult"":""良好"",""LISIR_ResultExplain"":""铜绿假单胞菌（粘液型）"",""LISIR_AbnormalFlags"":"""",""LISIR_Ranges"":"""",""LISIR_TestMethod"":"""",""LISIR_TestMachine"":"""",""LISIR_TestUserCode"":"""",""LISIR_TestUserDesc"":"""",""LISIR_ShowSeq"":"""",""LISIR_TestDate"":"""",""LISIR_TestTime"":"""",""LISIR_Count"":"""",""LISIR_ExpertRule"":""隐球菌：对棘白菌素类天然耐药！"",""LISIR_InterCode"":"""",""LISIR_ResClass"":"""",""LISIR_Organism"":"""",""LISIR_Remark"":"""",""LISIR_AssayStatus"":"""",""LISIR_ReAssayNum"":"""",""LISIR_ReAssayNumber"":"""",""LISIR_MultipleResistant"":""1"",""LISISR_ItemSenResult"":[{""LISISR_AntibioticsCode"":""AMK30"",""LISISR_AntibioticsDesc"":""阿米卡星"",""LISISR_Result"":""1"",""LISISR_SensitivityCode"":""I"",""LISISR_SensitivityDesc"":""中介"",""LISISR_IRanges"":""15<#&&#<16"",""LISISR_SRanges"":""#>16"",""LISISR_RRanges"":""#<15"",""LISISR_ShowSeq"":""0"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""FOX30"",""LISISR_AntibioticsDesc"":""头孢西丁"",""LISISR_Result"":""6"",""LISISR_SensitivityCode"":""--"",""LISISR_SensitivityDesc"":""无判定"",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""5"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""CLI2"",""LISISR_AntibioticsDesc"":""克林霉素"",""LISISR_Result"":""3"",""LISISR_SensitivityCode"":""R"",""LISISR_SensitivityDesc"":""耐药"",""LISISR_IRanges"":""15<#&&#<20"",""LISISR_SRanges"":""#>20"",""LISISR_RRanges"":""#<15"",""LISISR_ShowSeq"":""2"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""ERY15"",""LISISR_AntibioticsDesc"":""红霉素"",""LISISR_Result"":""4"",""LISISR_SensitivityCode"":""SDD"",""LISISR_SensitivityDesc"":""SDD"",""LISISR_IRanges"":""14<#&&#<22"",""LISISR_SRanges"":""#>22"",""LISISR_RRanges"":""#<14"",""LISISR_ShowSeq"":""3"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""LVX5"",""LISISR_AntibioticsDesc"":""左氧氟沙星"",""LISISR_Result"":""2"",""LISISR_SensitivityCode"":""S"",""LISISR_SensitivityDesc"":""敏感"",""LISISR_IRanges"":""16<#&&#<18"",""LISISR_SRanges"":""#>18"",""LISISR_RRanges"":""#<16"",""LISISR_ShowSeq"":""1"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""PNV10"",""LISISR_AntibioticsDesc"":""青霉素"",""LISISR_Result"":""5"",""LISISR_SensitivityCode"":""-"",""LISISR_SensitivityDesc"":""无判定"",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""4"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""SXT125"",""LISISR_AntibioticsDesc"":""复方新诺明"",""LISISR_Result"":""8"",""LISISR_SensitivityCode"":"""",""LISISR_SensitivityDesc"":"""",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""7"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""VAN30"",""LISISR_AntibioticsDesc"":""万古霉素"",""LISISR_Result"":""7"",""LISISR_SensitivityCode"":""I"",""LISISR_SensitivityDesc"":""中介"",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""6"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""}],""LISISR_ItemResultResistance"":[{""LISIRR_ItemCode"":""A0001"",""LISIRR_ItemDesc"":""β-内酰胺酶"",""LISIRR_Result"":""阴性"",""LISIRR_ShowSeq"":""1""},{""LISIRR_ItemCode"":""A0002"",""LISIRR_ItemDesc"":""超广谱β-内酰胺酶"",""LISIRR_Result"":""阴性"",""LISIRR_ShowSeq"":""2""},{""LISIRR_ItemCode"":""A0003"",""LISIRR_ItemDesc"":""耐甲氧西林葡萄球菌检测"",""LISIRR_Result"":""MSSA"",""LISIRR_ShowSeq"":""3""}]},{""LISIR_ItemCode"":""W0008"",""LISIR_ItemDesc"":""淋球菌培养"",""LISIR_Result"":""226"",""LISIR_Uint"":"""",""LISIR_TextResult"":""检出革兰阴性双球菌"",""LISIR_ExtraResult"":"""",""LISIR_ResultExplain"":"""",""LISIR_AbnormalFlags"":""A"",""LISIR_Ranges"":""未检出革兰阴性双球菌"",""LISIR_TestMethod"":"""",""LISIR_TestMachine"":"""",""LISIR_TestUserCode"":"""",""LISIR_TestUserDesc"":"""",""LISIR_ShowSeq"":""441"",""LISIR_TestDate"":"""",""LISIR_TestTime"":"""",""LISIR_Count"":"""",""LISIR_ExpertRule"":"""",""LISIR_InterCode"":"""",""LISIR_ResClass"":"""",""LISIR_Organism"":"""",""LISIR_Remark"":"""",""LISIR_AssayStatus"":"""",""LISIR_ReAssayNum"":"""",""LISIR_ReAssayNumber"":"""",""LISIR_MultipleResistant"":"""",""LISISR_ItemSenResult"":[],""LISISR_ItemResultResistance"":[]},{""LISIR_ItemCode"":""W0006"",""LISIR_ItemDesc"":""培养结果"",""LISIR_Result"":""246"",""LISIR_Uint"":"""",""LISIR_TextResult"":""生长假丝酵母菌"",""LISIR_ExtraResult"":"""",""LISIR_ResultExplain"":"""",""LISIR_AbnormalFlags"":""A"",""LISIR_Ranges"":"""",""LISIR_TestMethod"":"""",""LISIR_TestMachine"":"""",""LISIR_TestUserCode"":"""",""LISIR_TestUserDesc"":"""",""LISIR_ShowSeq"":""460"",""LISIR_TestDate"":"""",""LISIR_TestTime"":"""",""LISIR_Count"":"""",""LISIR_ExpertRule"":"""",""LISIR_InterCode"":"""",""LISIR_ResClass"":"""",""LISIR_Organism"":"""",""LISIR_Remark"":"""",""LISIR_AssayStatus"":"""",""LISIR_ReAssayNum"":"""",""LISIR_ReAssayNumber"":"""",""LISIR_MultipleResistant"":"""",""LISISR_ItemSenResult"":[],""LISISR_ItemResultResistance"":[]}]}]")
/// 入参示例：[{""LISRR_ReportID"":""81"",""LISRR_PatientID"":""0000000089"",""LISRR_VisitNumber"":""1000004205"",""LISRR_PatientName"":""myh预住院2"",""LISRR_Sex"":""女"",""LISRR_DOB"":19970202,""LISRR_ABO"":"""",""LISRR_RH"":"""",""LISRR_MobileNo"":""18756856565"",""LISRR_PhoneNo"":"""",""LISRR_Email"":"""",""LISRR_Address"":"""",""LISRR_MachineDate"":"""",""LISRR_MachineTime"":"""",""LISRR_TestDate"":20190927,""LISRR_TestTime"":33329,""LISRR_CancelDate"":"""",""LISRR_CancelTime"":"""",""LISRR_CancelUserCode"":"""",""LISRR_CancelReason"":"""",""LISRR_ReprotXml"":"""",""LISRR_ReprotPdf"":"""",""LISRR_ReprotType"":1,""LISRR_Remarks"":"""",""LISRR_ISMcroorganism"":1,""LISRR_UpdateDate"":"""",""LISRR_UpdateTime"":"""",""LISRR_Identifition"":"""",""LISRR_HosCode"":""DHSZHYYZY"",""LISRR_CheckDate"":20190927,""LISRR_CheckTime"":33438,""LISRR_CheckUserCode"":""LIS01"",""LISRR_CheckUserDesc"":""检验管理员"",""LISRR_FirstCheckUserCode"":""LIS01"",""LISRR_FirstCheckUserDesc"":""检验管理员"",""LISRR_CancelUserDesc"":"""",""LISRR_OrderItemDesc"":""痰培养药敏"",""LISRR_WarnCode"":"""",""LISRR_ReportClass"":1,""LISRR_Status"":1,""LISRR_AuthType"":1,""LISSR_OrderItemID"":"""",""LISRR_TransmitDate"":20190927,""LISRR_WorkGroupCode"":""WSW"",""LISRR_WorkGroupDesc"":""VITEK2-compact"",""LISRR_Order"":1,""LISRR_SpecimenID"":""SP009"",""LISRR_AccessionNo"":"""",""LISRR_ReceiveDate"":20190927,""LISRR_ReceiveTime"":33321,""LISRR_ReceiveUserCode"":""LIS01"",""LISRR_ReceiveUserDesc"":""检验管理员"",""LISRR_AcceptDate"":20190927,""LISRR_AcceptTime"":33329,""LISRR_AcceptUserCode"":""LIS01"",""LISRR_AcceptUserDesc"":""检验管理员"",""LISRR_ReCheckDate"":"""",""LISRR_ReCheckTime"":"""",""LISRR_ReCheckUserCode"":"""",""LISRR_ReCheckUserDesc"":"""",""LISRR_AutoCheck"":"""",""LISRR_DigitSign"":"""",""LISRR_DigitSignString"":"""",""LISRR_DigitSignTime"":"""",""LISRR_Printed"":"""",""LISRR_Readed"":"""",""LISRR_FirstReadDate"":"""",""LISRR_FirstReadTime"":"""",""LISRR_FirstReadUserCode"":"""",""LISRR_FirstReadUserDesc"":"""",""LISRR_MainConclusion"":"""",""LISRR_MinorConclusion"":"""",""LISRR_SpecimenQuality"":"""",""LISRR_ReAssayNumber"":"""",""LISRR_AddDate"":20190927,""LISRR_AddTime"":33321,""LISRR_AddUserCode"":""LIS01"",""LISRR_AddUserDesc"":""检验管理员"",""LISRR_ArriveDate"":"""",""LISRR_ArriveTime"":"""",""LISRR_ArriveUserCode"":"""",""LISRR_ArriveUserDesc"":"""",""LISRR_CollectDate"":"""",""LISRR_CollectTime"":"""",""LISRR_CollectUserCode"":"""",""LISRR_CollectUserDesc"":"""",""LISRR_CarryDate"":"""",""LISRR_CarryTime"":"""",""LISRR_CarryUserCode"":"""",""LISRR_CarryUserDesc"":"""",""LISRR_ItemResult"":[{""LISIR_ItemCode"":""W0013"",""LISIR_ItemDesc"":""细菌2"",""LISIR_Result"":""2162"",""LISIR_Uint"":""X10^4CFU/ml"",""LISIR_TextResult"":""金黄色葡萄球菌"",""LISIR_ExtraResult"":""良好"",""LISIR_ResultExplain"":""铜绿假单胞菌（粘液型）"",""LISIR_AbnormalFlags"":"""",""LISIR_Ranges"":"""",""LISIR_TestMethod"":"""",""LISIR_TestMachine"":"""",""LISIR_TestUserCode"":"""",""LISIR_TestUserDesc"":"""",""LISIR_ShowSeq"":"""",""LISIR_TestDate"":"""",""LISIR_TestTime"":"""",""LISIR_Count"":"""",""LISIR_ExpertRule"":""隐球菌：对棘白菌素类天然耐药！"",""LISIR_InterCode"":"""",""LISIR_ResClass"":"""",""LISIR_Organism"":"""",""LISIR_Remark"":"""",""LISIR_AssayStatus"":"""",""LISIR_ReAssayNum"":"""",""LISIR_ReAssayNumber"":"""",""LISIR_MultipleResistant"":""1"",""LISISR_ItemSenResult"":[{""LISISR_AntibioticsCode"":""AMK30"",""LISISR_AntibioticsDesc"":""阿米卡星"",""LISISR_Result"":""1"",""LISISR_SensitivityCode"":""I"",""LISISR_SensitivityDesc"":""中介"",""LISISR_IRanges"":""15<#&&#<16"",""LISISR_SRanges"":""#>16"",""LISISR_RRanges"":""#<15"",""LISISR_ShowSeq"":""0"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""FOX30"",""LISISR_AntibioticsDesc"":""头孢西丁"",""LISISR_Result"":""6"",""LISISR_SensitivityCode"":""--"",""LISISR_SensitivityDesc"":""无判定"",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""5"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""CLI2"",""LISISR_AntibioticsDesc"":""克林霉素"",""LISISR_Result"":""3"",""LISISR_SensitivityCode"":""R"",""LISISR_SensitivityDesc"":""耐药"",""LISISR_IRanges"":""15<#&&#<20"",""LISISR_SRanges"":""#>20"",""LISISR_RRanges"":""#<15"",""LISISR_ShowSeq"":""2"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""ERY15"",""LISISR_AntibioticsDesc"":""红霉素"",""LISISR_Result"":""4"",""LISISR_SensitivityCode"":""SDD"",""LISISR_SensitivityDesc"":""SDD"",""LISISR_IRanges"":""14<#&&#<22"",""LISISR_SRanges"":""#>22"",""LISISR_RRanges"":""#<14"",""LISISR_ShowSeq"":""3"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""LVX5"",""LISISR_AntibioticsDesc"":""左氧氟沙星"",""LISISR_Result"":""2"",""LISISR_SensitivityCode"":""S"",""LISISR_SensitivityDesc"":""敏感"",""LISISR_IRanges"":""16<#&&#<18"",""LISISR_SRanges"":""#>18"",""LISISR_RRanges"":""#<16"",""LISISR_ShowSeq"":""1"",""LISISR_Method"":""KB"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""PNV10"",""LISISR_AntibioticsDesc"":""青霉素"",""LISISR_Result"":""5"",""LISISR_SensitivityCode"":""-"",""LISISR_SensitivityDesc"":""无判定"",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""4"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""SXT125"",""LISISR_AntibioticsDesc"":""复方新诺明"",""LISISR_Result"":""8"",""LISISR_SensitivityCode"":"""",""LISISR_SensitivityDesc"":"""",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""7"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""},{""LISISR_AntibioticsCode"":""VAN30"",""LISISR_AntibioticsDesc"":""万古霉素"",""LISISR_Result"":""7"",""LISISR_SensitivityCode"":""I"",""LISISR_SensitivityDesc"":""中介"",""LISISR_IRanges"":"""",""LISISR_SRanges"":"""",""LISISR_RRanges"":"""",""LISISR_ShowSeq"":""6"",""LISISR_Method"":""MIC"",""LISISR_Suggestion"":"""",""LISISR_Flag"":"""",""LISISR_AntibioticsClassID"":"""",""LISISR_AntibioticsClassDesc"":""""}],""LISISR_ItemResultResistance"":[{""LISIRR_ItemCode"":""A0001"",""LISIRR_ItemDesc"":""β-内酰胺酶"",""LISIRR_Result"":""阴性"",""LISIRR_ShowSeq"":""1""},{""LISIRR_ItemCode"":""A0002"",""LISIRR_ItemDesc"":""超广谱β-内酰胺酶"",""LISIRR_Result"":""阴性"",""LISIRR_ShowSeq"":""2""},{""LISIRR_ItemCode"":""A0003"",""LISIRR_ItemDesc"":""耐甲氧西林葡萄球菌检测"",""LISIRR_Result"":""MSSA"",""LISIRR_ShowSeq"":""3""}]},{""LISIR_ItemCode"":""W0008"",""LISIR_ItemDesc"":""淋球菌培养"",""LISIR_Result"":""226"",""LISIR_Uint"":"""",""LISIR_TextResult"":""检出革兰阴性双球菌"",""LISIR_ExtraResult"":"""",""LISIR_ResultExplain"":"""",""LISIR_AbnormalFlags"":""A"",""LISIR_Ranges"":""未检出革兰阴性双球菌"",""LISIR_TestMethod"":"""",""LISIR_TestMachine"":"""",""LISIR_TestUserCode"":"""",""LISIR_TestUserDesc"":"""",""LISIR_ShowSeq"":""441"",""LISIR_TestDate"":"""",""LISIR_TestTime"":"""",""LISIR_Count"":"""",""LISIR_ExpertRule"":"""",""LISIR_InterCode"":"""",""LISIR_ResClass"":"""",""LISIR_Organism"":"""",""LISIR_Remark"":"""",""LISIR_AssayStatus"":"""",""LISIR_ReAssayNum"":"""",""LISIR_ReAssayNumber"":"""",""LISIR_MultipleResistant"":"""",""LISISR_ItemSenResult"":[],""LISISR_ItemResultResistance"":[]},{""LISIR_ItemCode"":""W0006"",""LISIR_ItemDesc"":""培养结果"",""LISIR_Result"":""246"",""LISIR_Uint"":"""",""LISIR_TextResult"":""生长假丝酵母菌"",""LISIR_ExtraResult"":"""",""LISIR_ResultExplain"":"""",""LISIR_AbnormalFlags"":""A"",""LISIR_Ranges"":"""",""LISIR_TestMethod"":"""",""LISIR_TestMachine"":"""",""LISIR_TestUserCode"":"""",""LISIR_TestUserDesc"":"""",""LISIR_ShowSeq"":""460"",""LISIR_TestDate"":"""",""LISIR_TestTime"":"""",""LISIR_Count"":"""",""LISIR_ExpertRule"":"""",""LISIR_InterCode"":"""",""LISIR_ResClass"":"""",""LISIR_Organism"":"""",""LISIR_Remark"":"""",""LISIR_AssayStatus"":"""",""LISIR_ReAssayNum"":"""",""LISIR_ReAssayNumber"":"""",""LISIR_MultipleResistant"":"""",""LISISR_ItemSenResult"":[],""LISISR_ItemResultResistance"":[]}]}]
/// 返回值格式：[{"ResultCode":"结果代码","ResultContent":"结果描述"}]
/// 返回值示例：[{"ResultCode":"0","ResultContent":"成功"}]
/// 返回值说明：结果代码 0成功 非0失败；结果描述 错误信息
ClassMethod LISReportInfo(InputStr As %Stream.GlobalCharacter, DocumentID As %String = "") As %Stream.GlobalCharacter
{
	s $zt="GetErroMSG"
	set tmpJSONs={}.%FromJSON(InputStr)
	s ResultStr=##class(%Stream.GlobalCharacter).%New()
	s MainErroString=""
	s count=tmpJSONs.%Size()
	f i=1:1:count
	{
		s ErroString=""
		s tmpJSON=tmpJSONs.%Get(i-1)
		//报告ID		
		s LISRRReportID=tmpJSON.%Get("LISRR_ReportID")
		i (LISRRReportID="")
		{
			s ErroString=ErroString_";报告ID不能为空"
		}
		//患者ID
		s LISRRPatientID=tmpJSON.%Get("LISRR_PatientID")
		i (LISRRPatientID="")
		{
			s ErroString=ErroString_";患者ID不能为空"
		}
		//就诊类型
		s LISRREncounterTypeCode=tmpJSON.%Get("LISRR_EncounterTypeCode")
		//条码号
		s LISRRVisitNumber=tmpJSON.%Get("LISRR_VisitNumber")
		i (LISRRVisitNumber="")
		{
			s ErroString=ErroString_";条码号不能为空"
		}
		//就诊病案号
		s LISRRDocumentNO=tmpJSON.%Get("LISRR_DocumentNO")
		//就诊日期
		s LISRRAdmDate=tmpJSON.%Get("LISRR_AdmDate")
		//就诊时间
		s LISRRAdmTime=tmpJSON.%Get("LISRR_AdmTime")
		//证件类型(名称)
		s LISRRCertType=tmpJSON.%Get("LISRR_CertType")
		//证件号
		s LISRRCertNo=tmpJSON.%Get("LISRR_CertNo")
		//身份证号
		s LISRRIDNumber=tmpJSON.%Get("LISRR_IDNumber")
		//支付类型(名称)
		s LISRRPaymentType=tmpJSON.%Get("LISRR_PaymentType")
		//姓名
		s LISRRPatientName=tmpJSON.%Get("LISRR_PatientName")
		//性别
		s LISRRSex=tmpJSON.%Get("LISRR_Sex")
		//出生日期
		s LISRRDOB=tmpJSON.%Get("LISRR_DOB")
		//年龄
		s LISRRAge=tmpJSON.%Get("LISRR_Age")
		//年龄单位
		s LISRRAgeUnit=tmpJSON.%Get("LISRR_AgeUnit")
		//民族
		s LISRRNation=tmpJSON.%Get("LISRR_Nation")
		//申请医院
		s LISRRHospital=tmpJSON.%Get("LISRR_Hospital")
		//申请科室代码
		s LISRRDeptCode=tmpJSON.%Get("LISRR_DeptCode")
		//申请科室名称
		s LISRRDeptName=tmpJSON.%Get("LISRR_DeptName")
		//申请日期
		s LISRRRequestDate=tmpJSON.%Get("LISRR_RequestDate")
		//申请时间
		s LISRRRequestTime=tmpJSON.%Get("LISRR_RequestTime")
		//病区代码
		s LISRRWardCode=tmpJSON.%Get("LISRR_WardCode")
		//病区名称
		s LISRRWardName=tmpJSON.%Get("LISRR_WardName")
		//床号
		s LISRRBedNo=tmpJSON.%Get("LISRR_BedNo")
		//临床症状
		s LISRRSymptom=tmpJSON.%Get("LISRR_Symptom")
		//手机号
		s LISRRMobileNo=tmpJSON.%Get("LISRR_MobileNo")
		//座机号
		s LISRRPhoneNo=tmpJSON.%Get("LISRR_PhoneNo")
		//邮箱
		s LISRREmail=tmpJSON.%Get("LISRR_Email")
		//身高
		s LISRRHeight=tmpJSON.%Get("LISRR_Height")
		//体重
		s LISRRWeight=tmpJSON.%Get("LISRR_Weight")
		//血压
		s LISRRBloodPressure=tmpJSON.%Get("LISRR_BloodPressure")
		//生理条件
		s LISRRClinicalConditions=tmpJSON.%Get("LISRR_ClinicalConditions")	
		//是否怀孕
		s LISRRPregnant=tmpJSON.%Get("LISRR_Pregnant")
		//怀孕周数
		s LISRRPregnantWeeks=tmpJSON.%Get("LISRR_PregnantWeeks")
		//ABO血型
		s LISRRABO=tmpJSON.%Get("LISRR_ABO")
		//RH血型
		s LISRRRH=tmpJSON.%Get("LISRR_RH")	
		//地址
		s LISRRAddress=tmpJSON.%Get("LISRR_Address")
		//传染标志
		s LISRRInfectFlag=tmpJSON.%Get("LISRR_InfectFlag")
		//院感标志
		s LISRRInfectAlert=tmpJSON.%Get("LISRR_InfectAlert")
		//特殊标本标志
		s LISRRSpecialFlag=tmpJSON.%Get("LISRR_SpecialFlag")
		//孕次
		s LISRRPregnantNum=tmpJSON.%Get("LISRR_PregnantNum")
		//产次
		s LISRRChildbirthNum=tmpJSON.%Get("LISRR_ChildbirthNum")	
		//申请备注
		s LISRRReqNotes=tmpJSON.%Get("LISRR_ReqNotes")	
		//申请单号		
		s LISRRRequestNo=tmpJSON.%Get("LISRR_RequestNo")
		//是否加急
		s LISRRUrgent=tmpJSON.%Get("LISRR_Urgent")
		//采集日期
		s LISRRCollectDate=tmpJSON.%Get("LISRR_CollectDate")
		//采集时间
		s LISRRCollectTime=tmpJSON.%Get("LISRR_CollectTime")
		//采集者代码
		s LISRRCollectUserCode=tmpJSON.%Get("LISRR_CollectUserCode")
		//采集者描述
		s LISRRCollectUserDesc=tmpJSON.%Get("LISRR_CollectUserDesc")
		//采集部位代码
		s LISRRCollectPositionCode=tmpJSON.%Get("LISRR_CollectPositionCode")
		//采集部位名称
		s LISRRCollectPosition=tmpJSON.%Get("LISRR_CollectPosition")
		//采集容器代码
		s LISRRContainerCode=tmpJSON.%Get("LISRR_ContainerCode")
		//采集容器名称
		s LISRRContainer=tmpJSON.%Get("LISRR_Container")
		//采集说明
		s LISRRCollectNotes=tmpJSON.%Get("LISRR_CollectNotes")
		//24小时尿量
		s LISRRH24Volume=tmpJSON.%Get("LISRR_H24Volume")
		//24小时尿量时间段
		s LISRRH24UTimePeriod=tmpJSON.%Get("LISRR_H24UTimePeriod")
		//采集时体温
		s LISRRBodyTemp=tmpJSON.%Get("LISRR_BodyTemp")
		//是否保密
		s LISRRConfidential=tmpJSON.%Get("LISRR_Confidential")
		//运送日期
		s LISRRCarryDate=tmpJSON.%Get("LISRR_CarryDate")
		//运送时间
		s LISRRCarryTime=tmpJSON.%Get("LISRR_CarryTime")
		//运送者代码
		s LISRRCarryUserCode=tmpJSON.%Get("LISRR_CarryUserCode")
		//运送者描述
		s LISRRCarryUserDesc=tmpJSON.%Get("LISRR_CarryUserDesc")
		//接收日期
		s LISRRReceiveDate=tmpJSON.%Get("LISRR_ReceiveDate")
		//接收时间
		s LISRRReceiveTime=tmpJSON.%Get("LISRR_ReceiveTime")
		//接收者代码
		s LISRRReceiveUserCode=tmpJSON.%Get("LISRR_ReceiveUserCode")
		//接收者描述
		s LISRRReceiveUserDesc=tmpJSON.%Get("LISRR_ReceiveUserDesc")
		//接收时标本质量
		s LISRRSpecimenQuality=tmpJSON.%Get("LISRR_SpecimenQuality")
		//接收说明
		s LISRRReceiveNotes=tmpJSON.%Get("LISRR_ReceiveNotes")
		//入库日期
		s LISRRInStorageDate=tmpJSON.%Get("LISRR_InStorageDate")
		//入库时间
		s LISRRInStorageTime=tmpJSON.%Get("LISRR_InStorageTime")
		//入库者代码
		s LISRRInStorageUserCode=tmpJSON.%Get("LISRR_InStorageUserCode")
		//入库者描述
		s LISRRInStorageUserDesc=tmpJSON.%Get("LISRR_InStorageUserDesc")
		//出库日期
		s LISRROutStorageDate=tmpJSON.%Get("LISRR_OutStorageDate")
		//出库时间
		s LISRROutStorageTime=tmpJSON.%Get("LISRR_OutStorageTime")
		//出库者代码
		s LISRROutStorageUserCode=tmpJSON.%Get("LISRR_OutStorageUserCode")
		//出库者描述
		s LISRROutStorageUserDesc=tmpJSON.%Get("LISRR_OutStorageUserDesc")
		//出库类型
		s LISRROutStorageType=tmpJSON.%Get("LISRR_OutStorageType")
		//创建日期
		s LISRRAddDate=tmpJSON.%Get("LISRR_AddDate")
		//创建时间
		s LISRRAddTime=tmpJSON.%Get("LISRR_AddTime")
		//创建者代码
		s LISRRAddUserCode=tmpJSON.%Get("LISRR_AddUserCode")
		//创建者描述
		s LISRRAddUserDesc=tmpJSON.%Get("LISRR_AddUserDesc")
		//创建类型
		s LISRRAddType=tmpJSON.%Get("LISRR_AddType")
		//送达日期
		s LISRRArriveDate=tmpJSON.%Get("LISRR_ArriveDate")
		//送达时间
		s LISRRArriveTime=tmpJSON.%Get("LISRR_ArriveTime")
		//送达者代码
		s LISRRArriveUserCode=tmpJSON.%Get("LISRR_ArriveUserCode")
		//送达者描述
		s LISRRArriveUserDesc=tmpJSON.%Get("LISRR_ArriveUserDesc")
		//送达位置
		s LISRRArriveWorkGroup=tmpJSON.%Get("LISRR_ArriveWorkGroup")
		//上机日期
		s LISRRMachineDate=tmpJSON.%Get("LISRR_MachineDate")
		//上机时间
		s LISRRMachineTime=tmpJSON.%Get("LISRR_MachineTime")
		//检测日期
		s LISRRTestDate=tmpJSON.%Get("LISRR_TestDate")
		//检测时间
		s LISRRTestTime=tmpJSON.%Get("LISRR_TestTime")
		//作废日期
		s LISRRCancelDate=tmpJSON.%Get("LISRR_CancelDate")
		//作废时间
		s LISRRCancelTime=tmpJSON.%Get("LISRR_CancelTime")
		//作废者代码
		s LISRRCancelUserCode=tmpJSON.%Get("LISRR_CancelUserCode")
		//作废者描述
		s LISRRCancelUserDesc=tmpJSON.%Get("LISRR_CancelUserDesc")
		//作废原因
		s LISRRCancelReason=tmpJSON.%Get("LISRR_CancelReason")
		//报告内容Xml
		s LISRRReprotXml=tmpJSON.%Get("LISRR_ReprotXml")
		//报告内容Pdf
		s LISRRReprotPdf=tmpJSON.%Get("LISRR_ReprotPdf")
		//报告类型（1普通，2危急，0其他）
		s LISRRReprotType=tmpJSON.%Get("LISRR_ReprotType")
		//备注
		s LISRRRemarks=tmpJSON.%Get("LISRR_Remarks")
		//是否微生物报告 1:微生物报告; 2:普通报告
		s LISRRISMcroorganism=tmpJSON.%Get("LISRR_ISMcroorganism")
		//时间戳日期
		s LISRRUpdateDate=tmpJSON.%Get("LISRR_UpdateDate")
		//时间戳时间
		s LISRRUpdateTime=tmpJSON.%Get("LISRR_UpdateTime")
		//鉴定结果
		s LISRRIdentifition=tmpJSON.%Get("LISRR_Identifition")
		//审核日期
		s LISRRCheckDate=tmpJSON.%Get("LISRR_CheckDate")
		//审核时间
		s LISRRCheckTime=tmpJSON.%Get("LISRR_CheckTime")
		//审核医生代码
		s LISRRCheckUserCode=tmpJSON.%Get("LISRR_CheckUserCode")
		//审核医生描述
		s LISRRCheckUserDesc=tmpJSON.%Get("LISRR_CheckUserDesc")
		//初审日期
		s LISRRFirstCheckDate=tmpJSON.%Get("LISRR_FirstCheckDate")
		//初审时间
		s LISRRFirstCheckTime=tmpJSON.%Get("LISRR_FirstCheckTime")
		//初审医生代码
		s LISRRFirstCheckUserCode=tmpJSON.%Get("LISRR_FirstCheckUserCode")
		//初审医生描述
		s LISRRFirstCheckUserDesc=tmpJSON.%Get("LISRR_FirstCheckUserDesc")
		//医嘱描述(针对于没有项目代码，只有项目名称的情况)
		s LISRROrderItemDesc=tmpJSON.%Get("LISRR_OrderItemDesc")
		//异常标识代码
		s LISRRWarnCode=tmpJSON.%Get("LISRR_WarnCode")
		//报告状态（1审核，2取消审核，3作废）
		s LISRRStatus=tmpJSON.%Get("LISRR_Status")
		//审核方式（1手工，2自动）
		s LISRRAuthType=tmpJSON.%Get("LISRR_AuthType")
		//传输日期
		s LISRRTransmitDate=tmpJSON.%Get("LISRR_TransmitDate")
		//工作小组代码
		s LISRRWorkGroupCode=tmpJSON.%Get("LISRR_WorkGroupCode")
		//工作小组名称
		s LISRRWorkGroupDesc=tmpJSON.%Get("LISRR_WorkGroupDesc")
		//标本报告序号
		s LISRROrder=tmpJSON.%Get("LISRR_Order")
		//条码号
		s LISRRSpecimenID=tmpJSON.%Get("LISRR_SpecimenID")
		//细菌鉴定号
		s LISRRAccessionNo=tmpJSON.%Get("LISRR_AccessionNo")
		//核收日期
		s LISRRAcceptDate=tmpJSON.%Get("LISRR_AcceptDate")
		//核收时间
		s LISRRAcceptTime=tmpJSON.%Get("LISRR_AcceptTime")
		//核收者代码
		s LISRRAcceptUserCode=tmpJSON.%Get("LISRR_AcceptUserCode")
		//核收者姓名
		s LISRRAcceptUserDesc=tmpJSON.%Get("LISRR_AcceptUserDesc")
		//重审日期
		s LISRRReCheckDate=tmpJSON.%Get("LISRR_ReCheckDate")
		//重审时间
		s LISRRReCheckTime=tmpJSON.%Get("LISRR_ReCheckTime")
		//重审者代码
		s LISRRReCheckUserCode=tmpJSON.%Get("LISRR_ReCheckUserCode")
		//重审者姓名
		s LISRRReCheckUserDesc=tmpJSON.%Get("LISRR_ReCheckUserDesc")
		//是否自动审核（1:是；2：否）
		s LISRRAutoCheck=tmpJSON.%Get("LISRR_AutoCheck")
		//是否数字签名
		s LISRRDigitSign=tmpJSON.%Get("LISRR_DigitSign")
		//签名字符串
		s LISRRDigitSignString=tmpJSON.%Get("LISRR_DigitSignString")
		//签名时间
		s LISRRDigitSignTime=tmpJSON.%Get("LISRR_DigitSignTime")
		//是否打印（1:是；2：否）
		s LISRRPrinted=tmpJSON.%Get("LISRR_Printed")
		//是否阅读
		s LISRRReaded=tmpJSON.%Get("LISRR_Readed")
		//首次阅读日期
		s LISRRFirstReadDate=tmpJSON.%Get("LISRR_FirstReadDate")
		//首次阅读时间
		s LISRRFirstReadTime=tmpJSON.%Get("LISRR_FirstReadTime")
		//首次阅读医生代码
		s LISRRFirstReadUserCode=tmpJSON.%Get("LISRR_FirstReadUserCode")
		//首次阅读医生姓名
		s LISRRFirstReadUserDesc=tmpJSON.%Get("LISRR_FirstReadUserDesc")
		//报告主评价
		s LISRRMainConclusion=tmpJSON.%Get("LISRR_MainConclusion")
		//报告次评价
		s LISRRMinorConclusion=tmpJSON.%Get("LISRR_MinorConclusion")
		//复查号
		s LISRRReAssayNumber=tmpJSON.%Get("LISRR_ReAssayNumber")
		//院区代码
		s LISRRHosCode=tmpJSON.%Get("LISRR_HosCode")
		//标本名称
		s LISRRSpecimenDesc=tmpJSON.%Get("LISRR_SpecimenDesc")
		//医嘱号
		s LISSROrderItemID=tmpJSON.%Get("LISSR_OrderItemID")
		
		s PatientDr=""
		s:LISRRPatientID'="" PatientDr=$o(^PAPERi("PAPMI_PatNo",LISRRPatientID,""))
		i (PatientDr="")
		{
			s ErroString=ErroString_";患者基本信息在系统内不存在！"
		}
		q:PatientDr=""
		s AdmNo=..GetAdmByLabNo(LISRRVisitNumber)
		i (AdmNo="")
		{
			s ErroString=ErroString_";患者就诊记录在系统内不存在！"
		}
		q:AdmNo=""
		s:(LISRREncounterTypeCode="")&&(AdmNo'="") LISRREncounterTypeCode=$p($g(^PAADM(AdmNo)),"^",2)
		s:LISRRDocumentNO="" LISRRDocumentNO=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientDr,"I","",.ErrMsg)
		s:(LISRRAdmDate="")&&(AdmNo'="") LISRRAdmDate=$p($g(^PAADM(AdmNo)),"^",6)
		s:(LISRRAdmTime="")&&(AdmNo'="") LISRRAdmTime=$p($g(^PAADM(AdmNo)),"^",7)
		//姓名
		s LISRRPatientName=$p($g(^PAPER(PatientDr,"ALL")),"^",1)
		ts
		//出生日期
		s LISRRDOB=..TransDateFormat(LISRRDOB)
		//申请日期
		s LISRRRequestDate=..TransDateFormat(LISRRRequestDate)
		//申请时间
		s LISRRRequestTime=..TransTimeFormat(LISRRRequestTime)
		//采集日期
		s LISRRCollectDate=..TransDateFormat(LISRRCollectDate)
		//采集时间
		s LISRRCollectTime=..TransTimeFormat(LISRRCollectTime)
		//运送日期
		s LISRRCarryDate=..TransDateFormat(LISRRCarryDate)
		//运送时间
		s LISRRCarryTime=..TransTimeFormat(LISRRCarryTime)
		//接收日期
		s LISRRReceiveDate=..TransDateFormat(LISRRReceiveDate)
		//接收时间
		s LISRRReceiveTime=..TransTimeFormat(LISRRReceiveTime)
		//入库日期
		s LISRRInStorageDate=..TransDateFormat(LISRRInStorageDate)
		//入库时间
		s LISRRInStorageTime=..TransTimeFormat(LISRRInStorageTime)
		//出库日期
		s LISRROutStorageDate=..TransDateFormat(LISRROutStorageDate)
		//出库时间
		s LISRROutStorageTime=..TransTimeFormat(LISRROutStorageTime)
		//创建日期
		s LISRRAddDate=..TransDateFormat(LISRRAddDate)
		//创建时间
		s LISRRAddTime=..TransTimeFormat(LISRRAddTime)
		//送达日期
		s LISRRArriveDate=..TransDateFormat(LISRRArriveDate)
		//送达时间
		s LISRRArriveTime=..TransTimeFormat(LISRRArriveTime)
		//上机日期
		s LISRRMachineDate=..TransDateFormat(LISRRMachineDate)
		//上机时间
		s LISRRMachineTime=..TransTimeFormat(LISRRMachineTime)
		//检测日期
		s LISRRTestDate=..TransDateFormat(LISRRTestDate)
		//检测时间
		s LISRRTestTime=..TransTimeFormat(LISRRTestTime)
		//作废日期
		s LISRRCancelDate=..TransDateFormat(LISRRCancelDate)
		//作废时间
		s LISRRCancelTime=..TransTimeFormat(LISRRCancelTime)
		//时间戳日期
		s LISRRUpdateDate=..TransDateFormat(LISRRUpdateDate)
		//时间戳时间
		s LISRRUpdateTime=..TransTimeFormat(LISRRUpdateTime)
		//审核日期
		s LISRRCheckDate=..TransDateFormat(LISRRCheckDate)
		//审核时间
		s LISRRCheckTime=..TransTimeFormat(LISRRCheckTime)
		//初审日期
		s LISRRFirstCheckDate=..TransDateFormat(LISRRFirstCheckDate)
		//初审时间
		s LISRRFirstCheckTime=..TransTimeFormat(LISRRFirstCheckTime)
		//传输日期
		s LISRRTransmitDate=..TransDateFormat(LISRRTransmitDate)
		//核收日期
		s LISRRAcceptDate=..TransDateFormat(LISRRAcceptDate)
		//核收时间
		s LISRRAcceptTime=..TransTimeFormat(LISRRAcceptTime)
		//重审日期
		s LISRRReCheckDate=..TransDateFormat(LISRRReCheckDate)
		//重审时间
		s LISRRReCheckTime=..TransTimeFormat(LISRRReCheckTime)
		//首次阅读日期
		s LISRRFirstReadDate=..TransDateFormat(LISRRFirstReadDate)
		//首次阅读时间
		s LISRRFirstReadTime=..TransTimeFormat(LISRRFirstReadTime)
		s:LISRRUpdateDate="" LISRRUpdateDate=+$h
		s:LISRRUpdateTime="" LISRRUpdateTime=$p($h,",",2)
		//手工计费的医嘱rowid串，多条逗号分隔
		s LISSRManualOrdItemList=tmpJSON.%Get("LISSR_ManualOrdItemList")
		//标本评价
		s LISRRSpecConc=tmpJSON.%Get("LISRR_SpecConc")
		s rptID=""
		&sql(select %id into :rptID from sqlUser.Ens_LISReportResult where LISRR_ReportID=:LISRRReportID)
		if rptID=""
		{
			&sql(insert into sqlUser.Ens_LISReportResult(LISRR_ReportID,LISRR_PatientID,LISRR_EncounterTypeCode,LISRR_VisitNumber,LISRR_DocumentNO,LISRR_AdmDate,LISRR_AdmTime,LISRR_CertType,LISRR_CertNo,LISRR_IDNumber,LISRR_PaymentType,LISRR_PatientName,LISRR_Sex,LISRR_DOB,LISRR_Age,LISRR_AgeUnit,LISRR_Nation,LISRR_Hospital,LISRR_DeptCode,LISRR_DeptName,LISRR_RequestDate,LISRR_RequestTime,
			LISRR_WardCode,LISRR_WardName,LISRR_BedNo,LISRR_Symptom,LISRR_MobileNo,LISRR_PhoneNo,LISRR_Email,LISRR_Height,LISRR_Weight,LISRR_ClinicalConditions,LISRR_Pregnant,LISRR_PregnantWeeks,LISRR_ABO,LISRR_RH,LISRR_Address,LISRR_InfectFlag,LISRR_InfectAlert,LISRR_SpecialFlag,LISRR_PregnantNum,LISRR_ChildbirthNum,LISRR_ReqNotes,LISRR_RequestNo,LISRR_Urgent,
			LISRR_CollectDate,LISRR_CollectTime,LISRR_CollectUserCode,LISRR_CollectUserDesc,LISRR_CollectPositionCode,LISRR_CollectPosition,LISRR_ContainerCode,LISRR_Container,LISRR_CollectNotes,LISRR_H24Volume,LISRR_H24UTimePeriod,LISRR_BodyTemp,LISRR_Confidential,LISRR_CarryDate,LISRR_CarryTime,LISRR_CarryUserCode,LISRR_CarryUserDesc,LISRR_ReceiveDate,LISRR_ReceiveTime,LISRR_ReceiveUserCode,LISRR_ReceiveUserDesc,
			LISRR_SpecimenQuality,LISRR_ReceiveNotes,LISRR_InStorageDate,LISRR_InStorageTime,LISRR_InStorageUserCode,LISRR_InStorageUserDesc,LISRR_OutStorageDate,LISRR_OutStorageTime,LISRR_OutStorageUserCode,LISRR_OutStorageUserDesc,LISRR_OutStorageType,LISRR_AddDate,LISRR_AddTime,LISRR_AddUserCode,LISRR_AddUserDesc,LISRR_AddType,LISRR_ArriveDate,LISRR_ArriveTime,LISRR_ArriveUserCode,LISRR_ArriveUserDesc,
			LISRR_ArriveWorkGroup,LISRR_MachineDate,LISRR_MachineTime,LISRR_TestDate,LISRR_TestTime,LISRR_CancelDate,LISRR_CancelTime,LISRR_CancelUserCode,LISRR_CancelUserDesc,LISRR_CancelReason,LISRR_ReprotXml,LISRR_ReprotPdf,LISRR_ReprotType,LISRR_Remarks,LISRR_ISMcroorganism,LISRR_UpdateDate,LISRR_UpdateTime,LISRR_Identifition,LISRR_CheckDate,LISRR_CheckTime,LISRR_CheckUserCode,LISRR_CheckUserDesc,LISRR_FirstCheckDate,LISRR_FirstCheckTime,
			LISRR_FirstCheckUserCode,LISRR_FirstCheckUserDesc,LISRR_OrderItemDesc,LISRR_WarnCode,LISRR_Status,LISRR_AuthType,LISRR_TransmitDate,LISRR_WorkGroupCode,LISRR_WorkGroupDesc,LISRR_Order,LISRR_SpecimenID,LISRR_AccessionNo,LISRR_AcceptDate,LISRR_AcceptTime,LISRR_AcceptUserCode,LISRR_AcceptUserDesc,LISRR_ReCheckDate,LISRR_ReCheckTime,LISRR_ReCheckUserCode,LISRR_ReCheckUserDesc,LISRR_AutoCheck,LISRR_DigitSign,
			LISRR_DigitSignString,LISRR_DigitSignTime,LISRR_Printed,LISRR_Readed,LISRR_FirstReadDate,LISRR_FirstReadTime,LISRR_FirstReadUserCode,LISRR_FirstReadUserDesc,LISRR_MainConclusion,LISRR_MinorConclusion,LISRR_ReAssayNumber,LISRR_HosCode,LISRR_SpecimenDesc,LISRR_HosName,LISRR_ManualOrdItemList,LISRR_SpecConc)
			values(:LISRRReportID,:PatientDr,:LISRREncounterTypeCode,:AdmNo,:LISRRDocumentNO,:LISRRAdmDate,:LISRRAdmTime,:LISRRCertType,:LISRRCertNo,:LISRRIDNumber,:LISRRPaymentType,:LISRRPatientName,:LISRRSex,:LISRRDOB,:LISRRAge,:LISRRAgeUnit,:LISRRNation,:LISRRHospital,:LISRRDeptCode,:LISRRDeptName,:LISRRRequestDate,:LISRRRequestTime,
			:LISRRWardCode,:LISRRWardName,:LISRRBedNo,:LISRRSymptom,:LISRRMobileNo,:LISRRPhoneNo,:LISRREmail,:LISRRHeight,:LISRRWeight,:LISRRClinicalConditions,:LISRRPregnant,:LISRRPregnantWeeks,:LISRRABO,:LISRRRH,:LISRRAddress,:LISRRInfectFlag,:LISRRInfectAlert,:LISRRSpecialFlag,:LISRRPregnantNum,:LISRRChildbirthNum,:LISRRReqNotes,:LISRRRequestNo,:LISRRUrgent,
			:LISRRCollectDate,:LISRRCollectTime,:LISRRCollectUserCode,:LISRRCollectUserDesc,:LISRRCollectPositionCode,:LISRRCollectPosition,:LISRRContainerCode,:LISRRContainer,:LISRRCollectNotes,:LISRRH24Volume,:LISRRH24UTimePeriod,:LISRRBodyTemp,:LISRRConfidential,:LISRRCarryDate,:LISRRCarryTime,:LISRRCarryUserCode,:LISRRCarryUserDesc,:LISRRReceiveDate,:LISRRReceiveTime,:LISRRReceiveUserCode,:LISRRReceiveUserDesc,
			:LISRRSpecimenQuality,:LISRRReceiveNotes,:LISRRInStorageDate,:LISRRInStorageTime,:LISRRInStorageUserCode,:LISRRInStorageUserDesc,:LISRROutStorageDate,:LISRROutStorageTime,:LISRROutStorageUserCode,:LISRROutStorageUserDesc,:LISRROutStorageType,:LISRRAddDate,:LISRRAddTime,:LISRRAddUserCode,:LISRRAddUserDesc,:LISRRAddType,:LISRRArriveDate,:LISRRArriveTime,:LISRRArriveUserCode,:LISRRArriveUserDesc,
			:LISRRArriveWorkGroup,:LISRRMachineDate,:LISRRMachineTime,:LISRRTestDate,:LISRRTestTime,:LISRRCancelDate,:LISRRCancelTime,:LISRRCancelUserCode,:LISRRCancelUserDesc,:LISRRCancelReason,:LISRRReprotXml,:LISRRReprotPdf,:LISRRReprotType,:LISRRRemarks,:LISRRISMcroorganism,:LISRRUpdateDate,:LISRRUpdateTime,:LISRRIdentifition,:LISRRCheckDate,:LISRRCheckTime,:LISRRCheckUserCode,:LISRRCheckUserDesc,:LISRRFirstCheckDate,:LISRRFirstCheckTime,
			:LISRRFirstCheckUserCode,:LISRRFirstCheckUserDesc,:LISRROrderItemDesc,:LISRRWarnCode,:LISRRStatus,:LISRRAuthType,:LISRRTransmitDate,:LISRRWorkGroupCode,:LISRRWorkGroupDesc,:LISRROrder,:LISRRSpecimenID,:LISRRAccessionNo,:LISRRAcceptDate,:LISRRAcceptTime,:LISRRAcceptUserCode,:LISRRAcceptUserDesc,:LISRRReCheckDate,:LISRRReCheckTime,:LISRRReCheckUserCode,:LISRRReCheckUserDesc,:LISRRAutoCheck,:LISRRDigitSign,
			:LISRRDigitSignString,:LISRRDigitSignTime,:LISRRPrinted,:LISRRReaded,:LISRRFirstReadDate,:LISRRFirstReadTime,:LISRRFirstReadUserCode,:LISRRFirstReadUserDesc,:LISRRMainConclusion,:LISRRMinorConclusion,:LISRRReAssayNumber,:LISRRHosCode,:LISRRSpecimenDesc,:LISRRHosName,:LISSRManualOrdItemList,:LISRRSpecConc))
			if SQLCODE'=0
			{
				tro	
				s ErroString=ErroString_" "_$g(%msg)
			}
		}
		else
		{
			&sql(update sqlUser.Ens_LISReportResult set LISRR_ReportID=:LISRRReportID,LISRR_PatientID=:PatientDr,LISRR_EncounterTypeCode=:LISRREncounterTypeCode,LISRR_VisitNumber=:AdmNo,LISRR_DocumentNO=:LISRRDocumentNO,LISRR_AdmDate=:LISRRAdmDate,LISRR_AdmTime=:LISRRAdmTime,LISRR_CertType=:LISRRCertType,LISRR_CertNo=:LISRRCertNo,LISRR_IDNumber=:LISRRIDNumber,LISRR_PaymentType=:LISRRPaymentType,LISRR_PatientName=:LISRRPatientName,LISRR_Sex=:LISRRSex,LISRR_DOB=:LISRRDOB,LISRR_Age=:LISRRAge,LISRR_AgeUnit=:LISRRAgeUnit,LISRR_Nation=:LISRRNation,LISRR_Hospital=:LISRRHospital,LISRR_DeptCode=:LISRRDeptCode,LISRR_DeptName=:LISRRDeptName,LISRR_RequestDate=:LISRRRequestDate,LISRR_RequestTime=:LISRRRequestTime,
			LISRR_WardCode=:LISRRWardCode,LISRR_WardName=:LISRRWardName,LISRR_BedNo=:LISRRBedNo,LISRR_Symptom=:LISRRSymptom,LISRR_MobileNo=:LISRRMobileNo,LISRR_PhoneNo=:LISRRPhoneNo,LISRR_Email=:LISRREmail,LISRR_Height=:LISRRHeight,LISRR_Weight=:LISRRWeight,LISRR_ClinicalConditions=:LISRRClinicalConditions,LISRR_Pregnant=:LISRRPregnant,LISRR_PregnantWeeks=:LISRRPregnantWeeks,LISRR_ABO=:LISRRABO,LISRR_RH=:LISRRRH,LISRR_Address=:LISRRAddress,LISRR_InfectFlag=:LISRRInfectFlag,LISRR_InfectAlert=:LISRRInfectAlert,LISRR_SpecialFlag=:LISRRSpecialFlag,LISRR_PregnantNum=:LISRRPregnantNum,LISRR_ChildbirthNum=:LISRRChildbirthNum,LISRR_ReqNotes=:LISRRReqNotes,LISRR_RequestNo=:LISRRRequestNo,LISRR_Urgent=:LISRRUrgent,
			LISRR_CollectDate=:LISRRCollectDate,LISRR_CollectTime=:LISRRCollectTime,LISRR_CollectUserCode=:LISRRCollectUserCode,LISRR_CollectUserDesc=:LISRRCollectUserDesc,LISRR_CollectPositionCode=:LISRRCollectPositionCode,LISRR_CollectPosition=:LISRRCollectPosition,LISRR_ContainerCode=:LISRRContainerCode,LISRR_Container=:LISRRContainer,LISRR_CollectNotes=:LISRRCollectNotes,LISRR_H24Volume=:LISRRH24Volume,LISRR_H24UTimePeriod=:LISRRH24VolumePeriod,LISRR_BodyTemp=:LISRRBodyTemp,LISRR_Confidential=:LISRRConfidential,LISRR_CarryDate=:LISRRCarryDate,LISRR_CarryTime=:LISRRCarryTime,LISRR_CarryUserCode=:LISRRCarryUserCode,LISRR_CarryUserDesc=:LISRRCarryUserDesc,LISRR_ReceiveDate=:LISRRReceiveDate,LISRR_ReceiveTime=:LISRRReceiveTime,LISRR_ReceiveUserCode=:LISRRReceiveUserCode,LISRR_ReceiveUserDesc=:LISRRReceiveUserDesc,
			LISRR_SpecimenQuality=:LISRRSpecimenQuality,LISRR_ReceiveNotes=:LISRRReceiveNotes,LISRR_InStorageDate=:LISRRInStorageDate,LISRR_InStorageTime=:LISRRInStorageTime,LISRR_InStorageUserCode=:LISRRInStorageUserCode,LISRR_InStorageUserDesc=:LISRRInStorageUserDesc,LISRR_OutStorageDate=:LISRROutStorageDate,LISRR_OutStorageTime=:LISRROutStorageTime,LISRR_OutStorageUserCode=:LISRROutStorageUserCode,LISRR_OutStorageUserDesc=:LISRROutStorageUserDesc,LISRR_OutStorageType=:LISRROutStorageType,LISRR_AddDate=:LISRRAddDate,LISRR_AddTime=:LISRRAddTime,LISRR_AddUserCode=:LISRRAddUserCode,LISRR_AddUserDesc=:LISRRAddUserDesc,LISRR_AddType=:LISRRAddType,LISRR_ArriveDate=:LISRRArriveDate,LISRR_ArriveTime=:LISRRArriveTime,LISRR_ArriveUserCode=:LISRRArriveUserCode,LISRR_ArriveUserDesc=:LISRRArriveUserDesc,
			LISRR_ArriveWorkGroup=:LISRRArriveWorkGroup,LISRR_MachineDate=:LISRRMachineDate,LISRR_MachineTime=:LISRRMachineTime,LISRR_TestDate=:LISRRTestDate,LISRR_TestTime=:LISRRTestTime,LISRR_CancelDate=:LISRRCancelDate,LISRR_CancelTime=:LISRRCancelTime,LISRR_CancelUserCode=:LISRRCancelUserCode,LISRR_CancelUserDesc=:LISRRCancelUserDesc,LISRR_CancelReason=:LISRRCancelReason,LISRR_ReprotXml=:LISRRReprotXml,LISRR_ReprotPdf=:LISRRReprotPdf,LISRR_ReprotType=:LISRRReprotType,LISRR_Remarks=:LISRRRemarks,LISRR_ISMcroorganism=:LISRRISMcroorganism,LISRR_UpdateDate=:LISRRUpdateDate,LISRR_UpdateTime=:LISRRUpdateTime,LISRR_Identifition=:LISRRIdentifition,LISRR_CheckDate=:LISRRCheckDate,LISRR_CheckTime=:LISRRCheckTime,LISRR_CheckUserCode=:LISRRCheckUserCode,LISRR_CheckUserDesc=:LISRRCheckUserDesc,LISRR_FirstCheckDate=:LISRRFirstCheckDate,LISRR_FirstCheckTime=:LISRRFirstCheckTime,
			LISRR_FirstCheckUserCode=:LISRRFirstCheckUserCode,LISRR_FirstCheckUserDesc=:LISRRFirstCheckUserDesc,LISRR_OrderItemDesc=:LISRROrderItemDesc,LISRR_WarnCode=:LISRRWarnCode,LISRR_Status=:LISRRStatus,LISRR_AuthType=:LISRRAuthType,LISRR_TransmitDate=:LISRRTransmitDate,LISRR_WorkGroupCode=:LISRRWorkGroupCode,LISRR_WorkGroupDesc=:LISRRWorkGroupDesc,LISRR_Order=:LISRROrder,LISRR_SpecimenID=:LISRRSpecimenID,LISRR_AccessionNo=:LISRRAccessionNo,LISRR_AcceptDate=:LISRRAcceptDate,LISRR_AcceptTime=:LISRRAcceptTime,LISRR_AcceptUserCode=:LISRRAcceptUserCode,LISRR_AcceptUserDesc=:LISRRAcceptUserDesc,LISRR_ReCheckDate=:LISRRReCheckDate,LISRR_ReCheckTime=:LISRRReCheckTime,LISRR_ReCheckUserCode=:LISRRReCheckUserCode,LISRR_ReCheckUserDesc=:LISRRReCheckUserDesc,LISRR_AutoCheck=:LISRRAutoCheck,LISRR_DigitSign=:LISRRDigitSign,
			LISRR_DigitSignString=:LISRRDigitSignString,LISRR_DigitSignTime=:LISRRDigitSignTime,LISRR_Printed=:LISRRPrinted,LISRR_Readed=:LISRRReaded,LISRR_FirstReadDate=:LISRRFirstReadDate,LISRR_FirstReadTime=:LISRRFirstReadTime,LISRR_FirstReadUserCode=:LISRRFirstReaUserCode,LISRR_FirstReadUserDesc=:LISRRFirstReadUserDesc,LISRR_MainConclusion=:LISRRMainConclusion,LISRR_MinorConclusion=:LISRRMinorConclusion,LISRR_ReAssayNumber=:LISRRReAssayNumber,LISRR_HosCode=:LISRRHosCode,LISRR_SpecimenDesc=:LISRRSpecimenDesc,LISRR_HosName=:LISRRHosName,LISRR_ManualOrdItemList=:LISSRManualOrdItemList,LISRR_SpecConc=:LISRRSpecConc where %id=:rptID) 
			if SQLCODE'=0
			{
				tro	
				s ErroString=ErroString_" "_$g(%msg)
			}
		}
		
		//检验结果list
		s LISRItemResult=tmpJSON.%Get("LISRR_ItemResult")
		if LISRItemResult'=""
		{
			if ($d(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"))))&&(LISRRISMcroorganism'="1") //插入检验结果表前，如果有历史数据，先清除
			{
				&SQL(delete from SQLUser.Ens_LISItemResult where LISIR_ReportID=:LISRRReportID)
				if SQLCODE'=0
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)	
				}
			}
			elseif ($d(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"))))&&(LISRRISMcroorganism="1") //&&(tmpResJSON.%Get("LISISR_ItemSenResult")="") //插入检验结果表前，如果有微生物历史数据并且有药敏结果，先清除药敏结果表再清除检验结果表
			{
				set LISIRItemCode=""
				for {
					set LISIRItemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode)) 
					q:LISIRItemCode=""
					set ResultDR=""
					for {
						set ResultDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISRRReportID,"U"),LISIRItemCode,ResultDR))
						q:ResultDR=""
						set LISISRResultID=$lg(^Busi.ENS.EnsLISItemResultD(ResultDR),2)
						if ($d(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID))){
							&SQL(delete from SQLUser.Ens_LISItemSenResult where LISISR_ResultID=:LISISRResultID)
							if SQLCODE'=0
							{
								tro
								s ErroString=ErroString_" "_$g(%msg)	
							}
						}
					}
				}
				&SQL(delete from SQLUser.Ens_LISItemResult where LISIR_ReportID=:LISRRReportID)
				if SQLCODE'=0
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)	
				}
			}	
		}
		s LISRItemResNum=LISRItemResult.%Size()
		for j=1:1:LISRItemResNum
		{
			s tmpResJSON=LISRItemResult.%Get(j-1)
			s LISIRReportID=tmpJSON.%Get("LISRR_ReportID")
			s LISIRPatientID=tmpJSON.%Get("LISRR_PatientID")
			s LISIRVisitNumber=tmpJSON.%Get("LISRR_VisitNumber")
			s LISIRItemCode=tmpResJSON.%Get("LISIR_ItemCode")
			s LISIRItemDesc=tmpResJSON.%Get("LISIR_ItemDesc")
			s LISIRResult=tmpResJSON.%Get("LISIR_Result")
			s:LISRRISMcroorganism="1" LISIRResult=tmpResJSON.%Get("LISIR_TextResult")
			s LISIRUint=tmpResJSON.%Get("LISIR_Uint")
			s LISIRTextResult=tmpResJSON.%Get("LISIR_TextResult")
			s LISIRExtraResult=tmpResJSON.%Get("LISIR_ExtraResult")
			s LISIRResultExplain=tmpResJSON.%Get("LISIR_ResultExplain")
			s LISIRAbnormalFlags=tmpResJSON.%Get("LISIR_AbnormalFlags")
			s LISIRRanges=tmpResJSON.%Get("LISIR_Ranges")
			s LISIRTestMethod=tmpResJSON.%Get("LISIR_TestMethod")
			s LISIRTestMachine=tmpResJSON.%Get("LISIR_TestMachine")
			s LISIRTestUserCode=tmpResJSON.%Get("LISIR_TestUserCode")
			s LISIRTestUserDesc=tmpResJSON.%Get("LISIR_TestUserDesc")
			s LISIRShowSeq=tmpResJSON.%Get("LISIR_ShowSeq")
			s LISIRTestDate=tmpResJSON.%Get("LISIR_TestDate")
			s:LISIRTestDate'="" LISIRTestDate=$zdh(LISIRTestDate,8)
			s LISIRTestTime=tmpResJSON.%Get("LISIR_TestTime")
			s LISIRCount=tmpResJSON.%Get("LISIR_Count")
			s LISIRExpertRule=tmpResJSON.%Get("LISIR_ExpertRule")
			s LISIRRemark=tmpResJSON.%Get("LISIR_Remark")
			s LISIRUpdateDate=tmpResJSON.%Get("LISIR_UpdateDate")
			s LISIRUpdateTime=tmpResJSON.%Get("LISIR_UpdateTime")
			s LISIRInterCode=tmpResJSON.%Get("LISIR_InterCode")
			s LISIROrderItemID=tmpResJSON.%Get("LISIR_OrderItemID")
			s LISIRAssayStatus=tmpResJSON.%Get("LISIR_AssayStatus")
			s LISIRReAssayNum=tmpResJSON.%Get("LISIR_ReAssayNum")
			s LISIRResClass=tmpResJSON.%Get("LISIR_ResClass")
			s LISIROrganism=tmpResJSON.%Get("LISIR_Organism")
			s LISIRReAssayNumber=tmpResJSON.%Get("LISIR_ReAssayNumber")
			s LISIRMultipleResistant=tmpResJSON.%Get("LISIR_MultipleResistant")
			s LISIRMultipleResChild=tmpResJSON.%Get("LISIR_MultipleResChild")
			s LISIRTestCodeHosCode=tmpResJSON.%Get("LISIR_TestCodeHosCode") //检验基础数据所属院区
			s:LISIRTestCodeHosCode'="" LISRRHosCode=LISIRTestCodeHosCode //如果检验基础数据所属院区非开单院区，则以LISIR_TestCodeHosCode为准
			s LISIRItemID=..GetTestCodeID(LISIRItemCode,LISIRItemDesc,LISRRHosCode)
			s:LISIRItemID="" LISIRItemID=..AddTestCode(LISIRItemCode,LISIRItemDesc,LISRRHosCode,LISRRISMcroorganism)
			s LISItemResID=""
			&sql(select %id into :LISItemResID from sqlUser.Ens_LISItemResult where LISIR_ReportID=:LISIRReportID and LISIR_ItemCode=:LISIRItemID)
			s:LISIRTestDate="" LISIRTestDate=LISRRCheckDate
			s:LISIRTestTime="" LISIRTestTime=LISRRCheckTime
			s:LISIRUpdateDate="" LISIRUpdateDate=+$h
			s:LISIRUpdateTime="" LISIRUpdateTime=$p($h,",",2)
			
			if LISItemResID=""
			{
				&sql(insert into SqlUser.Ens_LISItemResult(LISIR_ReportID,LISIR_PatientID,LISIR_VisitNumber,LISIR_ItemCode,LISIR_ItemDesc,LISIR_Result,LISIR_Uint,LISIR_TextResult,LISIR_ExtraResult,LISIR_ResultExplain,LISIR_AbnormalFlags,LISIR_Ranges,LISIR_TestMethod,LISIR_TestMachine,LISIR_TestUserCode,LISIR_TestUserDesc,LISIR_ShowSeq,LISIR_TestDate,LISIR_TestTime,LISIR_Count,
				LISIR_ExpertRule,LISIR_Remark,LISIR_UpdateDate,LISIR_UpdateTime,LISIR_InterCode,LISIR_OrderItemID,LISIR_AssayStatus,LISIR_ReAssayNum,LISIR_ResClass,LISIR_Organism,LISIR_ReAssayNumber,LISIR_MultipleResistant,LISIR_MultipleResChild)
				values(:LISIRReportID,:PatientDr,:AdmNo,:LISIRItemID,:LISIRItemDesc,:LISIRResult,:LISIRUint,:LISIRTextResult,:LISIRExtraResult,:LISIRResultExplain,:LISIRAbnormalFlags,:LISIRRanges,:LISIRTestMethod,:LISIRTestMachine,:LISIRTestUserCode,:LISIRTestUserDesc,:LISIRShowSeq,:LISIRTestDate,:LISIRTestTime,:LISIRCount,
				:LISIRExpertRule,:LISIRRemark,:LISIRUpdateDate,:LISIRUpdateTime,:LISIRInterCode,:LISIROrderItemID,:LISIRAssayStatus,:LISIRReAssayNum,:LISIRResClass,:LISIROrganism,:LISIRReAssayNumber,:LISIRMultipleResistant,:LISIRMultipleResChild))
				if SQLCODE'=0
				{
					tro	
					s ErroString=ErroString_" "_$g(%msg)
				}
			}
			else
			{
				&sql(update SqlUser.Ens_LISItemResult set LISIR_ReportID=:LISIRReportID,LISIR_PatientID=:PatientDr,LISIR_VisitNumber=:AdmNo,LISIR_ItemCode=:LISIRItemID,LISIR_ItemDesc=:LISIRItemDesc,LISIR_Result=:LISIRResult,LISIR_Uint=:LISIRUint,LISIR_TextResult=:LISIRTextResult,LISIR_ExtraResult=:LISIRExtraResult,LISIR_ResultExplain=:LISIRResultExplain,LISIR_AbnormalFlags=:LISIRAbnormalFlags,LISIR_Ranges=:LISIRRanges,LISIR_TestMethod=:LISIRTestMethod,LISIR_TestMachine=:LISIRTestMachine,LISIR_TestUserCode=:LISIRTestUserCode,LISIR_TestUserDesc=:LISIRTestUserDesc,LISIR_ShowSeq=:LISIRShowSeq,
				LISIR_TestDate=:LISIRTestDate,LISIR_TestTime=:LISIRTestTime,LISIR_Count=:LISIRCount,LISIR_ExpertRule=:LISIRExpertRule,LISIR_Remark=:LISIRRemark,LISIR_UpdateDate=:LISIRUpdateDate,LISIR_UpdateTime=:LISIRUpdateTime,LISIR_InterCode=:LISIRInterCode,LISIR_OrderItemID=:LISIROrderItemID,LISIR_AssayStatus=:LISIRAssayStatus,LISIR_ReAssayNum=:LISIRReAssayNum,LISIR_ResClass=:LISIRResClass,LISIR_Organism=:LISIROrganism,LISIR_ReAssayNumber=:LISIRReAssayNumber,LISIR_MultipleResistant=:LISIRMultipleResistant,LISIR_MultipleResChild=:LISIRMultipleResChild where %id=:LISItemResID)
				if SQLCODE'=0
				{
					tro	
					s ErroString=ErroString_" "_$g(%msg)
				}
			}
			
			//药敏结果list
			s LISIRItemSenResult=tmpResJSON.%Get("LISISR_ItemSenResult")
			if LISIRItemSenResult'=""
			{
			s LISIRItemSenNum=LISIRItemSenResult.%Size()
			s LISIRRowID=""
			&sql(select LISIR_RowID into :LISIRRowID from SqlUser.Ens_LISItemResult where %id in((select %id from sqlUser.Ens_LISItemResult where LISIR_ReportID=:LISIRReportID and LISIR_ItemCode=:LISIRItemID)))
			if $d(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISIRRowID)) //插入微生物药敏结果表前，如果有历史数据，先清除
			{
				&SQL(delete from SQLUser.Ens_LISItemSenResult where LISISR_ResultID=:LISIRRowID)
				if SQLCODE'=0
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)	
				}
			}
			for k=1:1:LISIRItemSenNum
			{
				s tmpResSenJSON=LISIRItemSenResult.%Get(k-1)
				s LISISRResultID=LISIRRowID	
				s LISISRAntibioticsCode=tmpResSenJSON.%Get("LISISR_AntibioticsCode")
				s LISISRAntibioticsDesc=tmpResSenJSON.%Get("LISISR_AntibioticsDesc")
				s LISISRResult=tmpResSenJSON.%Get("LISISR_Result")	
				s LISISRSensitivityCode=tmpResSenJSON.%Get("LISISR_SensitivityCode")
				s LISISRSensitivityDesc=tmpResSenJSON.%Get("LISISR_SensitivityDesc")
				s LISISRIRanges=tmpResSenJSON.%Get("LISISR_IRanges")	
				s LISISRSRanges=tmpResSenJSON.%Get("LISISR_SRanges")
				s LISISRRRanges=tmpResSenJSON.%Get("LISISR_RRanges")	
				s LISISRShowSeq=tmpResSenJSON.%Get("LISISR_ShowSeq")
				s LISISRMethod=tmpResSenJSON.%Get("LISISR_Method")	
				s LISISRSuggestion=tmpResSenJSON.%Get("LISISR_Suggestion")
				s LISISRFlag=tmpResSenJSON.%Get("LISISR_Flag")
				s LISISRAntibioticsClassID=tmpResSenJSON.%Get("LISISR_AntibioticsClassID")
				s LISISRAntibioticsClassDesc=tmpResSenJSON.%Get("LISISR_AntibioticsClassDesc")	
				s LISISRUpdateDate=tmpResSenJSON.%Get("LISISR_UpdateDate")	
				s:LISISRUpdateDate'="" LISISRUpdateDate=$zdh(LISISRUpdateDate,3)
				s:LISISRUpdateDate="" LISISRUpdateDate=+$h
				s LISISRUpdateTime=tmpResSenJSON.%Get("LISISR_UpdateTime")
				s:LISISRUpdateTime'="" LISISRUpdateTime=$zth(LISISRUpdateTime)
				s:LISISRUpdateTime="" LISISRUpdateTime=$p($h,",",2)
				s LISISRUnit=tmpResSenJSON.%Get("LISISR_Unit")	
				s LISISRAntItemID=..GetAntiobioticsID(LISISRAntibioticsCode)
				s:LISISRAntItemID="" LISISRAntItemID=..AddAntiobioticsID(LISISRAntibioticsCode,LISISRAntibioticsDesc)
				s LISISRAntibioticsCode=$lg(^dbo.BTAntibioticsD(LISISRAntItemID),2)
				s LISItemSenResultID=""
				&sql(select %id into :LISItemSenResultID from SqlUser.Ens_LISItemSenResult where LISISR_ResultID=:LISISRResultID and LISISR_AntibioticsCode=:LISISRAntibioticsCode)
				if LISItemSenResultID=""
				{
					&sql(insert into SqlUser.Ens_LISItemSenResult(LISISR_ResultID,LISISR_AntibioticsCode,LISISR_AntibioticsDesc,LISISR_Result,LISISR_SensitivityCode,LISISR_SensitivityDesc,LISISR_IRanges,LISISR_SRanges,LISISR_RRanges,LISISR_ShowSeq,
					LISISR_Method,LISISR_Suggestion,LISISR_Flag,LISISR_AntibioticsClassID,LISISR_AntibioticsClassDesc,LISISR_UpdateDate,LISISR_UpdateTime,LISISR_Unit)
					values(:LISISRResultID,:LISISRAntibioticsCode,:LISISRAntibioticsDesc,:LISISRResult,:LISISRSensitivityCode,:LISISRSensitivityDesc,:LISISRIRanges,:LISISRSRanges,:LISISRRRanges,:LISISRShowSeq,
					:LISISRMethod,:LISISRSuggestion,:LISISRFlag,:LISISRAntibioticsClassID,:LISISRAntibioticsClassDesc,:LISISRUpdateDate,:LISISRUpdateTime,:LISISRUnit))
					if SQLCODE'=0
					{
						tro	
						s ErroString=ErroString_" "_$g(%msg)
					}
				}
				else
				{
					&sql(update SqlUser.Ens_LISItemSenResult set LISISR_ResultID=:LISISRResultID,LISISR_AntibioticsCode=:LISISRAntibioticsCode,LISISR_AntibioticsDesc=:LISISRAntibioticsDesc,LISISR_Result=:LISISRResult,LISISR_SensitivityCode=:LISISRSensitivityCode,LISISR_SensitivityDesc=:LISISRSensitivityDesc,LISISR_IRanges=:LISISRIRanges,LISISR_SRanges=:LISISRSRanges,LISISR_RRanges=:LISISRRRanges,LISISR_ShowSeq=:LISISRShowSeq,
					LISISR_Method=:LISISRMethod,LISISR_Suggestion=:LISISRSuggestion,LISISR_Flag=:LISISRFlag,LISISR_AntibioticsClassID=:LISISRAntibioticsClassID,LISISR_AntibioticsClassDesc=:LISISRAntibioticsClassDesc,LISISR_UpdateDate=:LISISRUpdateDate,LISISR_UpdateTime=:LISISRUpdateTime,LISISR_Unit=:LISISRUnit where %id=:LISItemSenResultID)
					if SQLCODE'=0
					{
						tro	
						s ErroString=ErroString_" "_$g(%msg)
					}
				}
			}
			}
			s LISIRItemResRst=tmpResJSON.%Get("LISISR_ItemResultResistance")

			if LISIRItemResRst'=""
			{
				if $d(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",LISIRRowID)) //插入细菌耐药分析结果表前，如果有历史数据，先清除
				{
					&SQL(delete from SQLUser.Ens_LISItemResRst where LISIRR_ResultID=:LISIRRowID)
					if SQLCODE'=0
					{
						tro
						s ErroString=ErroString_" "_$g(%msg)	
					}
				}
				s LISIRItemResRstNum=LISIRItemResRst.%Size()
				for l=1:1:LISIRItemResRstNum
				{
					s tmpResRstJSON=LISIRItemResRst.%Get(l-1)
					s LISISRResultID=LISIRRowID	
					s LISIRRItemCode=tmpResRstJSON.%Get("LISIRR_ItemCode")
					s LISIRRItemDesc=tmpResRstJSON.%Get("LISIRR_ItemDesc")
					s LISIRRResult=tmpResRstJSON.%Get("LISIRR_Result")	
					s LISIRRShowSeq=tmpResRstJSON.%Get("LISIRR_ShowSeq")
					s LISItemResRstID=""
					
					&sql(select %id into :LISItemResRstID from SqlUser.Ens_LISItemResRst where LISIRR_ResultID=:LISISRResultID and LISIRR_ItemCode=:LISIRRItemCode)
					if LISItemResRstID=""
					{
						&sql(insert into SqlUser.Ens_LISItemResRst(LISIRR_ResultID,LISIRR_ItemCode,LISIRR_ItemDesc,LISIRR_Result,LISIRR_ShowSeq)
						values(:LISISRResultID,:LISIRRItemCode,:LISIRRItemDesc,:LISIRRResult,:LISIRRShowSeq))
						if SQLCODE'=0
						{
							tro	
							s ErroString=ErroString_" "_$g(%msg)
						}
					}
					else
					{
						&sql(update SqlUser.Ens_LISItemResRst set LISIRR_ResultID=:LISISRResultID,LISIRR_ItemCode=:LISIRRItemCode,LISIRR_ItemDesc=:LISIRRItemDesc,LISIRR_Result=:LISIRRResult,LISIRR_ShowSeq=:LISIRRShowSeq where %id=:LISItemResRstID)
						if SQLCODE'=0
						{
							tro	
							s ErroString=ErroString_" "_$g(%msg)
						}
					}
					
				}	
			}
		}
		s LISSROrderItemID=$replace(LISSROrderItemID,",","^")
		s len=$l(LISSROrderItemID,"^"),SpecimenRepID=""
		for ii=1:1:len
		{
			s SpecimenRepID=""
			s OrderItemID=$p(LISSROrderItemID,"^",ii)
			&sql(select %id into :SpecimenRepID from SqlUser.Ens_LISSpecimenReport where LISSR_ReportID=:LISRRReportID and LISSR_SpecimenID=:LISRRVisitNumber and LISSR_OrderItemID=:OrderItemID)
			if SpecimenRepID=""
			{
				&sql(insert into SqlUser.Ens_LISSpecimenReport(LISSR_ReportID,LISSR_SpecimenID,LISSR_OrderItemID,LISSR_PatientID,LISSR_VisitNumber) values(:LISRRReportID,:LISRRVisitNumber,:OrderItemID,:PatientDr,:AdmNo))
				if SQLCODE'=0 
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)
				}
			}
			else
			{  
				&sql(update SqlUser.Ens_LISSpecimenReport set LISSR_ReportID=:LISIRReportID,LISSR_SpecimenID=:LISRRVisitNumber,LISSR_OrderItemID=:OrderItemID,LISSR_PatientID=:PatientDr,LISSR_VisitNumber=:AdmNo where %id=:SpecimenRepID)
				if SQLCODE'=0 
				{
					tro
					s ErroString=ErroString_" "_$g(%msg)
				}
			}
			
			s EnsStatusDr=""
			&sql(select %id into :EnsStatusDr from SqlUser.Ens_Status where ES_OrdItemID=:OrderItemID and ES_ExamID=:LISRRVisitNumber and ES_StatusCode='RP')
			if (EnsStatusDr="")&&(DocumentID'="")
			{
				//写入状态表
				&sql(Insert into SqlUser.Ens_Status(ES_EffectiveFlag,ES_ExamID,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_Process,ES_StatusCode,ES_SystemCode) 
			    Values ('Y',:LISRRVisitNumber,:LISRRCheckDate,:LISRRCheckTime,:LISRRCheckUserCode,:LISRRCheckUserDesc,:OrderItemID,'Y','RP','LIS'))
				if SQLCODE'=0
				{
					tro	
					s ErroString=ErroString_" "_$g(%msg)
				}
				//写入日志表
				&sql(Insert into SqlUser.Ens_Statuslog(ES_ExamID,ES_OperateDate,ES_OperateTime,ES_OperatorID,ES_OperatorName,ES_OrdItemID,ES_StatusCode,ES_SystemCode,ES_OperateCode,ES_PreStatusCode) 
			    Values (:LISRRVisitNumber,:LISRRCheckDate,:LISRRCheckTime,:LISRRCheckUserCode,:LISRRCheckUserDesc,:OrderItemID,'RP','LIS','RP','ACCEPT'))
				if SQLCODE'=0
				{
					tro	
					s ErroString=ErroString_" "_$g(%msg)
				}	
			}	
			
		}
		
		set LISDocumentId=..SaveLISDocument(LISRRReportID,DocumentID)
	
		if LISDocumentId'=""
		{
			s DocumentId="",LISRelDocumentId=""
			&sql(select HOSD_DocumentID into:DocumentId from SqlUser.Ens_HOSDocument where %id=:LISDocumentId)
			q:DocumentId="" 
			&sql(select %id into :LISRelDocumentId from SqlUser.Ens_RelOrderDocument where RelOD_DocumentID=:DocumentId)
			;set RelODOrderItemID=..GetOrdByLabNo(LISRRVisitNumber)
			set RelODOrderItemID=..GetOrdIDByRptLabNo(LISRRReportID,LISRRVisitNumber)
			
			if LISRelDocumentId=""
			{
				s len=$l(RelODOrderItemID,"^")
				for ij=1:1:len
				{
					set OrderItemID=$p(RelODOrderItemID,"^",ij)
					
				 	if '$d(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,AdmNo,OrderItemID))
					{
						&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_LisLabNo,RelOD_LisReportID,RelOD_OrderItemID,RelOD_SpecimenID)values(:PatientDr,:AdmNo,:DocumentId,'xml',:LISRRVisitNumber,:LISRRReportID,:OrderItemID,:LISRRVisitNumber))
						
						if SQLCODE'=0
						{
							tro	
							s ErroString=ErroString_" "_$g(%msg)
						}
					}
					else
					{
						s rowid="",reldocUpdateFlag=0,uprowid=""
						for { 
						   s rowid=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,AdmNo,OrderItemID,rowid)) 
						   q:rowid=""  
						   set RelLisReportId = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),3)
						   set RelODDocumentType = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),5)
						   continue:RelODDocumentType'="xml"					   
						   if RelLisReportId=LISRRReportID 
						   {
								set reldocUpdateFlag=1  
						   		set uprowid=rowid 
						   }  
						}
						if ((reldocUpdateFlag=1)&&(uprowid'="")){
					    	&sql(update SqlUser.Ens_RelOrderDocument set RelOD_PatientID=:PatientDr,RelOD_VisitNumber=:AdmNo,RelOD_DocumentID=:DocumentId,RelOD_LisLabNo=:LISRRVisitNumber,RelOD_LisReportID=:LISRRReportID,RelOD_OrderItemID=:OrderItemID,RelOD_SpecimenID=:LISRRVisitNumber where %id=:uprowid)
							if (SQLCODE'=0)
							{
								tro	
								s ErroString=ErroString_" "_$g(%msg)
							}					   
						}
  						else{
							&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_LisLabNo,RelOD_LisReportID,RelOD_OrderItemID,RelOD_SpecimenID)values(:PatientDr,:AdmNo,:DocumentId,'xml',:LISRRVisitNumber,:LISRRReportID,:OrderItemID,:LISRRVisitNumber))
							if SQLCODE'=0
							{
								tro	
								s ErroString=ErroString_" "_$g(%msg)
							}  
						}	
					}
				}
					
				if (SQLCODE=0)&&($TLEVEL>0)
				{
					tc	
				}
			}
		else
		{
			s len=$l(RelODOrderItemID,"^")
			for ij=1:1:len
			{
				set OrderItemID=$p(RelODOrderItemID,"^",ij)
				
			 	if '$d(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,AdmNo,OrderItemID))
				{
					&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_LisLabNo,RelOD_LisReportID,RelOD_OrderItemID,RelOD_SpecimenID)values(:PatientDr,:AdmNo,:DocumentId,'xml',:LISRRVisitNumber,:LISRRReportID,:OrderItemID,:LISRRVisitNumber))
					
					if SQLCODE'=0
					{
						tro	
						s ErroString=ErroString_" "_$g(%msg)
					}
				}
				else
				{
					s rowid="" 
					for { 
				        s rowid=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODORDERITEMID",PatientDr,AdmNo,OrderItemID,rowid)) 
						q:rowid=""  
						set RelLisReportId = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),3)
						set RelODDocumentType = $lg(^Busi.ENS.EnsRelOrderDocumentD(rowid),5)
						continue:RelODDocumentType'="xml"
						if RelLisReportId=LISRRReportID 
						{
							set reldocUpdateFlag=1  
							set uprowid=rowid 
						}  
					}
					if ((reldocUpdateFlag=1)&&(uprowid'="")){
					    &sql(update SqlUser.Ens_RelOrderDocument set RelOD_PatientID=:PatientDr,RelOD_VisitNumber=:AdmNo,RelOD_DocumentID=:DocumentId,RelOD_LisLabNo=:LISRRVisitNumber,RelOD_LisReportID=:LISRRReportID,RelOD_OrderItemID=:OrderItemID,RelOD_SpecimenID=:LISRRVisitNumber where %id=:uprowid)
						if (SQLCODE'=0)
						{
							tro	
							s ErroString=ErroString_" "_$g(%msg)
						}					   
					}
  					else{
						&sql(Insert into SqlUser.Ens_RelOrderDocument(RelOD_PatientID,RelOD_VisitNumber,RelOD_DocumentID,RelOD_DocumentType,RelOD_LisLabNo,RelOD_LisReportID,RelOD_OrderItemID,RelOD_SpecimenID)values(:PatientDr,:AdmNo,:DocumentId,'xml',:LISRRVisitNumber,:LISRRReportID,:OrderItemID,:LISRRVisitNumber))
						if SQLCODE'=0
						{
							tro	
							s ErroString=ErroString_" "_$g(%msg)
						}  
					}	
				}
			}
					
			if (SQLCODE=0)&&($TLEVEL>0)
			{
				tc	
			}
		 }
	   }	
	}
	
	i ErroString'=""
	{
		s MainErroString=MainErroString_"##"_ErroString
	}
	i MainErroString=""
	{	
		d ResultStr.Write("[{""ResultCode"":""0"",""ResultContent"":""成功""}]")
		s AdmType=$p($g(^PAADM(AdmNo)),"^",2) //病人就诊类型，记录就诊类型为体检的医嘱号，体检需要统计实时的工作量
		if (##class(websys.Conversions).IsValidMethodName("web.DHCPE.TransResult","TransResultByOEID"))&&(AdmType="H")
		{
			s lenH=$l(LISSROrderItemID,"^")
			for h=1:1:lenH
			{
				s OrderItemIDH=$p(LISSROrderItemID,"^",h)
				d ##class(web.DHCPE.TransResult).TransResultByOEID(OrderItemIDH)
			}	
		}
		s rRptID=""
		&sql(select %id into :rRptID from SqlUser.Ens_LISReportResult where LISRR_ReportID=:LISRRReportID)
		d ##class(web.DHCENS.EnsHISService).DHCHisInterface("SendLISReportStruc",rRptID)
		q ResultStr
	}
	else
	{
		if $TLEVEL>0
		{
	 		tro	
		}
		d ResultStr.Write("[{""ResultCode"":""-1"",""ResultContent"":"""_MainErroString_"""}]")
		q ResultStr
	}
	q ResultStr
GetErroMSG
	if $TLEVEL>0
	{
	 	tro	
	}
	s ResultStr=##class(%Stream.GlobalCharacter).%New()
	d ResultStr.Write("[{""ResultCode"":""-2"",""ResultContent"":""程序内部错误"_$ze_"""}]")
	q ResultStr
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：执行此方法将清除检查报告表（SQLUser.Ens_RISReportResult）、检查报告子表（SQLUser.Ens_RISItemResult）以及检验报告表(SQLUser.Ens_LISReportResult)、检验结果表(SQLUser.Ens_LISItemResult)、标本报告表(SQLUser.Ens_LISSpecimenReport)、药敏结果表(SQLUser.Ens_LISItemSenResult)、细菌耐药分析结果表(SQLUser.Ens_LISItemResRst)、文档表(SQLUSER.Ens_HOSDocument)、医嘱文档关联表(SQLUSER.Ens_RelOrderDocument)、医嘱闭环状态表(SQLUSER.Ens_Status)、医嘱闭环状态日志表(SQLUSER.Ens_Statuslog)
/// Table：Ens_RISReportResult、Ens_LISReportResult、Ens_LISItemResult、Ens_LISSpecimenReport、Ens_LISItemSenResult、Ens_LISItemResRst、Ens_HOSDocument、Ens_RelOrderDocument
/// Others w ##class(web.DHCENS.STBLL.Method.PostReportInfo).ClearEnsReportData()
ClassMethod ClearEnsReportData() As %String
{
	s $zt="Err"
	k ^Busi.ENS.EnsRISReportResultI
	k ^Busi.ENS.EnsRISReportResultD
	k ^Busi.ENS.EnsRISReportResultS
	k ^Busi.ENS.EnsRISReportResultC
	
	k ^Busi.ENS.EnsRISItemResultI
	k ^Busi.ENS.EnsRISItemResultD
	k ^Busi.ENS.EnsRISItemResultS
	k ^Busi.ENS.EnsRISItemResultC
	
	k ^Busi.ENS.EnsLISReportResultI
	k ^Busi.ENS.EnsLISReportResultD
	k ^Busi.ENS.EnsLISReportResultS
	k ^Busi.ENS.EnsLISReportResultC
	
	k ^Busi.ENS.EnsLISItemResultI
	k ^Busi.ENS.EnsLISItemResultD
	k ^Busi.ENS.EnsLISItemResultS
	k ^Busi.ENS.EnsLISItemResultC
	
	k ^Busi.ENS.EnsLISSpecimenReportI
	k ^Busi.ENS.EnsLISSpecimenReportD
	k ^Busi.ENS.EnsLISSpecimenReportS
	k ^Busi.ENS.EnsLISSpecimenReportC
	
	k ^Busi.ENS.EnsLISItemSenResultI
	k ^Busi.ENS.EnsLISItemSenResultD
	k ^Busi.ENS.EnsLISItemSenResultS
	k ^Busi.ENS.EnsLISItemSenResultC
	
	k ^Busi.ENS.EnsLISItemResRstI
	k ^Busi.ENS.EnsLISItemResRstD
	k ^Busi.ENS.EnsLISItemResRstS
	k ^Busi.ENS.EnsLISItemResRstC

	k ^Busi.ENS.EnsHOSDocumentI
	k ^Busi.ENS.EnsHOSDocumentD
	k ^Busi.ENS.EnsHOSDocumentS
	k ^Busi.ENS.EnsHOSDocumentC

	k ^Busi.ENS.EnsRelOrderDocumentI
	k ^Busi.ENS.EnsRelOrderDocumentD
	k ^Busi.ENS.EnsRelOrderDocumentS
	k ^Busi.ENS.EnsRelOrderDocumentC

	k ^Busi.ENS.EnsStatusD
	k ^Busi.ENS.EnsStatusI
	k ^Busi.ENS.EnsStatusS
	k ^Busi.ENS.EnsStatusC
	
	k ^Busi.ENS.EnsStatusLogD
	k ^Busi.ENS.EnsStatusLogI
	k ^Busi.ENS.EnsStatusLogS
	k ^Busi.ENS.EnsStatusLogC
	
	k ^Busi.ENS.EnsRISExamReportD
	k ^Busi.ENS.EnsRISExamReportI
	k ^Busi.ENS.EnsRISExamReportS
	k ^Busi.ENS.EnsRISExamReportC
	
	k ^User.EnsInterfaceV8I
	k ^User.EnsInterfaceV8D
	k ^User.EnsInterfaceV8S

	k ^User.EnsInterfaceI
	k ^User.EnsInterfaceD
	k ^User.EnsInterfaceS
	q 0
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：根据检验号获取就诊号
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetAdmByLabNo("1000004176")
ClassMethod GetAdmByLabNo(labNo As %String) As %String
{
	s $zt="Err"
	s AdmNo=""
	q:labNo="" ""
	s ord=$o(^OEORD(0,"EpisNo",labNo,""))
	q:ord="" ""
	s AdmNo=$p($g(^OEORD(ord)),"^",1)
	q AdmNo
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：根据检验小项代码、院区代码获取检验小项RowID
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetTestCodeID("L0032","颗粒管型","DHSZHYYZY")
ClassMethod GetTestCodeID(testCode As %String, testName As %String, hospitalCode) As %String
{
	s $zt="Err"
	s testCode1=testCode,testCodeID=""
	q:hospitalCode="" ""
	s hospDr=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(hospitalCode),""))
	q:hospDr="" ""
	;s testCode1=$zcvt(testCode1,"U") //区分降钙素原代码PCT，而血小板比容代码为Pct，由于dbo.BTTestCode.cls中Code字段的COLLATION = "Exact"，索引中无需将小写转大写
	s testCodeID=$o(^dbo.BTTestCodeI("IndexCode",hospDr,##Class(LIS.Util.Common).IndexData(testCode1),""))
	if testCodeID=""
	{
		s testCodeID=$o(^dbo.BTTestCodeI("IndexCode",hospDr,##Class(LIS.Util.Common).IndexData("OT"_testCode1),""))	
	}
	q:testCodeID="" ""
	/*
	if testName'=$lg($g(^dbo.BTTestCodeD(testCodeID)),3)
	{
		&sql(update dbo.bt_testcode set cname=:testName where RowID=:testCodeID)	
	}	
	*/
	q testCodeID
Err
	q "-1^"_$ze
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-21
/// Description:： 获取报告结果
/// Table：        Ens_LISReportResult、Ens_LISItemResult
/// Input：        ReportDR:报告号
/// Output:        Synonym:缩写,TestCodeName:项目名称,Units:单位,ResultFormat:结果格式,
///                ResClass:结果类别,Result:结果,AbFlag:异常提示,RefRanges:参考范围,PreResult:前次结果,
///                PreAbFlag:前次异常提示,PreResultDR:前次结果号,ReportResultDR:结果ID,ResNoes:备注,AuthDate:报告审核日期,AuthTime:报告审核时间,MultipleResistant:多耐标志,ReportDR:报告ID,HelpDisInfo:检验结果辅助诊断
///                ReqDate:申请日期,ReqTime:申请时间,MajorConclusion:主要结论,RepStatus:报告状态,CollectionDate:采集日期,CollectionTime:采集时间,ReceiveDate:接收日期,ReceiveTime:接收时间,TestCodeCode:检验小项代码,ManualOrdItemList:手工计费的医嘱rowid串,AppDeptCode:送检科室代码,AppDeptDesc:送检科室描述,CollectionUserCode:采集人代码,CollectionUserName:采集人,CheckUserCode:审核人代码,CheckUserName:审核人
/// Debug:d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryTSInfo","1503,1500","","","","","","","","","","","65^^3^8^1") 1   2       3            4     5            6        7      8        9      10        11               12        13        14          15             16      17       18       19                20       21         
Query QryTSInfo(ReportDRs, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "TestCodeDR,Synonym,TestCodeName,Units,ResultFormat,ResClass,Result,ExtraRes,AbFlag,RefRanges,ClinicalSignifyS,PreResult,PreAbFlag,PreResultDR,ReportResultDR,ResNoes,AuthDate,AuthTime,MultipleResistant,ReportDR,HelpDisInfo,ReqDate,ReqTime,MajorConclusion,RepStatus,CollectionDate,CollectionTime,ReceiveDate,ReceiveTime,TestCodeCode,ManualOrdItemList,AppDeptCode,AppDeptDesc,CollectionUserCode,CollectionUserName,CheckUserCode,CheckUserName")
{
}

ClassMethod QryTSInfoExecute(ByRef qHandle As %Binary, ReportDRs, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	set ReportDRs=$g(ReportDRs),Sessions=$g(Sessions)
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
	Set repid=$i(^CacheTemp)
 	Set ind=1
	s RowCount=0
	k ^TMP($zn,$i,$j)
	s CurNamespace=$ZUTIL(5)
	i '$l(ReportDRs) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ReportLength = $l(ReportDRs,",")
	s thisIndex=0
	for {
		s thisIndex = thisIndex+1
		q:thisIndex>ReportLength
		s ReportDR = $p(ReportDRs,",",thisIndex)
		i '$l(ReportDR) continue
		d GetData
	}
	i $l(ReportDRs,",")>1 {
		s TestCodeName="" f  s TestCodeName=$o(^TMP($zn,$i,$j,"OGGroupDATA",TestCodeName)) q:TestCodeName=""  d
	 	.s Data=$g(^TMP($zn,$i,$j,"OGGroupDATA",TestCodeName))
 		.d OutPut
		
	} else {
		s TCSequence="" f  s TCSequence=$o(^TMP($zn,$i,$j,"DATA",TCSequence)) q:TCSequence=""  d
	 	.s Data=$g(^TMP($zn,$i,$j,"DATA",TCSequence))
 		.d OutPut
	}
	
	k ^TMP($zn,$i,$j)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetData	
	s LISRptID=""
	&sql(select %id into :LISRptID from sqlUser.Ens_LISReportResult where LISRR_ReportID=:ReportDR)
	i '$l(LISRptID) {//没有数据
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s TransmitDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),119)
	s WorkGroupMachineDR=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),120)
	s PatientID=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),3)
	q:PatientID=""
	s RegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	s AdmNo=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),5)
	s SpeciesDR=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),14)
	s SpecimenCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),123)
	s AuthDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),107)
	s AuthTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),108)
	s ReAuthDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),129)
	s ReAuthTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),130)
	//如果有重审时间，审核时间为重审时间，用于前次结果查询
	i $l($g(ReAuthDate)) s AuthDate = ReAuthDate
	i $l($g(ReAuthTime)) s AuthTime = ReAuthTime
	s Status=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),117)
	s RepStatus=$case(Status,"1":"审核","2":"取消审核","3":"作废",:"")
	s ReqDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),22)
	s:ReqDate'="" ReqDate=$zd(ReqDate,3)
	s ReqTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),23)
	s:ReqTime'="" ReqTime=$zt(ReqTime)
	s CollectionDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),48)
	s:CollectionDate'="" CollectionDate=$zd(CollectionDate,3)
	s CollectionTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),49)
	s:CollectionTime'="" CollectionTime=$zt(CollectionTime)
	s RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),65)
	s:RecDate'="" RecDate=$zd(RecDate,3)
	s RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),66)
	s:RecTime'="" RecTime=$zt(RecTime)
	s MajorConclusion=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),143)
	s ManualOrdItemList=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),149)
	s AppDeptCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),20)
	s AppDeptDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),21)
	if AppDeptCode=""
	{
		set SpecimenNo=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportDR,""))
		set OrdItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportDR,SpecimenNo,""))	
		if OrdItemID'=""
		{
			set OrdDeptDr=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),1)),"^",3)
			set:OrdDeptDr'="" AppDeptCode=$p($g(^CTLOC(OrdDeptDr)),"^",1)
			set:OrdDeptDr'="" AppDeptDesc=$p($g(^CTLOC(OrdDeptDr)),"^",2)
		}
	}
	s CollectionUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),50)
	s CollectionUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),51)
	s CheckUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),109)
	s CheckUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),110)
	s TestCodeDRs =..GetTestCodeDRsByReportDRSeq(ReportDR)
	i $l(TestCodeDRs) {
		s TLength = $l(TestCodeDRs,",")
		for i=1:1:TLength {
			s TestCodeDR = $p(TestCodeDRs,",",i)
			s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
			s TestCodeCode = $lg(TestCodeData,2) //代码
			s TestCodeName = $lg(TestCodeData,3)
			s Synonym = $lg(TestCodeData,7) //缩写
			s Units = $lg(TestCodeData,8) //单位
			s SCode = $lg(TestCodeData,14) //标准码
			s $LIST(TestCodeData,1)=TestCodeDR
			s ResultFormat=$LIST(TestCodeData,9) //结果格式(N数字,X文本,S列表,A血型ABO,R血型RH,M微生物)
			s ISMcroorganism=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),103)
			s:ISMcroorganism="1" ResultFormat="M" //增加判断微生物结果格式为M
			s ReportResult=..GetReportResult(ReportDR,TestCodeDR)
			s ResClass = $lg(ReportResult,31) //结果类别(0普通,1危急)
			s Result = $lg(ReportResult,8)
			s TextResult=$lg(ReportResult,10)
			s:TextResult'="" Result=TextResult ///有定性结果时，以定性结果为准
			s ExtraRes = $lg(ReportResult,11)
			s ResNoes = $lg(ReportResult,12)
			i '$l(Result),'$l(ExtraRes),'$l(TestCodeName) continue
			s Units = $lg(ReportResult,9) //单位
			s ReportResultDR = $lg(ReportResult,2)
			s MultipleResistant=$lg(ReportResult,34)
			//结果描述，细菌名称
	        //i ResultFormat="M",$l(Result) d  s Result=$lg(^dbo.BTOrganismD(Result),3)
			s AbFlag = $lg(ReportResult,13) //异常提示
			s RefRanges = $lg(ReportResult,14) //参考范围
			s ClinicalSignifyS = $lg(TestCodeData,20) //临床意义
			s (ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh)=""
			//获取前一次结果
			s PreResultList=..GetPreResult(PatientID,TestCodeDR,AuthDate,AuthTime,"",ReportDR)
			
			s PreResult=$p(PreResultList,"@@",1),PreAbFlag=$p(PreResultList,"@@",2),PreResultDR=$p(PreResultList,"@@",3)
			s PreResultList=$lb(PreResult,PreAbFlag,PreResultDR)
			s TCSequence=$li(ReportResult,19)
			
			//临床意义辅助诊断
			s lisResult = Result_$c(2)_AbFlag
			S HelpDisInfo=..GetLibHelpDisInfo(AdmNo,TestCodeCode,SCode,SpecimenCode,lisResult)
			i HelpDisInfo["未对照" s HelpDisInfo=""
			
			s Data=$lb(TestCodeDR,Synonym,TestCodeName,Units,ResultFormat,ResClass,Result,ExtraRes,AbFlag,RefRanges,ClinicalSignifyS)_PreResultList_$lb(ReportResultDR,ResNoes,AuthDate,AuthTime,MultipleResistant,ReportDR,HelpDisInfo,ReqDate,ReqTime,MajorConclusion,RepStatus,CollectionDate,CollectionTime,RecDate,RecTime,TestCodeCode,ManualOrdItemList,AppDeptCode,AppDeptDesc,CollectionUserCode,CollectionUserName,CheckUserCode,CheckUserName)
			i $l(TCSequence),$d(^TMP($zn,$i,$j,"DATA",TCSequence)) s TCSequence=TestCodeDR
			i '$l(TCSequence) s TCSequence=TestCodeDR
			i $d(^TMP($zn,$i,$j,"DATA",TCSequence)) s TCSequence=TCSequence+999
			s ^TMP($zn,$i,$j,"DATA",TCSequence)=Data
			i $d(^TMP($zn,$i,$j,"OGGroupDATA",TestCodeName)) s TestCodeName=TestCodeName_ReportDR
			i $l(ReportDRs,",")>1 s ^TMP($zn,$i,$j,"OGGroupDATA",TestCodeName)=Data
		}	
	}

	q $$$OK
	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryTSInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTSInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTSInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTSInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:获取检验结果辅助诊断
/// Debug:w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetLibHelpDisInfo(108,"437","","","","")
ClassMethod GetLibHelpDisInfo(AdmNo, TestCodeCode, SCode, SpecimenCode, lisResult) As %String
{
	Set $ZTrap = "ErrorHandleHIS"
	s HelpDisInfo=""
	S HelpDisInfo=##class(web.DHCSTPHCMINTERFACE).GetLibHelpDisInfo(AdmNo,TestCodeCode,SCode,SpecimenCode,lisResult)
	q HelpDisInfo
ErrorHandleHIS
    Quit ""  //影响返回值存储，错误返回空
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-06
/// Description: 根据报告ID、报告细项ID获取报告结果
/// Debug:w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetReportResult("81","455")
ClassMethod GetReportResult(ReportDR, TestCodeDR) As %String
{
	s ReportDR=$g(ReportDR),TestCodeDR=$g(TestCodeDR)
	s RetVal=$lb("","","","","","","","","","","","","","","","","","","","","","","","","","","")
	i '$l(ReportDR) q RetVal
	i '$l(TestCodeDR) q RetVal
	;s ReportResultDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem"," "_ReportDR,TestCodeDR,""))
	s ReportResultDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(ReportDR,"U"),TestCodeDR,""))
	i '$l(ReportResultDR) q RetVal
	s ReportResultData=$li($g(^Busi.ENS.EnsLISItemResultD(ReportResultDR)),1,35)
	s $li(ReportResultData,1)=ReportResultDR
	q ReportResultData
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-06
/// Description: 根据报告ID获取报告细项ID
/// Debug:w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetTestCodeDRsByReportDRSeq("81")
ClassMethod GetTestCodeDRsByReportDRSeq(ReportDR) As %String
{
	s TestCodeDRs=""
	;s WorkGroupMachineCode = $lg($g(^Busi.ENS.EnsLISItemResultI(ReportDR)),120)
	//看报告不关心布局，使用下面的因为外送回传没布局的新检验结果看报告***优先考虑结果对应项目，不保存结果时查询布局
	;s TestCodeDR="" f  s TestCodeDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem"," "_ReportDR,TestCodeDR)) q:TestCodeDR=""  d
	s TestCodeDR="" f  s TestCodeDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(ReportDR,"U"),TestCodeDR)) q:TestCodeDR=""  d
	.if TestCodeDRs=""  s TestCodeDRs=TestCodeDR
	.else  d  s TestCodeDRs=TestCodeDRs_","_TestCodeDR
	q TestCodeDRs
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-06
/// Description: 获取最近一次检验结果
/// Debug:w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetPreResult("1","1063","20180124","53122",2,"4865")
ClassMethod GetPreResult(PatientID, TestCodeDR, AuthDate, AuthTime, WorkGroupMachineDR, CurReportDR) As %String
{
	s PatientID=$g(PatientID),TestCodeDR=$g(TestCodeDR),AuthDate=$g(AuthDate),AuthTime=$g(AuthTime),WorkGroupMachineDR=$g(WorkGroupMachineDR),CurReportDR=$g(CurReportDR)
	s RetVal="",ReportResultDR=""
	i '$l(PatientID) q RetVal
	i '$l(TestCodeDR) q RetVal
	i '$l(AuthDate) d
	.s AuthDate="" f  s AuthDate=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate)) q:(AuthDate="")  d
	..s AuthTime="" f  s AuthTime=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,AuthTime)) q:(AuthTime="")  d
	...s FReportResultDR=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,AuthTime,""))
	...s FReportDR=$lg(^Busi.ENS.EnsLISItemResultD(FReportResultDR),3)
	...s Status=$lg(^Busi.ENS.EnsLISItemResultD(FReportDR),117)
	...;q:Status'=1 ////正在检测
	...s SpecimenDesc=""
	...&SQL(select LISRR_Specimendesc into :SpecimenDesc from sqluser.ens_lisreportresult where LISRR_ReportID=:FReportDR)
	...i $l(CurReportDR) d
	....s CurSpecimenDesc=""
	....&SQL(select LISRR_Specimendesc into :CurSpecimenDesc from sqluser.ens_lisreportresult where LISRR_ReportID=:CurReportDR)	
	...i $l(CurReportDR),FReportDR=CurReportDR q
	...i $l(SpecimenDesc),$l(CurSpecimenDesc),SpecimenDesc'=CurSpecimenDesc q
	...s ReportResultDR=FReportResultDR
	e  d
	.i $l($o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,AuthTime)),-1) d
	..s FAuthTime=AuthTime
	..s FAuthTime = $o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,FAuthTime),-1)
	..if FAuthTime="" d
	...set AuthDate=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate),-1)
	...q:AuthDate=""
	...set FAuthTime=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,FAuthTime),-1)
	..q:FAuthTime=""
	..s FReportResultDR=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,FAuthTime,""))
	..i '$l(FReportResultDR) q
	..s FReportDR=$lg(^Busi.ENS.EnsLISItemResultD(FReportResultDR),3)
	..s Status=""
	..if ($d(^Busi.ENS.EnsLISItemResultD(FReportDR))) s Status=$lg(^Busi.ENS.EnsLISItemResultD(FReportDR),117)
	..;q:Status'=1 ///正在检测
	..s SpecimenDesc=""
	..&SQL(select LISRR_Specimendesc into :SpecimenDesc from sqluser.ens_lisreportresult where LISRR_ReportID=:FReportDR)
	..i $l(CurReportDR) d
	...s CurSpecimenDesc=""
	...&SQL(select LISRR_Specimendesc into :CurSpecimenDesc from sqluser.ens_lisreportresult where LISRR_ReportID=:CurReportDR)	
	..i $l(CurReportDR),FReportDR=CurReportDR q
	..i $l(SpecimenDesc),$l(CurSpecimenDesc),SpecimenDesc'=CurSpecimenDesc q
	..s ReportResultDR=FReportResultDR
	..
	///获取结果
	i '$l(ReportResultDR) q RetVal
	s ReportResultData=$g(^Busi.ENS.EnsLISItemResultD(ReportResultDR))
	s Result=$lg(ReportResultData,8)
	s TextRes=$lg(ReportResultData,10)
	s:TextRes="" TextRes=Result
	s AbFlag=$lg(ReportResultData,13)
	s PreAuthDate = $lg(ReportResultData,20)
	s PreAuthTime = $lg(ReportResultData,21)
	s RetVal=TextRes_"@@"_AbFlag_"@@"_ReportResultDR_"@@"_PreAuthDate_"@@"_PreAuthTime
	Q RetVal
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-21
/// Description:   标本历史结果查询
/// Table：        Ens_LISReportResult
/// Input：        VisitNumberReportDR:标本报告RowID
/// Output：       AssayDate:检测日期，AssayTime:检测时间，TestCodeName:检验项目名称，Result:结果，AbFlag:异常提示
/// w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetHistoryResultMTHD("346","44,0","","","","","","","","","","","","","65^2^^8^1")
ClassMethod GetHistoryResultMTHD(VisitNumberReportDR, TestCodeDR, SttDate, EndDate, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions As %String = "", RowCount As %String) As %String
{
	s $zt="Err"
	s AuthDate = ""
	s AuthTime = ""
	s retJson = ""
	s dataHead = ""
	s TestCodeDRs = TestCodeDR
	set ReportDR=$g(VisitNumberReportDR)
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
	s total=0
	i '$l(TestCodeDR) {
		s TestCodeDRs =..GetTestCodeDRsByReportDRSeq(ReportDR)
	}
	s LISItemResID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(ReportDR,"U"),TestCodeDR,""))
	q:LISItemResID="" ""
	s LISItemDesc=$lg($g(^Busi.ENS.EnsLISItemResultD(LISItemResID)),7)
	s ReportID=""
	&sql(select %id into :ReportID from sqlUser.Ens_LISReportResult where LISRR_ReportID=:ReportDR)
	k ^TMP($zn,$j)
	s TLength = $l(TestCodeDRs,",")
	for i=1:1:TLength {
		s TestCodeDR = $p(TestCodeDRs,",",i)
		q:TestCodeDR=""
		s TestCodeName = $lg(^dbo.BTTestCodeD(TestCodeDR),3)
		s Units = $lg(^dbo.BTTestCodeD(TestCodeDR),8)
		s ResultFormat = $lg(^dbo.BTTestCodeD(TestCodeDR),9)
		s oneData = ""
		s ColID = 0
		s PatientID=$lg($g(^Busi.ENS.EnsLISReportResultD(ReportID)),3)
		s SpecimenDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(ReportID)),147)
		for {
			s AuthDate = $o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate),-1)
			q:AuthDate=""
			for {
				s AuthTime = $o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,AuthTime),-1)
				q:AuthTime=""
				s ColID = ColID+1
				s VisitNumberReportResultDR = $o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientID,TestCodeDR,AuthDate,AuthTime,""))
				s OneReportID=$lg($g(^Busi.ENS.EnsLISItemResultD(VisitNumberReportResultDR)),3)
				&sql(select %id into :ColReportID from sqlUser.Ens_LISReportResult where LISRR_ReportID=:OneReportID)
				s OneSpecimenDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(ColReportID)),147)
				q:(OneSpecimenDesc'="")&&(OneSpecimenDesc'=SpecimenDesc)
				s ResultItemName=$lg($g(^Busi.ENS.EnsLISItemResultD(VisitNumberReportResultDR)),7)
				q:(ResultItemName'="")&&(ResultItemName'=LISItemDesc)
				q:OneReportID="" 
				s OneReportDR=""
				&sql(select %id into :OneReportDR from sqlUser.Ens_LISReportResult where LISRR_ReportID=:OneReportID)

				q:OneReportDR=""
				s ReportAuthDate = $lg($g(^Busi.ENS.EnsLISReportResultD(OneReportDR)),107)
				q:ReportAuthDate=""
				s ReportAuthTime = $lg($g(^Busi.ENS.EnsLISReportResultD(OneReportDR)),108)
				s Status = $lg(^Busi.ENS.EnsLISReportResultD(OneReportDR),117)
				if Status'="1" continue ///过滤取消审核、作废状态
		    	s Result = $lg($g(^Busi.ENS.EnsLISItemResultD(VisitNumberReportResultDR)),8)
		    	s TextResult=$lg($g(^Busi.ENS.EnsLISItemResultD(VisitNumberReportResultDR)),10)
		    	s:TextResult'="" Result=TextResult
		    	s AbFlag = $lg($g(^Busi.ENS.EnsLISItemResultD(VisitNumberReportResultDR)),13)
		    	s RefRanges = $lg($g(^Busi.ENS.EnsLISItemResultD(VisitNumberReportResultDR)),14)
		    	i TestCodeName = "备注" continue
		    	s ^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR)=Result_"@@"_AbFlag_"@@"_RefRanges
			}
		}
	}
	s ColID=0
	s (ReportAuthTime,ReportAuthDate,dataHead) = ""
	i $l($g(EndDate)) s ReportAuthDate = $o(^TMP($zn,$j,"DATA",EndDate))
	i $l($g(SttDate)) s SttDate = $o(^TMP($zn,$j,"DATA",SttDate),-1)
	for i=1:1:TLength {
		s TestCodeDR = $p(TestCodeDRs,",",i)
		q:TestCodeDR=""
		s Units = $lg(^dbo.BTTestCodeD(TestCodeDR),8)
		s ResultFormat = $lg(^dbo.BTTestCodeD(TestCodeDR),9)
		i '$l(dataHead) {
			for {
				s ReportAuthDate = $o(^TMP($zn,$j,"DATA",ReportAuthDate),-1)
				q:ReportAuthDate=$g(SttDate)
				for {
					s ReportAuthTime = $o(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime),-1)
					q:ReportAuthTime=""
					s ColID = ColID + 1
					s RefRanges = $p($g(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR)),"@@",3)
					s dataHead = dataHead_"""Col"_ColID_""":"_""""_$zd(ReportAuthDate,8)_" "_$zt(ReportAuthTime)_""",""AbFlag"_ColID_""":"_"""AbFlag"_ColID_""",""RefRanges"_ColID_""":""RefRanges"_ColID_""","
				}
			}
		}
		s TestCodeName = $lg(^dbo.BTTestCodeD(TestCodeDR),3)
		i TestCodeName = "备注" continue
		s oneData = ""
		s ColID = 0
		s ReportAuthDate=""
		for {
			s ReportAuthDate = $o(^TMP($zn,$j,"DATA",ReportAuthDate),-1)
			q:ReportAuthDate=""
			for {
				s ReportAuthTime = $o(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime),-1)
				q:ReportAuthTime=""
				s ColID = ColID + 1
				s AuthDate1 = $o(^TMP($zn,$j,"DATA",ReportAuthDate),-1)
				s AuthTime1 = $o(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime),-1)
				s Result = ""
				s AbFlag = ""
				i $l($g(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR))) d
				.s Result = $p(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR),"@@",1)
				.s AbFlag = $p(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR),"@@",2)
				.s RefRanges = $p(^TMP($zn,$j,"DATA",ReportAuthDate,ReportAuthTime,TestCodeDR),"@@",3)
				s oneData = oneData_"""Col"_ColID_""":"_""""_Result_""",""AbFlag"_ColID_""":"""_AbFlag_""",""RefRanges"_ColID_""":"""_RefRanges_""","
			}
		}
		
		s oneData = $e(oneData,1,$l(oneData)-1)
		s retJson = $s($l(oneData):retJson_"{""TestCodeName"":"""_TestCodeName_""",""Units"":"""_Units_""",""ResultFormat"":"""_ResultFormat_""","_oneData_"},",1:retJson_"{""TestCodeName"":"""_TestCodeName_"""},")
	}
	s dataHead = $e(dataHead,1,$l(dataHead)-1)
	s retJson = $e(retJson,1,$l(retJson)-1)
	s dataHead = $s($l(dataHead):"[{""TestCodeName"":""项目名称"","_dataHead_"}]",1:"[{""TestCodeName"":""项目名称""}]")
	k ^TMP($zn,$j)
	s retJson = "{""dataHead"":"_dataHead_",""rows"":["_retJson_"]}"
	q retJson
Err
	q "-1^"
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-21
/// Description:： 查询药敏结果
/// Table：        Ens_LISItemSenResult
/// Input：        报告结果明细表主键
/// Output：       满足条件的数据集合
/// Return：       RowID:药敏结果ID,VisitNumberReportResultDR:报告明细结果ID,AntibioticsDR:抗生素ID,SenMethod:药敏检测方法,SenValue:药敏结果值,SensitivityDR:药敏结果代码表ID,IRanges:I折点值,SRanges:S折点值,RRanges:R折点值,Sequence:顺序号,SensitivityName:药敏结果名称,AntibioticsName:抗生素名称,SName:抗生素缩写,AntibioticsClassDR:抗生素级别ID
/// Debug：d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryReportResultSen","235","","","","","","","","","","","","","","65^2^^8^1")
Query QryReportResultSen(ReportResultDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,VisitNumberReportResultDR,AntibioticsDR,SenMethod,SenValue,SensitivityDR,IRanges,SRanges,RRanges,Sequence,SensitivityName,AntibioticsName,SName,AntibioticsClassDR")
{
}

ClassMethod QryReportResultSenExecute(ByRef qHandle As %Binary, ReportResultDR, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	set ReportResultDR=$g(ReportResultDR),Sessions=$g(Sessions)
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
	Set repid=$i(^CacheTemp)
 	Set ind=1
	s sequence="" f  s sequence=$o(^Busi.ENS.EnsLISItemSenResultI("IndexSequence",ReportResultDR,sequence)) q:sequence=""  d
	.s senRowId="" f  s senRowId=$o(^Busi.ENS.EnsLISItemSenResultI("IndexSequence",ReportResultDR,sequence,senRowId)) q:senRowId=""  d
	..s ReportResultSen=$g(^Busi.ENS.EnsLISItemSenResultD(senRowId))
	..s RowID=senRowId
	..s LISISRResultID=$lg(ReportResultSen,2)
	..s VisitNumberReportResultDR=LISISRResultID
	..s AntibioticsCode=$lg(ReportResultSen,3)
	..q:AntibioticsCode=""
	..s AntibioticsDR=$o(^dbo.BTAntibioticsI("IndexCode",##Class(LIS.Util.Common).IndexData(AntibioticsCode),""))
	..s SenMethod=$lg(ReportResultSen,12)
	..s SenValue=$lg(ReportResultSen,5)
	..s SensitivityCode=$lg(ReportResultSen,6),SensitivityDR=""
	..s:SensitivityCode'="" SensitivityDR=$o(^dbo.BTSensitivityI("IndexCode",##Class(LIS.Util.Common).IndexData(SensitivityCode),""))
	..s IRanges=$lg(ReportResultSen,8)
	..s SRanges=$lg(ReportResultSen,9)
	..s RRanges=$lg(ReportResultSen,10)
	..s Sequence=$lg(ReportResultSen,11)
	..s SensitivityName=$lg(ReportResultSen,7)
	..s AntibioticsName=$lg(ReportResultSen,4)
	..s SName=$lg($g(^dbo.BTAntibioticsD(AntibioticsDR)),5)
	..s AntibioticsClassDR=$lg(ReportResultSen,11)
	..s AntibioticsName= $lg(^dbo.BTAntibioticsD(AntibioticsDR),3)
	..s Data=$lb(RowID,VisitNumberReportResultDR,AntibioticsDR,SenMethod,SenValue,SensitivityDR,IRanges,SRanges,RRanges,Sequence,SensitivityName,AntibioticsName,SName) ;ReportResultSen_$LB(AntibioticsName,SName)_$lb(AntibioticsClassDR)
 	..d OutPut
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryReportResultSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportResultSenExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportResultSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportResultSenExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-21
/// Description:： 根据就诊号和起始时间查询病人检查医嘱列表
/// Table：        Ens_RISReportResult
/// Input：        就诊号、开始日期、结束日期
///                
/// Output：       满足条件的数据集合
/// Return：       ItemName:检查项目名称,OrdCreateDate:医嘱开立日期,OrdCreateTime:医嘱开立时间,OEOrdItemDR:医嘱明细ID,RptRowID:报告ID,RrtDate:报告日期,RrtTime:报告时间,RptURL:报告链接地址,ImgURL:图像链接地址,RISRSysCode:系统类型,IsPublish:是否发布,CheckLocCode:检查科室代码,CheckLocDesc:检查科室名称,IsPositive:是否阳性,Notes:备注,AdviseDesc:诊断建议
/// Debug：        d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectPACSItemListByDate","43","","")
Query SelectPACSItemListByDate(paadmdr As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "ItemName:%String,OrdCreateDate:%String,OrdCreateTime:%String,OEOrdItemDR:%String,RptRowID:%String,RrtDate:%String,RrtTime:%String,RptURL:%String,ImgURL:%String,RISRSysCode:%String,IsPublish:%String,CheckLocCode:%String,CheckLocDesc:%String,IsPositive:%String,Notes:%String,AdviseDesc:%String")
{
}

ClassMethod SelectPACSItemListByDateExecute(ByRef qHandle As %Binary, paadmdr As %String, StDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
	;if $g(paadmdr)="" Set paadmdr=$g(%request.Get("EpisodeID"))
 	
 	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))

	If $g(ind)="" Set ind=1
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ReportRowID="",oeorditemdr=""
	s (RptURL,ImgURL)=""
	i $g(paadmdr)="" Quit $$$OK
	s RptNum = 0
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
 	
 	s drptdr="" f  s drptdr=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",paadmdr,drptdr)) q:(drptdr="")  d
	.s (studyNo,oeoRowid)=""
	.s RISReportData=$g(^Busi.ENS.EnsRISReportResultD(drptdr))
	.s studyNo=$lg(RISReportData,3)
	.q:studyNo=""
	.s oeorditemStr=$lg(RISReportData,4)
	.for i=1:1:$l(oeorditemStr,"^") d
	..s perOEORowid=$p(oeorditemStr,"^",i)
	..q:perOEORowid=""
	..s perOEORowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(perOEORowid,"_","||")
	..s OrderRowid=$p(perOEORowid,"||",1)
	..s itemsub=$p(perOEORowid,"||",2)
	..//因为医生站展示界面从第三方检查系统取不到检查号，导致医生点阅读后将Ens_Status检查号更新为空,取不到报告，所以改为取状态日志表最后一条状态
    ..;s EnsStatusDr=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamID"," "_perOEORowid," "_studyNo,""))  
    ..s EnsStatusLogDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_perOEORowid,""),-1)
    ..q:EnsStatusLogDr=""
    ..;s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusDr)),9)
    ..s ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EnsStatusLogDr)),11)
	..q:((ESStatusCode'="RP")&&(ESStatusCode'="RD")&&(ESStatusCode'="RPV")&&(ESStatusCode="PRERP")&&(ESStatusCode="SRP"))
 	..s OrdCreateDate = $p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",7)
	..q:((OrdCreateDate<StDate)!(OrdCreateDate>EndDate))&&(StDate'="")&&(EndDate'="")   //不满足时间条件
	..s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)   
	..s strOrderName=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",2)
	..s OrdCreateDate=$zd(OrdCreateDate,3)
	..s OrdCreateTime=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",17)
	..s OrdCreateTime=$zt(OrdCreateTime,2)
	..s ReportDate=$lg(RISReportData,10)
	..s ReportTime=$lg(RISReportData,11)
	..i (ReportDate'="")&(ReportTime'="") d
	...s ReportDate=$zd(ReportDate,3)
	...s ReportTime=$zt(ReportTime)
	..s locdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	..s RptURL=$lg(RISReportData,33) ;##class(web.DHCEMInterface).GetPacsPortUrl(locdr,RegNo_"^"_studyNo_"^"_perOEORowid,1)
	..s ImgURL=$lg(RISReportData,32) ;##class(web.DHCEMInterface).GetPacsPortUrl(locdr,RegNo_"^"_studyNo_"^"_perOEORowid,2)
	..s RISRSysCode=$lg(RISReportData,7)
	..s IsPublish="Y" //是否发布
	..s RecLocDr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	..s:RecLocDr'="" CheckLocCode=$p($g(^CTLOC(RecLocDr)),"^",1) //检查科室代码
	..s:RecLocDr'="" CheckLocDesc=$p($g(^CTLOC(RecLocDr)),"^",2) //检查科室名称
	..s IsPositive=$lg(RISReportData,35) //是否阳性
	..s Notes=$lg(RISReportData,27) //备注
	..s AdviseDesc=$lg(RISReportData,27) //注意事项
	..s RISRStatus=$lg(RISReportData,48)
	..q:(RISRStatus'="")&&(RISRStatus'="1") //报告状态（1审核，2取消审核，3作废）,过滤取消审核状态、作废状态的
	..d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(strOrderName,OrdCreateDate,OrdCreateTime,perOEORowid,ReportRowID,ReportDate,ReportTime,RptURL,ImgURL,RISRSysCode,IsPublish,CheckLocCode,CheckLocDesc,IsPositive,Notes,AdviseDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectPACSItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPACSItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-18
/// Description:： 查询耐药分析结果
/// Table：        Ens_LISItemResRst
/// Input：        报告结果主键                
/// Output：       满足条件的数据集合
/// Return：       ResistanceItemDR:耐药项ID,ResistanceItemName:耐药项目名称,ResFormat:结果格式(N数字,X文本,S列表,T数据表),ResItem:耐药结果代码,RowID:耐药结果ID,Result:耐药结果,Sequence:耐药结果顺序号,TestCodeDR:检验小项RowID
/// Debug：d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryReportResultRst","","81","437","","","","","","","","","","","","113^25^^12^1")
Query QryReportResultRst(ReportResultDR, ReportDR, TestCodeDR, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ResistanceItemDR,ResistanceItemName,ResFormat,ResItem,RowID,Result,Sequence,TestCodeDR")
{
}

ClassMethod QryReportResultRstExecute(ByRef qHandle As %Binary, ReportResultDR, ReportDR, TestCodeDR, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	set ReportResultDR=$g(ReportResultDR),Sessions=$g(Sessions)
	s ReportDR=$g(ReportDR)
	s TestCodeDR=$g(TestCodeDR)
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
	Set repid=$i(^CacheTemp)
 	Set ind=1
 	s TestCodeDRAll=TestCodeDR
 	f ti=1:1:$l(TestCodeDRAll,"^") d
	.s TestCodeDR=$p(TestCodeDRAll,"^",ti)
 	.i $d(^Busi.ENS.EnsLISItemResultI("IndexReportItem",ReportDR,TestCodeDR)) d
 	..s ReportResultDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(ReportDR,"U"),TestCodeDR,""))
 	..s ResultID=$lg($g(^Busi.ENS.EnsLISItemResultD(ReportResultDR)),2)
 	.i $l(ResultID) d
	..s ResistanceItem="" f  s ResistanceItem=$o(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",ResultID,ResistanceItem)) q:ResistanceItem=""  d
	...s ResistanceItemDR=$o(^dbo.BTMCResistanceItemI("IndexCode",##Class(LIS.Util.Common).IndexData(ResistanceItem),""))
	...s LISItemResRstId=""  f  s LISItemResRstId=$o(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",ResultID,ResistanceItem,LISItemResRstId)) q:LISItemResRstId=""  d
	....s ResistanceItemName=$lg($g(^Busi.ENS.EnsLISItemResRstD(LISItemResRstId)),5)
	....s ResistanceItemName=$lg($g(^dbo.BTMCResistanceItemD(ResistanceItemDR)),3)
	....s ResFormat=$lg($g(^dbo.BTMCResistanceItemD(ResistanceItemDR)),5)
	....s ResItem=$lg($g(^Busi.ENS.EnsLISItemResRstD(LISItemResRstId)),6)
	....s RowID=LISItemResRstId
	....s Result=$lg($g(^Busi.ENS.EnsLISItemResRstD(LISItemResRstId)),6)
	....s Sequence=1
	....d OutPut
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	s Data=$LB(ResistanceItemDR,ResistanceItemName,ResFormat,ResItem,RowID,Result,Sequence,TestCodeDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryReportResultRstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportResultRstExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportResultRstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportResultRstExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-18
/// Description:： 根据检查医嘱rowid 查询结构化检查报告
/// Table：        
/// Input：        医嘱rowid
/// Output：       满足条件的数据集合
/// Return：       ExamDesc:检查所见,strResult:检查结果,strOrderName:医嘱名称,RISRCheckDocCode:检查医生工号,RISRCheckDocDesc:检查医生姓名,RISRCheckDate:检查日期,RISRCheckTime:检查时间,RISRReportDocCode:报告医生代码,RISRReportDocDesc:报告医生姓名,RISRReportDate:报告日期,RISRReportTime:报告时间,RISRWarnCode:危急值标识,RISRSysCode:系统类型代码,RISRIsPositive:是否阳性,RISRAbnormalFlags:异常标记
/// Debug：	d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectReportByOeordID","324||1")
Query SelectReportByOeordID(OEItemRowID As %String) As %Query(ROWSPEC = "ExamDesc:%String,strResult:%String,strOrderName:%String,RISRCheckDocCode:%String,RISRCheckDocDesc:%String,RISRCheckDate:%String,RISRCheckTime:%String,RISRReportDocCode:%String,RISRReportDocDesc:%String,RISRReportDate:%String,RISRReportTime:%String,RISRWarnCode:%String,RISRSysCode:%String,RISRIsPositive:%String,RISRAbnormalFlags:%String")
{
}

ClassMethod SelectReportByOeordIDExecute(ByRef qHandle As %Binary, OEItemRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
  	Quit:$g(OEItemRowID)="" $$$OK
	If $g(ind)="" Set ind=1
	s ExamDesc="未回报告",strResult="未回报告",strOrderName="",RptRowId=""
    s OrderRowid=$p(OEItemRowID,"||",1)
	s itemsub=$p(OEItemRowID,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    ;s rptStatus=..GetRptStatusByOrdID(OEItemRowID) //判断医嘱对应的报告状态
    s EnsStatusRowid="" f  s EnsStatusRowid=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OEItemRowID,EnsStatusRowid)) q:EnsStatusRowid=""  d
    .s StudyNo=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),3)
    .q:StudyNo=""
    .s Status=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),9)
    .q:((Status'="RP")&&(Status'="RD")&&(Status'="RPV")&&(Status="PRERP")&&(Status="SRP")) //过滤非报告审核状态、非阅读状态、非病理预报告、非病理补充报告状态
    .s RptRowId=""
    .f  s RptRowId=$o(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(StudyNo,"U"),RptRowId)) q:RptRowId=""  d
    ..s OrdRowID=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),4),flag=""
    ..if OrdRowID'=OEItemRowID s flag=0
    ..s RptNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),2)
    ..if $d(^Busi.ENS.EnsRISExamReportI("RISEXAMREPORTPKey"," "_RptNo)) d
    ...&SQL(select ID into :rowid from SQLUser.Ens_RISExamReport where RISSR_ReportID=:RptNo and RISSR_ExamID=:StudyNo and RISSR_OrderItemID=:OEItemRowID )
    ...if rowid'="" s flag=1
    ...;q:OrdRowID'=OEItemRowID
    ..q:flag=0
	..s ExamDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),24)
	..s:(ExamDesc'="") ExamDesc = ..ConvertRptContent(ExamDesc)  //处理特殊字符
	..s strResult=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),25)
	..s:(strResult'="") strResult = ..ConvertRptContent(strResult)  //处理特殊字符
	..s RISRCheckDocCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),12)
	..s RISRCheckDocDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),13)
	..s RISRCheckDate=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),14)
	..s:RISRCheckDate'="" RISRCheckDate=$zd(RISRCheckDate,3)
	..s RISRCheckTime=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),15)
	..s:RISRCheckTime'="" RISRCheckTime=$zt(RISRCheckTime)
	..s RISRReportDocCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),8)
	..s RISRReportDocDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),9)
	..s RISRReportDate=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),10)
	..s:RISRReportDate'="" RISRReportDate=$zd(RISRReportDate,3)
	..s RISRReportTime=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),11)
	..s:RISRReportTime'="" RISRReportTime=$zt(RISRReportTime)
	..s RISRWarnCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),34)
	..s RISRSysCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),7)
	..s RISRIsPositive=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),35)
	..s RISRAbnormalFlags=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),36)
	..s RISRStatus=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),48)
	..q:(RISRStatus'="")&&(RISRStatus'="1") //报告状态（1审核，2取消审核，3作废）,过滤取消审核状态、作废状态的
	..Do OutRptInfo
 	..Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptInfo
	set Data=$lb(ExamDesc,strResult,strOrderName,RISRCheckDocCode,RISRCheckDocDesc,RISRCheckDate,RISRCheckTime,RISRReportDocCode,RISRReportDocDesc,RISRReportDate,RISRReportTime,RISRWarnCode,RISRSysCode,RISRIsPositive,RISRAbnormalFlags)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectReportByOeordIDExecute1111(ByRef qHandle As %Binary, OEItemRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
  	Quit:$g(OEItemRowID)="" $$$OK
	If $g(ind)="" Set ind=1
	s ExamDesc="未回报告",strResult="未回报告",strOrderName="",RptRowId=""
    s OrderRowid=$p(OEItemRowID,"||",1)
	s itemsub=$p(OEItemRowID,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    set ensRelOrdDocumentRowID="" f  set ensRelOrdDocumentRowID = $O(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OEItemRowID,"xml",ensRelOrdDocumentRowID)) q:ensRelOrdDocumentRowID=""  d
    .set docuemntID = $lg($g(^Busi.ENS.EnsRelOrderDocumentD(ensRelOrdDocumentRowID)),2)
    .q:docuemntID=""
    .set documentStatus = $lg($g(^Busi.ENS.EnsHOSDocumentD(docuemntID)),13)
    .q:documentStatus="2" ///文档作废
    .s RptNo = $lg($g(^Busi.ENS.EnsRelOrderDocumentD(ensRelOrdDocumentRowID)),4)
    .q:RptNo=""
    .s StudyNo = $lg($g(^Busi.ENS.EnsRelOrderDocumentD(ensRelOrdDocumentRowID)),7)
    .q:StudyNo=""
    .s RptRowId=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",RptNo,""))
    .q:RptRowId=""
    .s RISRStatus=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),48)
	.q:(RISRStatus'="")&&(RISRStatus'="1") //报告状态（1审核，2取消审核，3作废）,过滤取消审核状态、作废状态的
    .s OrdRowID=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),4),flag=""
    .if OrdRowID'=OEItemRowID s flag=0
    .s rowid=0
    .if $d(^Busi.ENS.EnsRISExamReportI("RISEXAMREPORTPKey"," "_RptNo)) d
    ..&SQL(select ID into :rowid from SQLUser.Ens_RISExamReport where RISSR_ReportID=:RptNo and RISSR_ExamID=:StudyNo and RISSR_OrderItemID=:OEItemRowID )
    ..if rowid'="" s flag=1
    ..;q:OrdRowID'=OEItemRowID
    .q:flag=0
	.s ExamDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),24)
	.s:(ExamDesc'="") ExamDesc = ..ConvertRptContent(ExamDesc)  //处理特殊字符
	.s strResult=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),25)
	.s:(strResult'="") strResult = ..ConvertRptContent(strResult)  //处理特殊字符
	.s RISRCheckDocCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),12)
	.s RISRCheckDocDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),13)
	.s RISRCheckDate=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),14)
	.s:RISRCheckDate'="" RISRCheckDate=$zd(RISRCheckDate,3)
	.s RISRCheckTime=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),15)
	.s:RISRCheckTime'="" RISRCheckTime=$zt(RISRCheckTime)
	.s RISRReportDocCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),8)
	.s RISRReportDocDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),9)
	.s RISRReportDate=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),10)
	.s:RISRReportDate'="" RISRReportDate=$zd(RISRReportDate,3)
	.s RISRReportTime=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),11)
	.s:RISRReportTime'="" RISRReportTime=$zt(RISRReportTime)
	.s RISRWarnCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),34)
	.s RISRSysCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),7)
	.s RISRIsPositive=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),35)
	.s RISRAbnormalFlags=$lg($g(^Busi.ENS.EnsRISReportResultD(RptRowId)),36)
	.Do OutRptInfo
 	.Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRptInfo
	set Data=$lb(ExamDesc,strResult,strOrderName,RISRCheckDocCode,RISRCheckDocDesc,RISRCheckDate,RISRCheckTime,RISRReportDocCode,RISRReportDocDesc,RISRReportDate,RISRReportTime,RISRWarnCode,RISRSysCode,RISRIsPositive,RISRAbnormalFlags)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectReportByOeordIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectReportByOeordIDExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectReportByOeordIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectReportByOeordIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：     ZhangXinying
/// CreatDate：   2019-09-07
/// Desc:替换报告中的特殊字符
/// Debug:w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).ConvertRptContent("13")
ClassMethod ConvertRptContent(AString As %String, AHospital As %String = "") As %String
{
	q:($d(AString)=0)||(AString="") ""
	
	s (Result,tmpResult)=""
	s (delimstr,delimcount,num,delim,resultstr,resultcount,numsub,result)=""

	//替换报告中的特殊字符
	s Result = $tr(AString,"@")
	
	//替换报告中的空格符
	s Result = $tr(Result," ")
	
	//替换报告中的回车符
	s delimstr="_$c(13,10)_^_$c_^"_$c(13,10)_""
	s delimcount=$l(delimstr,"^")
	for num=1:1:delimcount {
		
		s delim = $p(delimstr,"^",num)
		
		s resultstr=Result
		s resultcount=$l(resultstr,delim)
		
		for numsub=1:1:resultcount {
			
			s result = $p(resultstr,delim,numsub)
			s tmpResult = tmpResult_result
		}
		//完成一个分隔符替换
		s Result=tmpResult,tmpResult=""
	}
	
	
	q Result
}

/// Creator：      ZhangXinying
/// CreateDate：   2019-09-18
/// Description:：根据"就诊号","开始时间(医嘱)","结束时间(医嘱)",查询医嘱套Rowid,医嘱套描述,标本号
/// Table： OE_Order,OE_OrdItm
/// Input： 医嘱OeordID
/// Output：医嘱套Rowid：OEordItemRowID,医嘱套描述：OEordItemDesc,标本号：LabEpisodeNo,标本类型：SpecimenDesc
///         标本采集日期：CollectionDate,标本采集时间:CollectionTime,标本接收日期：ReceiveDate,标本接收时间:ReceiveTime
///         标本审核日期:AuthorisationDate,标本审核时间:AuthorisationTime,是否有报告：ExistReport(Y:存在，N:不存在),EpisodeID:(病人就诊ID)
///         标本代码：SpecimenCode,送检科室代码：LocCode,送检科室名称：LocDesc，采集人代码：CollectUserCode，采集人名称：CollectUserName
///         标本接收人代码：ReceiveUserCode,标本接收人:	ReceiveUserName,检验医嘱串（外部代码、外部代码名称、医嘱代码、医嘱名称）:TestSetStr,检验结果（医嘱表）:TestSetRow
///         报告序号：Order，报告状态：RepStatus，录入日期：RegDate,录入时间：RegTime
///         录入人代码：RegUserCode,录入人姓名：RegUserName,审核人代码：AuthUserCode,审核人姓名：AuthUserName,ReqDate:申请日期,ReqTime:申请时间,MajorConclusion:主要评价,AbnormalFlag:异常标志[0(正常),1(异常))]     
/// Others：日期格式为数据库默认的存储格式，如果时间未指定查询所有
/// Debug:  d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectLISItemListByDate","338135","","")
Query SelectLISItemListByDate(EpisodeID As %String, Begdate As %Date = 0, EndDate As %Date = 0, FExistReport As %String) As %Query(ROWSPEC = "OEordItemRowID:%String,OEordItemDesc:%String,LabEpisodeNo:%String,SpecimenDesc:%String,CollectionDate:%String,CollectionTime:%String,ReceiveDate:%String,ReceiveTime:%String,AuthorisationDate:%String,AuthorisationTime:%String,ExistReport:%String,VisitNumberReportDR:%String,EpisodeID:%String,SpecimenCode:%String,LocCode:%String,LocDesc:%String,CollectUserCode:%String,CollectUserName:%String,ReceiveUserCode:%String,ReceiveUserName:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthUserCode:%String,AuthUserName:%String,ReqDate:%String,ReqTime:%String,MajorConclusion:%String,AbnormalFlag:%String")
{
}

ClassMethod SelectLISItemListByDateExecute(ByRef qHandle As %Binary, EpisodeID As %String, Begdate As %Date = 0, EndDate As %Date = 0, FExistReport As %String) As %Status
{
	S FExistReport=$G(FExistReport)
	S EpisodeID=$G(EpisodeID)
	S EndDate=$G(EndDate)
	S Begdate=$G(Begdate)
	Set ResultSetRootNode=$i(^CacheTemp) 		//记录集的根节点
	Set Counter=0       						//统计记录数，同时为子节点
 	Set OrderInfo=""    //保存一条记录
	Set OrderId="" 
	For  set OrderId=$Order(^OEORD(0,"Adm",EpisodeID,OrderId)) Quit:OrderId=""  Do
	.Set OEOrdDate=$P(^OEORD(OrderId),"^",2)
	.//Quit:$$CheckDate()'=1   //判断医嘱时间是否在查询的时间段中
	.Set OrderSubId=""  
	.For  set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId)) Quit:OrderSubId=""  Do
	..S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
	..Q:(DataFlag'=1)&(DataFlag'=11)
	..Set ARCItemMastStr=$g(^OEORD(OrderId,"I",OrderSubId,1))
	..s ItmMastDr=$p(ARCItemMastStr,"^",2)
	..i '$l(ItmMastDr) q
	..i '..isLabTS(ItmMastDr) q
	..S OEOrdStatus=$P(ARCItemMastStr,"^",13)
	..Q:OEOrdStatus'=6 //如果不是已经执行的医嘱则退出
	..Set OEOrdDate = $p($g(^OEORD(OrderId,"I",OrderSubId,3)),"^",7)  //按医嘱日期查询
	..i $l(OEOrdDate),$l(Begdate),OEOrdDate-Begdate<0 q
	..i $l(OEOrdDate),$l(EndDate),OEOrdDate-EndDate>0 q
	..;Quit:$$CheckDate()'=1   //判断医嘱时间是否在查询的时间段中
	..Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
	..Set ARCIMId=$Piece(ARCItemMastStr,"^",2) 
	..Quit:ARCIMId=""
	..Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) Quit:ItemNameDesc=""
	..Set OrderRowId=OrderId_"||"_OrderSubId
	..Set LabNo=$Piece(TestSetStr,"^",20)
	..q:'$l(LabNo)
	..s SpecimenRepID="" f  s SpecimenRepID=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_$zcvt(LabNo,"U"),SpecimenRepID)) q:SpecimenRepID=""  d
	...s LISSRReportID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenRepID)),2)
	...q:LISSRReportID=""
	...s OrdItemID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenRepID)),4)
	...q:OrdItemID'=OrderRowId
	...s LISSRReportDR=""
	...&sql(select %id into :LISSRReportDR from sqlUser.Ens_LISReportResult where LISRR_ReportID=:LISSRReportID)
	...q:LISSRReportDR="" 
	...Set (SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport)=""
	...s SpeDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),147) ///标本名称
	...s CollectDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),48)
	...s:CollectDate'="" CollectDate=$zd(CollectDate,3)
	...s CollectTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),49)
	...s:CollectTime'="" CollectTime=$zt(CollectTime)
	...s RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),65)
	...s:RecDate'="" RecDate=$zd(RecDate,3)
	...s RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),66)
	...s:RecTime'="" RecTime=$zt(RecTime)
	...S ExistReport="N",AdmNo=EpisodeID
	...s AuthorDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),107)
	...s:AuthorDate'="" AuthorDate=$zd(AuthorDate,3)
	...s AuthorTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),108)
	...s:AuthorTime'="" AuthorTime=$zt(AuthorTime)
	...i $lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),117)=1 s ExistReport="Y"
	...i $L(FExistReport),FExistReport'=ExistReport Q //
	...s VisitNumberReportDR=LISSRReportID
	...s SpeCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),123) ///标本代码
	...s LocCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),24) ///送检科室代码
	...s LocDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),25) ///送检科室
	...s CollectUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),50) 
	...s CollectUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),51)
	...s ReceiveUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),67)
	...s ReceiveUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),68)
	...s ExtCode=$p($g(^ARCIM(+ARCIMId,$p(ARCIMId,"||",2),"EXT",1)),"^",4)
	...s ExtDesc=$p($g(^ARCIM(+ARCIMId,$p(ARCIMId,"||",2),"EXT",1)),"^",6)
	...s ItemNameCode=$p($g(^ARCIM(+ARCIMId,$p(ARCIMId,"||",2),1)),"^",1)
	...s TestSetStr=ExtCode_"^"_ExtDesc_"^"_ItemNameCode_"^"_ItemNameDesc
	...s TestSetRow=""
	...s Order=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),122)
	...s Status=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),117)
	...s RepStatus=$case(Status,"1":"审核","2":"取消审核","3":"作废",:"")
	...s RegDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),111)
	...s:RegDate'="" RegDate=$zd(RegDate,3)
	...s RegTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),112)
	...s:RegTime'="" RegTime=$zt(RegTime)
	...s RegUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),113)
	...s RegUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),114)
	...s AuthUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),109)
	...s AuthUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),110)
	...s ReqDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),22)
	...s:ReqDate'="" ReqDate=$zd(ReqDate,3)
	...s ReqTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),23)
	...s:ReqTime'="" ReqTime=$zt(ReqTime)
	...s MajorConclusion=$lg($g(^Busi.ENS.EnsLISReportResultD(LISSRReportDR)),143)
	...s abnum="",AbnormalFlag="0"
	...&SQL(select count(*) into :abnum from SqlUser.Ens_LISItemResult where LISIR_ReportID=:LISSRReportID and LISIR_AbnormalFlags is not null)
	...if abnum>0 s AbnormalFlag="1" //0(正常), 1(异常)
	...Set OrderInfo=""
	...Set OrderInfo=$lb(OrderRowId,ItemNameDesc,LabNo,SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport,VisitNumberReportDR,AdmNo,SpeCode,LocCode,LocDesc,CollectUserCode,CollectUserName,ReceiveUserCode,ReceiveUserName,TestSetStr,TestSetRow,Order,RepStatus,RegDate,RegTime,RegUserCode,RegUserName,AuthUserCode,AuthUserName,ReqDate,ReqTime,MajorConclusion,AbnormalFlag) //保存医嘱套RowID,医嘱描述,标本号
    ...Set ^CacheTemp(ResultSetRootNode,Counter)=OrderInfo
    ...Set Counter=Counter+1
    //重置qHandle的值，方便倒序输出
    Set qHandle=$lb(ResultSetRootNode,Counter)
    Kill Counter
	Quit $$$OK
CheckDate()
    if ((Begdate=0)&&(EndDate=0)) //未指定开始时间和结束时间
    {   
	    Quit 1
	}ElseIF (((Begdate=0)&&(OEOrdDate<=EndDate))||((EndDate=0)&&(OEOrdDate>=Begdate))) //未指定开始时间或结束时间
	{  
		Quit 1
	}ElseIF ((OEOrdDate>=Begdate)&&(OEOrdDate<=EndDate)) //指定了开始时间和结束时间
	{
		Quit 1
	}
    Quit 0   //其他情况返回0
}

ClassMethod SelectLISItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	set RootNode=$List(qHandle,1)
	Set currChildNode=$List(qHandle,2)
	
	s currChildNode = $O(^CacheTemp(RootNode,currChildNode),-1)
	if (currChildNode="") 
	{
		s Row=""
		s AtEnd=1
		kill ^CacheTemp(RootNode)
	}
	else
	{
		s Row=^CacheTemp(RootNode,currChildNode)
		s qHandle=$lb(RootNode,currChildNode)
	}
	
	Quit $$$OK
}

ClassMethod SelectLISItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	set RootNode=$List(qHandle,1)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Description： 获得检验项目的名称
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetLabItemNameDesc("78||366")
ClassMethod GetLabItemNameDesc(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ItemCatId=$Piece(^ARCIM(ItemId,ItemSub,1),"^",10) Quit:ItemCatId="" ""
	Quit:..GetItemOrderType(ItemCatId)'="L" ""
	Set ItemDesc=$Piece(^ARCIM(ItemId,ItemSub,1),"^",2)
	Quit ItemDesc
}

/// Description：获得检验项目的类别
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).isLabTS("80")
ClassMethod GetItemOrderType(ItemCatId As %String) As %String
{
	s OrderTypeStr=$g(^ARC("IC",ItemCatId)) Quit:OrderTypeStr="" ""
	s OrderType=$P(OrderTypeStr,"^",7)	Quit:OrderType="" ""
	Quit OrderType
}

/// Description： 检查医嘱项目是否是否检验医嘱
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).isLabTS("78||366")
ClassMethod isLabTS(ItemMast As %String) As %String
{
	s ItemMast=$g(ItemMast)
	s RtnValue="0"
	s ItmCat=$p(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1),"^",10)
	i $l(ItmCat),$d(^ARC("IC",ItmCat)){
		i $p(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	}
	Quit RtnValue
}

/// Creator：      ZhangXinying
/// CreateDate：   2019-09-18
/// Description：根据指定医嘱ID，取得本医嘱的检验项目的结果
/// Table： OE_OrdItm、Ens_LISSpecimenReport、Ens_LISReportResult、Ens_LISItemResult
/// Input： 医嘱OeordID
/// Output：ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位
///         AbnorFlag:异常标记,ItemRanges:范围值,Sequence:序号,ItemCode:项目代码
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","SelectLISReportByOeordID","102||395")
Query SelectLISReportByOeordID(OeordID As %String) As %Query(ROWSPEC = "ItemDesc:%String,Synonym:%String,ItemResult:%String,ItemUnit:%String,AbnorFlag:%String,ItemRanges:%String,Sequence:%String,ItemCode:%String")
{
}

ClassMethod SelectLISReportByOeordIDExecute(ByRef qHandle As %Binary, OeordID As %String) As %Status
{
 	Set repid=$i(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1 	
 	k ^TMP($zn,repid)
 	Set ORDID=$Piece(OeordID,"||",1)
 	Set ORDSUB=$Piece(OeordID,"||",2)
 	Quit:'($l(ORDID)!$l(ORDSUB)) $$$OK
 	Set DataFlag=$D(^OEORD(ORDID,"I",ORDSUB,3))
 	Set TestSetStr=$G(^OEORD(ORDID,"I",ORDSUB,3))
 	;Set VisitNumberTestSetDR=$Piece(TestSetStr,"^",35)
 	;Set VisitNumberTestSetDR=$tr(VisitNumberTestSetDR,$c(0))
	;If '$l(VisitNumberTestSetDR)  Quit $$$OK
	//报告信息
	s EnsStatusRowid=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OeordID,""),-1)
 	s Status=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),9)
	s AdmDr="",AdmType=""
 	s AdmDr=$p($g(^OEORD(ORDID)),"^",1)
 	s AdmType=$p($g(^PAADM(AdmDr)),"^",2) //过滤就诊类型为H的，不判断医嘱闭环状态
    If (Status'="RP")&&(Status'="RD")&&(AdmType'="H")   Quit $$$OK
	Set LabNo=$Piece(TestSetStr,"^",20)
	q:'$l(LabNo)
	s SpecimenRepID=""
	f  s SpecimenRepID=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_$zcvt(LabNo,"U"),SpecimenRepID))	q:SpecimenRepID=""  d
	.s LISSRReportID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenRepID)),2)
	.q:LISSRReportID="" 
	.s statusRp=""
	.&SQL(Select LISRR_Status into :status from SQLUser.Ens_LISReportResult where LISRR_ReportID=:LISSRReportID)
	.q:statusRp="2" //过滤取消审核状态报告
	.s OrdItemID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenRepID)),4)
	.q:OrdItemID'=OeordID
 	.s TestCodeDR="" f  s TestCodeDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISSRReportID,"U"),TestCodeDR)) q:TestCodeDR=""  d
 	..s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	..s TestCode=$lg(TestCodeData,2)
	..s ItemDesc=$lg(TestCodeData,3)
	..s Synonym=$lg(TestCodeData,7)
 	..s ResultDR=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(LISSRReportID,"U"),TestCodeDR,"")) 
 	..q:'$l(ResultDR) 
 	..s ResultData=$g(^Busi.ENS.EnsLISItemResultD(ResultDR))
	..s LISIROrderItemID=$lg(ResultData,28)
 	..q:($l(LISIROrderItemID)&&(LISIROrderItemID'=OeordID))
	..s ItemResult=$lg(ResultData,8)
	..s TextResult=$lg(ResultData,10)
	..s:TextResult'="" ItemResult=TextResult
	..s ItemUnit=$lg(ResultData,9) 
	..s AbnorFlag=$lg(ResultData,13)
	..s ItemRanges=$lg(ResultData,14)
	..s ResNoes=$lg(ResultData,24)
	..s MethodName=$lg(ResultData,15)
 	..s Sequence=+$lg(ResultData,19)
 	..s ^TMP($zn,repid,Sequence,ResultDR)=$lb(ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRanges,Sequence,TestCode)
    //排序
 	s Seq="" f  s Seq=$o(^TMP($zn,repid,Seq)) q:Seq=""  d
 	.s ResDR="" f  s ResDR=$o(^TMP($zn,repid,Seq,ResDR)) q:ResDR=""  d
	..Set Data=^TMP($zn,repid,Seq,ResDR)
 	..Do OutPut

 	k ^TMP($zn,repid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod SelectLISReportByOeordIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISReportByOeordIDExecute ]
{
	
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLISReportByOeordIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISReportByOeordIDExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ZhangXinying
/// CreatDate：    2019-09-28
/// Description:：根据就诊号,化验项目,审核日期查询对照码结果
/// Table：       Ens_LISReportResult
/// Input：       入参：就诊号；登记号；开始日期；结束日期；检验项目代码(NationalLong,用^分割)。其中就诊号和登记号不能同时为空，其它没有限制。
/// Output：	  返回：1.报告结果DR 1.医嘱号;3.检验号;4.标本类型;5.检验项目代码;6.检验项目名称;7.缩写;8.检验项目结果;9.异常标志;10.单位;11.参考范围;12.M微生物类型;13.接收标本日期;14.接收标本时间;15.报告日期;16.报告时间;17.定量结果;18.审核人工号;19.审核人姓名
/// Return：无  
/// d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryTCResultBySync","","0000000012","WBC","")
Query QryTCResultBySync(AdmId As %String, RegNo As %String, TCSyncList As %String, SttDate As %String, EndDate As %String) As %Query(ROWSPEC = "ReportResultDR,OrdItmRowID,Labno,Specimen,TCCode,TCName,Sync,TCRes,Flag,Unit,Ranges,TCType,RecDate,RecTime,AuthDate,AuthTime,Result,AuthUserCode,AuthUserDesc")
{
}

ClassMethod QryTCResultBySyncExecute(ByRef qHandle As %Binary, AdmId As %String, RegNo As %String, TCSyncList As %String, SttDate As %String, EndDate As %String) As %Status
{
	Set repid=$i(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	s (ReportResultDR,OrdItmRowID,Labno,Specimen,TCCode,TCName,Sync,TCRes,Flag,Unit,Ranges,TCType,RecDate,RecTime,AuthDate,AuthTime)=""
    s AdmId=$g(AdmId),RegNo=$g(RegNo),TCSyncList=$g(TCSyncList)
	s SttDate=$g(SttDate),EndDate=$g(EndDate)
	s SttDate=$tr(SttDate,"-"),EndDate=$tr(EndDate,"-") 
    i $l(RegNo) d
    .s PatientDr=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
    .q:PatientDr=""
    .f k=1:1:$L(TCSyncList,"^") d
    ..s TCSync=$p(TCSyncList,"^",k)
    ..//s TCSync=$zcvt(TCSync,"U")
	..//s TCSync=$tr(TCSync,"-")
    ..i '$l(TCSync) q
    ..s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestCodeI("IndexSCode",##Class(LIS.Util.Common).IndexData(TCSync),TestCodeDR)) q:TestCodeDR=""  d
 	...s AuthDate="" f  s AuthDate=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientDr,TestCodeDR,AuthDate)) q:(AuthDate="")  d
 	....i $l(SttDate),AuthDate<SttDate q 
 	....i $l(EndDate),AuthDate>EndDate q 
	....s AuthTime="" f  s AuthTime=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientDr,TestCodeDR,AuthDate,AuthTime)) q:(AuthTime="")  d
	.....s ResultDR=$o(^Busi.ENS.EnsLISItemResultI("LISIRItemCodeIndex",PatientDr,TestCodeDR,AuthDate,AuthTime,""))
  	.....d OutPutData
    //就诊号查询
    i $l(AdmId) d
    .f k=1:1:$L(TCSyncList,"^") d
    ..s TCSync=$p(TCSyncList,"^",k)
    ..//s TCSync=$zcvt(TCSync,"U")
	..//s TCSync=$tr(TCSync,"-")
    ..i '$l(TCSync) q
    ..s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestCodeI("IndexSCode",##Class(LIS.Util.Common).IndexData(TCSync),TestCodeDR)) q:TestCodeDR=""  d
    ...s AuthDate="" f  s AuthDate=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR,AuthDate)) q:(AuthDate="")  d
    ....q:(AuthDate="-100000000000000")
 	....i $l(SttDate),AuthDate<SttDate q 
 	....i $l(EndDate),AuthDate>EndDate q 
    ....s AuthTime="" f  s AuthTime=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR,AuthDate,AuthTime))  q:(AuthTime="")  d
    .....q:(AuthTime="-100000000000000")
    .....s ResultDR=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR,AuthDate,AuthTime,""))
	.....d OutPutData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutPutData
    s TCCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),2)
	s TCName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
	s TCType=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
	s ResultData=$g(^Busi.ENS.EnsLISItemResultD(ResultDR))
	s LISIRRowID=$lg(ResultData,2)
	s VisitNumberReportDR=$lg(ResultData,3)
	q:VisitNumberReportDR="" ""
	s LISReportResultDR=""
	&sql(select %id into :LISReportResultDR from sqlUser.Ens_LISReportResult where LISRR_ReportID=:VisitNumberReportDR)
	q:LISReportResultDR="" ""
	s Labno=$tr($o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(VisitNumberReportDR,"U"),""))," ","")
	s RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportResultDR)),65)
	s RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportResultDR)),66)
	i $l(RecTime) s RecTime=$zt(RecTime)
	i $l(RecDate) s RecDate=$zd(RecDate,3)
	s TCRes=$lg(ResultData,10)
	s:TCRes="" TCRes=$lg(ResultData,8)
	s ExtraRes=$lg(ResultData,11)
	i $l(ExtraRes) s TCRes=TCRes_"("_ExtraRes_")"
	s Unit=$lg(ResultData,9) 
	s Flag=$lg(ResultData,13)
	s Ranges=$lg(ResultData,14)
	s ResComm=$lg(ResultData,24)
	s MethodName=$lg(ResultData,15)
	i $l(AuthTime)&&(AuthTime'="-100000000000000") s tAuthTime=$zt(AuthTime)
	i $l(AuthDate)&&(AuthDate'="-100000000000000") s tAuthDate=$zd(AuthDate,3)
	s OrdItmRowID=$lg(ResultData,28)
   	
   	s Result=$lg(ResultData,8) //定量结果
   	s AuthUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportResultDR)),109) //审核人工号
   	s AuthUserDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportResultDR)),110) //审核人姓名
	s Data=$lb(LISIRRowID,OrdItmRowID,Labno,Specimen,TCCode,TCName,Sync,TCRes,Flag,Unit,Ranges,TCType,RecDate,RecTime,tAuthDate,tAuthTime,Result,AuthUserCode,AuthUserDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryTCResultBySyncClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTCResultBySyncExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTCResultBySyncFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTCResultBySyncExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ZhangXinying
/// CreatDate：   2019-09-07
/// Description：根据医嘱号返回体检所需检验信息
/// Debug:w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetLabInfo("102||387")
ClassMethod GetLabInfo(OrderId As %String) As %String
{
	set OrderId=$g(OrderId)
 	Set ORDID=$Piece(OrderId,"||",1)
 	Set ORDSUB=$Piece(OrderId,"||",2)
 	Quit:'($l(ORDID)!$l(ORDSUB)) $$$OK
 	Set DataFlag=$D(^OEORD(ORDID,"I",ORDSUB,3))
 	Set temstr=$G(^OEORD(ORDID,"I",ORDSUB,3))
 	Set Labno=$Piece(temstr,"^",20),ret=""
	i '$l(Labno) q ""
	//报告信息
	s SpecimenID="" for  s SpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_$zcvt(Labno,"U"),SpecimenID)) q:SpecimenID=""  d
	.s LISReportID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenID)),2)
	.s OrdItemID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(SpecimenID)),4)
	.q:OrdItemID'=OrderId
	.s ReportDR=""
	.&sql(select %id into :ReportDR from sqlUser.Ens_LISReportResult where LISRR_ReportID=:LISReportID)
	.s VisitNumberDR=ReportDR
	.s LISReportResultData=$g(^Busi.ENS.EnsLISReportResultD(ReportDR))
	.s EpisodeNo=$lg(LISReportResultData,5)
	.s AcceptDate=$lg(LISReportResultData,125)
	.s AcceptTime=$lg(LISReportResultData,126)
	.s:AcceptDate'="" AcceptDate=$zd(AcceptDate,3)
	.s:AcceptTime'="" AcceptTime=$zt(AcceptTime)
	.s AcceptUserCode=$lg(LISReportResultData,127)
	.s AcceptUser=$lg(LISReportResultData,128)	
	.s EntryDate=$lg(LISReportResultData,111) ///初审日期
	.s EntryTime=$lg(LISReportResultData,112) ///初审时间
	.s:EntryDate'="" EntryDate=$zd(EntryDate,3)
	.s:EntryTime'="" EntryTime=$zt(EntryTime)
	.s EntryUserCode=$lg(LISReportResultData,113) 
	.s EntryUser=$lg(LISReportResultData,114)
	.s AuthDate=$lg(LISReportResultData,107)
	.s AuthTime=$lg(LISReportResultData,108)
	.s:AuthDate'="" AuthDate=$zd(AuthDate,3)
	.s:AuthTime'="" AuthTime=$zt(AuthTime)
	.s AuthUserCode=$lg(LISReportResultData,109)
	.s AuthUser=$lg(LISReportResultData,110)	
	.s UploadDate=$lg(LISReportResultData,90)
	.s UploadTime=$lg(LISReportResultData,91)
	.s:UploadDate'="" UploadDate=$zd(UploadDate,3)
	.s:UploadTime'="" UploadTime=$zt(UploadTime)
	.s MajorConclusion=$lg(LISReportResultData,143)
	.s MinorConclusion=$lg(LISReportResultData,144)
	.s Status=$lg(LISReportResultData,117)

	.s LISRRPatientID=$lg(LISReportResultData,3) 
	.s RegNo=$p($g(^PAPER(LISRRPatientID,"PAT",1)),"^",1)
	.s RecordNo=$lg(LISReportResultData,6)
	.s AdmType=$lg(LISReportResultData,4)
 	.s SurName=$lg(LISReportResultData,13)
	.s PatName=SurName
	.s Species=$lg(LISReportResultData,14),SpeciesDR=""
	.s BirthDate=$lg(LISReportResultData,15)
	.s Age=$lg(LISReportResultData,16)
	.s AgeUnit=$lg(LISReportResultData,17),AgeUnitDR=""
	.s Location=$lg(LISReportResultData,21),LocationDR=""
	.s Ward=$lg(LISReportResultData,25),WardDR=""
	.s BedNo=$lg(LISReportResultData,26)
	.set docRowID = $p($g(^OEORD(ORDID,"I",ORDSUB,1)),"^",11)
	.if docRowID'="" d
	..set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
	..if userId'=""  d
	...set DoctorCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	...set Doctor=$p($g(^SSU("SSUSR",userId)),"^",2)
			
	.s Diagnose=""
	.s Remark=$lg(LISReportResultData,45)
	.s Specimen=$lg(LISReportResultData,147)
	.s CollectDate=$lg(LISReportResultData,48)
	.s CollectTime=$lg(LISReportResultData,49)
	.s:CollectDate'="" CollectDate=$zd(CollectDate,3)
	.s:CollectTime'="" CollectTime=$zt(CollectTime)
	.s CollectUserCode=$lg(LISReportResultData,50)
	.s CollectUser=$lg(LISReportResultData,51)
	.s AdmDate=$lg(LISReportResultData,7)
	.s AdmTime=$lg(LISReportResultData,8)
	.s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	.s:AdmTime'="" AdmTime=$zt(AdmTime)
	.s RequestDate=$lg(LISReportResultData,22)
	.s RequestTime=$lg(LISReportResultData,23)
	.s:RequestDate'="" RequestDate=$zd(RequestDate,3)
	.s:RequestTime'="" RequestTime=$zt(RequestTime)
	.s AddType = $lg(LISReportResultData,84)
	.s RequestUserCode=DoctorCode
	.s RequestUser=Doctor
	.s CarryDate=$lg(LISReportResultData,61)
    .s CarryTime=$lg(LISReportResultData,62)
	.s:CarryDate'="" CarryDate=$zd(CarryDate,3)
	.s:CarryTime'="" CarryTime=$zt(CarryTime)
    .s CarryUserCode=$lg(LISReportResultData,63)
    .s CarryUser=$lg(LISReportResultData,64)
	.s ReceiveDate=$lg(LISReportResultData,65)
	.s ReceiveTime=$lg(LISReportResultData,66)
	.s:ReceiveDate'="" ReceiveDate=$zd(ReceiveDate,3)
	.s:ReceiveTime'="" ReceiveTime=$zt(ReceiveTime)
	.s ReceiveUserCode=$lg(LISReportResultData,67)
	.s ReceiveUser=$lg(LISReportResultData,68)
	.s InStorageDate=$lg(LISReportResultData,71)
	.s InStorageTime=$lg(LISReportResultData,72)
	.s:InStorageDate'="" InStorageDate=$zd(InStorageDate,3)
	.s:InStorageTime'="" InStorageTime=$zt(InStorageTime)
	.s InStorageUserCode=$lg(LISReportResultData,73)
	.s InStorageUser=$lg(LISReportResultData,74),InStorageUserDR=""
	.s OutStorageDate=$lg(LISReportResultData,75)
	.s OutStorageTime=$lg(LISReportResultData,76)
	.s:OutStorageDate'="" OutStorageDate=$zd(OutStorageDate,3)
	.s:OutStorageTime'="" OutStorageTime=$zt(OutStorageTime)
	.s OutStorageUserCode=$lg(LISReportResultData,76)
	.s OutStorageUser=$lg(LISReportResultData,77)
	.s AddDate=$lg(LISReportResultData,80)
	.s AddTime=$lg(LISReportResultData,81)
	.s:AddDate'="" AddDate=$zd(AddDate,3)
	.s:AddTime'="" AddTime=$zt(AddTime)
	.s AddUserCode=$lg(LISReportResultData,82)
	.s AddUser=$lg(LISReportResultData,83)
	.s TestSetDesc="",Price=""

	.s ret=VisitNumberDR_$c(2)_EpisodeNo_$c(2)_Labno_$c(2)_RegNo_$c(2)_RecordNo_$c(2)_PatName_$c(2)_SpeciesDR_$c(2)_Species_$c(2)_BirthDate_$c(2)_Age_$c(2)_AgeUnitDR
	.s ret=ret_$c(2)_AgeUnit_$c(2)_AdmType_$c(2)_LocationDR_$c(2)_Location_$c(2)_WardDR_$c(2)_Ward_$c(2)_BedNo_$c(2)_DoctorCode_$c(2)_Doctor_$c(2)_Diagnose_$c(2)_Remark
	.s ret=ret_$c(2)_TestSetDesc_$c(2)_Specimen_$c(2)_Price_$c(2)_CollectDate_$c(2)_CollectTime_$c(2)_CollectUserCode_$c(2)_CollectUser_$c(2)_AdmDate_$c(2)_AdmTime_$c(2)_RequestDate_$c(2)_RequestTime
	.s ret=ret_$c(2)_RequestUserCode_$c(2)_RequestUser_$c(2)_CarryDate_$c(2)_CarryTime_$c(2)_CarryUserCode_$c(2)_CarryUser_$c(2)_ReceiveDate_$c(2)_ReceiveTime_$c(2)_ReceiveUserCode
	.s ret=ret_$c(2)_ReceiveUser_$c(2)_InStorageDate_$c(2)_InStorageTime_$c(2)_InStorageUserDR_$c(2)_InStorageUser_$c(2)_OutStorageDate_$c(2)_OutStorageTime_$c(2)_OutStorageUserCode
	.s ret=ret_$c(2)_OutStorageUser_$c(2)_AddDate_$c(2)_AddTime_$c(2)_AddUserCode_$c(2)_AddUser_$c(2)_AcceptDate_$c(2)_AcceptTime_$c(2)_AcceptUserCode_$c(2)_AcceptUser_$c(2)_EntryDate_$c(2)_EntryTime_$c(2)_EntryUserCode_$c(2)_EntryUser
	.s ret=ret_$c(2)_AuthDate_$c(2)_AuthTime_$c(2)_AuthUserCode_$c(2)_AuthUser_$c(2)_UploadDate_$c(2)_UploadTime_$c(2)_MajorConclusion_$c(2)_MinorConclusion_$c(2)_AddType_$c(2)_Status
	q ret
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：根据检验号获取报告ID，针对部分报告，逗号分割多个报告ID
/// Table：Ens_LISSpecimenReport、Ens_LISReportResult、Ens_Status、Ens_StatusLog
/// Input：检验号
/// Return：报告ID，逗号分割
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).QryLISRptIDByLabNo("0000004275")
ClassMethod QryLISRptIDByLabNo(labNo As %String, ordItemID As %String = "") As %String
{
	s $zt="Err"
	s ReportIDs="",Flag=""
	s LisSpeRepID=""  f  s LisSpeRepID=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_$zcvt(labNo,"U"),LisSpeRepID)) q:LisSpeRepID=""  d
	.s ReportID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(LisSpeRepID)),2)
	.s Flag=""
	.q:ReportID=""
	.s RptRowID=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",$zcvt(ReportID,"U"),""))
	.s RptStatus=$lg($g(^Busi.ENS.EnsLISReportResultD(RptRowID)),117)
	.q:RptStatus="2" //过滤报告取消审核的
	.s OrderItemIDs=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(LisSpeRepID)),4)
	.q:OrderItemIDs=""
	.s OrderItemID=$p(OrderItemIDs,",",1)
	.q:(ordItemID'="")&&(ordItemID'=OrderItemID)
	.s StatusId=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OrderItemID,""),-1)
	.q:StatusId=""
	.s Status=$lg($g(^Busi.ENS.EnsStatusD(StatusId)),9),ESOperateCode=""
	.s EnsStatusLogID=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_OrderItemID,""),-1)
	.q:EnsStatusLogID=""
	.s ESOperateCode=$lg(^Busi.ENS.EnsStatusLogD(EnsStatusLogID),9)
	.;q:(Status'="RP")&&(Status'="PRP")&&(Status'="RD")
	.q:((Status'="RP")&&(Status'="PRP")&&(Status'="RD"))&&((Status="ACCEPT")&&(ESOperateCode'="CPRP"))&&(RptStatus'="1") //过滤非报告的、非部分报告的、非阅读状态的以及保留部分报告取消审核仍需能看到结果的记录
	.q:((Status="PRP")&&(ESOperateCode="CRP")) //过滤部分报告后进行报告，然后取消审核部分报告、再取消审核整个报告的情况
	.q:(Status="RECEIVE")&&(ESOperateCode="CACCEPT") //取消审核、取消核收情况不能查看报告
	.q:((Status="PRERP")&&(ESOperateCode="CRP")) //过滤预报告取消审核后，不能查看报告
	.if ReportIDs="" d  s ReportIDs=ReportID
	.else  d  s ReportIDs=ReportIDs_","_ReportID
	.s inputStr=##class(%Stream.GlobalCharacter).%New(),rtnStr=""
	.d inputStr.Write("[{""OEOrdItemID"":"""_OrderItemID_""",""ExamID"":"""_labNo_"""}]")
	.s rtnStream=##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatusLog",inputStr)
	.s rtnStr=rtnStream.Read()
	.if (rtnStr["CRP")&&(Status'="RP")  s Flag=1
	s len=$l(ReportIDs,",")
	f i=1:1:len
	{
		s ReportID=$p(ReportIDs,",",i)
		continue:ReportID=""
		s ReportIDs(ReportID,i)=ReportID	
	}
	s ID="",num=""
	s j="" f  s j=$o(ReportIDs(j)) q:j=""  d
	.s num=$o(ReportIDs(j,num))
	.if ID="" d  s ID=$g(ReportIDs(j,num))
	.else  s ID=ID_","_$g(ReportIDs(j,num))
	.s num=""
	s Count=""
	&SQL(select count(1) into :Count from SQLUser.OE_OrdItem where OEORI_LabEpisodeNo=:labNo)
	s ilen=$l(ID,",")
	;if (Flag=1)&&(Count=1) s ID=$p(ID,",",ilen)
	if (Flag=1)&&(Count=1)&&(ilen=1)&&(ID[",") s ID=""
	q ID
Err
	q "-1^"_$ze
}

/// Creator：     ZhangXinying
/// CreatDate：   2019-09-07
/// Description:  查询检查报告记录，医政组用，查询住院、急诊检查报告
/// Table：       Ens_RISReportResult、Ens_Status、Ens_StatusLog
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// Output:ReportID:报告结果ID,EpisodeID:就诊号,StudyNo:检查号,StatusCode:状态代码,StatusDesc:状态描述,OrdItemCode:医嘱项代码,OrdItemDesc:医嘱项名称,ExamDesc:检查所见,ExamResult检查结果,RegDate:登记日期,RegTime:登记时间,RegUserCode:登记人工号,RegUserDesc:登记人姓名,RepDate:申请日期,RepTime:申请时间,RepUserCode:申请人工号,RepUserDesc:申请人姓名
/// Debug：do ##class(%Library.ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QueryRBReport",43,"2019-09-18","2019-09-18")
Query QueryRBReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,StudyNo:%String,StatusCode:%String,StatusDesc:%String,OrdItemCode:%String,OrdItemDesc:%String,ExamDesc:%String,ExamResult:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String")
{
}

ClassMethod QueryRBReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'="" {
		Set AdmStr = $g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)       //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		Set xID=0
		For {
			Set xID=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",aEpisodeID,xID))
			Quit:xID=""
			Set ReportData=$g(^Busi.ENS.EnsRISReportResultD(xID))
			Continue:ReportData=""
			Set RecDate=$lg(ReportData,10)  //报告日期
			Continue:RecDate=""
			Continue:RecDate<aDateFrom
			Continue:RecDate>aDateTo
			Set Data=..BuildRBReport(xID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		For xDate=aDateFrom:1:aDateTo {
			Set xTime=""
			For {
				Set xTime=$o(^Busi.ENS.EnsRISReportResultI("RISRCheckDateTimeIndex",xDate,xTime))
				Quit:xTime=""
				Set xID=""
				For {
					set xID=$o(^Busi.ENS.EnsRISReportResultI("RISRCheckDateTimeIndex",xDate,xTime,xID))
					Quit:xID=""
					Set ReportData=$g(^Busi.ENS.EnsRISReportResultD(xID))
					Continue:ReportData=""
					Set EpisodeID=$lg(ReportData,6)     //就诊号
					Continue:EpisodeID=""
					Set AdmStr = $g(^PAADM(+EpisodeID))
					Set AdmType= $p(AdmStr,"^",2)	        //就诊类型
					Continue:(AdmType'="I")&(AdmType'="E")
					Set Data=..BuildRBReport(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryRBReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryRBReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：     ZhangXinying
/// CreatDate：   2019-09-07
/// Description:  组织Query输出检查报告
/// Input：       aReportID : 检查报告ID
/// Return：      返回List
/// Debug:        w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).BuildRBReport(2)
ClassMethod BuildRBReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildRBReportErr"
	
	Set ReportData=$g(^Busi.ENS.EnsRISReportResultD(aReportID))
	Quit:ReportData="" return
	Set EpisodeID=$lg(ReportData,6)     //就诊号
	Quit:EpisodeID="" return
 	Set StudyNo=$lg(ReportData,3)        //检查号
	Set ExamDesc=$lg(ReportData,24)      //检查所见
    Set ExamResult=$lg(ReportData,25)  //诊断意见
    
    Set RepDate=$lg(ReportData,10)        //报告日期
    Set:RepDate'="" RepDate=$zd(RepDate,3)
    Set RepTime=$lg(ReportData,11)       //报告时间
    Set:RepTime'="" RepTime=$zt(RepTime)
    Set RepUserCode=$lg(ReportData,12)    //报告人工号
    Set RepUserDesc=$lg(ReportData,13)    //报告人姓名
	Set OeorditemStr=$lg(ReportData,4)   //报告医嘱串
	Set RISRStatus=$lg(ReportData,48)
	q:(RISRStatus'="")&&(RISRStatus'="1") //报告状态（1审核，2取消审核，3作废）,过滤取消审核状态、作废状态的
	for i=1:1:$l(OeorditemStr,"^") d //合并预约情况下，一份检查对应多条医嘱
	.s perOEORowid=$p(OeorditemStr,"^",i)
	.q:perOEORowid=""
	.s perOEORowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(perOEORowid,"_","||")
	.Set ArcimID=$p(^OEORD(+perOEORowid,"I",+$p(perOEORowid,"||",2),1),"^",2)
 	.q:ArcimID=""
	.Set OrdItemCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		           //检查项目代码
	.Set OrdItemDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)	               //检查项目名称
	.s EnsStatusDr=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemIDExamID"," "_perOEORowid," "_StudyNo,""))
	.q:EnsStatusDr=""
	.s Status=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusDr)),9)
    .q:(Status'="RP")&&(Status'="RD")&&(Status'="RPV")
	.Set RegInfo=$g(^Busi.ENS.EnsStatusD(EnsStatusDr))
	.Set RegDate=$lg(RegInfo,7)       //登记日期
	.Set:RegDate'="" RegDate=$zd(RegDate,3)
	.Set RegTime=$lg(RegInfo,8)       //登记时间
	.Set:RegTime'="" RegTime=$zt(RegTime)
	.Set RegUserCode=$lg(RegInfo,5)   //登记人工号
	.Set RegUserDesc=$lg(RegInfo,6)   //登记人姓名
	.// 报告状态 AP^申请、BK^预约、SC^登记、IP^开始检查、IM^已有图像、RP^报告、CM^检查完成、CA^取消检查、OCA^撤销检查
 	.Set StatusCode=$lg(RegInfo,9)  
 	.q:StatusCode=""
 	.Set StatusDr=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",StatusCode,""))
 	.q:StatusDr=""
 	.Set StatusDesc=$lg(^Code.ENS.EnsStatusCodeD(StatusDr),9)  //处理StatusDr=0报错情况
 	
	Set return=$lb(aReportID)
	Set return=return_$lb(EpisodeID)
	Set return=return_$lb(StudyNo)
	Set return=return_$lb(StatusCode)
	Set return=return_$lb(StatusDesc)
	Set return=return_$lb(OrdItemCode)
	Set return=return_$lb(OrdItemDesc)
	Set return=return_$lb(ExamDesc)
	Set return=return_$lb(ExamResult)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RegUserCode)
	Set return=return_$lb(RegUserDesc)
	Set return=return_$lb(RepDate)
	Set return=return_$lb(RepTime)
	Set return=return_$lb(RepUserCode)
	Set return=return_$lb(RepUserDesc)
	Quit return
	
BuildRBReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     ZhangXinying
/// CreatDate：   2019-10-20
/// Description:  通过检验结果ID取耐药机制结果接口
/// Input：       aResultID:检验结果ID
/// Return：      耐药机制信息
/// w ##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetRepRstRes(321)
ClassMethod GetRepRstRes(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetRepRstResErr"

	Set xResItemID=""   //耐药机制
	For {
		Set xResItemID=$o(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",aResultID,xResItemID))
		Quit:xResItemID="" 
				
		Set xRstResID="" 
		For {
			Set xRstResID=$o(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",aResultID,xResItemID,xRstResID))
			Quit:xRstResID=""  
			
			Set ResRstData=$g(^Busi.ENS.EnsLISItemResRstD(xRstResID))
			Continue:ResRstData=""
			Set ResItemCode=$lg(ResRstData,4)
			Set ResItemName=$lg(ResRstData,5)
			Set RstName=$lg(ResRstData,6)
			Continue:RstName=""
			Set ResRstDr="",RstCode=""
			&SQL(select RowID into :ResRstDr from dbo.BT_BaseTable where CName=:RstName)
			Set ResData = $g(^dbo.BTBaseTableD(ResRstDr))
			Continue:ResData=""
			Set RstCode = $lg(ResData,3)

			Set RepResRstData = xRstResID_"^"_xResItemID_"^"_ResItemCode_"^"_ResItemName_"^"_ResRstDr_"^"_RstCode_"^"_RstName
			Set return = return_$lb(RepResRstData)
		}
	}
	
	Quit return
GetRepRstResErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Desc:转换时间格式
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).TransDateFormat("2019-10-25")
ClassMethod TransDateFormat(Date As %String) As %String
{
	s $zt="Err"
	s DateH=Date
	i $l(Date)=8 s DateH=$zdh(Date,8)
	i $l(Date,"-")=3 s DateH=$zdh(Date,3)
	
	q DateH
Err
	q "-1^"_$ze
}

/// Desc:转换时间格式
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).TransTimeFormat("12:25:44")
ClassMethod TransTimeFormat(Time As %String) As %String
{
	s $zt="Err"
	s TimeH=Time
	i $l(Time,":")=3 s TimeH=$zth(Time)
	i $l(Time,":")=2 s TimeH=$zth(Time,2)
	q TimeH
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019-10-20
/// Description：获取HIS系统检查报告xml文档信息
/// Table：Ens_RisReportResult
/// Input： 检查号
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetRISReportDocument("U20191023001")
ClassMethod GetRISReportDocument(StudyNo As %String) As %Stream.GlobalCharacter
{
	set $zt="Exception"
	set stream=##class(%Stream.GlobalCharacter).%New()
	set clinicalDocument=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.clinicalDocument).%New()
	set documentHeader=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader=..documentHeader(StudyNo)
	set clinicalDocument.documentHeader=documentHeader
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(StudyNo,"U"),RARRowid))
	q:RARRowid="" stream
	set AdmNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set structuredBody=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.structuredBody).%New()
	set E0004desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0004desc.desc="姓名"
	set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set structuredBody.E0004=E0004desc
	if SexId'="" {
		set E0005desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
		set E0005desc.desc="性别代码"
		set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
		set structuredBody.E0005=E0005desc	
		set E0006desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
		set E0006desc.desc="性别描述"
		set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
		set structuredBody.E0006=E0006desc	
	}
	set E0008desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set:BirthYear'="" E0008desc.content=##class(web.DHCBillInterface).GetPapmiAge(patRowId,AdmNo) ;$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set E0008desc.desc="年龄"
	set structuredBody.E0008=E0008desc	
	set E0148desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set AdmTypeCode=$p($g(^PAADM(AdmNo)),"^",2)
	set E0148desc.content=AdmTypeCode
	set E0148desc.desc="病人类型代码"
	set structuredBody.E0148=E0148desc	
	set E0149desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0149desc.content=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿",:"")
	set E0149desc.desc="病人类型名称"
	set structuredBody.E0149=E0149desc
	set E0156desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	set:CurrentDetpRowID'="" E0156desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	set E0156desc.desc="科室id"
	set structuredBody.E0156=E0156desc
	set E0077desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	set E0077desc.desc="科室"
	set structuredBody.E0077=E0077desc
	set E0002desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0002desc.desc="住院号"
	set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set structuredBody.E0002=E0002desc
	set E0000desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0000desc.desc="门诊号"
	set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	set structuredBody.E0000=E0000desc
	set E0154desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedRowID=$P($g(^PAADM(AdmNo)),"^",73)
	set E0154desc.content=CurrentBedRowID
	set E0154desc.desc="病床id"
	set structuredBody.E0154=E0154desc	
	set E0075desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedNo=""
	if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	.set BedWordRowID = $p(CurrentBedRowID,"||",1)
	.set BedChildSub = $p(CurrentBedRowID,"||",2)
	.if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	..set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	set E0075desc.desc="病床"
	set E0075desc.content=CurrentBedNo
	set structuredBody.E0075=E0075desc
	//取诊断信息
	set AllDiagnoses=..GetDiagnoses(AdmNo)
	set AllDiagnosesLen=$l(AllDiagnoses,"!")
	for i=1:1:AllDiagnosesLen {
		set AllDiagnose=$p($g(AllDiagnoses),"!",i)
		if AllDiagnose'="" {
			set S0048section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0048).%New()
			set S0048section.code="S0048"
			set S0048section.desc="诊断"
			set E07descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E07descDig.desc="医生填写的诊断"
			set E07descDig.content=$p($g(AllDiagnose),"^",2)
			set S0048section.E07=E07descDig
			set E01descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E01descDig.content=$p($g(AllDiagnose),"^",5) 
			set E01descDig.desc="诊断名称"
			set S0048section.E01=E01descDig
			set E02descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E02descDig.content=$p($g(AllDiagnose),"^",4)
			set E02descDig.desc="诊断代码"
			set S0048section.E02=E02descDig
			d structuredBody.S0048.Insert(S0048section)
		}
	}
	set S0076section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0076).%New()
	set S0076section.code="S0076"
	set S0076section.desc="检查记录" 
	set E01desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E01desc.desc="检查号"
	set E01desc.content=StudyNo
	set S0076section.E01=E01desc
	set E02desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E02desc.desc="检查设备编码"
	set S0076section.E02=E02desc
	set E03desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E03desc.desc="检查设备名称"
	set S0076section.E03=E03desc
	set E04desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	s RISRPositionCode=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),21)
	set E04desc.desc="检查部位代码"
	set E04desc.content=RISRPositionCode
	set S0076section.E04=E04desc
	s RISRPositionDesc=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),22)
	set E05desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E05desc.desc="检查部位名称"
	set E05desc.content=RISRPositionDesc
	set S0076section.E05=E05desc
	set E06desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E06desc.desc="检查部位医生手写"
	set S0076section.E06=E06desc
	set E07desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E07desc.desc="检查部位"
	set E07desc.content=RISRPositionDesc
	set S0076section.E07=E07desc
	set E08desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set DRPTRowID=0 
	;set DRPTRowID=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,DRPTRowID))
	set E08desc.desc="检查所见"
	set E08desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),24) ;^DHCRBStudy("Report",DRPTRowID,"ExamDescEx")
	set S0076section.E08=E08desc
	set E09desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E09desc.desc="检查结果"
	set E09desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),25) ;^DHCRBStudy("Report",DRPTRowID,"ResultDescEx")
	set S0076section.E09=E09desc
	set E10desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E10desc.desc="检查医师代码"
	set E10desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),8)
	set S0076section.E10=E10desc
	set E11desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E11desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),9)
	set E11desc.desc="检查医师姓名"
	set S0076section.E11=E11desc
	set E12desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	
	set E12desc.desc="审核医师代码"
	set E12desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),12)
	set S0076section.E12=E12desc
	set E13desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E13desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),13)
	set E13desc.desc="审核医师姓名"
	set S0076section.E13=E13desc
	set E14desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
 	
	set E14desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),12)
	set E14desc.desc="记录者代码"
	set S0076section.E14=E14desc
	set E15desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E15desc.desc="记录者姓名"
	set E15desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),13)
	set S0076section.E15=E15desc
	set E16desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),10)
	set:ReportDate'="" ReportDate= $ZD(ReportDate,3)
	set E16desc.desc="检查日期"
	set E16desc.content=ReportDate
	set S0076section.E16=E16desc
	set E17desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),11)
	set:ReportTime'="" ReportTime= $ZT(ReportTime,1)	
	set E17desc.desc="检查时间"	
	set E17desc.content=ReportTime
	set S0076section.E17=E17desc
	set E18desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E18desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),2)
	set E18desc.desc="报告号"
	set S0076section.E18=E18desc
	set E19desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),14)
	set:VerifyDate'="" VerifyDate= $ZD(VerifyDate,3)
	set E19desc.content=VerifyDate
	set E19desc.desc="审核日期"
	set S0076section.E19=E19desc
	set E20desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),15)
	set:VerifyTime'="" VerifyTime= $ZT(VerifyTime,1)
	set E20desc.desc="审核时间"
	set E20desc.content=VerifyTime
	set S0076section.E20=E20desc
	set E21desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set OeordItmDR =$p($lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4),"^",1)
    set OeordRowid = $p(OeordItmDR,"||",1)
    set OeordSub = $p(OeordItmDR,"||",2)
    set OEORIItmMastDR = $p(^OEORD(OeordRowid,"I",OeordSub,1),"^",2)
	set E21desc.desc="检查项目描述"
	set E21desc.content=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2) 
	set S0076section.E21=E21desc
	set E22desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E22desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),23) ;$p(^DHCRBStudy("Report",DRPTRowID),"^",24)
	set E22desc.desc="检查方法描述"
	set S0076section.E22=E22desc
	set E23desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),10)
	set:ReportDate'="" ReportDate= $ZD(ReportDate,3)
	set E23desc.content=ReportDate
	set E23desc.desc="报告日期"
	set S0076section.E23=E23desc
	set E24desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),11)
	set:ReportTime'="" ReportTime= $ZT(ReportTime,1)
	set E24desc.content=ReportTime
	set E24desc.desc="报告时间"
	set S0076section.E24=E24desc
	set E25desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E25desc.desc="医嘱号"
	set E25desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4)
	set S0076section.E25=E25desc
	set E26desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E26desc.desc="是否危急"
	set E26desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),34)
	set S0076section.E26=E26desc
	set E27desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E27desc.desc="是否阳性"
	set E27desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),35)
	set S0076section.E27=E27desc
	set E28desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E28desc.desc="异常标记"
	set E28desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),36)
	set S0076section.E28=E28desc
	set E29desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E29desc.desc="麻醉医师工号"
	set E29desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),37)
	set S0076section.E29=E29desc
	set E30desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E30desc.desc="麻醉医师姓名"
	set E30desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),38)
	set S0076section.E30=E30desc
	set E31desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E31desc.desc="麻醉方式代码"
	set E31desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),39)
	set S0076section.E31=E31desc
	set E32desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E32desc.desc="麻醉方式描述"
	set E32desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),40)
	set S0076section.E32=E32desc
	set E33desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E33desc.desc="麻醉分级代码"
	set E33desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),41)
	set S0076section.E33=E33desc
	set E34desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E34desc.desc="麻醉分级描述"
	set E34desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),42)
	set S0076section.E34=E34desc
	set E35desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E35desc.desc="麻醉开始时间"
	set E35desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),43)
	set S0076section.E35=E35desc
	set E36desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E36desc.desc="麻醉结束时间"
	set E36desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),44)
	set S0076section.E36=E36desc
	set structuredBody.S0076=S0076section
	set clinicalDocument.structuredBody=structuredBody
	set streamAll=##class(%Stream.GlobalCharacter).%New()
	do streamAll.Write("<?xml version=""1.0"" encoding=""UTF-8""?>") 
	do clinicalDocument.XMLExportToStream(.stream)
	do streamAll.CopyFrom(stream) 
	Quit streamAll
Exception
	set clinicalDocument=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.clinicalDocument).%New()
	d clinicalDocument.XMLExportToStream(.stream)
	Quit stream
}

/// Desc:	根据就诊号获取所有诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述!诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetDiagnoses("394")
ClassMethod GetDiagnoses(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s DiagnoseStatusDr="",DiagnoseStatus=""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		if (mrdiachildsub'=0) {
		    s admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
		    q:admDiagTypeId=""
	        s admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	        s admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
		    s themrdiachildsub = mrdiachildsub
		    s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
	        if (mricdid="") {
		        set mricdCode=""
		        set mricdDesc=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
		        s DiagnoseStatusDr=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",9)
		        i DiagnoseStatusDr'="" s DiagnoseStatus=$p($g(^MRC("DSTAT",DiagnoseStatusDr)),"^",2)

		    }
		    else{
		        s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
		        s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		        s DiagnoseStatusDr=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",9)
		        i DiagnoseStatusDr'="" s DiagnoseStatus=$p($g(^MRC("DSTAT",DiagnoseStatusDr)),"^",2)
		    }
		    if (retValue = "") {	
		    	set retValue = admDiagTypeCode_"^"_admDiagTypeDesc_"^"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_DiagnoseStatus
		    }
		    else {	
		    	s retValue = admDiagTypeCode_"^"_admDiagTypeDesc_"^"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_DiagnoseStatus_"!"_retValue
		    }
		}
	}
	q retValue
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检查报告ID返回报告结果头对象
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).documentHeader("U20190919002").XMLExport()
ClassMethod documentHeader(StudyNo As %String) As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader
{
	set documentHeader=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(StudyNo,"U"),""))
	q:RARRowid="" documentHeader
	set SysCode=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),7)
	if SysCode="PIS" set documentHeader.title="病理检查报告"
	else  set documentHeader.title="检查报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.author).%New()
	set AdmNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set RAROEORIDR=$p($lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4),"^",1)
	set ordstr1 = $g(^OEORD($p(RAROEORIDR,"||",1),"I",$p(RAROEORIDR,"||",2),1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.name).%New()
	set PatRowID=$P($g(^PAADM(AdmNo)),"^",1)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	set CredentialNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if ((CredentialTypeRowID'="")&&(CredentialNum'="")) {
		set certificatename.code=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set certificatename.content=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2) 
		set certificate.value=CredentialNum
	}
	else {
		set certificatename.code=""
		set certificatename.content=""
		set certificate.value=CredentialNum
	}
	set certificate.name=certificatename
	set patient.certificate=certificate
	set addr=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr).%New()
	set addr.text=$g(^PAPER(patRowId,"PER","ADD",1))
	set addr.desc="现住址"
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	set ProvinceDesc=""
	if ProvinceRowID'="" d
	.set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	.set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	if CityCodeRowID'="" d
	.set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	.set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	if CityAreaRowID'="" d
	.set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	set addr.houseNumber=""
	set addr.streetName=""
	set addr.township=""
	set addr.county=CityAreaDesc
	set addr.city=CityCodeDesc
	set addr.state=ProvinceDesc
	set WorkPostCodeDR=$o(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set:WorkPostCodeDR'="" addr.postalCode=$p($g(^DHCPERSON(WorkPostCodeDR)),"^",8)
	set patient.addr=addr
	set patient.name=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set patient.telecom=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set ethnicGroup=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	if age.value<=1
	{
		s age.value=$fn((+$h-BirthYear)/30,"",2)	
		s age.unit="月"
	}
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr).%New()
	set participantAddr.desc="联系人地址"
	set participantAddr.text=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set participantAddr.houseNumber=""
	set participantAddr.streetName=""
	set participantAddr.township=""
	set participantAddr.county=""
	set participantAddr.city=""
	set participantAddr.state=""
	set participantAddr.postalCode=""
	set participant.addr=participantAddr
	set documentHeader.participant=participant
	Quit documentHeader
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验报告ID返回报告文档流
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetLISReportDocument("85").Read()
ClassMethod GetLISReportDocument(reportId As %String) As %Stream.GlobalCharacter
{
	set $zt="Exception"
	set stream=##class(%Stream.GlobalCharacter).%New()
	set LabNo=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(reportId,"U"),"")) ;+reportId
	q:LabNo="" stream
	s LISReportId=""
	&sql(select %id into :LISReportId from sqlUser.Ens_LISReportResult where LISRR_ReportID=:reportId)
	set streamAll=##class(%Stream.GlobalCharacter).%New()
	if LabNo'=""  d
	.set clinicalDocument=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.clinicalDocument).%New()
	.set documentHeader=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader).%New()
	.set LabNo=$tr(LabNo," ","")
	.q:LabNo="" 
	.set documentHeader=..LISdocumentHeader(LabNo)
	.set clinicalDocument.documentHeader=documentHeader
	.set ordRowId=$O(^OEORD(0,"EpisNo",LabNo,""))
    .set AdmNo = $P($g(^OEORD(ordRowId)),"^",1)
	.set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	.set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	.set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	.set structuredBody=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.structuredBody).%New()
	.set E0004desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0004desc.desc="姓名"
	.set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	.set structuredBody.E0004=E0004desc	
	.set E0002desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0002desc.desc="住院号"
	.set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	.set structuredBody.E0002=E0002desc
	.set E0000desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0000desc.desc="门诊号"
	.set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	.set structuredBody.E0000=E0000desc	
	.set E0148desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set AdmTypeCode=$p($g(^PAADM(AdmNo)),"^",2)
	.set E0148desc.content=AdmTypeCode
	.set E0148desc.desc="病人类型代码"
	.set structuredBody.E0148=E0148desc	
	.set E0149desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0149desc.content=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	.set E0149desc.desc="病人类型名称"
	.set structuredBody.E0149=E0149desc
	.if SexId'="" d
	..set E0005desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E0005desc.desc="性别代码"
	..set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
	..set structuredBody.E0005=E0005desc	
	..set E0006desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E0006desc.desc="性别描述"
	..set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
	..set structuredBody.E0006=E0006desc
	.set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	.set E0077desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	.set E0077desc.desc="科室"
	.set structuredBody.E0077=E0077desc	
	.set E0008desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set:BirthYear'="" E0008desc.content=##class(web.DHCBillInterface).GetPapmiAge(patRowId,AdmNo) ; ;$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	.set E0008desc.desc="年龄"
	.set structuredBody.E0008=E0008desc
	.set E0075desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set CurrentBedNo=""
	.if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	..set BedWordRowID = $p(CurrentBedRowID,"||",1)
	..set BedChildSub = $p(CurrentBedRowID,"||",2)
	..if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	...set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	.set E0075desc.desc="病床"
	.set E0075desc.content=CurrentBedNo
	.set structuredBody.E0075=E0075desc
	
	.set E0150desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0150desc.content=""
	.set E0150desc.desc="费别代码"
	.set structuredBody.E0150=E0150desc
	.set E0151desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0151desc.content=""
	.set E0151desc.desc="费别名称"
	.set structuredBody.E0151=E0151desc	
	.//取诊断信息
	.set AllDiagnoses=..GetDiagnoses(AdmNo)
	.set AllDiagnosesLen=$l(AllDiagnoses,"!")
	.for i=1:1:AllDiagnosesLen d
	..set AllDiagnose=$p($g(AllDiagnoses),"!",i)
	..if AllDiagnose'="" d
	...set S0048section=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0048).%New()
	...set S0048section.code="S0048"
	...set S0048section.desc="诊断"
	...set E07descDig=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E07descDig.desc="医生填写的诊断"
	...set E07descDig.content=$p($g(AllDiagnose),"^",2)
	...set S0048section.E07=E07descDig
	...set E01descDig=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E01descDig.content=$p($g(AllDiagnose),"^",5) 
	...set E01descDig.desc="诊断名称"
	...set S0048section.E01=E01descDig
	...set E02descDig=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E02descDig.content=$p($g(AllDiagnose),"^",4)
	...set E02descDig.desc="诊断代码"
	...set S0048section.E02=E02descDig
	...d structuredBody.S0048.Insert(S0048section)
	.set S0061=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0061).%New()
	.set S0061.code="S0061"
	.set S0061.desc="检验记录"
	.set ReportDeptCode="",ReportDeptDesc="",labSpecCode="",labSpecName="",arcimCode=""
	.set arcimDesc="",veriTime="",veriDate="",OEORIEnterDocCode="",OEORIEnterDocDesc=""
	.set OEORDRowId=""  f  set OEORDRowId=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId)) q:OEORDRowId=""  d
	..set OEORIChildsub="" f  set OEORIChildsub=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...// 报告Id
	...set labRelatId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",35)
	...// 医嘱日期
	...set veriDate=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
	...set:veriDate'="" veriDate=$zd(veriDate,3)
	...// 医嘱ID
	...set OrdRowId=OEORDRowId_"||"_OEORIChildsub
	.../// 医嘱项Id  
	...set arcimRowId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...if arcimRowId'=""  d
	....set arcSub=+arcimRowId
	....set arcVer=$p(arcimRowId,"||",2)
	....set:arcimCode'="" arcimCode=arcimCode_","_$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	....set:arcimCode="" arcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	....set:arcimDesc'="" arcimDesc=arcimDesc_","_$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	....set:arcimDesc="" arcimDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	...set ReportDeptID=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...if ReportDeptID'=""  d
	....set ReportDeptCode=$p($g(^CTLOC(ReportDeptID)),"^",1)
	....set ReportDeptDesc=$p($g(^CTLOC(ReportDeptID)),"^",2)
	.../// 外部代码
    ...set arcExCode=..GetExCode(arcimRowId)
    .../// 检验标本代码、标本名称
	...set labSpecCode="",labSpecName=""		
	...if $d(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1))'=0 d
	....set labSpecInfo=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1))
	....set labSpecCode=$p(labSpecInfo,"^",1)
	....set HospitalID=..GetLabHospByAdm(AdmNo)
	....q:HospitalID=""
	....set:labSpecCode'="" labSpecID=$o(^dbo.BTSpecimenI("IndexCode",HospitalID,##Class(LIS.Util.Common).IndexData(labSpecCode),""))
	....set labSpecName=$lg(^dbo.BTSpecimenD(labSpecID),3)
	...set docRowID = $P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",11)
	...if docRowID'="" d
	....set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
	....if userId'="" d
	.....set OEORIEnterDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.....set OEORIEnterDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	.set TSData=$g(^Busi.ENS.EnsLISReportResultD(LISReportId))
	./// 接收日期、接收时间  
	.Set ReceiveDate=$lg(TSData,65)  
	.Set:ReceiveDate'="" ReceiveDate=$ZD(ReceiveDate,3) 
	.Set ReceiveTime=$lg(TSData,66)  
	.Set:ReceiveTime'="" ReceiveTime=$ZT(ReceiveTime,1)  
	.set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E01.desc="检验项目代码"
	.set E01.content=arcimCode
	.set S0061.E01=E01
	.set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E02.desc="检验项目名称"
	.set E02.content=arcimDesc
	.set S0061.E02=E02
	.set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E03.desc="送检日期"
	.set E03.content=ReceiveDate
	.set S0061.E03=E03
	.set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E04.desc="送检时间"
	.set E04.content=ReceiveTime
	.set S0061.E04=E04
	.set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E05.desc="标本类型代码"
	.set E05.content=labSpecCode
	.set S0061.E05=E05
	.set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E06.desc="标本类型名称"
	.set E06.content=labSpecName
	.set S0061.E06=E06
	.set E07=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E07.desc="标本号"
	.set E07.content=LabNo
	.set S0061.E07=E07
	.set E08=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E08.desc="检验备注"
	.set E08.content=""
	.set S0061.E08=E08
	.set E09=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E09.desc="送检医生代码"
	.set E09.content=OEORIEnterDocCode
	.set S0061.E09=E09
	.set E10=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E10.desc="送检医生姓名"
	.set E10.content=OEORIEnterDocDesc
	.set S0061.E10=E10
	
	./// 采集日期、采集时间
	.set CollectDate="",CollectTime=""
	.set CollectDate=$lg(TSData,48)
	.set CollectTime=$lg(TSData,49)     
	.set:(CollectDate'="") CollectDate=$ZD(CollectDate,3) 
	.set:(CollectTime'="") CollectTime=$ZT(CollectTime,1)		
	
	./// 接收者代码、接收者名称
	.set ReceiveUserName=""
	.Set ReceiveUserCode=$lg(TSData,67) 
 	.Set ReceiveUserName=$lg(TSData,68) 
	./// 检验者代码、检验者名称 
  	.set authorUserCode=$lg(TSData,127)
  	.set authorUserName=$lg(TSData,128)
    ./// 检验日期、检验时间  
	.set authorDate=$lg(TSData,125)
	.set:authorDate'="" authorDate=$ZD(authorDate,3)
	.set authorTime=$lg(TSData,126)	
	.set:authorTime'="" authorTime=$ZT(authorTime,1)
	.set E11=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E11.desc="检验日期"
	.set E11.content=authorDate
	.set S0061.E11=E11
	.set E12=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E12.desc="检验时间"
	.set E12.content=authorTime
	.set S0061.E12=E12
	.set E13=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E13.desc="检验者代码"
	.set E13.content=authorUserCode
	.set S0061.E13=E13
	.set E14=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E14.desc="检验者姓名"
	.set E14.content=authorUserName
	.set S0061.E14=E14	
	./// 审核日期、审核时间  
	.Set CheckDate=$lg(TSData,107)  
	.Set:$Length(CheckDate) CheckDate=$ZD(CheckDate,3) 
	.Set CheckTime=$lg(TSData,108)  
	.Set:$Length(CheckTime) CheckTime=$ZT(CheckTime,1)  
	./// 审核者代码、审核者名称
	.Set CheckUserCode=$lg(TSData,109)
	.Set CheckUserName=$lg(TSData,110)
	.set E17=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E17.desc="审核报告日期"
	.set E17.content=CheckDate
	.set S0061.E17=E17
	.set E18=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E18.desc="审核报告时间"
	.set E18.content=CheckTime
	.set S0061.E18=E18
	.set E19=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E19.desc="审核者代码"
	.set E19.content=CheckUserCode
	.set S0061.E19=E19
	.set E20=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E20.desc="审核者姓名"
	.set E20.content=CheckUserName
	.set S0061.E20=E20
	./// 报告发布日期 
	.set reportDate=$lg(TSData,107)
	.set:reportDate'="" reportDate=$ZD(reportDate,3)
	./// 报告发布时间
	.set reportTime=$lg(TSData,108)
	.set:reportTime'="" reportTime=$ZT(reportTime)	
	./// 报告医生
	.set reportUserCode=$lg(TSData,109)
	.set reportUserName=$lg(TSData,110)
	.set E15=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E15.desc="报告日期"
	.set E15.content=reportDate
	.set S0061.E15=E15
	.set E16=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E16.desc="报告时间"
	.set E16.content=reportTime
	.set S0061.E16=E16		
	.// 仪器代码、仪器名称 
	.Set MachineCode=$lg(TSData,120)  
	.set MachineName=$lg(TSData,121)
    ./// 打印标记
	.set printflag=$lg(TSData,137) 
	.set E21=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E21.desc="报告备注"
	.set E21.content=""
	.set S0061.E21=E21
	.set E22=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E22.desc="检验目的"
	.set E22.content=""
	.set S0061.E22=E22
	.set E23=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E23.desc="检验结果"
	.set E23.content=""
	.set S0061.E23=E23
	.set E24=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E24.desc="报告号"
	.set E24.content=reportId
	.set S0061.E24=E24
	.set E25=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E25.desc="医嘱号"
	.set E25.content=$replace(..QryLISOrdIDByRpt(reportId),",","^")
	.set S0061.E25=E25
	.if reportDate'=""  d
	..set tSC=..LISItemResult(reportId,.S0061)
	..if tSC=1 d
	...set structuredBody.S0061=S0061
	.set clinicalDocument.structuredBody=structuredBody
	.;d clinicalDocument.XMLExportToStream(.stream)
	.do streamAll.Write("<?xml version=""1.0"" encoding=""UTF-8""?>") 
	.do clinicalDocument.XMLExportToStream(.stream)
	.do streamAll.CopyFrom(stream) 
	Quit streamAll
	
Exception
	set clinicalDocument=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.clinicalDocument).%New()
	d clinicalDocument.XMLExportToStream(.stream)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验报告ID返回报告结果
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).LISItemResult(85,.obj)
ClassMethod LISItemResult(reportId As %String, Output S0061 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0061) As %String
{
	set $zt="Exception"		
	set LISReportId="" 
	&sql(select %id into :LISReportId from sqlUser.Ens_LISReportResult where LISRR_ReportID=:reportId)
	q:LISReportId="" ""
	set itemCode="" for  set itemCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(reportId,"U"),itemCode)) q:itemCode=""  d
	.set LISItemId=""  for  set LISItemId=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(reportId,"U"),itemCode,LISItemId)) q:LISItemId=""  d
	..set resultStr=$G(^Busi.ENS.EnsLISItemResultD(LISItemId))
	..// 序号
	..set serialNo=$lg(resultStr,19)
	..// 结果	
	..set resultValue=$lg(resultStr,10)
  	../// 检验方法名称
  	..set TestMethodDesc=$lg(resultStr,15)
	..//判断是否有药敏结果
	..set AntResFlag=0
	..set LISIRRowID=$lg(resultStr,2)
	..if $d(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISIRRowID)) set AntResFlag=1		
	..set receiveDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportId)),65)
	../// 检验结果项目rowid
	..set itemCode=$lg(resultStr,6)
 	../// 检验结果项目描述
 	..set itemDesc=$lg(resultStr,7)
 	../// 缩写
 	..set abbreviation=$lg($g(^dbo.BTTestCodeD(itemCode)),7)
	../// 定量结果
	..set resultQuantity=$lg(resultStr,8)
 	../// 结果值
 	..set resultValue=$lg(resultStr,10)
 	../// 单位
 	..set unit=$lg(resultStr,9)
 	../// 高低标识
 	..set flagUpDown=$lg(resultStr,13)
 	../// 正常范围
 	..set naturalRange=$lg(resultStr,14)
 	..//细菌计数
 	..set count=$lg(resultStr,22)
 	..//专家规则
 	..set expertRule=$lg(resultStr,23)
 	..//备注
 	..set notes=$lg(resultStr,24)
 	..set:notes="" notes=resultValue
 	..///细菌耐药性标志
	..set multipleResist=$lg(resultStr,34)
	..///检验设备编码、名称
	..set lisMachine=$lg(resultStr,16)
	..///结果说明
	..set resultExpain=$lg(resultStr,12)
	..///显示序号
	..set showSeq=$lg(resultStr,19)
 	..set warnFlag=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportId)),116) 	
 	..if AntResFlag=1 d
	...set S0063=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0063).%New()
	...set S0063.code="S0063"
	...set S0063.desc="微生物培养生成细菌信息"
	...set S0063.text=""
	...set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E01.desc="细菌代码"
	...set E01.content=$lg($g(^dbo.BTTestCodeD(itemCode)),2)
	...set S0063.E01=E01
	...set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E02.desc="细菌名称"
	...set E02.content=itemDesc
	...set S0063.E02=E02
	...set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E03.desc="细菌计数"
	...set E03.content=count
	...set S0063.E03=E03
	...set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E04.desc="专家规则"
	...set E04.content=expertRule
	...set S0063.E04=E04
	...set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E05.desc="备注"
	...set E05.content=notes
	...set S0063.E05=E05
	...set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E06.desc="细菌耐药性标志"
	...set E06.content=multipleResist
	...set S0063.E06=E06
	...set tSC=..LISItemSenResult(reportId,itemCode,.S0063)
	...if tSC=1 d
	....d S0061.S0063.Insert(S0063)
	..else  d
	...set S0062=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0062).%New()
	...set S0062.code="S0062"
	...set S0062.desc="检验子项结果"
	...set S0062.text=resultValue
	...set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E01.desc="检验子项代码"
	...set E01.content=$lg($g(^dbo.BTTestCodeD(itemCode)),2)
	...set S0062.E01=E01
	...set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E02.desc="检验子项名称"
	...set E02.content=itemDesc
	...set S0062.E02=E02
	...set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E03.desc="检验子项结果（定量）"
	...set E03.content=resultQuantity
	...set S0062.E03=E03
	...set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E04.desc="检验子项结果单位"
	...set E04.content=unit
	...set S0062.E04=E04
	...set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E05.desc="检验子项结果（定性，阴/阳）"
	...set E05.content=resultValue
	...set S0062.E05=E05
	...set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E06.desc="检验子项参考值范围"
	...set E06.content=naturalRange
	...set S0062.E06=E06
	...set E07=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E07.desc="检验子项异常标志"
	...set E07.content=flagUpDown
	...set S0062.E07=E07
	...set E08=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E08.desc="检验设备编码"
	...set E08.content=lisMachine
	...set S0062.E08=E08
	...set E09=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E09.desc="检验设备名称"
	...set E09.content=lisMachine
	...set S0062.E09=E09
	...set E10=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E10.desc="结果说明"
	...set E10.content=resultExpain
	...set S0062.E10=E10
	...set E11=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E11.desc="显示序号"
	...set E11.content=showSeq
	...set S0062.E11=E11
	...set E12=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E12.desc="检验子项缩写"
	...set E12.content=""
	...set S0062.E12=E12
	...d S0061.S0062.Insert(S0062)
	Quit 1
Exception
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验报告ID、报告小项ID返回药敏结果
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).LISItemSenResult(85,437,.obj)
ClassMethod LISItemSenResult(reportId As %String, itemCode As %String, Output S0063 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0063) As %String
{
	set $zt="Exception"	
	set LISReportId=""
	&sql(select %id into :LISReportId from sqlUser.Ens_LISReportResult where LISRR_ReportID=:reportId)
	q:LISReportId="" ""
	set LISItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(reportId,"U"),itemCode,""))
	q:LISItemResultID="" ""
	set LISISRResultID=$lg($g(^Busi.ENS.EnsLISItemResultD(LISItemResultID)),2)
	set ant="" f  s ant=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID,ant)) q:ant=""  d
	.// 抗生素名称
	.set antId=$o(^dbo.BTAntibioticsI("IndexCode",##Class(LIS.Util.Common).IndexData(ant),""))
	.q:antId="" 
	.set antname=$lg(^dbo.BTAntibioticsD(antId),3)
	.// 英文名称
	.set antEname=$lg(^dbo.BTAntibioticsD(antId),4)
  	.set SenId="" f  s SenId=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",LISISRResultID,ant,SenId)) q:SenId=""  d
  	..s temstr=$g(^Busi.ENS.EnsLISItemSenResultD(SenId))
  	..// 结果
	..set temresCode=$lg(temstr,6) 
	..set method=$lg(temstr,12)
	..set result=$lg(temstr,5)
	..// mic结果
	..set temmic=""
	..set:method="MIC" temmic=result   
	..if $e(temmic,1)="." set temmic="0"_temmic
	..// mm结果等同于KB
	..set temmm=""
	..set:method="KB" temmm=result  
	..if $e(temmm,1)="." set temmm="0"_temmm
	..set temresDesc=""
	..if temresCode="R" set temresDesc="耐药" 
	..if temresCode="S" set temresDesc="敏感" 
	..if temresCode="I" set temresDesc="中介" 
	..if temresCode="SDD" set temresDesc="SDD"
	..if temresCode="D" set temresDesc="剂量依赖性敏感"
	..if temresCode="-" set temresDesc="无判定"
	..//建议
  	..set suggestion=$lg(temstr,13),iranges=$lg(temstr,8),sranges=$lg(temstr,9),rranges=$lg(temstr,10) 
	..set S0064=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0064).%New()
	..set S0064.code="S0064"
	..set S0064.desc="细菌的药敏信息"
	..set S0064.text=temresDesc
	..set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E01.desc="抗生素代码"
	..set E01.content=ant
	..set S0064.E01=E01
	..set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E02.desc="抗生素名称"
	..set E02.content=antname
	..set S0064.E02=E02
	..set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E03.desc="最低抑菌浓度"
	..set E03.content=result
	..set S0064.E03=E03
	..set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E04.desc="药敏结果代码"
	..set E04.content=temresCode
	..set S0064.E04=E04
	..set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E05.desc="药敏结果描述"
	..set E05.content=temresDesc
	..set S0064.E05=E05
	..set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E06.desc="建议"
	..set E06.content=suggestion
	..set S0064.E06=E06
	..set E07=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E07.desc="药敏结果标志"
	..set E07.content=temresCode
	..set S0064.E07=E07
	..set E08=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E08.desc="I折点范围"
	..set E08.content=iranges
	..set S0064.E08=E08
	..set E09=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E09.desc="S折点范围"
	..set E09.content=sranges
	..set S0064.E09=E09
	..set E10=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E10.desc="R折点范围"
	..set E10.content=rranges
	..set S0064.E10=E10
	..set E11=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E11.desc="试验方法"
	..set E11.content=method
	..set S0064.E11=E11
	..d S0063.S0064.Insert(S0064)	
	Quit 1
Exception
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验医嘱项rowid返回检验外部代码
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetExCode("4716||1")
ClassMethod GetExCode(ArcimRowid As %String) As %String
{
	set arcsub=$p(ArcimRowid,"||",2)
	Quit:arcsub="" ""
	set ExCode=""
	set chl="" for  set chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.set tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.set fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.Quit:(fromd'="")&(fromd>+$h)
	.Quit:(tod'="")&(tod<+$h)
	.set ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
	Quit ExCode
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验号返回临床文档头对象
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).LISdocumentHeader(108).XMLExport()
ClassMethod LISdocumentHeader(labno As %String) As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader
{
	set documentHeader=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set documentHeader.title="检验报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.author).%New()
	set ordRowId=$O(^OEORD(0,"EpisNo",labno,""))
    set AdmNo = $P($g(^OEORD(ordRowId)),"^",1)
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set subId=$O(^OEORD(0,"EpisNo",labno,ordRowId,""))
	set ordstr1 = $g(^OEORD(ordRowId,"I",subId,1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.name).%New()
	set PatRowID=$P($g(^PAADM(AdmNo)),"^",1)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	set CredentialNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if ((CredentialTypeRowID'="")&&(CredentialNum'="")) {
		set certificatename.code=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set certificatename.content=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2) 
		set certificate.value=CredentialNum
	}
	else {
		set certificatename.code=""
		set certificatename.content=""
		set certificate.value=CredentialNum
	}
	set certificate.name=certificatename
	set patient.certificate=certificate
	set addr=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.addr).%New()
	set addr.text=$g(^PAPER(patRowId,"PER","ADD",1))
	set addr.desc="现住址"
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	set ProvinceDesc=""
	if ProvinceRowID'="" d
	.set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	.set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	if CityCodeRowID'="" d
	.set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	.set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	if CityAreaRowID'="" d
	.set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	set addr.houseNumber=""
	set addr.streetName=""
	set addr.township=""
	set addr.county=CityAreaDesc
	set addr.city=CityCodeDesc
	set addr.state=ProvinceDesc
	set WorkPostCodeDR=$o(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set:WorkPostCodeDR'="" addr.postalCode=$p($g(^DHCPERSON(WorkPostCodeDR)),"^",8)
	set patient.addr=addr
	set patient.name=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set patient.telecom=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set ethnicGroup=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.addr).%New()
	set participantAddr.desc="联系人地址"
	set participantAddr.text=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set participantAddr.houseNumber=""
	set participantAddr.streetName=""
	set participantAddr.township=""
	set participantAddr.county=""
	set participantAddr.city=""
	set participantAddr.state=""
	set participantAddr.postalCode=""
	set participant.addr=participantAddr
	set documentHeader.participant=participant
	Quit documentHeader
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据就诊号返回检验院区rowid
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetLabHospByAdm(108)
ClassMethod GetLabHospByAdm(AdmNo As %String) As %String
{
	set LocDr=$p($g(^PAADM(AdmNo)),"^",4)
	set HospDr=$p($g(^CTLOC(LocDr)),"^",29)
	q:HospDr="" ""
	set HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:HospCode="" ""
	set LisHospDr=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	q LisHospDr
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据院区代码、检验项目代码查询缩写
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetTestCodeAbbr("DHSZHYYZY","L0032")
ClassMethod GetTestCodeAbbr(HosCode As %String, TestCode As %String) As %String
{
	s Synonym=""
	q:HosCode="" ""
	set HosDr=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HosCode),""))
	q:HosDr="" ""
	set TestID=$o(^dbo.BTTestCodeI("IndexCode",HosDr,##Class(LIS.Util.Common).IndexData(TestCode),""))
	q:TestID="" ""
	set Synonym=$lg(^dbo.BTTestCodeD(TestID),7)
	q Synonym
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检查号保存文档，返回文档ID
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).SaveRISDocument("U20190920001")
ClassMethod SaveRISDocument(StudyNo As %String, DocumentNO As %String = "") As %String
{
	set $zt="Err"
	set RISReportID=$o(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(StudyNo,"U"),""))
	q:RISReportID="" ""
	set SysCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),7)
	if SysCode="PACS"
	{
		set DocType="02001"
	}
	elseif SysCode="US"
	{
		set DocType="02002"
	}
	elseif SysCode="ES"
	{
		set DocType="02003"
	}
	elseif SysCode="EKG"
	{
		set DocType="02004"
	}
	elseif SysCode="ECT"
	{
		set DocType="02005"
	}
	elseif SysCode="PIS"
	{
		set DocType="02006"
	}
	else
	{
		set DocType="02"	
	}
	set HOSDSerialNumber=DocType_"_"_DocumentNO_".xml"
	if DocumentNO="" set HOSDSerialNumber=DocType_"_"_StudyNo_".xml"
	set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,""))
	if (DocumentID="")&&(DocumentNO'="")
	{
		set HOSDSerialNumber=DocType_"_"_DocumentNO_".xml"
		set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,""))
		if DocumentID=""
		{
			set HOSDSerialNumber=DocType_"_"_DocumentNO_".pdf"
			set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,"")) 
		}
	}
	if DocumentID=""
	{
		set Document=##class(User.EnsHOSDocument).%New()
	}
	else{
		set Document=##class(User.EnsHOSDocument).%OpenId(DocumentID,0)
	}
	if DocType="02006" ///保存病理xml文档
	{
		set:DocumentNO="" Document.HOSDCContent=..GetPISReportDocument(StudyNo)
	}
	else ///保存检查文档
	{
		set:DocumentNO="" Document.HOSDCContent=..GetRISReportDocument(StudyNo)
	}
	set:Document.HOSDFormat="" Document.HOSDFormat="xml"
	set:Document.HOSDManufacturerID="" Document.HOSDManufacturerID="1"
	set Document.HOSDClassificationCode=DocType
	set AdmNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),6)
	q:AdmNo="" ""
	set AdmLocDr=$p($g(^PAADM(AdmNo)),"^",4)
	q:AdmLocDr="" ""
	set HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	q:HospDr="" ""
	set HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:HospCode="" ""
	set Document.HOSDOrganId=HospCode
	set PatientDr=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),5)
	do Document.HOSDPatientIDSetObjectId(PatientDr)
	set Document.HOSDSerialNumber=HOSDSerialNumber
	set Document.HOSDStatus="1"
	set:DocumentNO'="" Document.HOSDSubsysDocumentID=DocumentNO
	set:DocumentNO="" Document.HOSDSubsysDocumentID=StudyNo
	set Document.HOSDTemplateVersionNumber="V1.0"
	set Document.HOSDTypeCode="1"
	set:Document.HOSDUpdateDate="" Document.HOSDUpdateDate=+$h
	set:Document.HOSDUpdateTime="" Document.HOSDUpdateTime=$p($h,",",2)
	set:Document.HOSDUpdateUserCode="" Document.HOSDUpdateUserCode="-"
	set:Document.HOSDUrl="" Document.HOSDUrl=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),33)
	set:Document.HOSDCPicUrl="" Document.HOSDCPicUrl=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),32)
	do Document.HOSDVisitNumberSetObjectId(AdmNo)
	set sc=Document.%Save()
	if $system.Status.IsError(sc) d                 //检查Save是否成功
   	.d $system.OBJ.DisplayError(sc) 
   	.set id=-1
   	.tro
	else  d
	.set id=Document.%Id()	
	.do Document.%Close()
	q id
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据报告ID保存检验xml文档，返回文档ID
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).SaveLISDocument("85")
ClassMethod SaveLISDocument(ReportID As %String, DocumentNO As %String = "") As %String
{
	set $zt="Err"
	set LISReportID=""
	&sql(select %id into :LISReportID from sqlUser.Ens_LISReportResult where LISRR_ReportID=:ReportID)

	q:LISReportID="" ""
	set LISRRISMcroorganism=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportID)),103)
	if LISRRISMcroorganism="1"
	{
		set DocType="01002"
	}
	elseif LISRRISMcroorganism="2"
	{
		set DocType="01001"
	}
	else
	{
		set DocType="01"	
	}
	set HOSDSerialNumber=DocType_"_"_DocumentNO_".xml"
	if DocumentNO="" set HOSDSerialNumber=DocType_"_"_ReportID_".xml"
	set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,""))

	if DocumentID=""
	{
		set Document=##class(User.EnsHOSDocument).%New()	
	}
	else
	{
		set Document=##class(User.EnsHOSDocument).%OpenId(DocumentID,0)	
	}
	set:DocumentNO="" Document.HOSDCContent=..GetLISReportDocument(ReportID)
	set:Document.HOSDFormat="" Document.HOSDFormat="xml"
	set:Document.HOSDManufacturerID="" Document.HOSDManufacturerID="1"
	set AdmNo=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportID)),5)
	q:AdmNo="" ""
	set AdmLocDr=$p($g(^PAADM(AdmNo)),"^",4)
	q:AdmLocDr="" ""
	set HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	q:HospDr="" ""
	set HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:HospCode="" ""
	set Document.HOSDOrganId=HospCode
	set PatientDr=$lg($g(^Busi.ENS.EnsLISReportResultD(LISReportID)),3)
	do Document.HOSDPatientIDSetObjectId(PatientDr)
	set Document.HOSDSerialNumber=HOSDSerialNumber
	set Document.HOSDClassificationCode=DocType
	set Document.HOSDStatus="1"
	set:DocumentNO'="" Document.HOSDSubsysDocumentID=DocumentNO
	set:DocumentNO="" Document.HOSDSubsysDocumentID=ReportID
	set Document.HOSDTemplateVersionNumber="V1.0"
	set Document.HOSDTypeCode="1"
	set:Document.HOSDUpdateDate="" Document.HOSDUpdateDate=+$h
	set:Document.HOSDUpdateTime="" Document.HOSDUpdateTime=$p($h,",",2)
	set:Document.HOSDUpdateUserCode="" Document.HOSDUpdateUserCode="-"
	do Document.HOSDVisitNumberSetObjectId(AdmNo)
	set sc=Document.%Save()
	if $system.Status.IsError(sc) d                 //检查Save是否成功
   	.d $system.OBJ.DisplayError(sc) 
   	.set id=-1
   	.tro
	else  d
	.set id=Document.%Id()		
	.do Document.%Close()

	q id
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验号返回标本报告表医嘱串
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetOrdByLabNo("1000004242")
ClassMethod GetOrdByLabNo(labNo As %String) As %String
{
	s $zt="Err"
	s OrdID=""
	s RepSpecimenId=""  f  s RepSpecimenId=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_$zcvt(labNo,"U"),RepSpecimenId)) q:RepSpecimenId=""  d
	.s OrdRowID=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(RepSpecimenId)),4)
	.q:OrdRowID[","
	.if OrdID="" s OrdID=OrdRowID
	.else  s OrdID=OrdID_"^"_OrdRowID
	i $p(OrdID,"^",1)=$p(OrdID,"^",2) s OrdID=$p(OrdID,"^",1) //医嘱号剃重
	q OrdID
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检验项代码、名称、院区代码，保存第三方检验代码，前缀增加OT标识
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).AddTestCode("QXM","暂不用10","DHSZHYYZY")
ClassMethod AddTestCode(testCode As %String, testName As %String, hospitalCode As %String, ISMcroorganism As %String = "") As %String
{
	s $zt="Err"
	s obj=##Class(dbo.BTTestCode).%New()
	s obj.Code="OT"_testCode
	s obj.CName=testName
	s obj.Synonym=""
	s obj.Active=1
	s obj.ResultFormat="N" //由于数值型检验结果需要绘折线图，结果格式默认设为N
	s:ISMcroorganism="1" obj.ResultFormat="M" //微生物结果格式为M
	s HospitalDR=""
	s:hospitalCode'="" HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(hospitalCode),""))
	s obj.HospitalDR=HospitalDR
	s sc=obj.%Save()
	If '($SYSTEM.Status.IsOK(sc)) s err=testCode_"插入失败:"_$SYSTEM.Status.GetErrorText(sc) Quit
	s TestCodeDR=obj.RowID
	q TestCodeDR
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description： 解析xml生成json,并存储检验报告
/// w ##class(web.DHCENS.STBLL.Method.PostReportInfo).ParseLISReport().Read()
ClassMethod ParseLISReport(inputContent As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	s $zt="Err"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	d inputContent.Rewind()
	if $$$ISERR(tSC) {
		set RtnStreams=##class(%Stream.GlobalCharacter).%New()
		do RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]></ResultContent></Body></Response>")
		Quit RtnStreams 	
	}else{
		set (OrganizationCode,PATPatientID,PAADMVisitNumber,DocumentType,DocumentID)=""
		set (DocumentContent,UpdateUserCode,UpdateDate,UpdateTime,DocumentPath)=""
		set (hospSpecimenID,hospRisExamId,pdfrowId,BusinessFieldCode,HospitalCode,OEORIOrderItemID)=""
		
		set (ReportID,PatientID,VisitNumber,PatientName,Sex,DOB,ABO,RH,MobileNo,PhoneNo,Email,Address)=""
    	set (MachineDate,MachineTime,TestDate,TestTime,CancelDate,CancelTime,CancelUserCode,CancelReason)=""
    	set (ReprotXml,ReprotPdf,ReprotType,Remarks,ISMcroorganism,UpdateDate,UpdateTime,Identifition,HosCode,CheckDate,CheckTime)=""
    	set (CheckUserCode,CheckUserDesc,FirstCheckDate,FirstCheckTime,FirstCheckUserCode,FirstCheckUserDesc,CancelUserDesc,OrderItemDesc,WarnCode,ReportClass,Status,AuthType)=""
    	set (OrderItemID,TransmitDate,WorkGroupCode,WorkGroupDesc,Order,SpecimenID,SpecimenDesc,AccessionNo,AcceptDate,AcceptTime,AcceptUserCode,AcceptUserDesc)=""
		set (ReCheckDate,ReCheckTime,ReCheckUserCode,ReCheckUserDesc,AutoCheck,DigitSign,DigitSignString,DigitSignTime)=""
		set (Printed,Readed,FirstReadDate,FirstReadTime,FirstReadUserCode,FirstReadUserDesc,MainConclusion,MinorConclusion,SpecimenQualityDesc,ReAssayNumber)=""
		set (AddDate,AddTime,AddUserCode,AddUserDesc,ArriveDate,ArriveTime,ArriveUserCode,ArriveUserDesc,ReceiveDate,ReceiveTime,ReceiveUserCode,ReceiveUserDesc)=""
		set (CollectDate,CollectTime,CollectUserCode,CollectUserDesc,CarryDate,CarryTime,CarryUserCode,CarryUserDesc,LISRRSpecConc)=""
		set RtnStreams=##class(%Stream.GlobalCharacter).%New()
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OrganizationCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OrganizationCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentType","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentType=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentID=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentContent","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentContent=fieldValue
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateDate=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateTime=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentPath","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentPath=$tr(fieldValue,$c(0),"")
		}

		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospRisExamId=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospSpecimenID=$tr(fieldValue,$c(0),"")
		}

		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/BusinessFieldCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set BusinessFieldCode=$tr(fieldValue,$c(0),"")
		} 
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/HospitalCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set HospitalCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OEORIOrderItemID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
		}
		if BusinessFieldCode="" 
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>业务域代码不能为空</ResultContent></Body></Response>")
			q RtnStreams
		}
		if HospitalCode=""
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>院区代码不能为空</ResultContent></Body></Response>")
			q RtnStreams	
		}
		set patientId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,""))
		if patientId=""
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>登记号为"_PATPatientID_"的病人不存在</ResultContent></Body></Response>")
			q RtnStreams	
		}
		if '$d(^PAADM(PAADMVisitNumber))
		{
			do RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊信息不存在</ResultContent></Body></Response>")
			q RtnStreams
		}
		if DocumentPath'=""{		///01001	检验报告; 01002	微生物检验报告
			if ((DocumentType'="01001")&&(DocumentType'="01002")) 
			{
				d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>文档类型有误！</ResultContent></Body></Response>")
				q RtnStreams			
			}
		}
		if OEORIOrderItemID="" 
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医嘱号不能为空</ResultContent></Body></Response>")
			q RtnStreams
		}
		/// 保存xml文件
		if DocumentContent'=""{
			//处理xml超长问题
			Set DocString=""
			If $isobject(DocumentContent) = 1 {
		         Set len = DocumentContent.Size
		         Do DocumentContent.Rewind()
		         Set DocString = DocumentContent.Read(.len, .st)
			} else {
		         Set DocString = DocumentContent
			}
			Set DocString=$tr(DocString,$c(0),"")
			set DocumentContent=$SYSTEM.Encryption.Base64Decode(DocString)

			set DocumentContent=$zcvt(DocumentContent,"I","UTF8")
			set:$e(DocumentContent,1,38)="<?xml version=""1.0"" encoding=""UTF-8""?>" DocumentContent=$e(DocumentContent,39,$l(DocumentContent))
			set stream=##class(%Stream.GlobalCharacter).%New()
			d stream.Write(DocumentContent)

			s docContentStream = ##Class(%Stream.GlobalCharacter).%New()
			d docContentStream.CopyFrom(stream)
			s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.tDocument)
			d docContentStream.Rewind()
			s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/E0004","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PatientName = result.GetAt(1).Value

			s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/E0006","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Sex = result.GetAt(1).Value
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/documentHeader/patient/telecom","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) MobileNo = result.GetAt(1).Value
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/documentHeader/title","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Title = result.GetAt(1).Value
			set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0061'])",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set hsCount=tRes.GetAt(1).Value
				if hsCount="0"
				{
					d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>信息为空</ResultContent></Body></Response>")
					q RtnStreams	
				}
				for i=1:1:hsCount {
					///医嘱号	
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E25","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) OrderItemID = result.GetAt(1).Value
					if OrderItemID="" s OrderItemID=OEORIOrderItemID
					///标本号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E07","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) labEpisodeNo = result.GetAt(1).Value
					
					///标本类型代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E05","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SpecimenID = result.GetAt(1).Value
					///标本类型
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E06","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SpecimenDesc = result.GetAt(1).Value
					
					///报告ID
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E24","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportID = result.GetAt(1).Value
					
					///报告url
					
					///检验者工号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E13","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AcceptUserCode = result.GetAt(1).Value
					
					///检验者姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E14","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AcceptUserDesc = result.GetAt(1).Value
					
					///审核者，工号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E19","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckUserCode = result.GetAt(1).Value
					
					///审核者		
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E20","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckUserDesc = result.GetAt(1).Value
					
					///审核日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E17","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDate = result.GetAt(1).Value
					
					///审核时间		
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E18","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckTime = result.GetAt(1).Value
					
					///报告备注
					s ReportNote=""
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E21","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportNote = result.GetAt(1).Value
					
					///医嘱代码
					s oEordItemCode=""
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E01","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) oEordItemCode = result.GetAt(1).Value
					
					///医嘱名称对应到检验项目名称
					s oEordItemDesc=""
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E02","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) oEordItemDesc = result.GetAt(1).Value
					
					///检验日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E11","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) TestDate = result.GetAt(1).Value
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AcceptDate = result.GetAt(1).Value
					
					///检验时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E12","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) TestTime = result.GetAt(1).Value
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AcceptTime = result.GetAt(1).Value
					
					///备注
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E21","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Remarks = result.GetAt(1).Value
					
					///送检日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E03","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReceiveDate = result.GetAt(1).Value
					
					///送检时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E04","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReceiveTime = result.GetAt(1).Value
					
					///送检医生代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E09","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReceiveUserCode = result.GetAt(1).Value
					
					///送检医生姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E10","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReceiveUserDesc = result.GetAt(1).Value
					
					///鉴定结果
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E23","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Identifition = result.GetAt(1).Value
					
					///标本评价
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/E28","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) LISRRSpecConc = result.GetAt(1).Value
					
					s array=[]
				    s tmpMainObj=##class(%DynamicObject).%New()

					s tmpMainObj."LISRR_ReportID"=ReportID
					s tmpMainObj."LISRR_PatientID"=PATPatientID
					s tmpMainObj."LISRR_VisitNumber"=labEpisodeNo
					s tmpMainObj."LISRR_PatientName"=PatientName
					s tmpMainObj."LISRR_Sex"=Sex
					s DOB=$p($g(^PAPER(patientId,"ALL")),"^",6)

					s DOB=..TransDateFormat(DOB)
					s tmpMainObj."LISRR_DOB"=DOB
					s tmpMainObj."LISRR_ABO"=ABO
					s tmpMainObj."LISRR_RH"=RH
					s tmpMainObj."LISRR_MobileNo"=MobileNo
					s tmpMainObj."LISRR_PhoneNo"=MobileNo
					s tmpMainObj."LISRR_Email"=Email
					s tmpMainObj."LISRR_Address"=Address
					s tmpMainObj."LISRR_MachineDate"=MachineDate
					s tmpMainObj."LISRR_MachineTime"=MachineTime
					s tmpMainObj."LISRR_TestDate"=TestDate
					s tmpMainObj."LISRR_TestTime"=TestTime

					s tmpMainObj."LISRR_CancelDate"=CancelDate
					s tmpMainObj."LISRR_CancelTime"=CancelTime
					s tmpMainObj."LISRR_CancelUserCode"=CancelUserCode
					s tmpMainObj."LISRR_CancelReason"=CancelReason
					s tmpMainObj."LISRR_ReprotXml"=ReprotXml
					s tmpMainObj."LISRR_ReprotPdf"=ReprotPdf
					s tmpMainObj."LISRR_ReprotType"=ReprotType
					s tmpMainObj."LISRR_Remarks"=Remarks
					s:Title["检验" tmpMainObj."LISRR_ISMcroorganism"="2" ;普通报告
					s:Title["微生物" tmpMainObj."LISRR_ISMcroorganism"="1"

					s tmpMainObj."LISRR_UpdateDate"=UpdateDate
					s tmpMainObj."LISRR_UpdateTime"=UpdateTime
					s tmpMainObj."LISRR_Identifition"=Identifition
					s tmpMainObj."LISRR_HosCode"=HospitalCode
					s tmpMainObj."LISRR_CheckDate"=CheckDate
					s tmpMainObj."LISRR_CheckTime"=CheckTime
					s tmpMainObj."LISRR_CheckUserCode"=CheckUserCode
					s tmpMainObj."LISRR_CheckUserDesc"=CheckUserDesc
					s tmpMainObj."LISRR_FirstCheckDate"=FirstCheckDate
					s tmpMainObj."LISRR_FirstCheckTime"=FirstCheckTime
					s tmpMainObj."LISRR_FirstCheckUserCode"=FirstCheckUserCode
					s tmpMainObj."LISRR_FirstCheckUserDesc"=FirstCheckUserDesc
					s tmpMainObj."LISRR_CancelUserDesc"=CancelUserDesc
					s tmpMainObj."LISRR_OrderItemDesc"=OrderItemDesc 
					s:OrderItemDesc="" tmpMainObj."LISRR_OrderItemDesc"=oEordItemDesc
					s tmpMainObj."LISRR_WarnCode"=WarnCode
					s tmpMainObj."LISRR_ReportClass"=ReportClass
					s tmpMainObj."LISRR_Status"=Status ///报告状态（1审核，2取消审核，3作废）
					s:tmpMainObj."LISRR_Status"="" tmpMainObj."LISRR_Status"="1"
					s tmpMainObj."LISRR_AuthType"=AuthType
					s tmpMainObj."LISSR_OrderItemID"=OrderItemID
					s tmpMainObj."LISRR_TransmitDate"=TransmitDate
					s tmpMainObj."LISRR_WorkGroupCode"=WorkGroupCode
					s tmpMainObj."LISRR_WorkGroupDesc"=WorkGroupDesc
					s tmpMainObj."LISRR_Order"=Order
					s:tmpMainObj."LISRR_Order"="" tmpMainObj."LISRR_Order"=i
					s tmpMainObj."LISRR_SpecimenID"=SpecimenID
					s tmpMainObj."LISRR_SpecimenDesc"=SpecimenDesc   ///标本名称
					s tmpMainObj."LISRR_AccessionNo"=AccessionNo
					s tmpMainObj."LISRR_ReceiveDate"=ReceiveDate
					s tmpMainObj."LISRR_ReceiveTime"=ReceiveTime
					s tmpMainObj."LISRR_ReceiveUserCode"=ReceiveUserCode
					s tmpMainObj."LISRR_ReceiveUserDesc"=ReceiveUserDesc
					s tmpMainObj."LISRR_AcceptDate"=AcceptDate
					s tmpMainObj."LISRR_AcceptTime"=AcceptTime
					s tmpMainObj."LISRR_AcceptUserCode"=AcceptUserCode
					s tmpMainObj."LISRR_AcceptUserDesc"=AcceptUserDesc
					s tmpMainObj."LISRR_ReCheckDate"=ReCheckDate
					s tmpMainObj."LISRR_ReCheckTime"=ReCheckTime
					s tmpMainObj."LISRR_ReCheckUserCode"=ReCheckUserCode
					s tmpMainObj."LISRR_ReCheckUserDesc"=ReCheckUserDesc
					s tmpMainObj."LISRR_AutoCheck"=AutoCheck
					s tmpMainObj."LISRR_DigitSign"=DigitSign
					s tmpMainObj."LISRR_DigitSignString"=DigitSignString
					s tmpMainObj."LISRR_DigitSignTime"=DigitSignTime
					s tmpMainObj."LISRR_Printed"=Printed
					s tmpMainObj."LISRR_Readed"=Readed
					s tmpMainObj."LISRR_FirstReadDate"=FirstReadDate
					s tmpMainObj."LISRR_FirstReadTime"=FirstReadTime
					s tmpMainObj."LISRR_FirstReadUserCode"=FirstReadUserCode
					s tmpMainObj."LISRR_FirstReadUserDesc"=FirstReadUserDesc
					s tmpMainObj."LISRR_MainConclusion"=MainConclusion
					s tmpMainObj."LISRR_MinorConclusion"=MinorConclusion
					s tmpMainObj."LISRR_SpecimenQuality"=SpecimenQualityDesc
					s tmpMainObj."LISRR_ReAssayNumber"=ReAssayNumber
					s tmpMainObj."LISRR_AddDate"=AddDate
					s tmpMainObj."LISRR_AddTime"=AddTime
					s tmpMainObj."LISRR_AddUserCode"=AddUserCode
					s tmpMainObj."LISRR_AddUserDesc"=AddUserDesc
	
					s tmpMainObj."LISRR_ArriveDate"=ArriveDate
					s tmpMainObj."LISRR_ArriveTime"=ArriveTime
					s tmpMainObj."LISRR_ArriveUserCode"=ArriveUserCode
					s tmpMainObj."LISRR_ArriveUserDesc"=ArriveUserDesc

					s tmpMainObj."LISRR_CollectDate"=CollectDate
					s tmpMainObj."LISRR_CollectTime"=CollectTime
					s tmpMainObj."LISRR_CollectUserCode"=CollectUserCode
					s tmpMainObj."LISRR_CollectUserDesc"=CollectUserDesc

					s tmpMainObj."LISRR_CarryDate"=CarryDate
					s tmpMainObj."LISRR_CarryTime"=CarryTime
					s tmpMainObj."LISRR_CarryUserCode"=CarryUserCode
					s tmpMainObj."LISRR_CarryUserDesc"=CarryUserDesc
					s tmpMainObj."LISRR_SpecConc"=LISRRSpecConc
					set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]","count(section[@code='S0062'])",.tRes)
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
							set hsCount=tRes.GetAt(1).Value
							Continue:hsCount="0"
							s subResArray=[]
							set oldItemId=""
							for j=1:1:hsCount {	
								set subResObj=##class(%DynamicObject).%New()
								//显示顺序
								set subResObj."LISIR_ShowSeq"=j	
								//检验号
								//检验项目代码
								set (LISIRItemCode,ItemRowID)=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E01","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRItemCode=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_ItemCode"=LISIRItemCode
								}
								//检验项目名称
								set LISIRItemDesc=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E02","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRItemDesc=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_ItemDesc"=LISIRItemDesc
								}
								//检验项目定量结果
								set LISIRResult=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E03","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRResult=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_Result"=LISIRResult
								}
								//检验项目定量结果单位
								set LISIRUint=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E04","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRUint=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_Uint"=LISIRUint
								}
								//检验项目定性结果
								set LISIRTextResult=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E05","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRTextResult=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_TextResult"=LISIRTextResult
								}
								 //检验项目参考范围
								set LISIRRanges=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E06","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRRanges=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_Ranges"=LISIRRanges
								}
								//检验项目异常标志
								set LISIRAbnormalFlags=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E07","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRAbnormalFlags=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_AbnormalFlags"=LISIRAbnormalFlags
								}
								//检验设备编码
								set LISIRDeviceCode=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E08","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRDeviceCode=$tr(fieldValue,$c(0),"")
									set:LISIRDeviceCode'="" subResObj."LISIR_TestMachine"=LISIRDeviceCode
								}
								//检验设备名称
								set LISIRDeviceDesc=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E09","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRDeviceDesc=$tr(fieldValue,$c(0),"")
									set:LISIRDeviceDesc'="" subResObj."LISIR_TestMachine"=LISIRDeviceDesc
									
								}
								//检验结果说明
								set LISIRResultExplain=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E10","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRResultExplain=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_ResultExplain"=LISIRResultExplain
								}
								//显示序号
								set LISIRShowSeq=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E11","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIRShowSeq=$tr(fieldValue,$c(0),"")
									set:LISIRShowSeq'="" subResObj."LISIR_ShowSeq"=LISIRShowSeq
								}
								//检验子项缩写
								set LISIREngName=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E12","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIREngName=$tr(fieldValue,$c(0),"")
									
								}
								//检验子项对应医嘱号
								set LISIROrderItemID=""
								set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0062']["_j_"]/E13","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set LISIROrderItemID=$tr(fieldValue,$c(0),"")
									set subResObj."LISIR_OrderItemID"=LISIROrderItemID
									
								}
								d subResArray.%Push(subResObj)

							}
							s tmpMainObj."LISRR_ItemResult"=subResArray
							do array.%Push(tmpMainObj)
							s ReturnJson=array.%ToJSON()	
						}
						
						s RtnStreams=##class(%Stream.GlobalCharacter).%New()
						s stream=##class(%Stream.GlobalCharacter).%New()
						d stream.Write(ReturnJson)
						s RtnStreams=..LISReportInfo(stream,DocumentID)
						
    				}
				
						//是否微生物
						set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]","count(section[@code='S0063'])",.tRes)
						if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){		
							set MicroHsCount=tRes.GetAt(1).Value
							s subResArray=[]
							for k=1:1:MicroHsCount
								{
									set subResObj=##class(%DynamicObject).%New()
									set subResObj."LISIR_ShowSeq"=k
									s tmpMainObj."LISRR_ISMcroorganism"="1"
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E01","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISMicroTestCode=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_ItemCode"=LISMicroTestCode
									}
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E02","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISMicroTestName=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_ItemDesc"=LISMicroTestName
									}
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E02","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISMicroTestName=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_Result"=LISMicroTestName
									}
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E02","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISMicroTestName=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_TextResult"=LISMicroTestName
									}
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E03","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISIRCount=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_Count"=LISIRCount
									}
									
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E04","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISIRExpertRule=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_ExpertRule"=LISIRExpertRule
									}
									
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E05","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISIRRemark=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_Remark"=LISIRRemark
									}
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E06","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISIRMultipleResistant=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_MultipleResistant"=LISIRMultipleResistant
									}
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/E07","text()",.tRes)					
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
										set fieldValue=tRes.GetAt(1).Value
										set LISIRMultipleResChild=$tr(fieldValue,$c(0),"")
										set subResObj."LISIR_MultipleResChild"=LISIRMultipleResChild
									}
									s subResSenArray=[]
									set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]","count(section[@code='S0064'])",.tRes)
									if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
										set msCount=tRes.GetAt(1).Value
										for m=1:1:msCount {
											set subResSenObj = ##class(%DynamicObject).%New()
										
											//抗生素代码
											set LISISRAntibioticsCode=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E01","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRAntibioticsCode=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_AntibioticsCode"=LISISRAntibioticsCode
											}
											//抗生素名称
											set LISISRAntibioticsDesc=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E02","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRAntibioticsDesc=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_AntibioticsDesc"=LISISRAntibioticsDesc
											}
											//最低抑菌浓度
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E03","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRSen=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_Result"=LISISRSen
											}
										
											//药敏结果代码
											set LISISRSensitivityCode=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E04","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRSensitivityCode=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_SensitivityCode"=LISISRSensitivityCode
											}
										
											//药敏结果描述
											set LISISRSensitivityDesc=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E05","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRSensitivityDesc=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_SensitivityDesc"=LISISRSensitivityDesc
											}
										
											//建议
											set LISISRSuggestion=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E06","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRSuggestion=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_Suggestion"=LISISRSuggestion
											}
											//I折点范围
											set LISISRIRanges=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E08","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRIRanges=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_IRanges"=LISISRIRanges
											}
											//S折点范围
											set LISISRSRanges=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E09","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRSRanges=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_SRanges"=LISISRSRanges
											}
										
											//R折点范围
											set LISISRRRanges=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E10","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRRRanges=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_RRanges"=LISISRRRanges
											}
										
											//试验方法
											set LISISRMethod=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E11","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRMethod=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_Method"=LISISRMethod
											}
										
											//药敏结果标志
											set LISISRFlag=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E07","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRFlag=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_Flag"=LISISRFlag
											}
											
											//药敏结果单位
											set LISISRUnit=""
											set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_i_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_m_"]/E12","text()",.tRes)					
											if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
												set fieldValue=tRes.GetAt(1).Value
												set LISISRUnit=$tr(fieldValue,$c(0),"")
												set subResSenObj."LISISR_Unit"=LISISRUnit
											}
											d subResSenArray.%Push(subResSenObj) 
											
										}
										s subResObj."LISISR_ItemSenResult"=subResSenArray
										d subResArray.%Push(subResObj)
									}
									s tmpMainObj."LISRR_ItemResult"=subResArray
									do array.%Push(tmpMainObj)
								 	s ReturnJson=array.%ToJSON()
								}
								if MicroHsCount>0
								{
									s RtnStreams=##class(%Stream.GlobalCharacter).%New()
									s stream=##class(%Stream.GlobalCharacter).%New()
									d stream.Write(ReturnJson)
									s RtnStreams=..LISReportInfo(stream,DocumentID)
								}
							}
				}
			}
			/*
		s RtnStreams=##class(%Stream.GlobalCharacter).%New()

		s stream=##class(%Stream.GlobalCharacter).%New()
		d stream.Write(ReturnJson)
		s RtnStreams=..LISReportInfo(stream,DocumentID)
		*/
		d RtnStreams.Rewind()
		s RtnString=RtnStreams.Read()
		s RtnJSONArr={}.%FromJSON(RtnString)
		s RtnJSON=RtnJSONArr.%Get(0)
		s ResultCode=RtnJSON.%Get("ResultCode")
		s ResultContent=RtnJSON.%Get("ResultContent")
		s ResultStream=##class(%Stream.GlobalCharacter).%New()
		d ResultStream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>"_ResultCode_"</ResultCode><ResultContent><![CDATA["_ResultContent_"]]></ResultContent></Body></Response>")
		q ResultStream
	}
Err
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败,<![CDATA["_$ze_"]]></ResultContent></Body></Response>")
	q stream
}

/// Creator：ZhangXinying
/// CreatDate：2019-10-20
/// Description：获取HIS系统病理报告xml文档信息
/// Table：Ens_RisReportResult
/// Input： 病理号
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetPISReportDocument("C1800150").Read()
ClassMethod GetPISReportDocument(StudyNo As %String) As %Stream.GlobalCharacter
{
	set $zt="Exception"
	set stream=##class(%Stream.GlobalCharacter).%New()
	set clinicalDocument=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.clinicalDocument).%New()
	set documentHeader=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader=..PISdocumentHeader(StudyNo)
	set clinicalDocument.documentHeader=documentHeader
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(StudyNo,"U"),RARRowid))
	q:RARRowid="" stream
	set AdmNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set structuredBody=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.structuredBody).%New()
	set E0004desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0004desc.desc="姓名"
	set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set structuredBody.E0004=E0004desc
	if SexId'="" {
		set E0005desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
		set E0005desc.desc="性别代码"
		set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
		set structuredBody.E0005=E0005desc	
		set E0006desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
		set E0006desc.desc="性别描述"
		set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
		set structuredBody.E0006=E0006desc	
	}
	set E0008desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set:BirthYear'="" E0008desc.content=##class(web.DHCBillInterface).GetPapmiAge(patRowId,AdmNo) ;$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set E0008desc.desc="年龄"
	set structuredBody.E0008=E0008desc	
	
	set E0001desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0001desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set E0001desc.desc="病案号"
	set structuredBody.E0001=E0001desc	
	
	set E0002desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set E0002desc.desc="住院号"
	set structuredBody.E0002=E0002desc	

	set E0040desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0040desc.content=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set E0040desc.desc="联系电话"
	set structuredBody.E0002=E0040desc	
	
	set E0154desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedRowID=$P($g(^PAADM(AdmNo)),"^",73)
	set E0154desc.content=CurrentBedRowID
	set E0154desc.desc="病床id"
	set structuredBody.E0154=E0154desc	

	set E0075desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedNo=""
	if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	.set BedWordRowID = $p(CurrentBedRowID,"||",1)
	.set BedChildSub = $p(CurrentBedRowID,"||",2)
	.if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	..set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	set E0075desc.desc="病床"
	set E0075desc.content=CurrentBedNo
	set structuredBody.E0075=E0075desc
	set E0156desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	set:CurrentDetpRowID'="" E0156desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	set E0156desc.desc="科室id"
	set structuredBody.E0156=E0156desc
	set E0077desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	set E0077desc.desc="科室"
	set structuredBody.E0077=E0077desc
	
	set E0000desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0000desc.desc="门诊号"
	set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	set structuredBody.E0000=E0000desc
	set OeordID=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),4)
	set S0141section=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.S0141).%New()
	set S0141section.code="S0141"
	set S0141section.desc="病理检查记录" 
	set E01desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E01desc.desc="申请号"
	set E01desc.content=OeordID
	set S0141section.E01=E01desc

	set E02desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E02desc.desc="病理号"
	set E02desc.content=StudyNo
	set S0141section.E02=E02desc
	set E03desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E03desc.desc="实验室编号"
	set E03desc.content=""
	set S0141section.E03=E03desc

	set AdmLocDr=$p($g(^PAADM(AdmNo)),"^",4),HospDr=""
	set:AdmLocDr'="" HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	
	set E04desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E04desc.desc="送检医院编码"
	set:HospDr'="" E04desc.content=$p($g(^CT("HOSP",HospDr)),"^",1)
	set S0141section.E04=E04desc
	
	set E05desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E05desc.desc="送检医院名称"
	set:HospDr'="" E05desc.content=$p($g(^CT("HOSP",HospDr)),"^",2)
	set S0141section.E05=E05desc

	set E06desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E06desc.desc="检查医院编码"
	set:HospDr'="" E06desc.content=$p($g(^CT("HOSP",HospDr)),"^",1)
	set S0141section.E06=E06desc
	
	set E07desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E07desc.desc="检查医院名称"
	set:HospDr'="" E07desc.content=$p($g(^CT("HOSP",HospDr)),"^",2)
	set S0141section.E07=E07desc

	set E08desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E08desc.desc="送检科室编码"
	set:AdmLocDr'="" E08desc.content=$p($g(^CTLOC(AdmLocDr)),"^",1)
	set S0141section.E08=E08desc
	
	set E09desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E09desc.desc="送检科室名称"
	set:AdmLocDr'="" E09desc.content=$p($g(^CTLOC(AdmLocDr)),"^",2)
	set S0141section.E09=E09desc
	set OperateDate="",OperateID="",OperateName="",ExamPartID="",ExamPart="",CheckDate="",CheckDocCode="",CheckDocDesc=""
	set EsStatusDr=""  f  set EsStatusDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID",OeordID,EsStatusDr)) q:EsStatusDr=""  d
	.set StatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),11)
	.set PreStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),12)
	.if (StatusCode="SC")&&(PreStatusCode="AP") d
	..s OperateDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
	..s OperateID=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),5)
	..s OperateName=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),6)
	..s ExamPartID=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),13)
	..s ExamPart=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),4)
	.if (StatusCode="DIAG")&&(PreStatusCode="SC") d
	..s CheckDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
	..s CheckDocCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),5)
	..s CheckDocDesc=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),6)
	set E10desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E10desc.desc="取样日期"
	set:OperateDate'="" E10desc.content=$zd(OperateDate,3)
	set S0141section.E10=E10desc

	set E11desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E11desc.desc="取样医生编码"
	set E11desc.content=OperateID
	set S0141section.E11=E11desc

	set E12desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E12desc.desc="取样医生名称"
	set E12desc.content=OperateName
	set S0141section.E12=E12desc

	
	set E13desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set RISRPositionCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),21)
	set E13desc.desc="取材部位代码"
	set E13desc.content=ExamPartID
	set:ExamPartID="" E13desc.content=RISRPositionCode
	set S0141section.E13=E13desc
	set RISRPositionDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),22)
	set E14desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E14desc.desc="取材部位名称"
	set E14desc.content=ExamPart
	set:ExamPart="" E14desc.content=RISRPositionDesc
	set S0141section.E14=E14desc
	
	set E15desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E15desc.desc="送检日期"
	set E15desc.content=CheckDate
	set S0141section.E15=E15desc
	set E16desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E16desc.desc="送检医生编码"
	set E16desc.content=CheckDocCode
	set S0141section.E16=E16desc
	set E17desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E17desc.desc="送检医生名称"
	set E17desc.content=CheckDocDesc
	set S0141section.E17=E17desc

	set E19desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E19desc.desc="临床表现"
	set E19desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),24)
	set S0141section.E19=E19desc
	set E20desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E20desc.desc="临床诊断"
	set E20desc.content=$p($p(..GetDiagnoses(AdmNo),"!",1),"^",5)
	set S0141section.E20=E20desc

	set E21desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E21desc.desc="病理大体所见"
	set E21desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),24)
	set S0141section.E21=E21desc
	set E22desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E22desc.desc="病理诊断"
	set E22desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),25)
	set S0141section.E22=E22desc
	set E23desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E23desc.desc="补充意见"
	set E23desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),27)
	set S0141section.E23=E23desc
	set E24desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E24desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),12)
	set E24desc.desc="核对医师编码"
	set S0141section.E24=E24desc
	
	set E25desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E25desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),13)
	set E25desc.desc="核对医师姓名"
	set S0141section.E25=E25desc

	set E26desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E26desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),8)
	set E26desc.desc="报告医师编码"
	set S0141section.E26=E24desc
	
	set E27desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E27desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),9)
	set E27desc.desc="报告医师姓名"
	set S0141section.E27=E27desc
	set E28desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E28desc.desc="备注"
	set E28desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),27)
	set S0141section.E28=E28desc
	set E29desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E29desc.desc="是否危急"
	set E29desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),34)
	set S0141section.E29=E29desc
	set E30desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E30desc.desc="是否阳性"
	set E30desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),35)
	set S0141section.E30=E30desc
	set E31desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E31desc.desc="异常标记"
	set E31desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),36)
	set S0141section.E31=E31desc
	set E32desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E32desc.desc="冰冻号"
	set E32desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),45)
	set S0141section.E32=E32desc
	set E33desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E33desc.desc="送检材料"
	set E33desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),46)
	set S0141section.E33=E33desc
	set E34desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E34desc.desc="免疫组化"
	set E34desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),47)
	set S0141section.E28=E28desc
	set structuredBody.S0141=S0141section
	set clinicalDocument.structuredBody=structuredBody
	set streamAll=##class(%Stream.GlobalCharacter).%New()
	do streamAll.Write("<?xml version=""1.0"" encoding=""UTF-8""?>") 
	do clinicalDocument.XMLExportToStream(.stream)
	do streamAll.CopyFrom(stream) 
	Quit streamAll
Exception
	set clinicalDocument=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.clinicalDocument).%New()
	d clinicalDocument.XMLExportToStream(.stream)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2019—11-08
/// Description： 解析检查报告xml生成json，并保存检查报告
/// w ##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePACSReport().Read()
ClassMethod ParsePACSReport(inputContent As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	s $zt="Err"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	d inputContent.Rewind()
	s ExamMethod=""
	if $$$ISERR(tSC) {
		set RtnStreams=##class(%Stream.GlobalCharacter).%New()
		do RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]]]><![CDATA[></ResultContent></Body></Response>")
		Quit RtnStreams 
	}else{
		set (OrganizationCode,PATPatientID,PAADMVisitNumber,DocumentType,DocumentID)=""
		set (DocumentContent,UpdateUserCode,UpdateDate,UpdateTime,DocumentPath)=""
		set (hospSpecimenID,hospRisExamId,pdfrowId,BusinessFieldCode,HospitalCode,OEORIOrderItemID,ArcimId,ArcimCode,ArcimDesc)=""

		set RtnStreams=##class(%Stream.GlobalCharacter).%New()
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OrganizationCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OrganizationCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentType","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentType=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentID=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentContent","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentContent=fieldValue
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateDate=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateTime=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentPath","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentPath=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospRisExamId=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospSpecimenID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/BusinessFieldCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set BusinessFieldCode=$tr(fieldValue,$c(0),"")
		} 
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/HospitalCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set HospitalCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OEORIOrderItemID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
		}
		set patientId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,""))
		if patientId=""
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>登记号为"_PATPatientID_"的病人不存在</ResultContent></Body></Response>")
			q RtnStreams	
		}
		if '$d(^PAADM(PAADMVisitNumber))
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊信息不存在</ResultContent></Body></Response>")
			q RtnStreams
		}
		if DocumentPath'=""{		
			if ((DocumentType="01001")||(DocumentType="01002"))
			{
				d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>文档类型有误！</ResultContent></Body></Response>")
				q RtnStreams	
			}
		}

		/// 保存xml文件
		if DocumentContent'=""{
			//处理xml超长问题
			Set DocString=""
			If $isobject(DocumentContent) = 1 {
		         Set len = DocumentContent.Size
		         Do DocumentContent.Rewind()
		         Set DocString = DocumentContent.Read(.len, .st)
			} else {
		         Set DocString = DocumentContent
			}
			Set DocString=$tr(DocString,$c(0),"")
			
			set DocumentContent=$SYSTEM.Encryption.Base64Decode(DocString)
			set DocumentContent=$zcvt(DocumentContent,"I","UTF8")
			set:$e(DocumentContent,1,38)="<?xml version=""1.0"" encoding=""UTF-8""?>" DocumentContent=$e(DocumentContent,39,$l(DocumentContent))
			set stream=##class(%Stream.GlobalCharacter).%New()
			d stream.Write(DocumentContent)
			s docContentStream = ##Class(%Stream.GlobalCharacter).%New()
			d docContentStream.CopyFrom(stream)
			s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.tDocument)
			d docContentStream.Rewind()
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/E0004","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PatientName = result.GetAt(1).Value
			s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/E0005","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Sex = result.GetAt(1).Value
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/documentHeader/patient/telecom","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) MobileNo = result.GetAt(1).Value
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/documentHeader/title","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Title = result.GetAt(1).Value
			set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0076'])",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set hsCount=tRes.GetAt(1).Value
				if hsCount="0"
				{
					d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>信息为空</ResultContent></Body></Response>")
					q RtnStreams	
				}
				s (StudyNo,PacsDeviceCode,PacsDeviceDesc,BodyPartCode,BodyPartDesc,ExamPartDocWrite,ExamPart,ExamSee,ExamResult,StudyDocCode,StudyDocName,CheckDocCode,CheckDocDesc)=""
				s (RecordDocCode,RecordDocName,StudyDate,StudyTime,ReportID,CheckDate,CheckTime,PacsItemDesc,ExamMethod,ReportDate,ReportTime,OrderItemID)=""
				s (IsUrgent,IsPositive,AbnormalFlags,RISRAnesDocCode,RISRAnesDocName,RISRAnesMethodCode,RISRAnesMethodDesc,RISRAnesMethodDesc,RISRAnesLevelCode,RISRAnesLevelDesc,RISRAnesStartDateTime,RISRAnesEndDateTime)=""
				for i=1:1:hsCount {
					///检查号	
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E01","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) StudyNo = result.GetAt(1).Value
					
					///检查设备编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E02","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PacsDeviceCode = result.GetAt(1).Value
					
					///检查设备名称
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E03","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PacsDeviceDesc = result.GetAt(1).Value
					
					///检查部位代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E04","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) BodyPartCode = result.GetAt(1).Value
					
					///检查部位名称
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E05","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) BodyPartDesc = result.GetAt(1).Value
					
					///检查部位医生手写
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E06","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ExamPartDocWrite = result.GetAt(1).Value
					
					///检查部位
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E07","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ExamPart = result.GetAt(1).Value
					
					///检查所见
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E08","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ExamSee = result.GetAt(1).Value
					
					///检查结果
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E09","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ExamResult = result.GetAt(1).Value
					
					///检查医师代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E10","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) StudyDocCode = result.GetAt(1).Value
					
					///检查医师姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E11","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) StudyDocName = result.GetAt(1).Value
					
					///审核医师代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E12","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDocCode = result.GetAt(1).Value
					
					///审核医师姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E13","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDocDesc = result.GetAt(1).Value
					
					///记录者代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E14","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RecordDocCode = result.GetAt(1).Value
					
					///记录者姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E15","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RecordDocName = result.GetAt(1).Value
					
					///检查日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E16","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) StudyDate = result.GetAt(1).Value
					
					///检查时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E17","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) StudyTime = result.GetAt(1).Value
					
					///报告号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E18","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportID = result.GetAt(1).Value
					
					///审核日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E19","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDate = result.GetAt(1).Value
					
					///审核时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E20","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckTime = result.GetAt(1).Value
					
					///检查项目描述
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E21","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PacsItemDesc = result.GetAt(1).Value
					
					///检查方法描述
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E22","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ExamMethod = result.GetAt(1).Value
					
					///报告日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E23","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportDate = result.GetAt(1).Value
					
					///报告时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E24","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportTime = result.GetAt(1).Value
					
					///医嘱号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E25","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) OrderItemID = result.GetAt(1).Value
					i OrderItemID["^" s OrderItemID=$p(OrderItemID,"^",1)
					s ArcimId=$p($g(^OEORD($p(OrderItemID,"||",1),"I",$p(OrderItemID,"||",2),1)),"^",2)
					q:ArcimId=""
					s ArcimCode=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",1)
					s ArcimDesc=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",2)	
								
					///是否危急
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E26","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) IsUrgent = result.GetAt(1).Value	
									
					///是否阳性
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E27","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) IsPositive = result.GetAt(1).Value
					
					///异常标记
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E28","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AbnormalFlags = result.GetAt(1).Value	
									
					///麻醉医师工号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E29","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesDocCode = result.GetAt(1).Value
					
					///麻醉医师姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E30","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesDocName = result.GetAt(1).Value
					
					///麻醉方式代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E31","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesMethodCode = result.GetAt(1).Value
					
					///麻醉方式描述
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E32","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesMethodDesc = result.GetAt(1).Value
				
					///麻醉分级代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E33","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesLevelCode = result.GetAt(1).Value
				
					///麻醉分级描述
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E34","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesLevelDesc = result.GetAt(1).Value
				
					///麻醉开始时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E35","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesStartDateTime = result.GetAt(1).Value
					
					///麻醉结束时间
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']["_i_"]/E36","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RISRAnesEndDateTime = result.GetAt(1).Value
				}
			s array=[]
			s tmpMainObj=##class(%DynamicObject).%New()
			s tmpMainObj."RISR_ReportID"=ReportID
			s tmpMainObj."RISR_ExamID"=StudyNo
			s tmpMainObj."RISR_OrderItemID"=OEORIOrderItemID
			s tmpMainObj."RISR_PatientID"=PATPatientID
			s tmpMainObj."RISR_VisitNumber"=PAADMVisitNumber
			s tmpMainObj."RISR_SysCode"=$case(DocumentType,"02001":"PACS","02002":"US","02003":"ES","02004":"EKG","02005":"ECT",:"")
			s tmpMainObj."RISR_ReportDocCode"=RecordDocCode
			s tmpMainObj."RISR_ReportDocDesc"=RecordDocName
			s tmpMainObj."RISR_ReportDate"=ReportDate
			s tmpMainObj."RISR_ReportTime"=ReportTime
			s tmpMainObj."RISR_CheckDocCode"=CheckDocCode
			s tmpMainObj."RISR_CheckDocDesc"=CheckDocDesc
			s tmpMainObj."RISR_CheckDate"=CheckDate
			s tmpMainObj."RISR_CheckTime"=CheckTime
			s tmpMainObj."RISR_FinalCheckDocCode"=CheckDocCode
			s tmpMainObj."RISR_FinalCheckDocDesc"=CheckDocDesc
			s tmpMainObj."RISR_OrderItemDesc"=PacsItemDesc
			s tmpMainObj."RISR_BACode"=BodyPartCode
			s tmpMainObj."RISR_BADesc"=BodyPartDesc
			s tmpMainObj."RISR_Method"=ExamMethod
			s tmpMainObj."RISR_ExamDesc"=ExamSee
			s tmpMainObj."RISR_DiagDesc"=ExamResult
			s tmpMainObj."RISR_ACRCode"=""
			s tmpMainObj."RISR_AdviseDesc"=ExamResult
			s tmpMainObj."RISR_IsGet"=""
			s tmpMainObj."RISR_ImageSrc"=""
			s tmpMainObj."RISR_ReportImageSrc"=DocumentPath
			s tmpMainObj."RISR_ItemCode"=ArcimCode
			s tmpMainObj."RISR_ItemDesc"=ArcimDesc
			s tmpMainObj."RISR_WarnCode"=IsUrgent
			s tmpMainObj."RISR_IsPositive"=IsPositive	
			s tmpMainObj."RISR_AbnormalFlags"=AbnormalFlags
			s tmpMainObj."RISR_AnesDocCode"=RISRAnesDocCode
			s tmpMainObj."RISR_AnesDocName"=RISRAnesDocName
			s tmpMainObj."RISR_AnesMethodCode"=RISRAnesMethodCode
			s tmpMainObj."RISR_AnesMethodDesc"=RISRAnesMethodDesc
			s tmpMainObj."RISR_AnesLevelCode"=RISRAnesLevelCode
			s tmpMainObj."RISR_AnesLevelDesc"=RISRAnesLevelDesc
			s tmpMainObj."RISR_AnesLevelCode"=RISRAnesLevelCode
			s tmpMainObj."RISR_AnesLevelDesc"=RISRAnesLevelDesc
			s tmpMainObj."RISR_AnesStartDateTime"=RISRAnesStartDateTime
			s tmpMainObj."RISR_AnesEndDateTime"=RISRAnesEndDateTime		
			s tmpMainObj."RISR_Status"="1"
			s tmpMainObj."RISR_ExamDocCode"=StudyDocCode
			s tmpMainObj."RISR_ExamDocDesc"=StudyDocName
			s tmpMainObj."RISR_ExamDate"=StudyDate
			s tmpMainObj."RISR_ExamTime"=StudyTime	
		}
		do array.%Push(tmpMainObj)
		s ReturnJson=array.%ToJSON()
		s RtnStreams=##class(%Stream.GlobalCharacter).%New()

		s stream=##class(%Stream.GlobalCharacter).%New()
		d stream.Write(ReturnJson)
		s RtnStreams=..RISReportInfo(stream,DocumentID)
		d RtnStreams.Rewind()
		s RtnString=RtnStreams.Read()
		s RtnJSONArr={}.%FromJSON(RtnString)
		s RtnJSON=RtnJSONArr.%Get(0)
		s ResultCode=RtnJSON.%Get("ResultCode")
		s ResultContent=RtnJSON.%Get("ResultContent")
		s ResultStream=##class(%Stream.GlobalCharacter).%New()
		d ResultStream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>"_ResultCode_"</ResultCode><ResultContent><![CDATA["_ResultContent_"]]></ResultContent></Body></Response>")
		q ResultStream
	}
Err
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败,<![CDATA["_$ze_"]]></ResultContent></Body></Response>")
	q stream
}
}

/// Creator：ZhangXinying
/// CreatDate：2019—11-08
/// Description： 解析病理报告xml生成json，并保存病理检查报告
/// w ##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePISReport().Read()
ClassMethod ParsePISReport(inputContent As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	s $zt="Err"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	d inputContent.Rewind()
	s ExamMethod=""
	if $$$ISERR(tSC) {
		set RtnStreams=##class(%Stream.GlobalCharacter).%New()
		do RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]]]><![CDATA[></ResultContent></Body></Response>")
		Quit RtnStreams 	
	}else{
		set (OrganizationCode,PATPatientID,PAADMVisitNumber,DocumentType,DocumentID)=""
		set (DocumentContent,UpdateUserCode,UpdateDate,UpdateTime,DocumentPath)=""
		set (hospSpecimenID,hospRisExamId,pdfrowId,BusinessFieldCode,HospitalCode,OEORIOrderItemID,ArcimId,ArcimCode,ArcimDesc)=""
		set RtnStreams=##class(%Stream.GlobalCharacter).%New()		
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OrganizationCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OrganizationCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentType","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentType=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentID=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentContent","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentContent=fieldValue
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateDate=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateTime=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentPath","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentPath=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospRisExamId=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospSpecimenID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/BusinessFieldCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set BusinessFieldCode=$tr(fieldValue,$c(0),"")
		} 
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/HospitalCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set HospitalCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OEORIOrderItemID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
		}
		set patientId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,""))
		if patientId=""
		{
			d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>登记号为"_PATPatientID_"的病人不存在</ResultContent></Body></Response>")	
			q RtnStreams
		}
		if '$d(^PAADM(PAADMVisitNumber))
		{
			set RtnStreams=##class(%Stream.GlobalCharacter).%New()
			do RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊信息不存在</ResultContent></Body></Response>")
			Quit RtnStreams
		}
		if DocumentPath'=""{		
			if (DocumentType'="02006")
			{
				d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>文档类型有误！</ResultContent></Body></Response>")
				q RtnStreams	
			}
		}

		/// 保存xml文件
		if DocumentContent'=""{
			//处理xml超长问题
			Set DocString=""
			If $isobject(DocumentContent) = 1 {
		         Set len = DocumentContent.Size
		         Do DocumentContent.Rewind()
		         Set DocString = DocumentContent.Read(.len, .st)
			} else {
		         Set DocString = DocumentContent
			}
			Set DocString=$tr(DocString,$c(0),"")
			
			set DocumentContent=$SYSTEM.Encryption.Base64Decode(DocString)
			set DocumentContent=$zcvt(DocumentContent,"I","UTF8")
			set:$e(DocumentContent,1,38)="<?xml version=""1.0"" encoding=""UTF-8""?>" DocumentContent=$e(DocumentContent,39,$l(DocumentContent))
			set stream=##class(%Stream.GlobalCharacter).%New()
			d stream.Write(DocumentContent)
			s docContentStream = ##Class(%Stream.GlobalCharacter).%New()
			d docContentStream.CopyFrom(stream)
			s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.tDocument)
			d docContentStream.Rewind()
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/E0004","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PatientName = result.GetAt(1).Value
			s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/E0005","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Sex = result.GetAt(1).Value
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/documentHeader/patient/telecom","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) MobileNo = result.GetAt(1).Value
			
			s sc = tDocument.EvaluateExpression("/clinicalDocument/documentHeader/title","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Title = result.GetAt(1).Value
			set tSC=tDocument.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0141'])",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set hsCount=tRes.GetAt(1).Value
				if hsCount="0"
				{
					d RtnStreams.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>信息为空</ResultContent></Body></Response>")
					q RtnStreams	
				}
				set (ApplyNo,PISNo,LabRoomNo,CheckHospitalCode,CheckHospitalDesc,HospitalCode,HospitalDesc,CheckDeptCode,CheckDeptDesc,GetLabDate,LabDocCode,LabDocName,BodyPartCode,BodyPartDesc)=""
				set (CheckDate,CheckDocCode,CheckDocName,ClinicInfo,ClinicDiag,ExamMethod,ExamSee,PISDiag,Suggest,VerifyDocCode,VerifyDocName,ReportDocCode,ReportDocName,Notes)=""
				set (IsUrgent,IsPositive,AbnormalFlags,SliceFrozenNo,InspMaterials,ImmuneGrpNo,ReportNo)=""
				for i=1:1:hsCount {
					///申请号	
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E01","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ApplyNo = result.GetAt(1).Value
					
					///病理号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E02","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PISNo = result.GetAt(1).Value
					
					///实验室编号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E03","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) LabRoomNo = result.GetAt(1).Value
					
					///送检医院编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E04","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckHospitalCode = result.GetAt(1).Value
					
					///送检医院名称
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E05","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckHospitalDesc = result.GetAt(1).Value
					
					///检查医院编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E06","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) HospitalCode = result.GetAt(1).Value
					
					///检查医院名称
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E07","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) HospitalDesc = result.GetAt(1).Value
					
					///送检科室编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E08","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDeptCode = result.GetAt(1).Value
					
					///送检科室名称
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E09","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDeptDesc = result.GetAt(1).Value
					
					///取样日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E10","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) GetLabDate = result.GetAt(1).Value
					
					///取样医生编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E11","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) LabDocCode = result.GetAt(1).Value
					
					///取样医生姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E12","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) LabDocName = result.GetAt(1).Value
					
					///取材部位代码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141]["_i_"]/E13","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) BodyPartCode = result.GetAt(1).Value
					
					///取材部位名称
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E14","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) BodyPartDesc = result.GetAt(1).Value
					
					///送检日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E15","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDate = result.GetAt(1).Value
					
					///送检医生编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E16","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDocCode = result.GetAt(1).Value
					
					///送检医生姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E17","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) CheckDocName = result.GetAt(1).Value
					
					///报告日期
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E18","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportDate = result.GetAt(1).Value
					
					///临床表现
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E19","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ClinicInfo = result.GetAt(1).Value
					
					///临床诊断
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E20","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ClinicDiag = result.GetAt(1).Value
					
					///病理大体所见
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E21","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ExamSee = result.GetAt(1).Value
					
					///病理诊断
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E22","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PISDiag = result.GetAt(1).Value
					
					//补充意见
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E23","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Suggest = result.GetAt(1).Value
					
					///核对医师编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E24","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) VerifyDocCode = result.GetAt(1).Value
					
					///核对医师姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E25","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) VerifyDocName = result.GetAt(1).Value
					
					///报告医师编码
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E26","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportDocCode = result.GetAt(1).Value
					
					///报告医师姓名
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E27","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportDocName = result.GetAt(1).Value
					
					///备注
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E28","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Notes = result.GetAt(1).Value
					
					///是否危急
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E29","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) IsUrgent = result.GetAt(1).Value	
					
					///是否阳性
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E30","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) IsPositive = result.GetAt(1).Value
					
					///异常标记
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E31","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AbnormalFlags = result.GetAt(1).Value
						
					///冰冻号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E32","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SliceFrozenNo = result.GetAt(1).Value	
					
					///送检材料
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E33","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) InspMaterials = result.GetAt(1).Value
					
					///免疫组化
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E34","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ImmuneGrpNo = result.GetAt(1).Value		
					
					///报告号
					s sc = tDocument.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_i_"]/E35","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ReportNo = result.GetAt(1).Value	
				}
			i OEORIOrderItemID["^" s OEORIOrderItemID=$p(OEORIOrderItemID,"^",1)
			s ArcimId=$p($g(^OEORD($p(OEORIOrderItemID,"||",1),"I",$p(OEORIOrderItemID,"||",2),1)),"^",2)
			q:ArcimId="" RtnStreams
			s ArcimCode=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",1)
			s ArcimDesc=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",2)
			s array=[]
			s tmpMainObj=##class(%DynamicObject).%New()
			s tmpMainObj."RISR_ReportID"=ReportNo
			s tmpMainObj."RISR_ExamID"=PISNo
			s tmpMainObj."RISR_OrderItemID"=OEORIOrderItemID
			s tmpMainObj."RISR_PatientID"=PATPatientID
			s tmpMainObj."RISR_VisitNumber"=PAADMVisitNumber
			s tmpMainObj."RISR_SysCode"=$case(DocumentType,"02001":"PACS","02002":"US","02003":"ES","02004":"EKG","02005":"PACS","02006":"PIS",:"")
			s tmpMainObj."RISR_ReportDocCode"=ReportDocCode
			s tmpMainObj."RISR_ReportDocDesc"=ReportDocName
			s:ReportDate[" " tmpMainObj."RISR_ReportDate"=$p(ReportDate," ",1)
			s:ReportDate'[" " tmpMainObj."RISR_ReportDate"=ReportDate
			s:ReportDate[" " tmpMainObj."RISR_ReportTime"=$p(ReportDate," ",2)
			s:ReportDate'[" " tmpMainObj."RISR_ReportTime"="00:00:00"
			s:tmpMainObj."RISR_ReportTime"="" tmpMainObj."RISR_ReportTime"="00:00:00"
			s tmpMainObj."RISR_CheckDocCode"=ReportDocCode
			s tmpMainObj."RISR_CheckDocDesc"=ReportDocName
			s:CheckDate[" " tmpMainObj."RISR_CheckDate"=$p(CheckDate," ",1)
			s:CheckDate'[" " tmpMainObj."RISR_CheckDate"=CheckDate
			s:CheckDate[" " tmpMainObj."RISR_CheckTime"=$p(CheckDate," ",2)
			s tmpMainObj."RISR_FinalCheckDocCode"=VerifyDocCode
			s tmpMainObj."RISR_FinalCheckDocDesc"=VerifyDocName
			s tmpMainObj."RISR_OrderItemDesc"=ArcimDesc
			s tmpMainObj."RISR_BACode"=BodyPartCode
			s tmpMainObj."RISR_BADesc"=BodyPartDesc
			s tmpMainObj."RISR_Method"=ExamMethod
			s tmpMainObj."RISR_ExamDesc"=ExamSee
			s tmpMainObj."RISR_DiagDesc"=PISDiag
			s tmpMainObj."RISR_ACRCode"=""
			s tmpMainObj."RISR_AdviseDesc"=Suggest
			s:tmpMainObj."RISR_AdviseDesc"="" tmpMainObj."RISR_AdviseDesc"=PISDiag
			s tmpMainObj."RISR_IsGet"=""
			s tmpMainObj."RISR_ImageSrc"=""
			s tmpMainObj."RISR_ReportImageSrc"=DocumentPath
			s tmpMainObj."RISR_ItemCode"=ArcimCode
			s tmpMainObj."RISR_ItemDesc"=ArcimDesc	
			s tmpMainObj."RISR_WarnCode"=IsUrgent
			s tmpMainObj."RISR_IsPositive"=IsPositive	
			s tmpMainObj."RISR_AbnormalFlags"=AbnormalFlags
			s tmpMainObj."RISR_SliceFrozenNo"=SliceFrozenNo	
			s tmpMainObj."RISR_InspMaterials"=InspMaterials
			s tmpMainObj."RISR_ImmuneGrpNo"=ImmuneGrpNo	
								
		}
		do array.%Push(tmpMainObj)
		s ReturnJson=array.%ToJSON()
		s RtnStreams=##class(%Stream.GlobalCharacter).%New()

		s stream=##class(%Stream.GlobalCharacter).%New()
		d stream.Write(ReturnJson)
		s RtnStreams=..RISReportInfo(stream,DocumentID)
		d RtnStreams.Rewind()
		s RtnString=RtnStreams.Read()
		s RtnJSONArr={}.%FromJSON(RtnString)
		s RtnJSON=RtnJSONArr.%Get(0)
		s ResultCode=RtnJSON.%Get("ResultCode")
		s ResultContent=RtnJSON.%Get("ResultContent")
		s ResultStream=##class(%Stream.GlobalCharacter).%New()
		d ResultStream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>"_ResultCode_"</ResultCode><ResultContent><![CDATA["_ResultContent_"]]></ResultContent></Body></Response>")
		q ResultStream
	}
Err
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败,<![CDATA["_$ze_"]]></ResultContent></Body></Response>")
	q stream
	}
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-06
/// Description：根据报告ID获取医嘱rowid，针对拆报告的，逗号分割多个医嘱rowid
/// Table：Ens_LISSpecimenReport
/// Input：报告ID
/// Return：医嘱ID，逗号分割
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).QryLISOrdIDByRpt("745")
ClassMethod QryLISOrdIDByRpt(rptID As %String) As %String
{
	s $zt="Err"
	s OrderItemIDs=""
	set myquery = "SELECT * FROM SqlUser.Ens_LisSpecimenReport where LISSR_ReportID= "_"'"_rptID_"'"
  	set tStatement = ##class(%SQL.Statement).%New()
  	set qStatus = tStatement.%Prepare(myquery)
  	set rset = tStatement.%Execute()
   	while rset.%Next() {	
   		set OrderItemID=rset.%Get("LISSR_OrderItemID")
   		if OrderItemIDs="" s OrderItemIDs=OrderItemID
   		else  d  s OrderItemIDs=OrderItemIDs_","_rset.%Get("LISSR_OrderItemID")
   	}
   	q OrderItemIDs
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据病理报告ID返回报告结果头对象
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).PISdocumentHeader("176").XMLExport()
ClassMethod PISdocumentHeader(StudyNo As %String) As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader
{
	set documentHeader=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISRExamIDIndex",$zcvt(StudyNo,"U"),""))
	q:RARRowid="" ""
	set SysCode=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),7)
	if SysCode="PIS" set documentHeader.title="病理检查报告"
	else  set documentHeader.title="检查报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.author).%New()
	set AdmNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set RAROEORIDR=$p($lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4),"^",1)
	set ordstr1 = $g(^OEORD($p(RAROEORIDR,"||",1),"I",$p(RAROEORIDR,"||",2),1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.name).%New()
	set PatRowID=$P($g(^PAADM(AdmNo)),"^",1)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	set CredentialNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if ((CredentialTypeRowID'="")&&(CredentialNum'="")) {
		set certificatename.code=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set certificatename.content=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2) 
		set certificate.value=CredentialNum
	}
	else {
		set certificatename.code=""
		set certificatename.content=""
		set certificate.value=CredentialNum
	}
	set certificate.name=certificatename
	set patient.certificate=certificate
	set addr=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.addr).%New()
	set addr.text=$g(^PAPER(patRowId,"PER","ADD",1))
	set addr.desc="现住址"
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	set ProvinceDesc=""
	if ProvinceRowID'="" d
	.set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	.set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	if CityCodeRowID'="" d
	.set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	.set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	if CityAreaRowID'="" d
	.set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	set addr.houseNumber=""
	set addr.streetName=""
	set addr.township=""
	set addr.county=CityAreaDesc
	set addr.city=CityCodeDesc
	set addr.state=ProvinceDesc
	set WorkPostCodeDR=$o(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set:WorkPostCodeDR'="" addr.postalCode=$p($g(^DHCPERSON(WorkPostCodeDR)),"^",8)
	set patient.addr=addr
	set patient.name=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set patient.telecom=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set ethnicGroup=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	if age.value<=1
	{
		s age.value=$fn((+$h-BirthYear)/30,"",2)	
		s age.unit="月"
	}
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.addr).%New()
	set participantAddr.desc="联系人地址"
	set participantAddr.text=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set participantAddr.houseNumber=""
	set participantAddr.streetName=""
	set participantAddr.township=""
	set participantAddr.county=""
	set participantAddr.city=""
	set participantAddr.state=""
	set participantAddr.postalCode=""
	set participant.addr=participantAddr
	set documentHeader.participant=participant
	Quit documentHeader
}

/// Creator：ZhangXinying
/// CreatDate：2020—07-22
/// Description：根据抗生素代码抗生素字典表RowID，第三方的加OT标识判断
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetAntiobioticsID("CTX32")
ClassMethod GetAntiobioticsID(AntibioCode As %String) As %String
{
	s $zt="Err"
	s AntibioCode1=AntibioCode,AntibioID=""
	s AntibioID=$o(^dbo.BTAntibioticsI("IndexCode",##Class(LIS.Util.Common).IndexData(AntibioCode),""))
	s AntibioCode1=$zcvt(AntibioCode1,"U")
	if AntibioID=""
	{
		s AntibioID=$o(^dbo.BTAntibioticsI("IndexCode",##Class(LIS.Util.Common).IndexData("OT"_AntibioCode1),""))	
	}
	q:AntibioID="" ""
	q AntibioID
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2020—07-22
/// Description：根据抗生素代码、名称，保存第三方抗生素字典，前缀增加OT标识
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).AddAntiobioticsID("an","阿米卡星")
ClassMethod AddAntiobioticsID(AntibioCode As %String, AntibioDesc As %String) As %String
{
	s $zt="Err"
	s obj=##Class(dbo.BTAntibiotics).%New()
	s obj.Code="OT"_AntibioCode
	s obj.CName=AntibioDesc
	s sc=obj.%Save()
	If '($SYSTEM.Status.IsOK(sc)) s err=AntibioCode_"插入失败:"_$SYSTEM.Status.GetErrorText(sc) Quit
	s AntibioDR=obj.RowID
	q AntibioDR
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// CreatDate：2021—01-15
/// Description: 根据就诊rowid获取药敏耐药结果，抗菌药物申请单药敏记录用
/// Output :   rowid   序号     报告日期    样本号                   编码  细菌名[中文]     耐药机制    细菌名英文名   抗生素名  备注  whonet     检验项目   标本     送检日期
///         Rowid   SeqNo   ReportDate   SampleNo  SpecResource   code  BacterialNameC  Resistance  BacterialNameE  AntName   Note  whonet      TSName   SPName    RecDate
/// Debug: d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QrySensitiveList",13)
Query QrySensitiveList(AdmId As %String) As %Query(ROWSPEC = "id:%String,SeqNo:%String,ReportDate:%String,SampleNo:%String,SpecResource:%String,code:%String,BacterialNameC:%String,Resistance:%String,BacterialNameE:%String,AntName:%String,Note:%String,whoNet:%String,TSName:%String,SPName:%String,RecDate:%String")
{
}

ClassMethod QrySensitiveListExecute(ByRef qHandle As %Binary, AdmId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1,RetStr=""
    Set qHandle=$lb(0,repid,0)
    q:$g(AdmId)="" $$$OK
    s TestCodeDR="" f  s TestCodeDR=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR)) q:(TestCodeDR="")  d
    .s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
    .s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
    .;i ResultFormat'="M" q   ///只查询微生物项目类型(由于第三方检验无法确定结果格式，所以去掉此屏蔽)
    .s AuthDate="" f  s AuthDate=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR,AuthDate)) q:(AuthDate="")  d
    ..q:(AuthDate="-100000000000000")
    ..s AuthTime="" f  s AuthTime=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR,AuthDate,AuthTime)) q:AuthTime=""  d
    ...q:(AuthTime="-100000000000000")
    ...s ReportResultDR="" f  s ReportResultDR=$o(^Busi.ENS.EnsLISItemResultI("LISIRAdmItemIndex",AdmId,TestCodeDR,AuthDate,AuthTime,ReportResultDR)) q:ReportResultDR=""  d
	....s ResultData=$g(^Busi.ENS.EnsLISItemResultD(ReportResultDR))
	....s VisitNumberReportDR=$lg(ResultData,3),VisitNumberRepRowid=""
	....s VisitNumberRepRowid=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",VisitNumberReportDR,""))
	....s ReportData=$g(^Busi.ENS.EnsLISReportResultD(VisitNumberRepRowid))
    ....s ResultStatus=$lg(ReportData,117)   //（1审核，2取消审核，3作废）
    ....i ResultStatus'=1 Quit
	....s TestSetDesc=""
	....s LISIROrderItemID=$lg(ResultData,28)
	....if LISIROrderItemID'="" d
	.....s LISIRArcimDr=$p($g(^OEORD($p(LISIROrderItemID,"||",1),"I",$p(LISIROrderItemID,"||",2),1)),"^",1)
	.....s:LISIRArcimDr'="" TestSetDesc=$p($g(^ARCIM($p(LISIRArcimDr,"||",1),$p(LISIRArcimDr,"||",2),1)),"^",2)
    ....s Labno = $o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(VisitNumberReportDR,"U"),""))
    ....s Labno = $tr(Labno," ","")
    ....s ReceiveDate = $lg(ReportData,125)
    ....s:ReceiveDate'="" ReceiveDate=$zd(ReceiveDate,3)
    ....s ReceiveTime = $lg(ReportData,126)
    ....s:ReceiveTime'="" ReceiveTime=$zt(ReceiveTime)
    ....s SpecimenDesc=$lg(ReportData,147)
    ....s OrganismName=$lg(ResultData,8)
    ....s OrganismEName=""
	....s num=0
	....s ReportResultID=$lg($g(^Busi.ENS.EnsLISItemResultD(ReportResultDR)),2)
    ....s AntibioticsDR="" f  s AntibioticsDR=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",ReportResultID, AntibioticsDR)) q:AntibioticsDR=""  d
    .....s SenDR="" f  s SenDR=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",ReportResultID, AntibioticsDR,SenDR)) q:SenDR=""  d
    ......s SenData=$g(^Busi.ENS.EnsLISItemSenResultD(SenDR)),WCode=""
    ......s SensitivityCode=$lg(SenData,6)
    ......s SensitivityName=$lg(SenData,7)
    ......s AntibioticsCode=$lg(SenData,3)
    ......s AntibioticsName=$lg(SenData,4)
    ......s AntibioticsID=$o(^dbo.BTAntibioticsI("IndexCode",##Class(LIS.Util.Common).IndexData(AntibioticsCode),""))
    ......s:AntibioticsID'="" WCode=$lg($g(^dbo.BTAntibioticsD(AntibioticsID)),6)
    ......s num=num+1
	......//药敏记录rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注
	......s list=VisitNumberReportDR_"||"_TestCodeDR_"||"_AntibioticsDR_"||"_SensitivityCode_"^"_num_"^"_AuthDate_"^"_Labno_"^^"_AntibioticsCode_"^"_OrganismName_"^"_SensitivityName_"^"_OrganismEName_"^"_AntibioticsName_"^^"_WCode_"^"_TestSetDesc_"^"_SpecimenDesc_"^"_ReceiveDate
	......s RetStr=RetStr_list_"!"
	......s num=num+1
	s SusceptStr=$p(RetStr,"!",1,$l(RetStr,"!")-1)
    Set len=$l(SusceptStr,"!")
    for i=1:1:len do
    .Set Suscept=$p(SusceptStr,"!",i)
    .q:Suscept=""  
    .Set Rowid=$p(Suscept,"^",1)
    .Set SeqNo=$p(Suscept,"^",2)
    .Set ReportDate=$p(Suscept,"^",3)
    .Set:ReportDate'="" ReportDate=$zd(ReportDate,3)	
    .Set SampleNo=$p(Suscept,"^",4)
    .Set SpecResource=$p(Suscept,"^",5)
    .Set code=$p(Suscept,"^",6)
    .Set BacterialNameC=$p(Suscept,"^",7)
    .Set Resistance=$p(Suscept,"^",8)
    .;q:(Resistance'["耐药")&&(Resistance'["敏感")&&(Resistance'["药敏")&&(Resistance'["中介")
    .Set BacterialNameE=$p(Suscept,"^",9)
    .Set AntName=$p(Suscept,"^",10)
    .Set Note=$p(Suscept,"^",11)
    .set whoNet=$p(Suscept,"^",12)  ;
    .set TSName=$p(Suscept,"^",13)     ;检验项目
    .set SPName=$p(Suscept,"^",14)      ;标本
    .set RecDate=$p(Suscept,"^",15)     ;送检日期
    .Do OutwardRow7
    Quit $$$OK
OutwardRow7
    set Data=$lb(Rowid,SeqNo,ReportDate,SampleNo,SpecResource,code,BacterialNameC,Resistance,BacterialNameE,AntName,Note,whoNet,TSName,SPName,RecDate)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QrySensitiveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySensitiveListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QrySensitiveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySensitiveListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

// d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryTSInfoReport","17663393","","","","","","","","","","","65^^3^8^1")

Query QryTSInfoReport(ReportDRs, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "AuthDate,AuthTime,ReportDR,ReqDate,ReqTime,MajorConclusion,RepStatus,CollectionDate,CollectionTime,RecDate,RecTime,ManualOrdItemList,ReportStatus")
{
}

ClassMethod QryTSInfoReportExecute(ByRef qHandle As %Binary, ReportDRs, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	set ReportDRs=$g(ReportDRs)
	Set repid=$i(^CacheTemp)
 	Set ind=1
	s RowCount=0
	s CurNamespace=$ZUTIL(5)
	i '$l(ReportDRs) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ReportLength = $l(ReportDRs,",")
	s thisIndex=0
	for {
		s thisIndex = thisIndex+1
		q:thisIndex>ReportLength
		s ReportDR = $p(ReportDRs,",",thisIndex)
		i '$l(ReportDR) continue
		d GetData
		d OutPut
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetData	
	s LISRptID="",Data=""
	&sql(select %id into :LISRptID from sqlUser.Ens_LISReportResult where LISRR_ReportID=:ReportDR)
	i '$l(LISRptID) {//没有数据
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s AuthDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),107)
	s AuthTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),108)
	s ReAuthDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),129)
	s ReAuthTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),130)
	//如果有重审时间，审核时间为重审时间，用于前次结果查询
	i $l($g(ReAuthDate)) s AuthDate = ReAuthDate
	i $l($g(ReAuthTime)) s AuthTime = ReAuthTime
	s Status=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),117)
	s RepStatus=$case(Status,"1":"审核","2":"取消审核","3":"作废",:"")
	s ReqDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),22)
	s:ReqDate'="" ReqDate=$zd(ReqDate,3)
	s ReqTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),23)
	s:ReqTime'="" ReqTime=$zt(ReqTime)
	s CollectionDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),48)
	s:CollectionDate'="" CollectionDate=$zd(CollectionDate,3)
	s CollectionTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),49)
	s:CollectionTime'="" CollectionTime=$zt(CollectionTime)
	s RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),65)
	s:RecDate'="" RecDate=$zd(RecDate,3)
	s RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),66)
	s:RecTime'="" RecTime=$zt(RecTime)
	s MajorConclusion=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),143)
	s ManualOrdItemList=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),149)
	
	s AuthDate = $replace($replace($replace(AuthDate,$C(10),""),$c(9),""),$c(13),"")
	s AuthTime = $replace($replace($replace(AuthTime,$C(10),""),$c(9),""),$c(13),"")
	s ReportDR = $replace($replace($replace(ReportDR,$C(10),""),$c(9),""),$c(13),"")

	s ReqDate = $replace($replace($replace(ReqDate,$C(10),""),$c(9),""),$c(13),"")
	s ReqTime = $replace($replace($replace(ReqTime,$C(10),""),$c(9),""),$c(13),"")
	s MajorConclusion = $replace($replace($replace(MajorConclusion,$C(10),""),$c(9),""),$c(13),"")
	s RepStatus = $replace($replace($replace(RepStatus,$C(10),""),$c(9),""),$c(13),"")
	s CollectionDate = $replace($replace($replace(CollectionDate,$C(10),""),$c(9),""),$c(13),"")
	s CollectionTime = $replace($replace($replace(CollectionTime,$C(10),""),$c(9),""),$c(13),"")
	s RecDate = $replace($replace($replace(RecDate,$C(10),""),$c(9),""),$c(13),"")
	s RecTime = $replace($replace($replace(RecTime,$C(10),""),$c(9),""),$c(13),"")

	s ManualOrdItemList = $replace($replace($replace(ManualOrdItemList,$C(10),""),$c(9),""),$c(13),"")
	s ReportStatus="1"
	
	s LISSRSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(ReportDR,"U"),""))
	q:LISSRSpecimenID=""
	s LISSROrderItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(ReportDR,"U"),LISSRSpecimenID,""))
	s jsonArr=##class(%DynamicArray).%New()
	s jsonObj=##class(%DynamicObject).%New()
	s jsonObj.OEOrdItemID=LISSROrderItemID
	s jsonObj.ExamID=$tr(LISSRSpecimenID," ","")
	d jsonArr.%Push(jsonObj)
	s str=jsonArr.%ToJSON()
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write(str)
	s statusStream=##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatus",stream)
	s statusJsonArr={}.%FromJSON(statusStream)
	s statusJson=statusJsonArr.%Get(0)
	s statusCur=""
	s statusCur=statusJson.Status
	q:statusCur=""
	if statusCur="PRERP" s ReportStatus="4" //预报告
	if statusCur="PRP" s ReportStatus="5" //部分报告
	s ReportType=$lg($g(^Busi.ENS.EnsLISReportResultD(LISRptID)),101)
	if ReportType="2" s ReportStatus="3" //空:无报告;1:正常报告;2:异常报告;3:危急报告;4:中间报告(预报告);5:部分报告
	s abnum="",wjnum=""
	&SQL(select count(*) into :abnum from SqlUser.Ens_LISItemResult where LISIR_ReportID=:ReportDR and LISIR_AbnormalFlags in('A','L','H'))
	if abnum>0 s ReportStatus="2"
	&SQL(select count(*) into :wjnum from SqlUser.Ens_LISItemResult where LISIR_ReportID=:ReportDR and LISIR_AbnormalFlags in('PL','PH'))
	if wjnum>0 s ReportStatus="3"
	s Data=$lb(AuthDate,AuthTime,ReportDR,ReqDate,ReqTime,MajorConclusion,RepStatus,CollectionDate,CollectionTime,RecDate,RecTime,ManualOrdItemList,ReportStatus)

	q $$$OK
	
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QryTSInfoReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTSInfoReportExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTSInfoReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTSInfoReportExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：ZhangXinying
/// CreatDate：2021-11-16
/// Description：根据报告ID、条码号返回医嘱号
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetOrdIDByRptLabNo("482211","21111200170")
ClassMethod GetOrdIDByRptLabNo(rptID As %String, labNo As %String) As %String
{
	q:(rptID="")||(labNo="") ""
	s OrdID=""
	s OrdRowID=""  f  s OrdRowID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_$zcvt(rptID,"U")," "_$zcvt(labNo,"U"),OrdRowID)) q:OrdRowID=""  d
	.if OrdID="" s OrdID=OrdRowID
	.else  s OrdID=OrdID_"^"_OrdRowID
	i $p(OrdID,"^",1)=$p(OrdID,"^",2) s OrdID=$p(OrdID,"^",1) //医嘱号剃重
	q OrdID
}

/// 根据医嘱号获取检查号，在医生站检查结果界面展示用
/// w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetStudyNoByOeordID("329||142")
ClassMethod GetStudyNoByOeordID(OEItemRowID As %String) As %String
{
    q:OEItemRowID=""
    s EnsStatusRowid=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OEItemRowID,""),-1) 
    q:EnsStatusRowid="" ""
    s StudyNo=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),3)
    q:StudyNo="" ""
    s Status=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),9)
    q:(Status'="RP")&&(Status'="RD") ""
    q StudyNo
}

/// Creator：ZhangXinying
/// CreatDate：2022-03-16
/// Description：根据报告ID、检查号返回医嘱号
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetOrdIDByRptExamNo("482211","21111200170")
ClassMethod GetOrdIDByRptExamNo(rptID As %String, examNo As %String) As %String
{
	q:(rptID="")||(examNo="") ""
	if $d(^Busi.ENS.EnsRISExamReportI("RISEXAMREPORTPKey"," "_$zcvt(rptID,"U"))) d
	.s OrdID=""
	.s OrdRowID=""  f  s OrdRowID=$o(^Busi.ENS.EnsRISExamReportI("RISEXAMREPORTPKey"," "_$zcvt(rptID,"U")," "_$zcvt(examNo,"U"),OrdRowID)) q:OrdRowID=""  d
	..if OrdID="" s OrdID=OrdRowID
	..else  s OrdID=OrdID_"^"_OrdRowID
	.i $p(OrdID,"^",1)=$p(OrdID,"^",2) s OrdID=$p(OrdID,"^",1) //医嘱号剃重
	else  d
	.s OrdID=""
	.s rptrowid=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",$zcvt(rptID,"U")),"")
	.s OrdID=$lg($g(^Busi.ENS.EnsRISReportResultD(rptrowid)),4)
	q OrdID
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据报告号保存文档，返回文档ID
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).SaveRISDocument("U20190920001")
ClassMethod SaveRISDocumentByRptID(RptID As %String, DocumentNO As %String = "") As %String
{
	set $zt="Err"
	q:RptID="" ""
	set RISReportID=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",RptID,""))
	q:RISReportID="" ""
	set StudyNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),3)
	set SysCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),7)
	if SysCode="PACS"
	{
		set DocType="02001"
	}
	elseif SysCode="US"
	{
		set DocType="02002"
	}
	elseif SysCode="ES"
	{
		set DocType="02003"
	}
	elseif SysCode="EKG"
	{
		set DocType="02004"
	}
	elseif SysCode="ECT"
	{
		set DocType="02005"
	}
	elseif SysCode="PIS"
	{
		set DocType="02006"
	}
	else
	{
		set DocType="02"	
	}
	set HOSDSerialNumber=DocType_"_"_DocumentNO_".xml"
	if DocumentNO="" set HOSDSerialNumber=DocType_"_"_RptID_".xml"
	set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,""))
	if (DocumentID="")&&(DocumentNO'="")
	{
		set HOSDSerialNumber=DocType_"_"_DocumentNO_".xml"
		set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,""))
		if DocumentID=""
		{
			set HOSDSerialNumber=DocType_"_"_DocumentNO_".pdf"
			set DocumentID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTSerialIndex",HOSDSerialNumber,"")) 
		}
	}
	if DocumentID=""
	{
		set Document=##class(User.EnsHOSDocument).%New()
	}
	else{
		set Document=##class(User.EnsHOSDocument).%OpenId(DocumentID,0)
	}
	if DocType="02006" ///保存病理xml文档
	{
		set:DocumentNO="" Document.HOSDCContent=..GetPISReportDocumentByRptID(RptID)
	}
	else ///保存检查文档
	{
		set:DocumentNO="" Document.HOSDCContent=..GetRISReportDocumentByRptID(RptID)
	}
	set:Document.HOSDFormat="" Document.HOSDFormat="xml"
	set:Document.HOSDManufacturerID="" Document.HOSDManufacturerID="1"
	set Document.HOSDClassificationCode=DocType
	set AdmNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),6)
	q:AdmNo="" ""
	set AdmLocDr=$p($g(^PAADM(AdmNo)),"^",4)
	q:AdmLocDr="" ""
	set HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	q:HospDr="" ""
	set HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	q:HospCode="" ""
	set Document.HOSDOrganId=HospCode
	set PatientDr=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),5)
	do Document.HOSDPatientIDSetObjectId(PatientDr)
	set Document.HOSDSerialNumber=HOSDSerialNumber
	set Document.HOSDStatus="1"
	set:DocumentNO'="" Document.HOSDSubsysDocumentID=DocumentNO
	set:DocumentNO="" Document.HOSDSubsysDocumentID=RptID
	set Document.HOSDTemplateVersionNumber="V1.0"
	set Document.HOSDTypeCode="1"
	set:Document.HOSDUpdateDate="" Document.HOSDUpdateDate=+$h
	set:Document.HOSDUpdateTime="" Document.HOSDUpdateTime=$p($h,",",2)
	set:Document.HOSDUpdateUserCode="" Document.HOSDUpdateUserCode="-"
	set:Document.HOSDUrl="" Document.HOSDUrl=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),33)
	set:Document.HOSDCPicUrl="" Document.HOSDCPicUrl=$lg($g(^Busi.ENS.EnsRISReportResultD(RISReportID)),32)
	do Document.HOSDVisitNumberSetObjectId(AdmNo)
	set sc=Document.%Save()
	if $system.Status.IsError(sc) d                 //检查Save是否成功
   	.d $system.OBJ.DisplayError(sc) 
   	.set id=-1
   	.tro
	else  d
	.set id=Document.%Id()	
	.do Document.%Close()
	q id
Err
	q "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2019-10-20
/// Description：获取HIS系统病理报告xml文档信息
/// Table：Ens_RisReportResult
/// Input： 病理报告号
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetPISReportDocument("C1800150").Read()
ClassMethod GetPISReportDocumentByRptID(RptID As %String) As %Stream.GlobalCharacter
{
	set $zt="Exception"
	q:RptID="" ""
	set stream=##class(%Stream.GlobalCharacter).%New()
	set clinicalDocument=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.clinicalDocument).%New()
	set documentHeader=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader=..PISdocumentHeaderByRptID(RptID)
	set clinicalDocument.documentHeader=documentHeader
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",RptID,RARRowid))
	q:RARRowid="" stream
	set StudyNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),3) //病理号
	set AdmNo=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set structuredBody=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.structuredBody).%New()
	set E0004desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0004desc.desc="姓名"
	set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set structuredBody.E0004=E0004desc
	if SexId'="" {
		set E0005desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
		set E0005desc.desc="性别代码"
		set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
		set structuredBody.E0005=E0005desc	
		set E0006desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
		set E0006desc.desc="性别描述"
		set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
		set structuredBody.E0006=E0006desc	
	}
	set E0008desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set:BirthYear'="" E0008desc.content=##class(web.DHCBillInterface).GetPapmiAge(patRowId,AdmNo) ;$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set E0008desc.desc="年龄"
	set structuredBody.E0008=E0008desc	
	
	set E0001desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0001desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set E0001desc.desc="病案号"
	set structuredBody.E0001=E0001desc	
	
	set E0002desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set E0002desc.desc="住院号"
	set structuredBody.E0002=E0002desc	

	set E0040desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0040desc.content=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set E0040desc.desc="联系电话"
	set structuredBody.E0002=E0040desc	
	
	set E0154desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedRowID=$P($g(^PAADM(AdmNo)),"^",73)
	set E0154desc.content=CurrentBedRowID
	set E0154desc.desc="病床id"
	set structuredBody.E0154=E0154desc	

	set E0075desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedNo=""
	if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	.set BedWordRowID = $p(CurrentBedRowID,"||",1)
	.set BedChildSub = $p(CurrentBedRowID,"||",2)
	.if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	..set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	set E0075desc.desc="病床"
	set E0075desc.content=CurrentBedNo
	set structuredBody.E0075=E0075desc
	set E0156desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	set:CurrentDetpRowID'="" E0156desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	set E0156desc.desc="科室id"
	set structuredBody.E0156=E0156desc
	set E0077desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	set E0077desc.desc="科室"
	set structuredBody.E0077=E0077desc
	
	set E0000desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E0000desc.desc="门诊号"
	set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	set structuredBody.E0000=E0000desc
	set OeordID=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),4)
	set S0141section=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.S0141).%New()
	set S0141section.code="S0141"
	set S0141section.desc="病理检查记录" 
	set E01desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E01desc.desc="申请号"
	set E01desc.content=OeordID
	set S0141section.E01=E01desc

	set E02desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E02desc.desc="病理号"
	set E02desc.content=StudyNo
	set S0141section.E02=E02desc
	set E03desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E03desc.desc="实验室编号"
	set E03desc.content=""
	set S0141section.E03=E03desc

	set AdmLocDr=$p($g(^PAADM(AdmNo)),"^",4),HospDr=""
	set:AdmLocDr'="" HospDr=$p($g(^CTLOC(AdmLocDr)),"^",22)
	
	set E04desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E04desc.desc="送检医院编码"
	set:HospDr'="" E04desc.content=$p($g(^CT("HOSP",HospDr)),"^",1)
	set S0141section.E04=E04desc
	
	set E05desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E05desc.desc="送检医院名称"
	set:HospDr'="" E05desc.content=$p($g(^CT("HOSP",HospDr)),"^",2)
	set S0141section.E05=E05desc

	set E06desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E06desc.desc="检查医院编码"
	set:HospDr'="" E06desc.content=$p($g(^CT("HOSP",HospDr)),"^",1)
	set S0141section.E06=E06desc
	
	set E07desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E07desc.desc="检查医院名称"
	set:HospDr'="" E07desc.content=$p($g(^CT("HOSP",HospDr)),"^",2)
	set S0141section.E07=E07desc

	set E08desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E08desc.desc="送检科室编码"
	set:AdmLocDr'="" E08desc.content=$p($g(^CTLOC(AdmLocDr)),"^",1)
	set S0141section.E08=E08desc
	
	set E09desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E09desc.desc="送检科室名称"
	set:AdmLocDr'="" E09desc.content=$p($g(^CTLOC(AdmLocDr)),"^",2)
	set S0141section.E09=E09desc
	set OperateDate="",OperateID="",OperateName="",ExamPartID="",ExamPart="",CheckDate="",CheckDocCode="",CheckDocDesc=""
	set EsStatusDr=""  f  set EsStatusDr=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID",OeordID,EsStatusDr)) q:EsStatusDr=""  d
	.set StatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),11)
	.set PreStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),12)
	.if (StatusCode="SC")&&(PreStatusCode="AP") d
	..s OperateDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
	..s OperateID=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),5)
	..s OperateName=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),6)
	..s ExamPartID=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),13)
	..s ExamPart=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),4)
	.if (StatusCode="DIAG")&&(PreStatusCode="SC") d
	..s CheckDate=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),7)
	..s CheckDocCode=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),5)
	..s CheckDocDesc=$lg($g(^Busi.ENS.EnsStatusLogD(EsStatusDr)),6)
	set E10desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E10desc.desc="取样日期"
	set:OperateDate'="" E10desc.content=$zd(OperateDate,3)
	set S0141section.E10=E10desc

	set E11desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E11desc.desc="取样医生编码"
	set E11desc.content=OperateID
	set S0141section.E11=E11desc

	set E12desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E12desc.desc="取样医生名称"
	set E12desc.content=OperateName
	set S0141section.E12=E12desc

	
	set E13desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set RISRPositionCode=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),21)
	set E13desc.desc="取材部位代码"
	set E13desc.content=ExamPartID
	set:ExamPartID="" E13desc.content=RISRPositionCode
	set S0141section.E13=E13desc
	set RISRPositionDesc=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),22)
	set E14desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E14desc.desc="取材部位名称"
	set E14desc.content=ExamPart
	set:ExamPart="" E14desc.content=RISRPositionDesc
	set S0141section.E14=E14desc
	
	set E15desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E15desc.desc="送检日期"
	set E15desc.content=CheckDate
	set S0141section.E15=E15desc
	set E16desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E16desc.desc="送检医生编码"
	set E16desc.content=CheckDocCode
	set S0141section.E16=E16desc
	set E17desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E17desc.desc="送检医生名称"
	set E17desc.content=CheckDocDesc
	set S0141section.E17=E17desc

	set E19desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E19desc.desc="临床表现"
	set E19desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),24)
	set S0141section.E19=E19desc
	set E20desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E20desc.desc="临床诊断"
	set E20desc.content=$p($p(..GetDiagnoses(AdmNo),"!",1),"^",5)
	set S0141section.E20=E20desc

	set E21desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E21desc.desc="病理大体所见"
	set E21desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),24)
	set S0141section.E21=E21desc
	set E22desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E22desc.desc="病理诊断"
	set E22desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),25)
	set S0141section.E22=E22desc
	set E23desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E23desc.desc="补充意见"
	set E23desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),27)
	set S0141section.E23=E23desc
	set E24desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E24desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),12)
	set E24desc.desc="核对医师编码"
	set S0141section.E24=E24desc
	
	set E25desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E25desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),13)
	set E25desc.desc="核对医师姓名"
	set S0141section.E25=E25desc

	set E26desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E26desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),8)
	set E26desc.desc="报告医师编码"
	set S0141section.E26=E24desc
	
	set E27desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E27desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),9)
	set E27desc.desc="报告医师姓名"
	set S0141section.E27=E27desc
	set E28desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E28desc.desc="备注"
	set E28desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),27)
	set S0141section.E28=E28desc
	set E29desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E29desc.desc="是否危急"
	set E29desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),34)
	set S0141section.E29=E29desc
	set E30desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E30desc.desc="是否阳性"
	set E30desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),35)
	set S0141section.E30=E30desc
	set E31desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E31desc.desc="异常标记"
	set E31desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),36)
	set S0141section.E31=E31desc
	set E32desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E32desc.desc="冰冻号"
	set E32desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),45)
	set S0141section.E32=E32desc
	set E33desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E33desc.desc="送检材料"
	set E33desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),46)
	set S0141section.E33=E33desc
	set E34desc=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc).%New()
	set E34desc.desc="免疫组化"
	set E34desc.content=$lg($g(^Busi.ENS.EnsRISReportResultD(RARRowid)),47)
	set S0141section.E28=E28desc
	set structuredBody.S0141=S0141section
	set clinicalDocument.structuredBody=structuredBody
	set streamAll=##class(%Stream.GlobalCharacter).%New()
	do streamAll.Write("<?xml version=""1.0"" encoding=""UTF-8""?>") 
	do clinicalDocument.XMLExportToStream(.stream)
	do streamAll.CopyFrom(stream) 
	Quit streamAll
Exception
	set clinicalDocument=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.clinicalDocument).%New()
	d clinicalDocument.XMLExportToStream(.stream)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据病理报告ID返回报告结果头对象
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).PISdocumentHeaderByRptID("176").XMLExport()
ClassMethod PISdocumentHeaderByRptID(RptID As %String) As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader
{
	s $zt="Err"
	q:RptID="" ""
	set documentHeader=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",RptID,""))
	q:RARRowid="" ""
	set SysCode=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),7)
	if SysCode="PIS" set documentHeader.title="病理检查报告"
	else  set documentHeader.title="检查报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.author).%New()
	set AdmNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set RAROEORIDR=$p($lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4),"^",1)
	set ordstr1 = $g(^OEORD($p(RAROEORIDR,"||",1),"I",$p(RAROEORIDR,"||",2),1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.name).%New()
	set PatRowID=$P($g(^PAADM(AdmNo)),"^",1)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	set CredentialNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if ((CredentialTypeRowID'="")&&(CredentialNum'="")) {
		set certificatename.code=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set certificatename.content=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2) 
		set certificate.value=CredentialNum
	}
	else {
		set certificatename.code=""
		set certificatename.content=""
		set certificate.value=CredentialNum
	}
	set certificate.name=certificatename
	set patient.certificate=certificate
	set addr=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.addr).%New()
	set addr.text=$g(^PAPER(patRowId,"PER","ADD",1))
	set addr.desc="现住址"
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	set ProvinceDesc=""
	if ProvinceRowID'="" d
	.set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	.set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	if CityCodeRowID'="" d
	.set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	.set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	if CityAreaRowID'="" d
	.set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	set addr.houseNumber=""
	set addr.streetName=""
	set addr.township=""
	set addr.county=CityAreaDesc
	set addr.city=CityCodeDesc
	set addr.state=ProvinceDesc
	set WorkPostCodeDR=$o(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set:WorkPostCodeDR'="" addr.postalCode=$p($g(^DHCPERSON(WorkPostCodeDR)),"^",8)
	set patient.addr=addr
	set patient.name=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set patient.telecom=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set ethnicGroup=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	if age.value<=1
	{
		s age.value=$fn((+$h-BirthYear)/30,"",2)	
		s age.unit="月"
	}
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.addr).%New()
	set participantAddr.desc="联系人地址"
	set participantAddr.text=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set participantAddr.houseNumber=""
	set participantAddr.streetName=""
	set participantAddr.township=""
	set participantAddr.county=""
	set participantAddr.city=""
	set participantAddr.state=""
	set participantAddr.postalCode=""
	set participant.addr=participantAddr
	set documentHeader.participant=participant
	Quit documentHeader
Err
	s $zt=""
	s obj=##class(web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader).%New()
	q obj
}

/// Creator：ZhangXinying
/// CreatDate：2019-10-20
/// Description：获取HIS系统检查报告xml文档信息
/// Table：Ens_RisReportResult
/// Input： 检查号
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetRISReportDocumentByRptID("U20191023001")
ClassMethod GetRISReportDocumentByRptID(RptID As %String) As %Stream.GlobalCharacter
{
	set $zt="Exception"
	q:RptID="" ""
	set stream=##class(%Stream.GlobalCharacter).%New()
	set clinicalDocument=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.clinicalDocument).%New()
	set documentHeader=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader=..documentHeaderByRptID(RptID)
	set clinicalDocument.documentHeader=documentHeader
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",RptID,RARRowid))
	q:RARRowid="" stream
	set StudyNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),3) //检查号
	set AdmNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set structuredBody=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.structuredBody).%New()
	set E0004desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0004desc.desc="姓名"
	set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set structuredBody.E0004=E0004desc
	if SexId'="" {
		set E0005desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
		set E0005desc.desc="性别代码"
		set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
		set structuredBody.E0005=E0005desc	
		set E0006desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
		set E0006desc.desc="性别描述"
		set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
		set structuredBody.E0006=E0006desc	
	}
	set E0008desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set:BirthYear'="" E0008desc.content=##class(web.DHCBillInterface).GetPapmiAge(patRowId,AdmNo) ;$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set E0008desc.desc="年龄"
	set structuredBody.E0008=E0008desc	
	set E0148desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set AdmTypeCode=$p($g(^PAADM(AdmNo)),"^",2)
	set E0148desc.content=AdmTypeCode
	set E0148desc.desc="病人类型代码"
	set structuredBody.E0148=E0148desc	
	set E0149desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0149desc.content=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿",:"")
	set E0149desc.desc="病人类型名称"
	set structuredBody.E0149=E0149desc
	set E0156desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	set:CurrentDetpRowID'="" E0156desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	set E0156desc.desc="科室id"
	set structuredBody.E0156=E0156desc
	set E0077desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	set E0077desc.desc="科室"
	set structuredBody.E0077=E0077desc
	set E0002desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0002desc.desc="住院号"
	set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set structuredBody.E0002=E0002desc
	set E0000desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0000desc.desc="门诊号"
	set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	set structuredBody.E0000=E0000desc
	set E0154desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedRowID=$P($g(^PAADM(AdmNo)),"^",73)
	set E0154desc.content=CurrentBedRowID
	set E0154desc.desc="病床id"
	set structuredBody.E0154=E0154desc	
	set E0075desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedNo=""
	if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	.set BedWordRowID = $p(CurrentBedRowID,"||",1)
	.set BedChildSub = $p(CurrentBedRowID,"||",2)
	.if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	..set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	set E0075desc.desc="病床"
	set E0075desc.content=CurrentBedNo
	set structuredBody.E0075=E0075desc
	//取诊断信息
	set AllDiagnoses=..GetDiagnoses(AdmNo)
	set AllDiagnosesLen=$l(AllDiagnoses,"!")
	for i=1:1:AllDiagnosesLen {
		set AllDiagnose=$p($g(AllDiagnoses),"!",i)
		if AllDiagnose'="" {
			set S0048section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0048).%New()
			set S0048section.code="S0048"
			set S0048section.desc="诊断"
			set E07descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E07descDig.desc="医生填写的诊断"
			set E07descDig.content=$p($g(AllDiagnose),"^",2)
			set S0048section.E07=E07descDig
			set E01descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E01descDig.content=$p($g(AllDiagnose),"^",5) 
			set E01descDig.desc="诊断名称"
			set S0048section.E01=E01descDig
			set E02descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E02descDig.content=$p($g(AllDiagnose),"^",4)
			set E02descDig.desc="诊断代码"
			set S0048section.E02=E02descDig
			d structuredBody.S0048.Insert(S0048section)
		}
	}
	set S0076section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0076).%New()
	set S0076section.code="S0076"
	set S0076section.desc="检查记录" 
	set E01desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E01desc.desc="检查号"
	set E01desc.content=StudyNo
	set S0076section.E01=E01desc
	set E02desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E02desc.desc="检查设备编码"
	set S0076section.E02=E02desc
	set E03desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E03desc.desc="检查设备名称"
	set S0076section.E03=E03desc
	set E04desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	s RISRPositionCode=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),21)
	set E04desc.desc="检查部位代码"
	set E04desc.content=RISRPositionCode
	set S0076section.E04=E04desc
	s RISRPositionDesc=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),22)
	set E05desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E05desc.desc="检查部位名称"
	set E05desc.content=RISRPositionDesc
	set S0076section.E05=E05desc
	set E06desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E06desc.desc="检查部位医生手写"
	set S0076section.E06=E06desc
	set E07desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E07desc.desc="检查部位"
	set E07desc.content=RISRPositionDesc
	set S0076section.E07=E07desc
	set E08desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set DRPTRowID=0 
	;set DRPTRowID=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,DRPTRowID))
	set E08desc.desc="检查所见"
	set E08desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),24) ;^DHCRBStudy("Report",DRPTRowID,"ExamDescEx")
	set S0076section.E08=E08desc
	set E09desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E09desc.desc="检查结果"
	set E09desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),25) ;^DHCRBStudy("Report",DRPTRowID,"ResultDescEx")
	set S0076section.E09=E09desc
	set E10desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E10desc.desc="检查医师代码"
	set E10desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),49) 
	set:E10desc.content="" E10desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),8)
	set S0076section.E10=E10desc
	set E11desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E10desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),50) 
	set:E11desc.content="" E11desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),9)
	set E11desc.desc="检查医师姓名"
	set S0076section.E11=E11desc
	set E12desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	
	set E12desc.desc="审核医师代码"
	set E12desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),12)
	set S0076section.E12=E12desc
	set E13desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E13desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),13)
	set E13desc.desc="审核医师姓名"
	set S0076section.E13=E13desc
	set E14desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
 	
	set E14desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),12)
	set E14desc.desc="记录者代码"
	set S0076section.E14=E14desc
	set E15desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E15desc.desc="记录者姓名"
	set E15desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),13)
	set S0076section.E15=E15desc
	set E16desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),10)
	set:ReportDate'="" ReportDate= $ZD(ReportDate,3)
	set ExamDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),51)
	set:ExamDate'="" ExamDate= $ZD(ExamDate,3)
	set E16desc.desc="检查日期"
	set E16desc.content=ExamDate
	set S0076section.E16=E16desc
	set E17desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),11)
	set:ReportTime'="" ReportTime= $ZT(ReportTime,1)
	set ExamTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),52)
	set:ExamTime'="" ExamTime= $ZT(ExamTime,1)
	set E17desc.desc="检查时间"	
	set E17desc.content=ExamTime
	set S0076section.E17=E17desc
	set E18desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E18desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),2)
	set E18desc.desc="报告号"
	set S0076section.E18=E18desc
	set E19desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),14)
	set:VerifyDate'="" VerifyDate= $ZD(VerifyDate,3)
	set E19desc.content=VerifyDate
	set E19desc.desc="审核日期"
	set S0076section.E19=E19desc
	set E20desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),15)
	set:VerifyTime'="" VerifyTime= $ZT(VerifyTime,1)
	set E20desc.desc="审核时间"
	set E20desc.content=VerifyTime
	set S0076section.E20=E20desc
	set E21desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set OeordItmDR =$p($lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4),"^",1)
    set OeordRowid = $p(OeordItmDR,"||",1)
    set OeordSub = $p(OeordItmDR,"||",2)
    set OEORIItmMastDR = $p(^OEORD(OeordRowid,"I",OeordSub,1),"^",2)
	set E21desc.desc="检查项目描述"
	set E21desc.content=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2) 
	set S0076section.E21=E21desc
	set E22desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E22desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),23) ;$p(^DHCRBStudy("Report",DRPTRowID),"^",24)
	set E22desc.desc="检查方法描述"
	set S0076section.E22=E22desc
	set E23desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportDate=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),10)
	set:ReportDate'="" ReportDate= $ZD(ReportDate,3)
	set E23desc.content=ReportDate
	set E23desc.desc="报告日期"
	set S0076section.E23=E23desc
	set E24desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportTime=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),11)
	set:ReportTime'="" ReportTime= $ZT(ReportTime,1)
	set E24desc.content=ReportTime
	set E24desc.desc="报告时间"
	set S0076section.E24=E24desc
	set E25desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E25desc.desc="医嘱号"
	set E25desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4)
	set S0076section.E25=E25desc
	set E26desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E26desc.desc="是否危急"
	set E26desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),34)
	set S0076section.E26=E26desc
	set E27desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E27desc.desc="是否阳性"
	set E27desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),35)
	set S0076section.E27=E27desc
	set E28desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E28desc.desc="异常标记"
	set E28desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),36)
	set S0076section.E28=E28desc
	set E29desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E29desc.desc="麻醉医师工号"
	set E29desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),37)
	set S0076section.E29=E29desc
	set E30desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E30desc.desc="麻醉医师姓名"
	set E30desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),38)
	set S0076section.E30=E30desc
	set E31desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E31desc.desc="麻醉方式代码"
	set E31desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),39)
	set S0076section.E31=E31desc
	set E32desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E32desc.desc="麻醉方式描述"
	set E32desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),40)
	set S0076section.E32=E32desc
	set E33desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E33desc.desc="麻醉分级代码"
	set E33desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),41)
	set S0076section.E33=E33desc
	set E34desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E34desc.desc="麻醉分级描述"
	set E34desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),42)
	set S0076section.E34=E34desc
	set E35desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E35desc.desc="麻醉开始时间"
	set E35desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),43)
	set S0076section.E35=E35desc
	set E36desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E36desc.desc="麻醉结束时间"
	set E36desc.content=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),44)
	set S0076section.E36=E36desc
	set structuredBody.S0076=S0076section
	set risItemCode=""
	for  set risItemCode=$o(^Busi.ENS.EnsRISItemResultI("IndexReportItem",RptID,risItemCode)) q:risItemCode=""  d
	.set risrItemRowid="" for  set risrItemRowid=$o(^Busi.ENS.EnsRISItemResultI("IndexReportItem",RptID,risItemCode,risrItemRowid)) q:risrItemRowid=""  d
	..set risrItemInfo=$g(^Busi.ENS.EnsRISItemResultD(risrItemRowid))
	..set S0176Section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0176).%New()
	..set S0176Section.code="S0176"
	..set S0176Section.desc="检查测值记录，包括超声心动、心电(HR、P-R间期、QRS时限、RV5、RV5+SV1、QT间期、QTC、电轴等)、CTA血管造影等"
	..set E01desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E01desc.content=$lg(risrItemInfo,6)
	..set S0176Section.E01=E01desc
	..set E02desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E02desc.content=$lg(risrItemInfo,7)
	..set S0176Section.E02=E02desc
	..set E03desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E03desc.content=$lg(risrItemInfo,8)
	..set S0176Section.E03=E03desc
	..set E04desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E04desc.content=$lg(risrItemInfo,9)
	..set S0176Section.E04=E04desc
	..set E05desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E05desc.content=$lg(risrItemInfo,10)
	..set S0176Section.E05=E05desc
	..set E06desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E06desc.content=$lg(risrItemInfo,11)
	..set S0176Section.E06=E06desc
	..set E07desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E07desc.content=$lg(risrItemInfo,12)
	..set S0176Section.E07=E07desc
	..set E08desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E08desc.content=$lg(risrItemInfo,13)
	..set S0176Section.E08=E08desc
	..set E09desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E09desc.content=$lg(risrItemInfo,14)
	..set S0176Section.E09=E09desc
	..set E10desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	..set E10desc.content=$lg(risrItemInfo,15)
	..set S0176Section.E10=E10desc
	..do structuredBody.S0176.Insert(S0176Section)
	set clinicalDocument.structuredBody=structuredBody
	set streamAll=##class(%Stream.GlobalCharacter).%New()
	do streamAll.Write("<?xml version=""1.0"" encoding=""UTF-8""?>") 
	do clinicalDocument.XMLExportToStream(.stream)
	do streamAll.CopyFrom(stream) 
	Quit streamAll
Exception
	set $zt=""
	set clinicalDocument=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.clinicalDocument).%New()
	d clinicalDocument.XMLExportToStream(.stream)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2019—09-08
/// Description：根据检查报告ID返回报告结果头对象
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).documentHeaderByRptID("U20190919002").XMLExport()
ClassMethod documentHeaderByRptID(RptID As %String) As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader
{
	set documentHeader=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set RARRowid=""
	set RARRowid=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",RptID,""))
	q:RARRowid="" documentHeader
	set SysCode=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),7)
	if SysCode="PIS" set documentHeader.title="病理检查报告"
	else  set documentHeader.title="检查报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.author).%New()
	set AdmNo=$lg(^Busi.ENS.EnsRISReportResultD(RARRowid),6) //就诊号
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set RAROEORIDR=$p($lg(^Busi.ENS.EnsRISReportResultD(RARRowid),4),"^",1)
	set ordstr1 = $g(^OEORD($p(RAROEORIDR,"||",1),"I",$p(RAROEORIDR,"||",2),1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.name).%New()
	set PatRowID=$P($g(^PAADM(AdmNo)),"^",1)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	set CredentialNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if ((CredentialTypeRowID'="")&&(CredentialNum'="")) {
		set certificatename.code=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set certificatename.content=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2) 
		set certificate.value=CredentialNum
	}
	else {
		set certificatename.code=""
		set certificatename.content=""
		set certificate.value=CredentialNum
	}
	set certificate.name=certificatename
	set patient.certificate=certificate
	set addr=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr).%New()
	set addr.text=$g(^PAPER(patRowId,"PER","ADD",1))
	set addr.desc="现住址"
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	set ProvinceDesc=""
	if ProvinceRowID'="" d
	.set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	.set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	if CityCodeRowID'="" d
	.set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	.set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	if CityAreaRowID'="" d
	.set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	set addr.houseNumber=""
	set addr.streetName=""
	set addr.township=""
	set addr.county=CityAreaDesc
	set addr.city=CityCodeDesc
	set addr.state=ProvinceDesc
	set WorkPostCodeDR=$o(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set:WorkPostCodeDR'="" addr.postalCode=$p($g(^DHCPERSON(WorkPostCodeDR)),"^",8)
	set patient.addr=addr
	set patient.name=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set patient.telecom=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set ethnicGroup=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	if age.value<=1
	{
		s age.value=$fn((+$h-BirthYear)/30,"",2)	
		s age.unit="月"
	}
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr).%New()
	set participantAddr.desc="联系人地址"
	set participantAddr.text=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set participantAddr.houseNumber=""
	set participantAddr.streetName=""
	set participantAddr.township=""
	set participantAddr.county=""
	set participantAddr.city=""
	set participantAddr.state=""
	set participantAddr.postalCode=""
	set participant.addr=participantAddr
	set documentHeader.participant=participant
	Quit documentHeader
}

/// Creator：ZhangXinying
/// CreatDate：2023—05-08
/// Description：根据医嘱ID返回医嘱报告状态，针对病理同一医嘱号、同一病理号，出多份病理报告，取消审核其中一份的，另一份报告仍为审核状态的，该医嘱判断为报告审核状态
/// Debug:w ##class(web.DHCENS.STBLL.Method.PostReportInfo).GetRptStatusByOrdID("98||1")
ClassMethod GetRptStatusByOrdID(OrdItemID As %String) As %String
{
	try
	{
		set num="0",rptStatus=""
		set ensRelOrdDocumentRowID="" f  set ensRelOrdDocumentRowID = $O(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OrdItemID,"xml",ensRelOrdDocumentRowID)) q:ensRelOrdDocumentRowID=""  d
    	.set documentID = $lg($g(^Busi.ENS.EnsRelOrderDocumentD(ensRelOrdDocumentRowID)),2)
    	.q:documentID=""
   		.set documentStatus = $lg($g(^Busi.ENS.EnsHOSDocumentD(documentID)),13)
    	.;q:documentStatus="2" ///文档作废
    	.s rptNo = $lg($g(^Busi.ENS.EnsRelOrderDocumentD(ensRelOrdDocumentRowID)),4)
    	.q:rptNo=""
    	.s rptRowId=$o(^Busi.ENS.EnsRISReportResultI("RISREPORTPKey",rptNo,""))
    	.q:rptRowId=""
    	.s risrStatus=$lg($g(^Busi.ENS.EnsRISReportResultD(rptRowId)),48)
		.;q:(risrStatus'="")&&(risrStatus'="1") //报告状态（1审核，2取消审核，3作废）,过滤取消审核状态、作废状态的
		.set num=num+1
		.if (documentStatus'="2")&&(risrStatus'="2") d
		..s rptFlag(num)="1" //记录该医嘱对应的当前报告状态是否为审核，如果有拆报告则分别记录每份报告状态
		.else  d
		..s rptFlag(num)="0"
		s key="0"
		f  s key=$o(rptFlag(key))  q:key=""  d
		.if rptFlag(key)="1" d 
		..s rptStatus="1" //如果该医嘱对应的多份报告中取消审核了其中一份，其他仍为审核状态，则该医嘱对应的报告状态为审核。
	}
	catch
	{
		s $zt=""
		s rptStatus=""
	}
	q rptStatus
}

}
