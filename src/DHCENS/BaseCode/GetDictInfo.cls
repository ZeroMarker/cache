Class DHCENS.BaseCode.GetDictInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "GetDictInfoReturn";

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

Property DictLists As list Of DHCENS.BaseCode.DictList;

/// 0科室1病区2人员
ClassMethod GetDictInfo(DicCat As %String) As %String
{
	s objStream=##class(%GlobalCharacterStream).%New()
	
	if (DicCat="0")
	{
		s objStream=..GetLocInfo("E")
	}
	elseif (DicCat="1")
	{
		s objStream=..GetLocInfo("W")
	}
	elseif (DicCat="2")
	{
		s objStream=..GetUserInfo("")
	}
	elseif ($p(DicCat,"@",1)="3")
	{
		s objStream=..GetOrderInfo(DicCat)
	}
	else
	{
		d objStream.Write("<Response><GetDictInfoReturn><ResultCode>-1</ResultCode><ResultContent>请输入正确的分类信息</ResultContent></GetDictInfoReturn></Response>")
	}
	q objStream
}

/// 得到科室信息
ClassMethod GetLocInfo(type As %String) As %GlobalCharacterStream
{
	s MainObj=##class(DHCENS.BaseCode.GetDictInfo).%New()
	if (type'="")
	{
		s rowid="" f  s rowid=$o(^CTLOC(0,"LocType",type,rowid)) q:rowid=""  d
		.s insObj=##class(DHCENS.BaseCode.DictList).%New()
		.s insObj.Code=$p($g(^CTLOC(rowid)),"^",1)
		.s insObj.Desc=$p($p($g(^CTLOC(rowid)),"^",2),"-",2)
		.s insObj.Alias=$p($p($g(^CTLOC(rowid)),"^",2),"-",1)
		.d MainObj.DictLists.Insert(insObj)
		s MainObj.ResultCode="0"
		s MainObj.ResultContent="成功"
		d MainObj.XMLExportToStream(.Xml)
	}
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

/// 得到用户信息
ClassMethod GetUserInfo(type As %String) As %GlobalCharacterStream
{
	s MainObj=##class(DHCENS.BaseCode.GetDictInfo).%New()
	s RowId="" f  s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
	.s insObj=##class(DHCENS.BaseCode.DictList).%New()
	.s insObj.Code=$p($g(^SSU("SSUSR",RowId)),"^",1)
	.s insObj.Desc=$p($g(^SSU("SSUSR",RowId)),"^",2)
	.s insObj.Alias=""
	.d MainObj.DictLists.Insert(insObj)
	s MainObj.ResultCode="0"
	s MainObj.ResultContent="成功"
	d MainObj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

/// 根据传入的医嘱类型，得到该类型下的所有医嘱名称。如果类型为空，则查询所有医嘱名称。
ClassMethod GetOrderInfo(type As %String) As %GlobalCharacterStream
{
	s OrdType=$P(type,"@",2)
	s MainObj=##class(DHCENS.BaseCode.GetDictInfo).%New()
	s ArmSub=""
	f  s ArmSub=$O(^ARCIM(ArmSub)) Q:ArmSub=""  do
	.s ArmVer=""
	.f  s ArmVer=$O(^ARCIM(ArmSub,ArmVer)) Q:ArmVer=""  do
	..s OrdCate=..GetOrdCateByArmid(ArmSub,ArmVer)
	..q:(OrdCate'=OrdType)
	..s insObj=##class(DHCENS.BaseCode.DictList).%New()
	..s insObj.Code=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1)
	..s insObj.Desc=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2)
	..s insObj.Alias=""
	..d MainObj.DictLists.Insert(insObj)
	
	s MainObj.ResultCode="0"
	s MainObj.ResultContent="成功"
	d MainObj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

ClassMethod GetOrdCateByArmid(ArmSub As %Integer, ArmVer As %Integer) As %String
{
	s OrderCate=""
	s ItemCatDr=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",10)
	i (ItemCatDr'="")
	{
		s OrderCateDr=$p($g(^ARC("IC",ItemCatDr)),"^",8)	
		i (OrderCateDr'="")
		{
			s OrderCate=$p($g(^OEC("ORCAT",OrderCateDr)),"^",2)
		}
	}
	Quit OrderCate
}

}
