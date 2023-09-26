Class DHCENS.BC.GetPatList Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "GetPatListReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

Property PatLists As list Of DHCENS.BC.PatList;

/// 通过不同卡类型获取病人列表。当卡类型为空的时候，
/// 默认按照接受科室进行查询。医嘱状态主要使用：审核（V），执行（E），全部（A）。
/// 审核表示医嘱尚未执行，病人还没有接收科室登记；执行表示病人已经在接收科室登记，进行检查；
/// 全部表示时间段内，这个接收科室的所有医嘱信息。
/// 卡类型 1 医嘱号 2 登记号 3 卡号
ClassMethod GetPatList(CardValue As %String, CardTypes As %String, StartDate As %String, EndDate As %String, ExeLoc As %String, Status As %String) As %GlobalCharacterStream
{
	s objStream=##class(%GlobalCharacterStream).%New()
	
	if (CardTypes="1")
	{	
		s objStream=##class(DHCENS.BC.GetPatList).GetPatListByOrder(CardValue)
	}
	if (CardTypes="2")
	{
		s objStream=##class(DHCENS.BC.GetPatList).GetPatListByPatID(CardValue,StartDate,EndDate,ExeLoc,Status)
	}
	if (CardTypes="3")
	{
		s objStream=##class(DHCENS.BC.GetPatList).GetPatListByCardNo(CardValue,StartDate,EndDate,ExeLoc,Status)
	}
	if (CardTypes'="1")&&(CardTypes'="2")&&(CardTypes'="3")
	{
		s objStream=##class(DHCENS.BC.GetPatList).GetPatListByCtLoc(ExeLoc,StartDate,EndDate,Status)
	}
	
	q objStream
}

ClassMethod GetPatListByOrder(OrdRowid As %String) As %GlobalCharacterStream
{
	s MainObj=##class(DHCENS.BC.GetPatList).%New()
    s OrdRowid=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrdRowid,"_","||")
    i (OrdRowid'="")
    {
		//检查医嘱是否存在
		s flag=$d(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2)))
		i (flag=0)
		{
			s MainObj.ResultCode="-1"
			s MainObj.ResultContent="医嘱不存在"
		}
		else
		{
			s insObj=##class(DHCENS.BC.PatList).PatList(OrdRowid)
			d MainObj.PatLists.Insert(insObj)
			s MainObj.ResultCode="0"
			s MainObj.ResultContent="成功"
		}
	}
	else
	{
		s MainObj.ResultCode="-1"
		s MainObj.ResultContent="卡类型为1时卡值不能为空"
	}
	d MainObj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<Response>")
	d objStream.CopyFrom(Xml)
	d objStream.Write("</Response>")
	q objStream
}

ClassMethod GetPatListByPatID(RegisterNo As %String, StartDate As %String, EndDate As %String, ExeLoc As %String, Status As %String) As %GlobalCharacterStream
{

	s MainObj=##class(DHCENS.BC.GetPatList).%New()
	
	if (StartDate="")||(EndDate="")||(ExeLoc="")||(Status="")
	{
		s MainObj.ResultCode="-1"
		s MainObj.ResultContent="时间、科室、状态不能为空"
	}
	else
	{
		s StartDate=$zdh(StartDate,3)
		s EndDate=$zdh(EndDate,3)
		
		for tmpDate=StartDate:1:EndDate
		{
			s OeRowId="" f  s OeRowId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId))  q:OeRowId=""  d
			.s SubId="" f  s SubId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId,SubId))  q:SubId=""  d
			..s ordid=OeRowId_"||"_SubId
			..s OrdCate=##class(DHCENS.Method.BaseMethod).GetOrderCateBy(ordid)
			..q:OrdCate'="检查"
			..s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
			..s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
			..q:(tmpOrderStatus'=Status)&&(Status'="A")
			..s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",6)
			..i DeptDr'="" d
			...s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
			..e  d
			...s DeptCode=""
			
			..s tmpRegisterNo=##class(DHCENS.Method.BaseMethod).GetPatNoByOrderID(ordid)
			..q:(RegisterNo'="")&&(RegisterNo'=tmpRegisterNo)	
			..q:($p(ExeLoc,"@",1)'=DeptCode)
			..s insObj=##class(DHCENS.BC.PatList).PatList(ordid)
			..d MainObj.PatLists.Insert(insObj)
		}
		s MainObj.ResultCode="0"
		s MainObj.ResultContent="成功"
	}
	d MainObj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

ClassMethod GetPatListByCardNo(CardNo As %String, StartDate As %String, EndDate As %String, ExeLoc As %String, Status As %String) As %GlobalCharacterStream
{
	s RegisterNo=##class(DHCENS.Method.BaseMethod).GetPatNoByCardNo(CardNo)
	s objStream=..GetPatListByPatID(RegisterNo,StartDate,EndDate,ExeLoc,Status)
	q objStream
}

ClassMethod GetPatListByCtLoc(ExeLoc As %String, StartDate As %String, EndDate As %String, Status As %String) As %String
{
	s MainObj=##class(DHCENS.BC.GetPatList).%New()
	
	if (StartDate="")||(EndDate="")||(ExeLoc="")||(Status="")
	{
		s MainObj.ResultCode="-1"
		s MainObj.ResultContent="时间、科室、状态不能为空"
	}
	else
	{
		s StartDate=$zdh(StartDate,3)
		s EndDate=$zdh(EndDate,3)

	  for tmpDate=StartDate:1:EndDate
	  {
		s OeRowId="" f  s OeRowId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId))  q:OeRowId=""  d
		.s SubId="" f  s SubId=$o(^OEORDi(0,"ItemDate",tmpDate,OeRowId,SubId))  q:SubId=""  d
		..s ordid=OeRowId_"||"_SubId
		..s OrdCate=##class(DHCENS.Method.BaseMethod).GetOrderCateBy(ordid)
	    ..q:OrdCate'="检查"
		..s OrderStatusDr=$p($g(^OEORD(OeRowId,"I",SubId,1)),"^",13)
		..s tmpOrderStatus=$p($g(^OEC("OSTAT",OrderStatusDr)),"^",1)
		..q:(tmpOrderStatus'=Status)&&(Status'="A")
		..s DeptDr=$p($g(^OEORD(OeRowId,"I",SubId,3)),"^",6)
		..i DeptDr'="" d
		...s DeptCode=$p($g(^CTLOC(DeptDr)),"^",1)
		..e  d
		...s DeptCode=""
		..s tmpRegisterNo=##class(DHCENS.Method.BaseMethod).GetPatNoByOrderID(ordid)
		..q:($p(ExeLoc,"@",1)'=DeptCode)
		..s insObj=##class(DHCENS.BC.PatList).PatList(ordid)
		..d MainObj.PatLists.Insert(insObj)
	  }
	   s MainObj.ResultCode="0"
	   s MainObj.ResultContent="成功"
	}
	d MainObj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

}
