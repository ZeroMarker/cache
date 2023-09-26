/// 名称：DHCMed.SMDService.PrintSrv
/// 描述：精神疾病报卡打印服务
/// 编写者：liuzhenhe
/// 编写日期：2019-10-21
Class DHCMed.SMDService.PrintSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.SMDService.PrintSrv).PrintSMDReport("fillxlSheet",12)
ClassMethod PrintSMDReport(itmjs As %String, aReportID As %String) As %String
{
	new (itmjs,aReportID)
	set return=0
	quit:aReportID="" return
	
	set objReport=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	quit:'$IsObject(objReport) return
	set EpisodeID=objReport.SREpisodeID
	quit:EpisodeID="" return
	
	Set PatList = ##class(DHCMed.SMD.ReportPat).GetPatStr(aReportID,objReport.SREpisodeID)
	Set AdmType = objReport.SRAdmTypeDr.Code
	// 住院
	If AdmType = 2
	{
		Set Row=2
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCardNo,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set Row = 3
		Set PatType = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRPatTypeDr),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatType,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set AdmType = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRAdmTypeDr),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmType,"O","JS")_"',"_Row_",34);"
		&javascript<#(retval)#>
	
		Set Row = 4
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),1),"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),2),"O","JS")_"',"_Row_",20);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),4),"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set Birthday = $p(PatList,$C(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_Row_",45);"
		&javascript<#(retval)#>
	
		Set Row = 5
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactor,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactorTel,"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRHomeTel,"O","JS")_"',"_Row_",45);"
		&javascript<#(retval)#>

		Set Row = 6
		Set PatRelationDRype = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRPatRelationDR),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatRelationDRype,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set PatNation = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRPatNation),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatNation,"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set CertType = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRCertType),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(CertType,"O","JS")_"',"_Row_",45);"
		&javascript<#(retval)#>

		Set Row = 7
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCompany,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set National = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRNational),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(National,"O","JS")_"',"_Row_",37);"
		&javascript<#(retval)#>
		
		Set Row = 8
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCompanyTel,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set HB = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRHB),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(HB,"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set LocalDr = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRLocalDr),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(LocalDr,"O","JS")_"',"_Row_",45);"
		&javascript<#(retval)#>
	
		Set Row = 9
		Set RegAddrTypeDesc = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRRegAddrTypeDr),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddrTypeDesc,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 10
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRegAddress,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 11
		Set CurrAddrTypeDesc = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRCurrAddrTypeDr),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(CurrAddrTypeDesc,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 12
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCurrAddress,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 13
		Set Ducation = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRDucation),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Ducation,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set Marriage = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRMarriage),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Marriage,"O","JS")_"',"_Row_",41);"
		&javascript<#(retval)#>
	
		Set Row = 14
		Set OccupationDr = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SROccupationDr),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(OccupationDr,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set Family = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRFamily),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Family,"O","JS")_"',"_Row_",47);"
		&javascript<#(retval)#>
		
		Set Row = 15
		Set KJSYW = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRKJSYW),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(KJSYW,"O","JS")_"',"_Row_",19);"
		&javascript<#(retval)#>
		Set FirstDrugTreatDate = objReport.SRFirstDrugTreatDate
		Set:FirstDrugTreatDate'="" FirstDrugTreatDate = $zd(FirstDrugTreatDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDrugTreatDate,"O","JS")_"',"_Row_",44);"
		&javascript<#(retval)#>
	
		Set Row = 16
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRIPTreatTimes,"O","JS")_"',"_Row_",30);"
		&javascript<#(retval)#>
		Set GS = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRGS),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(GS,"O","JS")_"',"_Row_",48);"
		&javascript<#(retval)#>
	
		Set Row = 17
		Set WXXWS=""
		For ind=1:1:objReport.SRWXXW.Count() {
			Set objDic=objReport.SRWXXW.GetAt(ind)
			Set:WXXWS'="" WXXWS=WXXWS_","_objDic.Description
			Set:WXXWS="" WXXWS=objDic.Description
		}
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(WXXWS,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set WXPG = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRWXPG),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(WXPG,"O","JS")_"',"_Row_",39);"
		&javascript<#(retval)#>
		
		Set Row = 18
		Set SickDate = objReport.SRSickDate
		Set:SickDate'="" SickDate = $zd(SickDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(SickDate,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		
		Set Row = 19
		Set Referral = ##class(DHCMed.SMD.Report).GetSRReferralDr(objReport)
		Set Referrals = ""
		For i=1:1:$l(Referral,"#"){
			Set strReferral = $p(Referral,"#",i)	//修改打印时，送检主体不正确问题
			Set ReferralInfo = ##class(DHCMed.SMDService.ReportSrv).GetDescById($p(strReferral,"^",1))
			Set Referrals = Referrals_","_ReferralInfo
		}
		Set Referrals = $e(Referrals,2,$l(Referrals)+1)
		//Set:objReport.SRReferralTxt'="" Referrals=$replace(Referrals,"其他",objReport.SRReferralTxt)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Referrals,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>

		Set Row = 20
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRDiagHospital,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set DiagDate = objReport.SRDiagDate
		Set:DiagDate'="" DiagDate = $zd(DiagDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DiagDate,"O","JS")_"',"_Row_",39);"
		&javascript<#(retval)#>
		
		Set Row = 21
		Set Disease = ##class(DHCMed.SMDService.ReportSrv).GeICDString(objReport.SRDiseaseDr)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),2),"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 23
		Set Row = 24
		Set Row = 25
		Set Row = 26
		
		Set Row = 27
		Set ZQTY = $p(##class(DHCMed.SMDService.ReportSrv).GetDicString(objReport.SRZQTY),$c(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZQTY,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set ZQTYDate = objReport.SRZQTYDate
		Set:ZQTYDate'="" ZQTYDate = $zd(ZQTYDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ZQTYDate,"O","JS")_"',"_Row_",39);"
		&javascript<#(retval)#>
		
		Set Row = 28
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReportLoc,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRepLocTel,"O","JS")_"',"_Row_",39);"
		&javascript<#(retval)#>
	
		Set Row = 29
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReportUser,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set ReportDate = objReport.SRReportDate
		Set:ReportDate'="" ReportDate = $zd(ReportDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',"_Row_",39);"
		&javascript<#(retval)#>
		
		Set Row = 30
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReportNote,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	}
	
	Set return=1
	Quit return
}

}
