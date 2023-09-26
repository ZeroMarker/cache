Class DHCENS.LIS.OrderList Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "OrderList";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱Rowid
Property OrdID As %String(TRUNCATE = 1);

/// 医嘱代码
Property ArcimCode As %String(TRUNCATE = 1);

/// 医嘱名称
Property ArcimDesc As %String(TRUNCATE = 1);

/// 医嘱数量
Property OrderQty As %String(TRUNCATE = 1);

/// 医嘱状态
Property OrderStatus As %String(TRUNCATE = 1);

/// 价格
Property TSPrice As %String(TRUNCATE = 1);

/// 开单科室
Property OrderDept As %String(TRUNCATE = 1);

/// 接收科室
Property OrderRecDep As %String(TRUNCATE = 1);

/// 开单医生
Property OrderDoctor As %String(TRUNCATE = 1);

/// 录入人
Property OrderUser As %String(TRUNCATE = 1);

/// 开单日期
Property OrderDate As %String(TRUNCATE = 1);

/// 开单时间
Property OrderTime As %String(TRUNCATE = 1);

/// 要求执行日期
Property OrderSttDat As %String(TRUNCATE = 1);

/// 要求执行时间
Property OrderSttTim As %String(TRUNCATE = 1);

/// 就诊号
Property AdmNo As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊时间
Property AdmTime As %String(TRUNCATE = 1);

/// 费别
Property FeeType As %String(TRUNCATE = 1);

/// 患者所在病区
Property PatientWard As %String(TRUNCATE = 1);

/// 床号
Property BedNo As %String(TRUNCATE = 1);

/// 诊断
Property Diagnose As %String(TRUNCATE = 1);

/// 标本类型
Property SpecimenType As %String(TRUNCATE = 1);

/// 备注
Property Notes As %String(TRUNCATE = 1);

/// 收费状态
Property BillStatus As %String(TRUNCATE = 1);

/// 病人基本信息节点
Property RegisterNo As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

Property DOB As %String(TRUNCATE = 1);

Property DocumentID As %String(TRUNCATE = 1);

Property PatientAddress As %String(TRUNCATE = 1);

Property IdentityCardNo As %String(TRUNCATE = 1);

/// 得到医嘱信息
ClassMethod GetOrderInfo(OrdID As %String) As DHCENS.LIS.OrderList
{
	s obj=##class(DHCENS.LIS.OrderList).%New()
	s obj.OrdID=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrdID,"||","_")
	
	s ArcimID=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",2)
	i (ArcimID'="")
	{
		s obj.ArcimCode=..GetLabCode(ArcimID)
		s obj.ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		
	}
	s obj.OrderQty=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",12)
	
	s ItemStatDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",13)
	s obj.OrderStatus=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)_"@"_$p($g(^OEC("OSTAT",ItemStatDr)),"^",2)
	
	s OrderDeptDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",3)
	i (OrderDeptDr'="")
	{ 
		s obj.OrderDept=$p($g(^CTLOC(OrderDeptDr)),"^",1)_"@"_$p($g(^CTLOC(OrderDeptDr)),"^",2)
	}
	
	s OrderRecDepDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
	i (OrderRecDepDr'="")
	{ 
		s obj.OrderRecDep=$p($g(^CTLOC(OrderDeptDr)),"^",1)_"@"_$p($g(^CTLOC(OrderDeptDr)),"^",2)
	}
		
	s DoctorDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",11)
	i (DoctorDr'="")
	{
		s obj.OrderDoctor=$p($g(^CTPCP(DoctorDr,1)),"^",1)_"@"_$p($g(^CTPCP(DoctorDr,1)),"^",2)
	}
	
	s OrderUserDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),7)),"^",1)
	i (OrderUserDr'="")
	{
		s obj.OrderUser=$p($g(^SSU("SSUSR",OrderUserDr)),"^",1)_"@"_$p($g(^SSU("SSUSR",OrderUserDr)),"^",2)
	}
	
	s obj.OrderDate=$zd($p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",9),3)	
	s obj.OrderTime=$zt($p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",10))	
	
	s obj.OrderSttDat="" ;$zd($p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",9),3)	
	s obj.OrderSttTim="" ;$zt($p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",10))	
	
	
	s obj.AdmNo=$p($g(^OEORD(+OrdID)),"^",1)
	s obj.AdmDate=$zd($p($g(^PAADM(obj.AdmNo)),"^",6),3)	
	s obj.AdmTime=$zt($p($g(^PAADM(obj.AdmNo)),"^",7))		
	s obj.FeeType=""
	
	
	s WardDR=$p(^PAADM(obj.AdmNo),"^",70)
  	i (WardDR'="")
  	{
		s obj.PatientWard=$p($g(^PAWARD(WardDR)),"^",1)_"@"_$p($g(^PAWARD(WardDR)),"^",2)
	}
  
	s BedNoDR=$p(^PAADM(obj.AdmNo),"^",73)
	i (BedNoDR'="")    ; 取床号
	{
		s wardrowid=$p(BedNoDR,"||",1)
		s bedchildsub=$p(BedNoDR,"||",2)
		s obj.BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
	}
	s obj.Diagnose=##class(DHCENS.Method.BaseMethod).GetMRAdmDiagnosis(obj.AdmNo)	
	s obj.SpecimenType=""	
	s obj.Notes=""
	
	s obj.BillStatus=##class(DHCENS.Method.BaseMethod).GetOrderBillStatus(OrdID)
		
	s prcstr=##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",ArcimID,$zdh(obj.OrderDate,3),"","","","")
	s obj.TSPrice=$p(prcstr,"^",1)
	
	//设置病人基本信息
	set PapatDr=$P($g(^PAADM(obj.AdmNo)),"^",1)
	if (PapatDr'="")
	{
	  s obj.RegisterNo=$P($g(^PAPER(PapatDr,"PAT",1)),"^",1)
	  s obj.PatientName=$p($g(^PAPER(PapatDr,"ALL")),"^",1)
	  
	  s SexDr=$p($g(^PAPER(PapatDr,"ALL")),"^",7)
	  i SexDr'="" s obj.Sex=$p($g(^CT("SEX",SexDr)),"^",1)_"@"_$p($g(^CT("SEX",SexDr)),"^",2)

	  s Dob=$p($g(^PAPER(PapatDr,"ALL")),"^",6)
	  i Dob'="" s obj.DOB=$zd(Dob,3)
	  
	  s obj.DocumentID =  $P(^PAPER(PapatDr,"PAT",1),"^",22)	
	  s obj.PatientAddress=$g(^PAPER(PapatDr,"PER","ADD",1))
	  s obj.IdentityCardNo=$p($g(^PAPER(PapatDr,"ALL")),"^",9)
	  
	}	
	Quit obj
}

/// 得到外部系统的检验项目代码
ClassMethod GetLabCode(ArcimID As %String) As %String
{
	q:ArcimID="" ""
	s temord=$o(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),"EXT",""),-1)
	s ExtCode="",RetCode=""
	i (temord'="")
	{
		s ExtCode=$p(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),"EXT",temord),"^",4)
	
		i (ExtCode'="")
		{
			s RetCode=$p($g(^TTAB("TS",ExtCode)),"\",3)
		}
	}
	q RetCode
}

}
