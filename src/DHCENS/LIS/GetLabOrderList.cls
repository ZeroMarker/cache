Class DHCENS.LIS.GetLabOrderList Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "GetLabOrderListReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

Property OrderLists As list Of DHCENS.LIS.OrderList;

/// 根据患者的登记号和日期范围，得到检验医嘱列表，
/// 连同采血材料费在内。其中日期范围解释：对于住院，
/// 取出该日期范围内的医嘱；对于门诊，该日期范围内的多次就诊中的医嘱
/// 如果登记号为空则按开单科室查询该科室所有的检验医嘱（住院用）
/// EpsiodeType:I--住院O—门诊E—急诊
/// w ##class(DHCENS.LIS.GetLabOrderList).GetLabOrderList("","2010-01-01","2010-07-01","I","V","130401")
ClassMethod GetLabOrderList(CardNo As %String, RegisterNo As %String, StartDate As %String, EndDate As %String, EpsiodeType As %String, OrderStatus As %String, OrderDept As %String) As DHCENS.LIS.GetLabOrderList
{
	;s ^tmp("insu")=RegisterNo_"^"_StartDate_"^"_EndDate_"^"_EpsiodeType_"^"_OrderStatus_"^"_OrderDept
	s MainObj=##class(DHCENS.LIS.GetLabOrderList).%New()
	
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	
	if (CardNo'="")
	{
		set PatRowid=##class(DHCENS.LIS.GetPatInfo).GetPatIdByCardNo(CardNo,"1")
		set RegisterNo=$p(^PAPER(PatRowid,"PAT",1),"^",2)
	}
	
	//门诊急诊病人
	if ((EpsiodeType="E")||(EpsiodeType="O"))
	{
		if (RegisterNo'="")
		{
			for tmpDate=StartDate:1:EndDate
			{
				s OeRowId="" f  s OeRowId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId))  q:OeRowId=""  d
				.s SubId="" f  s SubId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId,SubId))  q:SubId=""  d
				..s ordid=OeRowId_"||"_SubId
				..s tmpOrderCate=##class(DHCENS.Method.BaseMethod).GetOrderCateBy(ordid)
				..q:tmpOrderCate'="检验"
				..s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
				..s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
				..q:tmpOrderStatus'=OrderStatus
				..s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",3)
				..i DeptDr'="" d
				...s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
				..e  d
				...s DeptCode=""
				..s tmpRegisterNo=##class(DHCENS.Method.BaseMethod).GetPatNoByOrderID(ordid)
				..q:(RegisterNo'="")&&(RegisterNo'=tmpRegisterNo)	
				..s insObj=##class(DHCENS.LIS.OrderList).GetOrderInfo(ordid)
				..d MainObj.OrderLists.Insert(insObj)
			}
		}
	}
	
	//住院病人
	if (EpsiodeType="I")
	{
		for tmpDate=StartDate:1:EndDate
		{
			s OeRowId="" f  s OeRowId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId))  q:OeRowId=""  d
			.s SubId="" f  s SubId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId,SubId))  q:SubId=""  d
			..s ordid=OeRowId_"||"_SubId
			..s tmpOrderCate=##class(DHCENS.Method.BaseMethod).GetOrderCateBy(ordid)
			..q:tmpOrderCate'="检验"
			..s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
			..s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
			..q:tmpOrderStatus'=OrderStatus
			..s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",3)
			..i DeptDr'="" d
			...s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
			..e  d
			...s DeptCode=""
			..s tmpRegisterNo=##class(DHCENS.Method.BaseMethod).GetPatNoByOrderID(ordid)
			..q:(RegisterNo'="")&&(RegisterNo'=tmpRegisterNo)	
			..q:($p(OrderDept,"@",1)'=DeptCode)
			..s insObj=##class(DHCENS.LIS.OrderList).GetOrderInfo(ordid)
			..d MainObj.OrderLists.Insert(insObj)
		}
	}
	
	s MainObj.ResultCode="0"
	s MainObj.ResultContent="成功!"
	d MainObj.XMLExportToStream(.Xml)
	
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
    q objStream
}

}
