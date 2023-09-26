Class DHCENS.LIS.GetLabOrder Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "GetLabOrderReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

/// 登记号
Property RegisterNo As %String(TRUNCATE = 1);

/// 就诊号
Property AdmNo As %String(TRUNCATE = 1);

/// 姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 病案号
Property DocumentID As %String(TRUNCATE = 1);

/// 家庭住址
Property PatientAddress As %String(TRUNCATE = 1);

/// 身份证号
Property IdentityCardNo As %String(TRUNCATE = 1);

/// 就诊类型
Property AdmType As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊时间
Property AdmTime As %String(TRUNCATE = 1);

/// 开单科室
Property OrderDept As %String(TRUNCATE = 1);

/// 患者所在病区
Property PatientWard As %String(TRUNCATE = 1);

/// 床号
Property BedNo As %String(TRUNCATE = 1);

/// 诊断
Property Diagnose As %String(TRUNCATE = 1);

Property OrderLists As list Of DHCENS.LIS.LabOrder;

/// 根据检验号，得到病人的基本信息和检验医嘱信息
ClassMethod GetLabOrder(input As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	set obj = ##class(DHCENS.LIS.GetLabOrder).%New()
	set LabNo = +input
	s OeRowid= $O(^OEORD(0,"EpisNo",LabNo,""))
	q:OeRowid=""
	set AdmNo = $P(^OEORD(OeRowid),"^",1)
	;根据病人就诊号设置病人就诊的基本信息
	set obj.AdmNo = AdmNo
	set PatRowid = $P(^PAADM(AdmNo),"^",1)
	set obj.RegisterNo = $P(^PAPER(PatRowid,"PAT",1),"^",1)
	set obj.PatientName = $P(^PAPER(PatRowid,"ALL"),"^",1)
	set SexDr = $P(^PAPER(PatRowid,"ALL"),"^",7)
	set obj.Sex = $P(^CT("SEX",SexDr),"^",2)
	set obj.DOB = $ZD($P(^PAPER(PatRowid,"ALL"),"^",6),3)
	set obj.DocumentID =  $P(^PAPER(PatRowid,"PAT",1),"^",22)
	set obj.PatientAddress = $P(^PAPER(PatRowid,"PER","ADD",1),"^",1)
	set obj.IdentityCardNo = $P(^PAPER(PatRowid,"ALL"),"^",9)
	set PatientType = $P(^PAADM(AdmNo),"^",2)
	i (PatientType="E")
	{
		s obj.AdmType="急诊"
	}
	i (PatientType="O")
	{
		s obj.AdmType="门诊"
	}
	i (PatientType="I")
	{
		s obj.AdmType="住院"
	}
	i (PatientType="H")
	{
		s obj.AdmType="体检"
	}
	i (PatientType="N")
	{
		s obj.AdmType="新生儿"
	}
	set obj.AdmDate = $ZD($P(^PAADM(AdmNo),"^",6),3)
	set obj.AdmTime = $ZT($P(^PAADM(AdmNo),"^",7))
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
	set obj.Diagnose = ##class(DHCENS.Method.BaseMethod).GetMRAdmDiagnosis(AdmNo)
	s OeRowid =""
	for  s OeRowid = $O(^OEORD(0,"EpisNo",LabNo,OeRowid)) Q:OeRowid=""  do
	.s Subid =""
	.for  s Subid = $O(^OEORD(0,"EpisNo",LabNo,OeRowid,Subid)) Q:Subid=""  do
	..s ordid=OeRowid_"||"_Subid
	..s OrderDeptDr=$p($g(^OEORD(OeRowid,"I",Subid,1)),"^",3)
	..i OrderDeptDr'="" do
	...s obj.OrderDept=$p($g(^CTLOC(OrderDeptDr)),"^",1)_"@"_$p($g(^CTLOC(OrderDeptDr)),"^",2)
	..s tmpOrderCate=##class(DHCENS.Method.BaseMethod).GetOrderCateBy(ordid)
	..q:tmpOrderCate'="检验"
	..s OrderItem = ##class(DHCENS.LIS.LabOrder).GetOrderItem(ordid)
	..do obj.OrderLists.Insert(OrderItem)
	s obj.ResultCode = 0
	s obj.ResultContent = "成功"
	do obj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
    q objStream

SendMessageET
    tro
    zn "dhc-app"
    s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response><GetLabOrderReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.LIS.GetLabOrder程序异常</ResultContent></GetLabOrderReturn></Response>")
	q objStream
}

}
