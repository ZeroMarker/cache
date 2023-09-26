Import SQLUser

/// 创建时间		：2007.03.27
/// 创建人			：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			: 
/// 主要功能		：将体检结果输出为xml形式
/// 主要功能		：获取信息见 web.DHCPE.ReportGetInfor
/// 最后修改时间	：
/// 最后修改人		：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.ReportOutToXML Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

/// 输出患者信息
/// d ##Class(web.DHCPE.ReportOutToXML).OutPatientToXML()
ClassMethod OutPatientToXML(PAAdmRowid As %String)
{
	d ##Class(web.DHCPE.ReportGetInfor).GetPatient(PAAdmRowid)
 	w "<xml id=xmlPatInfo>",!
 	w "<DHCPEReport>",!
 	w "	<PatInfo>",!
	
	s Field=""
	f  s Field=$O(^TMPReport("PatInfo",Field)) Q:(""=Field)  d
	.w "  <"_Field_">"_$G(^TMPReport("PatInfo",Field))_"</"_Field_">",!
 	
 	w " </PatInfo>",!
 	w "</DHCPEReport>",!
 	w "</xml>",!
}

/// d ##Class(web.DHCPE.ReportOutToXML).OutResultToXML("5747947")
/// 输出检验检查结果
ClassMethod OutResultToXML(PAAdmRowid As %String)
{
	d ##Class(web.DHCPE.ReportGetInfor).GetReportResult(PAAdmRowid)
	w "<xml id=xmlReport>",!
	w "<Report>",!
	w "<ReportList>",!
	
	s ARCIM=""
	f  s ARCIM=$O(^TMPReport("Result", "ARCIM", ARCIM)) Q:(""=ARCIM)  d
	.s CurData=$G(^TMPReport("Result", "ARCIM", ARCIM))
	.
	.w "<DHCPEReport>",!
	.w "<ARCIMDesc>"_$P(CurData,"^",1)_"</ARCIMDesc>",!
	.w "<Checker>"_$P(CurData,"^",2)_"</Checker>",!
	.w "<TestDate>"_$P(CurData,"^",3)_"</TestDate>",!
	.s ReportFormat=$P(CurData,"^",4)
	.w "<ReportFormat>"_ReportFormat_"</ReportFormat>",!
	.w "<Result>",!
	.//b // w ReportFormat
	.d:(ReportFormat["LIS") ..OutLISDataToXML(ARCIM)
	.d:(ReportFormat["NOR") ..OutNORDataToXML(ARCIM)
	.d:(ReportFormat["RIS") ..OutRISDataToXML(ARCIM)
	.w " </Result>",!
	.
	.w "</DHCPEReport>",!
	.
	
	w "</ReportList>",!
	w "</Report>",!
	w "</xml>",!
}

/// d ##Class(web.DHCPE.ReportOutToXML).OutNORDataToXML("5152818||5")
ClassMethod OutNORDataToXML(ARCIM As %String)
{
	s ODID=""
	f  s ODID=$O(^TMPReport("Result", "Content",ARCIM,ODID)) Q:(""=ODID)  d
	.
	.s CurData=$g(^TMPReport("Result", "Content",ARCIM,ODID))
	.w " <Value>",!
	.w "  <TestName>"_$P(CurData,"^",1)_"</TestName>",!
	.w "  <TestValue>"_$P(CurData,"^",2)_"</TestValue>",!
	.w "  <Normal>"_$P(CurData,"^",3)_"</Normal>",!
	.w " </Value>",!
}

/// d ##Class(web.DHCPE.ReportOutToXML).OutLISDataToXML()
ClassMethod OutLISDataToXML(ARCIM As %String)
{
	s ODID=""
	f  s ODID=$O(^TMPReport("Result", "Content",ARCIM,ODID)) Q:(""=ODID)  d
	.s CurData=$g(^TMPReport("Result", "Content",ARCIM,ODID))
	.w " <Value>",!
	.w "  <TestName>"_$P(CurData,"^",1)_"</TestName>",!
	.w "  <TestValue>"_$P(CurData,"^",2)_"</TestValue>",!
	.w "  <Normal>"_$P(CurData,"^",3)_"</Normal>",!
	.w "  <TestUnit>"_$P(CurData,"^",4)_"</TestUnit>",!
	.w "  <Standard>"_$P(CurData,"^",5)_"</Standard>",!
	.w " </Value>",!
}

ClassMethod OutRISDataToXML(ARCIM As %String)
{
	s ODID=""
	f  s OD=$O(^TMPReport("Result", "Content", ARCIM,OD)) Q:(""=OD)  d
	.s CurData=$g(^TMPReport("Result", "Content", ARCIM,OD))
	.w " <Value>",!
	.w "  <TestName>"_$P(CurData,"^",1)_"</TestName>",!
	.w "  <TestValue>"_$P(CurData,"^",2)_"</TestValue>",!
	.w "  <Normal>"_$P(CurData,"^",3)_"</Normal>",!
	.w " </Value>",!
}

/// d ##Class(web.DHCPE.ReportOutToXML).OutSummarizeToXML()
ClassMethod OutSummarizeToXML(PAAdmRowid As %String)
{
	d ##Class(web.DHCPE.ReportGetInfor).GetSummarize(PAAdmRowid)
 	w "<xml id=xmlSummarize>",!
 	w "<Report>",!
 	w " <SummarizeList>",!
	
	i 10=$D(^TMPReport("Summarize")) d
	.s sid=""
	.f  s sid=$O(^TMPReport("Summarize", "Station", sid)) Q:(""=sid)  d
	..s sDesc=$G(^TMPReport("Summarize", "Station", sid))
	..Q:(""=sDesc)
	..w " <Summarize>",!
	..w "  <Station>"_sDesc_"</Station>",!
	..w "  <Desc>"_"<![CDATA["_$G(^TMPReport("Summarize", "Content", sDesc))_"]]>"_"</Desc>",!
	..w "  <AduitUser>"_$G(^TMPReport("Summarize", "Content", sDesc, "AduitUser"))_"</AduitUser>",!
	..w "  <AduitDate>"_$G(^TMPReport("Summarize", "Content", sDesc, "AduitDate"))_"</AduitDate>",!
	..w " </Summarize>",!
 	
 	w " </SummarizeList>",!
 	w "</Report>",!
 	w "</xml>",!
}

/// d ##Class(web.DHCPE.ReportOutToXML).OutGeneralAdviceToXML(5747947)
ClassMethod OutGeneralAdviceToXML(PAAdmRowid As %String)
{

	d ##Class(web.DHCPE.ReportGetInfor).GetGeneralAdvice(PAAdmRowid)
 	w "<xml id=xmlGeneralAdvice>",!
 	w "<Report>",!
 	w "	<GeneralAdvice>",!
	w "<Caption>建议:</Caption>"
	w "  <AduitUser>"_$G(^TMPReport("GeneralAdvice", "AduitUser"))_"</AduitUser>",!
	w "  <AduitDate>"_$G(^TMPReport("GeneralAdvice", "AduitDate"))_"</AduitDate>",!
	w "  <Advice>"_"<![CDATA["_$G(^TMPReport("GeneralAdvice", "Advice"))_"]]>"_"</Advice>",!
 	
 	w " </GeneralAdvice>",!
 	w "</Report>",!
 	w "</xml>",!
}

}
