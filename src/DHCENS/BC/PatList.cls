Class DHCENS.BC.PatList Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "PatListReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 医嘱号
Property Rowid As %String(TRUNCATE = 1);

/// 开单日期
Property StartRowidDate As %String(TRUNCATE = 1);

/// 送检科室
Property Loc As %String(TRUNCATE = 1);

/// 状态
Property Status As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 医嘱名称
Property OrdName As %String(TRUNCATE = 1);

/// 收费状态
Property BillStatus As %String(TRUNCATE = 1);

/// 就诊号
Property AdmNo As %String(TRUNCATE = 1);

ClassMethod PatList(OrdID As %String) As DHCENS.BC.PatList
{
	s obj=##class(DHCENS.BC.PatList).%New()
	
	s obj.Rowid=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrdID,"||","_")
	s obj.AdmNo=$p($g(^OEORD(+OrdID)),"^",1)
	s PapatDr=$p($g(^PAADM(obj.AdmNo)),"^",1)
	
	if (PapatDr'="")
	{
		s obj.RegNo=$p($g(^PAPER(PapatDr,"PAT",1)),"^",1)
		s obj.Name=$p($g(^PAPER(PapatDr,"ALL")),"^",1)
		s Dob=$p($g(^PAPER(PapatDr,"ALL")),"^",6)
		if (Dob'="")
		{
			s obj.Age=##class(DHCENS.Method.BaseMethod).GetAgeByPatid(PapatDr)
		}
		s SexDr=$p($g(^PAPER(PapatDr,"ALL")),"^",7)
		if (SexDr'="")
		{
			s obj.Sex=$p($g(^CT("SEX",SexDr)),"^",1)_"@"_$p($g(^CT("SEX",SexDr)),"^",2)
		}
	}
	s obj.StartRowidDate=$zd($p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",7),3)
	s OrderRecDepDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
	i (OrderRecDepDr'="")
	{ 
		s obj.Loc=$p($g(^CTLOC(OrderRecDepDr)),"^",1)_"@"_$p($g(^CTLOC(OrderRecDepDr)),"^",2)
	}
	s obj.Status=##class(DHCENS.Method.BaseMethod).GetOrderStatus(OrdID)	
	
	s ArcimID=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",2)
	i (ArcimID'="")
	{
		s obj.OrdName=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	}
	s obj.BillStatus=##class(DHCENS.Method.BaseMethod).GetOrderBillStatus(OrdID)
	q obj
}

}
