Class web.DHCENS.STBLL.Method.QueryReportByID Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：根据rowid获取检查、病理报告
/// Table：Ens_RISReportResult、Ens_RISItemResult、Ens_RISExamReport
/// Input：RISRRowID:报告表rowid
/// Output:报告xml流
/// Debug:w ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetReportInfo("1").Read()
ClassMethod GetReportInfo(RISRRowID As %String = "") As %GlobalCharacterStream
{
	try
	{
	s ResponseObj=##class(web.DHCENS.STBLL.Method.Model.ReportRequest).%New()
	s obj=##class(web.DHCENS.STBLL.Method.Model.RISRptInfo).%New()
	s ReportData=$g(^Busi.ENS.EnsRISReportResultD(RISRRowID))
	s reportID=$lg(ReportData,2)
	s obj.RISRReportID=reportID
	s obj.RISRExamID=$lg(ReportData,3)
	s ordItemID=$lg(ReportData,4)
	s obj.RISROrderItemID=ordItemID
	s patDr=$lg(ReportData,5)
	s:patDr'="" obj.RISRPatientID=$p($g(^PAPER(patDr,"PAT",1)),"^",1)
	s obj.RISRPatientName=$p($g(^PAPER(patDr,"ALL")),"^",1)
	s admDr=$lg(ReportData,6)
	s obj.RISRVisitNumber=admDr
	s:admDr'="" obj.RISREncounterTypeCode=$p($g(^PAADM(admDr)),"^",2)
	s admDeptDr=$p($g(^PAADM(admDr)),"^",4)
	s:admDeptDr'="" obj.RISRAdmDeptCode=$p($g(^CTLOC(admDeptDr)),"^",1)
	s:admDeptDr'="" obj.RISRAdmDeptDesc=$p($g(^CTLOC(admDeptDr)),"^",2)
	s arcItmMastDr=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),1)),"^",2)
	s arcItemDr=$p($g(^ARCIM(+arcItmMastDr,$p(arcItmMastDr,"||",2),1)),"^",10)
	s obj.RISROrdSubCatCode=$p($g(^ARC("IC",arcItemDr)),"^",1)
	s obj.RISROrdSubCatDesc=$p($g(^ARC("IC",arcItemDr)),"^",2)
	s ordCarDr=$p($g(^ARC("IC",arcItemDr)),"^",8)
	s obj.RISROrdCatCode=$p($g(^OEC("ORCAT",ordCarDr)),"^",1)
	s obj.RISROrdCatDesc=$p($g(^OEC("ORCAT",ordCarDr)),"^",2)
	s ordRecDeptDr=$p($g(^OEORD(+ordItemID,"I",$p(ordItemID,"||",2),3)),"^",6)
	s:ordRecDeptDr'="" obj.RISRRecDeptCode=$p($g(^CTLOC(ordRecDeptDr)),"^",1)
	s:ordRecDeptDr'="" obj.RISRRecDeptDesc=$p($g(^CTLOC(ordRecDeptDr)),"^",2)
	s obj.RISRSysCode=$lg(ReportData,7)
	s obj.RISRReportDocCode=$lg(ReportData,8)
	s obj.RISRReportDocDesc=$lg(ReportData,9)
	s obj.RISRReportDate=$lg(ReportData,10)
	s obj.RISRReportTime=$lg(ReportData,11)
	s obj.RISRCheckDocCode=$lg(ReportData,12)
	s obj.RISRCheckDocDesc=$lg(ReportData,13)
	s obj.RISRCheckDate=$lg(ReportData,14)
	s obj.RISRCheckTime=$lg(ReportData,15)
	s obj.RISRFinalCheckDocCode=$lg(ReportData,16)
	s obj.RISRFinalCheckDocDesc=$lg(ReportData,17)
	s obj.RISRFinalCheckDate=$lg(ReportData,18)
	s obj.RISRFinalCheckTime=$lg(ReportData,19)
	s obj.RISRItemDesc=$lg(ReportData,20)
	s obj.RISRBACode=$lg(ReportData,21)
	s obj.RISRBADesc=$lg(ReportData,22)
	s obj.RISRMethod=$lg(ReportData,23)
	s obj.RISRExamDesc=$lg(ReportData,24)
	s obj.RISRDiagDesc=$lg(ReportData,25)
	s obj.RISRACRCode=$lg(ReportData,26)
	s obj.RISRAdviseDesc=$lg(ReportData,27)
	s obj.RISRIsGet=$lg(ReportData,28)
	s obj.RISROrderItemDesc=$lg(ReportData,31)
	s obj.RISRImageSrc=$lg(ReportData,32)
	s obj.RISRReportImageSrc=$lg(ReportData,33)
	s obj.RISRWarnCode=$lg(ReportData,34)
	s obj.RISRIsPositive=$lg(ReportData,35)
	s obj.RISRAbnormalFlags=$lg(ReportData,36)
	s obj.RISRAnesDocCode=$lg(ReportData,37)
	s obj.RISRAnesDocName=$lg(ReportData,38)
	s obj.RISRAnesMethodCode=$lg(ReportData,39)
	s obj.RISRAnesMethodDesc=$lg(ReportData,40)
	s obj.RISRAnesLevelCode=$lg(ReportData,41)
	s obj.RISRAnesLevelDesc=$lg(ReportData,42)
	s aneStDateTime=$lg(ReportData,43)
	s:aneStDateTime'="" obj.RISRAnesStartDateTime=$zd(aneStDateTime,3)
	s anesEndDateTime=$lg(ReportData,44)
	s:anesEndDateTime'="" obj.RISRAnesEndDateTime=$zt(anesEndDateTime)
	s obj.RISRSliceFrozenNo=$lg(ReportData,45)
	s obj.RISRInspMaterials=$lg(ReportData,46)
	s obj.RISRImmuneGrpNo=$lg(ReportData,47)
	if $d(^Busi.ENS.EnsRISItemResultI("IndexReportItem",$zcvt(reportID,"U")))
	{
		s risItemID="" 
		for
		{
			s risItemID=$o(^Busi.ENS.EnsRISItemResultI("IndexReportItem",$zcvt(reportID,"U"),risItemID))
			q:risItemID=""
			s risItemResultID=""
			for
			{
				s risItemResultID=$o(^Busi.ENS.EnsRISItemResultI("IndexReportItem",$zcvt(reportID,"U"),risItemID,risItemResultID))
				q:risItemResultID=""	
				s risItemObj=##class(web.DHCENS.STBLL.Method.Model.RISRItemResult).%New()
				s risItemData=$g(^Busi.ENS.EnsRISItemResultD(risItemResultID))
				s risItemObj.RISIRItemCode=$lg(risItemData,6)
				s risItemObj.RISIRItemDesc=$lg(risItemData,7)
				s risItemObj.RISIRResult=$lg(risItemData,8)
				s risItemObj.RISIRRanges=$lg(risItemData,9)
				s risItemObj.RISIRHigh=$lg(risItemData,10)
				s risItemObj.RISIRLow=$lg(risItemData,11)
				s risItemObj.RISIRUnit=$lg(risItemData,12)
				d obj.RISRItemResultList.Insert(risItemObj)
			}
		}		
	}
	s Body=##class(web.DHCENS.STBLL.Method.Model.Respbody).%New()
	s Body.ExamReport=obj
	s ResponseObj.Respbody=Body
	s Header=##class(web.DHCENS.STBLL.Method.Model.Header).%New()
	s Header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	s Header.SourceSystem="SYS0001"
	s ResponseObj.header=Header
	s stream=##class(%Stream.GlobalCharacter).%New()
	d ResponseObj.XMLExportToStream(.stream)
	}
	catch
	{
		s stream=##class(%Stream.GlobalCharacter).%New()
		s $zt=""	
	}
	q stream
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：根据就诊号获取检查报告的PDF报告路径信息
/// Table：Ens_HOSDocument
/// Input：就诊rowid
/// Output:文件路径使用HTTP的形式，如果有多个文件路径时使用^进行分隔
/// Debug: w ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetRISHOSDUrl("39","US")
ClassMethod GetRISHOSDUrl(EncounterId As %String, RISRType As %String = "") As %String
{
	try
	{
		q:EncounterId=""
		s hosdClass="",hosdType="",hosdUrls="",hosdUrl=""
		s docuType=$case(RISRType,"PACS":"02001","US":"02002","ES":"02003","EKG":"02004","PIS":"02006",:"")
		q:docuType=""
		for  
		{
			s hosdClass=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVisitNumberIndex",EncounterId,hosdClass))
			q:hosdClass=""
			s hosdType=$e(hosdClass,1,2)
			continue:hosdType'="02" //02001放射;02002超声;02003内镜;02004心电;02005核医学;02006病理;02007CT;02008DR;02009电生理;02010核磁共振;02011专科检查;02012肺功能;02099其他检查
			continue:hosdClass'=docuType
			s hosdID="",hosdUrls=""
			for 
			{
				s hosdID=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVisitNumberIndex",EncounterId,hosdClass,hosdID))
				q:hosdID=""
				s hosdUrl=$lg($g(^Busi.ENS.EnsHOSDocumentD(hosdID)),19)
				
				if hosdUrls=""
				{
					s hosdUrls=hosdUrl	
				}
				else
				{
					s hosdUrls=hosdUrls_"^"_hosdUrl	
				}
			}
		}
	}
	catch
	{
		s $zt=""		
	}
	q hosdUrls
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：根据医嘱ID获取报告ID
/// Table：Ens_RelOrderDocument
/// Input：医嘱rowid
/// Output:报告ID，如果有多个报告ID时使用^进行分隔
/// Debug: w ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetReportIDByOrd("")
ClassMethod GetReportIDByOrd(OrderItemId As %String = "") As %String
{
	try
	{
		q:OrderItemId=""
		s arcItmMastId=$p($g(^OEORD($p(OrderItemId,"||",1),"I",$p(OrderItemId,"||",2),1)),"^",2)
		s arcItmID="",orderType=""
		s:arcItmMastId'="" arcItmID=$p($g(^ARCIM($p(arcItmMastId,"||",1),$p(arcItmMastId,"||",2),1)),"^",10)
		s:arcItmID'="" orderType=$p($g(^ARC("IC",arcItmID)),"^",7)
		s reportID=""
		s documentType="xml",relOrdDocuID=""
		for  
		{
			s relOrdDocuID=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",OrderItemId,documentType,relOrdDocuID))
			q:relOrdDocuID=""
			if orderType="L"
			{
				s lisRptID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(relOrdDocuID)),3)
				if reportID=""
				{
					s reportID=lisRptID	
				}
				else
				{
					s reportID=reportID_"^"_lisRptID	
				}
			}
			elseif orderType="X"
			{
				s risRptID=$lg($g(^Busi.ENS.EnsRelOrderDocumentD(relOrdDocuID)),4)
				if reportID=""
				{
					s reportID=risRptID	
				}
				else
				{
					s reportID=reportID_"^"_risRptID	
				}
				
			}
		}
	}
	catch
	{
		s $zt=""		
	}
	q reportID
}

/// Creator：ZhangXinying
/// CreatDate：2021—12-16
/// Description：根据rowid获取检验报告
/// Table：Ens_LISReportResult、Ens_LISItemResult、Ens_LISItemSenResult、Ens_LISItemResRst
/// Input：LISRRowID:报告表rowid
/// Output:报告xml流
/// Debug:w ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetLISReportInfo("1").Read()
ClassMethod GetLISReportInfo(LISRRowID As %String = "") As %GlobalCharacterStream
{
	try
	{
	s ResponseObj=##class(web.DHCENS.STBLL.Method.Model.ReportRequest).%New()
	s obj=##class(web.DHCENS.STBLL.Method.Model.LISRptInfo).%New()
	s ReportData=$g(^Busi.ENS.EnsLISReportResultD(LISRRowID))
	s reportID=$lg(ReportData,2)
	s obj.LISRRReportID=reportID
	s patDr=$lg(ReportData,3)
	s:patDr'="" obj.LISRRPatientID=$p($g(^PAPER(patDr,"PAT",1)),"^",1)
	s obj.LISRREncounterTypeCode=$lg(ReportData,4)
	s obj.LISRRVisitNumber=$lg(ReportData,5)
	s obj.LISRRCollectDate=$lg(ReportData,48)
	s obj.LISRRCollectTime=$lg(ReportData,49)
	s obj.LISRRCollectUserCode=$lg(ReportData,50)
	s obj.LISRRCollectUserDesc=$lg(ReportData,51)
	s obj.LISRRCarryDate=$lg(ReportData,61)
	s obj.LISRRCarryTime=$lg(ReportData,62)
	s obj.LISRRCarryUserCode=$lg(ReportData,63)
	s obj.LISRRCarryUserDesc=$lg(ReportData,64)
	s obj.LISRRReceiveDate=$lg(ReportData,65)
	s obj.LISRRReceiveTime=$lg(ReportData,66)
	s obj.LISRRReceiveUserCode=$lg(ReportData,67)
	s obj.LISRRReceiveUserDesc=$lg(ReportData,68)
	s obj.LISRRSpecimenQuality=$lg(ReportData,69)
	s obj.LISRRReceiveNotes=$lg(ReportData,70)
	s obj.LISRRInStorageDate=$lg(ReportData,71)
	s obj.LISRRInStorageTime=$lg(ReportData,72)
	s obj.LISRRInStorageUserCode=$lg(ReportData,73)
	s obj.LISRRInStorageUserDesc=$lg(ReportData,74)
	s obj.LISRROutStorageDate=$lg(ReportData,75)
	s obj.LISRROutStorageTime=$lg(ReportData,76)
	s obj.LISRROutStorageUserCode=$lg(ReportData,77)
	s obj.LISRROutStorageUserDesc=$lg(ReportData,78)
	s obj.LISRROutStorageType=$lg(ReportData,79)
	s obj.LISRRAddDate=$lg(ReportData,80)
	s obj.LISRRAddTime=$lg(ReportData,81)
	s obj.LISRRAddUserCode=$lg(ReportData,82)
	s obj.LISRRAddUserDesc=$lg(ReportData,83)
	s obj.LISRRAddType=$lg(ReportData,84)
	s obj.LISRRArriveDate=$lg(ReportData,85)
	s obj.LISRRArriveTime=$lg(ReportData,86)
	s obj.LISRRArriveUserCode=$lg(ReportData,87)
	s obj.LISRRArriveUserDesc=$lg(ReportData,88)
	s obj.LISRRArriveWorkGroup=$lg(ReportData,89)
	s obj.LISRRMachineDate=$lg(ReportData,90)
	s obj.LISRRMachineTime=$lg(ReportData,91)
	s obj.LISRRTestDate=$lg(ReportData,92)
	s obj.LISRRTestTime=$lg(ReportData,93)
	s obj.LISRRCancelDate=$lg(ReportData,94)
	s obj.LISRRCancelTime=$lg(ReportData,95)
	s obj.LISRRCancelUserCode=$lg(ReportData,96)
	s obj.LISRRCancelUserDesc=$lg(ReportData,97)
	s obj.LISRRCancelReason=$lg(ReportData,98)
	s obj.LISRRReprotType=$lg(ReportData,101)
	s obj.LISRRRemarks=$lg(ReportData,102)
	s obj.LISRRISMcroorganism=$lg(ReportData,103)
	s obj.LISRRIdentifition=$lg(ReportData,106)
	s obj.LISRRCheckDate=$lg(ReportData,107)
	s obj.LISRRCheckTime=$lg(ReportData,108)
	s obj.LISRRCheckUserCode=$lg(ReportData,109)
	s obj.LISRRCheckUserDesc=$lg(ReportData,110)
	s obj.LISRRFirstCheckDate=$lg(ReportData,111)
	s obj.LISRRFirstCheckTime=$lg(ReportData,112)
	s obj.LISRRFirstCheckUserCode=$lg(ReportData,113)
	s obj.LISRRFirstCheckUserDesc=$lg(ReportData,114)
	s obj.LISRROrderItemDesc=$lg(ReportData,115)
	s obj.LISRRWarnCode=$lg(ReportData,116)
	s obj.LISRRStatus=$lg(ReportData,117)
	s obj.LISRRAuthType=$lg(ReportData,118)
	s obj.LISRRTransmitDate=$lg(ReportData,119)
	s obj.LISRRWorkGroupCode=$lg(ReportData,120)
	s obj.LISRRWorkGroupDesc=$lg(ReportData,121)
	s obj.LISRROrder=$lg(ReportData,122)
	s obj.LISRRSpecimenID=$lg(ReportData,123)
	s obj.LISRRAcceptDate=$lg(ReportData,125)
	s obj.LISRRAcceptTime=$lg(ReportData,126)
	s obj.LISRRAcceptUserCode=$lg(ReportData,127)
	s obj.LISRRAcceptUserDesc=$lg(ReportData,128)
	s obj.LISRRMainConclusion=$lg(ReportData,143)
	s obj.LISRRMinorConclusion=$lg(ReportData,144)
	s obj.LISRRSpecimenDesc=$lg(ReportData,147)
	if $d(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(reportID,"U")))
	{
		s lisItemID="" 
		for
		{
			s lisItemID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(reportID,"U"),lisItemID))
			q:lisItemID=""
			s lisItemResultID=""
			for
			{
				s lisItemResultID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",$zcvt(reportID,"U"),lisItemID,lisItemResultID))
				q:lisItemResultID=""	
				s lisItemObj=##class(web.DHCENS.STBLL.Method.Model.LISRItemResult).%New()
				s lisItemData=$g(^Busi.ENS.EnsLISItemResultD(lisItemResultID))
				s lisResultID=$lg(lisItemData,2)
				s lisItemObj.LISIRItemCode=$lg(lisItemData,6)
				s lisItemObj.LISIRItemDesc=$lg(lisItemData,7)
				s lisItemObj.LISIRResult=$lg(lisItemData,8)
				s lisItemObj.LISIRUnit=$lg(lisItemData,9)
				s lisItemObj.LISIRTextResult=$lg(lisItemData,10)
				s lisItemObj.LISIRExtraResult=$lg(lisItemData,11)
				s lisItemObj.LISIRResultExplain=$lg(lisItemData,12)
				s lisItemObj.LISIRAbnormalFlags=$lg(lisItemData,13)
				s lisItemObj.LISIRRanges=$lg(lisItemData,14)
				s lisItemObj.LISIRTestMethod=$lg(lisItemData,15)
				s lisItemObj.LISIRTestMachine=$lg(lisItemData,16)
				s lisItemObj.LISIRTestUserCode=$lg(lisItemData,17)
				s lisItemObj.LISIRTestUserDesc=$lg(lisItemData,18)
				s lisItemObj.LISIRShowSeq=$lg(lisItemData,19)
				s lisItemObj.LISIRTestDate=$lg(lisItemData,20)
				s lisItemObj.LISIRTestTime=$lg(lisItemData,21)
				s lisItemObj.LISIRCount=$lg(lisItemData,22)
				s lisItemObj.LISIRExpertRule=$lg(lisItemData,23)
				s lisItemObj.LISIRRemark=$lg(lisItemData,24)
				s lisItemObj.LISIRInterCode=$lg(lisItemData,27)
				s lisItemObj.LISIROrderItemID=$lg(lisItemData,28)
				s lisItemObj.LISIRAssayStatus=$lg(lisItemData,29)
				s lisItemObj.LISIRReAssayNum=$lg(lisItemData,30)
				s lisItemObj.LISIRResClass=$lg(lisItemData,31)
				s lisItemObj.LISIROrganism=$lg(lisItemData,32)
				s lisItemObj.LISIRReAssayNumber=$lg(lisItemData,33)
				s lisItemObj.LISIRMultipleResistant=$lg(lisItemData,34)
				d obj.LISItemResultList.Insert(lisItemObj)
			}
		}	
		if $d(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",lisResultID))
		{
		s lisItemAnt="" 
		for
		{	
			s lisItemAnt=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",lisResultID,lisItemAnt))
			q:lisItemAnt=""
			s lisItemSenID=""
			for
			{
				s lisItemSenID=$o(^Busi.ENS.EnsLISItemSenResultI("PKHIPUSERLISITEMSENRESULT",lisResultID,lisItemAnt,lisItemSenID))
				q:lisItemSenID=""
				s lisItemSenObj=##class(web.DHCENS.STBLL.Method.Model.LISRItemSenResult).%New()
				s lisItemSenData=$g(^Busi.ENS.EnsLISItemSenResultD(lisItemSenID))
				s lisItemSenObj.LISISRAntibioticsCode=$lg(lisItemSenData,3)
				s lisItemSenObj.LISISRAntibioticsDesc=$lg(lisItemSenData,4)
				s lisItemSenObj.LISISRResult=$lg(lisItemSenData,5)
				s lisItemSenObj.LISISRSensitivityCode=$lg(lisItemSenData,6)
				s lisItemSenObj.LISISRSensitivityDesc=$lg(lisItemSenData,7)
				s lisItemSenObj.LISISRIRanges=$lg(lisItemSenData,8)
				s lisItemSenObj.LISISRSRanges=$lg(lisItemSenData,9)
				s lisItemSenObj.LISISRRRanges=$lg(lisItemSenData,10)
				s lisItemSenObj.LISISRShowSeq=$lg(lisItemSenData,11)
				s lisItemSenObj.LISISRMethod=$lg(lisItemSenData,12)
				s lisItemSenObj.LISISRSuggestion=$lg(lisItemSenData,13)
				s lisItemSenObj.LISISRFlag=$lg(lisItemSenData,14)
				s lisItemSenObj.LISISRAntibioticsClassID=$lg(lisItemSenData,15)
				s lisItemSenObj.LISISRAntibioticsClassDesc=$lg(lisItemSenData,16)
				d lisItemObj.LISItemSenResultList.Insert(lisItemSenObj)
			}
			}
		}
		if $d(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",lisResultID))
		{
			s lisItemRstId="" 
			for
			{
				s lisItemRstId=$o(^Busi.ENS.EnsLISItemResRstI("IndexResultRstItem",lisResultID,lisItemRstId))
				q:lisItemRstId=""
				s lisItemRstObj=##class(web.DHCENS.STBLL.Method.Model.LISItemResRst).%New()
				s lisItemRstData=$g(^Busi.ENS.EnsLISItemResRstD(lisItemRstId))
				s lisItemRstObj.LISIRRItemCode=$lg($g(lisItemRstData,2))
				s lisItemRstObj.LISIRRItemDesc=$lg($g(lisItemRstData,3))
				s lisItemRstObj.LISIRRResult=$lg($g(lisItemRstData,4))
				s lisItemRstObj.LISIRRShowSeq=$lg($g(lisItemRstData,5))
				d lisItemObj.LISItemResRst.Insert(lisItemRstObj)	
			}
		}
	}
	s Body=##class(web.DHCENS.STBLL.Method.Model.Respbody).%New()
	s Body.LISReport=obj
	s ResponseObj.Respbody=Body
	s Header=##class(web.DHCENS.STBLL.Method.Model.Header).%New()
	s Header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	s Header.SourceSystem="SYS0001"
	s ResponseObj.header=Header
	s stream=##class(%Stream.GlobalCharacter).%New()
	d ResponseObj.XMLExportToStream(.stream)
	}
	catch
	{
		s stream=##class(%Stream.GlobalCharacter).%New()
		s $zt=""	
	}
	q stream
}

}
