/// 名称: DHCMed.CCService.Lib.RisReport
/// 描述: 与Ris相关的函数库,DHCRB_Report
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Lib.RisReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.RisReport).Test()
ClassMethod Test()
{
    New
    
	Set %EpisodeID=20130139
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..ExamDescAndResult("医嘱||25423||申请胸部正测位")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=20130139
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..ExamRisCompare()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// 检查胸片是否有感染或炎症
ClassMethod ExamDescAndResult(aOEOrdItem As %String, aExamStr As %String = "", aCompareR As %String = "") As %String
{
	New (aOEOrdItem,aExamStr,aCompareR,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Set aOEOrdItem=$g(aOEOrdItem)
	Quit:aOEOrdItem="" return
	
	Set $ZT="ExamDescAndResultError"
	Set aExamStr=$g(aExamStr)
	Set aCompareR=$g(aCompareR)
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set ArcimID=$p(aOEOrdItem,"||",2)
	Quit:ArcimID="" return
	Set ArcimID=ArcimID_"||1"
	Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		Set SttDate=0
		For {
			Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
			Quit:SttDate=""
			
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
				Quit:SubID=""
				
				Set PACRegID=$o(^DHCPACRegInfoi("OEORI",OrderID_"||"_SubID,0))
				Continue:PACRegID=""
			    Set RisStudyNo=$p($g(^DHCPACRegInfo(PACRegID)),"^",2)
			    Set DRPTID=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
			    Continue:DRPTID=""
			    Set RisItemStatus=$p($g(^DHCRBStudy("Report",DRPTID)),"^",4)
			    Continue:(RisItemStatus'="5") //未发布
			    //Set ClinicInfo=$p($g(^DicomRpt(DCMRPTRowId)),"^",17)            ;17,临床诊断
			    //Set ExamDesc=$g(^DHCRBStudy("Report",DRPTID,"ExamDescEx"))      ;3,检查所见
			    Set ExamResult=$g(^DHCRBStudy("Report",DRPTID,"ResultDescEx"))  ;4,诊断意见
			    Continue:ExamResult=""
			    Continue:(ExamResult["未见明显异常")
				Continue:(ExamResult["未见明确病变")
				Continue:(ExamResult["未照")
				
			    //根据关键字判断，多个关键字逗号分隔
			    If aExamStr'="" {
					Continue:(..CompareKeyword(ExamResult,aExamStr,aCompareR)'=1)
			    }
			    
			    //判断最后发布时间
			    Set AuditDate=$p($g(^DHCRBStudy("Report",DRPTID)),"^",12)
			    Set AuditTime=$p($g(^DHCRBStudy("Report",DRPTID)),"^",13)
			    //Set IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",OrderID))
			    //Set TranedDate=+IfTraned
			    //Set TranedTime=$p(IfTraned,",",2)
			    
			    Set OrdName=$p(^ARCIM($p(ArcimID,"||",1),$P(ArcimID,"||",2),1),"^",2) ;医嘱名称
			    Set OrdDate=$p($g(^OEORD(OrderID,"I",SubID),1),"^",9) ;医嘱日期
			    Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
			    
			    Set Count=Count+1
			    
			    Set TempData=""
				Set $p(TempData,$c(3),1)=OrdName_"(诊断意见："_ExamResult_")"
				Set $p(TempData,$c(3),2)=+AuditDate
				Set $p(TempData,$c(3),3)=+AuditTime
				Set $p(TempData,$c(3),4)=ExamResult
				Set $p(TempData,$c(3),5)=OrderID_"||"_SubID
				Set $p(TempData,$c(3),6)="" //+objUser.Rowid
				Set $p(TempData,$c(3),7)="aOEOrdItem"_aOEOrdItem_",aExamStr"_aExamStr_",aCompareR"_aCompareR
				Set %ExtraData=%ExtraData_$lb(TempData)
			}
		}
	}
	
	Set return=Count
	Quit return
	
ExamDescAndResultError
    Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     liuyh
/// CreatDate：   2010-10-13
/// Description:  根据影像诊断意见判定是否特定关键字
/// Table：       
/// Input：       TempStr
/// return：      ret=0:不包含	>0:包含
/// w ##class(DHCMed.CCService.Lib.RisExamLib).ExamRisCompare("肝癌")
ClassMethod ExamRisCompare(aExamStr As %String = "", aCompareR As %String = "") As %String
{
	New (aExamStr,aCompareR,%EpisodeID,%ExtraData,%ErrorData)	
	Set return=0,Count=0
	
	Set $ZT="ExamRisCompareError"
	Set aExamStr=$g(aExamStr)
	Set aCompareR=$g(aCompareR)
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set OrderID=0
	For {
		Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,OrderID))
		Quit:OrderID=""
		
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID))
			Quit:ArcimID=""
			Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			
			Set SttDate=0
			For {
				Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
				Quit:SttDate=""
				
				Set SubID=0
				For {
					Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
					Quit:SubID=""
					
					Set PACRegID=$o(^DHCPACRegInfoi("OEORI",OrderID_"||"_SubID,0))
				    Continue:PACRegID=""
				    Set RisStudyNo=$p($g(^DHCPACRegInfo(PACRegID)),"^",2)
				    Set DRPTID=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
				    Continue:DRPTID=""
				    Set RisItemStatus=$p($g(^DHCRBStudy("Report",DRPTID)),"^",4)
				    Continue:(RisItemStatus'="5") //未发布
				    //Set ClinicInfo=$p($g(^DicomRpt(DCMRPTRowId)),"^",17)            ;17,临床诊断
				    //Set ExamDesc=$g(^DHCRBStudy("Report",DRPTID,"ExamDescEx"))      ;3,检查所见
				    Set ExamResult=$g(^DHCRBStudy("Report",DRPTID,"ResultDescEx"))  ;4,诊断意见
				    Continue:ExamResult=""
				    Continue:(ExamResult["未见明显异常")
				    Continue:(ExamResult["未见明确病变")
				    Continue:(ExamResult["未照")
				    
					//根据关键字判断，多个关键字逗号分隔
					If aExamStr'="" {
						Continue:(..CompareKeyword(ExamResult,aExamStr,aCompareR)'=1)
					}
				    
				    //判断最后发布时间
				    Set AuditDate=$p($g(^DHCRBStudy("Report",DRPTID)),"^",12)
				    Set AuditTime=$p($g(^DHCRBStudy("Report",DRPTID)),"^",13)
				    //Set IfTraned=$g(^DHCPEDataEx("DHC_PE_PreIOrdItem","PIOITranDateTime",OrderID))
				    //Set TranedDate=+IfTraned
				    //Set TranedTime=$p(IfTraned,",",2)
				    
				    Set OrdName=$p(^ARCIM($p(ArcimID,"||",1),$P(ArcimID,"||",2),1),"^",2) ;医嘱名称
				    Set OrdDate=$p($g(^OEORD(OrderID,"I",SubID),1),"^",9) ;医嘱日期
				    Set:OrdDate'="" OrdDate=$zd(OrdDate,3)
				    
				    Set Count=Count+1
				    
				    Set TempData=""
					Set $p(TempData,$c(3),1)=OrdName_"(诊断意见："_ExamResult_")"
					Set $p(TempData,$c(3),2)=+AuditDate
					Set $p(TempData,$c(3),3)=+AuditTime
					Set $p(TempData,$c(3),4)=ExamResult
					Set $p(TempData,$c(3),5)=OrderID_"||"_SubID
					Set $p(TempData,$c(3),6)="" //+objUser.Rowid
					Set $p(TempData,$c(3),7)="aExamStr"_aExamStr_",aCompareR"_aCompareR
					Set %ExtraData=%ExtraData_$lb(TempData)
				}
			}
		}
	}
	
	Set return=Count
	Quit return
	
ExamRisCompareError
    Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// 比较关键字,多个关键字逗号分隔
/// w ##Class(DHCMed.CCService.Lib.RisReport).CompareKeyword("感染性腹泻","感染性,腹泻","AND")
ClassMethod CompareKeyword(aExamResult As %String, aKeywords As %String, aCompareR As %String) As %String
{
	New (aExamResult,aKeywords,aCompareR)
	Set return=0
	Quit:(aExamResult="")||(aKeywords="") return
	Quit:$tr(aKeywords,",","")="" return
	
	If $zcvt(aCompareR,"U")="AND" {
		Set flg1=0,flg2=0
		For ind=1:1:$l(aKeywords,",")
		{
			Set keyword=$p(aKeywords,",",ind)
			Continue:keyword=""
			Set flg1=flg1+1
			Continue:aExamResult'[keyword
			Set flg2=flg2+1
		}
		Set:(flg1>0)&&(flg1=flg2) return=1
	} Else {  //OR
		For ind=1:1:$l(aKeywords,",")
		{
			Set keyword=$p(aKeywords,",",ind)
			Continue:keyword=""
			Continue:aExamResult'[keyword
			Set return=1
		}
	}
	
	Quit return
}

}
