Class DHCENS.LIS.LabOrderInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "LabOrderInfo";

Property CardNo As %String(TRUNCATE = 1);

Property RegisterNo As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

Property DOB As %String(TRUNCATE = 1);

Property DocumentID As %String(TRUNCATE = 1);

Property PatientAddress As %String(TRUNCATE = 1);

Property IdentityCardNo As %String(TRUNCATE = 1);

Property OrderLists As list Of DHCENS.LIS.OrderList;

ClassMethod LabOrderInfo(OrderItemRowId As %String) As %String
{
	s MainObj=##class(DHCENS.LIS.LabOrderInfo).%New()
	//取医嘱信息
	for i=1:1:$l(OrderItemRowId,"^")
	 {
		 s ordid=$p(OrderItemRowId,"^",i)
		 if (ordid'="")
		 {
			s insObj=##class(DHCENS.LIS.OrderList).GetOrderInfo(ordid)
		 }
		 d MainObj.OrderLists.Insert(insObj)
	 }
	//取病人基本信息
	s PatientID=..GetPatIdByOrderID($p(OrderItemRowId,"^",1))
	&SQL(Select PAPMI_No,PAPMI_Name,PAPMI_Sex_DR->CTSEX_Desc,PAPMI_Sex_DR->CTSEX_Code,
	TO_Date(PAPMI_DOB,'YYYY-MM-DD'),PAPMI_Medicare,PAPMI_SecondPhone
    Into :RegisterNo,:PatientName,:Sex,:SexCode,:DOB,:DocumentID,:PatientAddress
    From SQLUser.PA_PatMas Where PAPMI_RowId=:PatientID)
     
	i (SQLCODE=0) {
		s PatientAddress=$g(^PAPER(PatientID,"PER","ADD",1))
		s IdentityCardNo=$P(^PAPER(PatientID,"ALL"),"^",9)
		s MainObj.RegisterNo=RegisterNo
		s MainObj.PatientName=PatientName
		s MainObj.Sex=SexCode_"@"_Sex
		s MainObj.DOB=DOB
		s MainObj.IdentityCardNo=IdentityCardNo
		s MainObj.PatientAddress=PatientAddress
		s MainObj.DocumentID=DocumentID
	}
	s Status=MainObj.XMLExportToStream(.Xml)
	;s Status=MainObj.XMLExportToString(.Xml1)
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<Request>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Request>")
	s obj=##class(DHCENS.LIS.EnsSoap.DHCCLISSoap).%New()
	s retStream=obj.dhcService("LabOrderInfo",objStream)
	d retStream.Rewind()
	s len=retStream.SizeGet()
	s retStr=retStream.Read(len)
	q retStr
}

ClassMethod GetPatIdByOrderID(OrderID As %String) As %String
{
	s adm=$p($g(^OEORD(+OrderID)),"^",1)
	s patId=""
	i (adm'="")
	{
		s patId=$p(^PAADM(adm),"^",1)
	}
	q patId
}

}
