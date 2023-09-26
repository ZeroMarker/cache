Class web.udhcOPHandinIF Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 80;

ClassMethod GetDate(hUser As %String, EndDate As %String, ExpStr As %String) As %String
{
	n (hUser, EndDate, ExpStr)
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;s myrtn=##class(web.udhcOPHandin).GetDate(hUser, EndDate)
		s myrtn=##class(web.udhcOPHandin0).GetDate(hUser, EndDate)
	}elseif(+myVer=1){
		s myrtn=##class(web.udhcOPHandin1).GetDate(hUser, EndDate)
	}elseif(+myVer=3){
		;大同
		s myrtn=##class(web.udhcOPHandin3).GetDate(hUser, EndDate)
	}elseif(+myVer=4){
		s myrtn=##class(web.udhcOPHandin4).GetDate(hUser, EndDate)
	}elseif(+myVer=7){
		s myrtn=##class(web.udhcOPHandin7).GetDate(hUser, EndDate)
	}elseif(+myVer=12){
		s myrtn=##class(web.udhcOPHandin7).GetDate(hUser, EndDate)
	}
	else{
		s myClsName="web.udhcOPHandin"_myVer
		s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"GetDate")
		if (myflag)
		{
			s myrtn= $ZOBJCLASSMETHOD(myClsName, "GetDate", hUser, EndDate)
		}
		//s myrtn=##class(web.udhcOPHandin).GetDate(hUser, EndDate)
	}
	
	q myrtn
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String, ExpStr As %String)
{
	n (itmjs, itmjsex, hUser, ExpStr)
	;w ##class(web.udhcOPHandinIF).GetHandin("","","148","")
	
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	b
	
	if (+myVer=0){
		;s myrtn=##class(web.udhcOPHandin).GetHandin(itmjs,itmjsex,hUser)
		s myrtn=##class(web.udhcOPHandin0).GetHandin(itmjs,itmjsex,hUser)
	}elseif(+myVer=1){
		s myrtn=##class(web.udhcOPHandin1).GetHandin(itmjs,itmjsex,hUser)
	}elseif(+myVer=3){
		;大同
		s myrtn=##class(web.udhcOPHandin3).GetHandin(itmjs,itmjsex,hUser)
	}elseif(+myVer=4){
		s myrtn=##class(web.udhcOPHandin4).GetHandin(itmjs,itmjsex,hUser)
	}elseif(+myVer=5){
		s myrtn=##class(web.udhcOPHandin5).GetHandin(itmjs,itmjsex,hUser)
	}elseif(+myVer=6){
		s myrtn=##class(web.udhcOPHandin6).GetHandin(itmjs,itmjsex,hUser)
	//}elseif(+myVer=7){
	//	//华西一院
	//	s myrtn=##class(web.udhcOPHandin7).GetHandin(itmjs,itmjsex,hUser)
	}else{
		s myClsName="web.udhcOPHandin"_myVer
		s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"GetHandin")
		if (myflag)
		{
			s myrtn= $ZOBJCLASSMETHOD(myClsName, "GetHandin", itmjs,itmjsex,hUser)
		}
		//s myrtn=##class(web.udhcOPHandin).GetHandin(itmjs,itmjsex,hUser)
	}
	q myrtn
}

ClassMethod Handin(sUser As %String, FootInfo As %String, ExpStr As %String) As %String
{
	n (sUser, FootInfo, ExpStr)
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;s myrtn=##class(web.udhcOPHandin).Handin(sUser, FootInfo)
		s myrtn=##class(web.udhcOPHandin0).Handin(sUser, FootInfo)
	}elseif(+myVer=1){
		s myrtn=##class(web.udhcOPHandin1).Handin(sUser, FootInfo)
	}elseif(+myVer=3){
		;大同
		s myrtn=##class(web.udhcOPHandin3).Handin(sUser, FootInfo)
	}elseif(+myVer=4){
		s myrtn=##class(web.udhcOPHandin4).Handin(sUser, FootInfo)
	}elseif(+myVer=5){
		s myrtn=##class(web.udhcOPHandin5).Handin(sUser, FootInfo)
	}elseif(+myVer=6){
		s myrtn=##class(web.udhcOPHandin6).Handin(sUser, FootInfo)
	//}elseif(+myVer=7){
	//	//华西一院
	//	s myrtn=##class(web.udhcOPHandin7).Handin(sUser, FootInfo)
	}else{
		s myClsName="web.udhcOPHandin"_myVer
		s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"Handin")
		if (myflag)
		{
			s myrtn= $ZOBJCLASSMETHOD(myClsName, "Handin", sUser, FootInfo)
		}
		//s myrtn=##class(web.udhcOPHandin).Handin(sUser, FootInfo)
	}
	q myrtn
}

ClassMethod SaveReportsData(sUser As %String, FootInfo As %String, ReportsXmlData As %String, CatXmlData As %String, ExpStr As %String) As %String
{
	;INVPRTPayModeXml As %String, PDXmlData As %String, APIXmlData As %String, CardXmlData As %String,
	;n (sUser, FootInfo, ExpStr)
	;INVPRTPayModeXml, PDXmlData, APIXmlData, CardXmlData,
	n (sUser, FootInfo, ReportsXmlData,  CatXmlData, ExpStr)
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;s myrtn=##class(web.udhcOPHandin).Handin(sUser, FootInfo)
		s myrtn=##class(web.udhcOPHandin0).Handin(sUser, FootInfo)
	//}elseif(+myVer=7){
	//	//华西一院
	//	s myrtn=##class(web.udhcOPHandin7).Handin(sUser, FootInfo)
	}else{
		s myClsName="web.udhcOPHandin"_myVer
		s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"Handin")
		if (myflag)
		{
			
			s myrtn= $ZOBJCLASSMETHOD(myClsName, "Handin", sUser, FootInfo, ReportsXmlData,  CatXmlData)
		}
	}
	q myrtn
}

ClassMethod ReadReportsDataByRowID(itmjs As %Library.String = "", itmjsex As %Library.String = "", ReportRowID As %String, ExpStr As %String) As %String
{
	n (itmjs, itmjsex, ReportRowID, ExpStr)
	s myrtn=0
	
	s myrtn=##class(web.udhcOPHandRepCommon).ReadReportsDataByRowID(itmjs, itmjsex, ReportRowID)
	q myrtn
}

ClassMethod CancelReportsByRowID(ReportRowID As %String, ExpStr As %String) As %String
{
	;w ##class(web.udhcOPHandinIF).CancelReportsByRowID(1,"")
	n (ReportRowID, ExpStr)
	s myrtn=0
	s myrtn=##class(web.udhcOPHandRepCommon).CancelReportsByRowID(ReportRowID)
	
	q myrtn
}

/// 排序 发票信息
ClassMethod CompositorINVInfo(INVInfo As %String, CompositorMode As %String, ExpStr As %String) As %String
{
	;CompositorMode = Desc, Asc
	;##class(web.udhcOPHandinIF).CompositorINVInfo(INVInfo, CompositorMode, ExpStr)
	n (INVInfo, CompositorMode, ExpStr)
	s myrtn=""
	
	s myrtn=##class(web.udhcOPHandin7).CompositorINVInfo(INVInfo, CompositorMode, ExpStr)
	
	q myrtn
}

ClassMethod GetReportDataByRowIDPrint(ReportRowID As %String) As %String
{
	;Cell
	;List
	;1^2^报表值$c(1)^^$c(2)^^^^^^$(1)^^^^^^^
	n (ReportRowID)
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	s myClsName="web.udhcOPHandin"_myVer
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"GetReportDataByRowIDPrint")
	if (myflag)
	{
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "GetReportDataByRowIDPrint", ReportRowID)
	}
	q myrtn
}

/// 重新计算报表
ClassMethod ReCalculateRep(RepRowID As %String, ExpStr As %String) As %String
{
	;w ##class(web.udhcOPHandinIF).ReCalculateRep(1, "")
	n (RepRowID, ExpStr)
	
	s myrtn=0
	
	s myrtn=##class(web.udhcOPHandin7).ReCalculateRep(RepRowID)
	
	q myrtn
}

ClassMethod ReportRSOut(itmjsex As %String, INVObj As %ObjectHandle) As %String
{
	;w ##class(web.udhcOPHandinIF).ReportRSOut("",INVObj)
	n (itmjsex, INVObj)
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	s myClsName="web.udhcOPHandin"_myVer
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"ReportRSOut")
	if (myflag)
	{
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "ReportRSOut", itmjsex, INVObj)
	}
	
	q myrtn
}

ClassMethod ReportXmlOut(itmjs As %String, INVObj As %ObjectHandle) As %String
{
	n (itmjs, INVObj)
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	s myClsName="web.udhcOPHandin"_myVer
	s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"ReportXmlOut")
	if (myflag)
	{
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "ReportXmlOut", itmjs, INVObj)
	}
	
	q myrtn
}

}
