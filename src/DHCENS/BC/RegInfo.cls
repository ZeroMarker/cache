Class DHCENS.BC.RegInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "RegInfoReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod RegInfo(input As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.BC.RegInfo).%New()
	ts
	s len=$l(input,"/")
	f i=1:1:len
	{
		s tmpStr=$p(input,"/",i)
		
		//改变医嘱Rowid为RIS接受的形式
		s RisRowid=##class(DHCENS.Method.BaseMethod).ReplaceStr($p(tmpStr,"^",1),"||","_")
		s tmpStr = RisRowid_"^"_$P(tmpStr,"^",2,$L(tmpStr,"^"))
		zn "RIS"
		s Reg=##class(web.DHCRisOutInterface).SetRegInfo(tmpStr)
		zn "DHC-APP"

		s Rowid=##class(DHCENS.Method.BaseMethod).ReplaceStr($p(tmpStr,"^",1),"_","||")
		s StatusDr=##class(DHCENS.Method.BaseMethod).OrderStatusDr("E")
		s ExeUser=$p($p(tmpStr,"^",5),"@",1)
		s ExeUserDr=##class(DHCENS.Method.BaseMethod).GetUserDrByUserCode(ExeUser)
		s flag=##class(DHCENS.Method.BaseMethod).UpdateOrdStabyRowId(Rowid,StatusDr,ExeUserDr)
		q:flag'=0
	}
	if (flag=0)
	{
		tc
		s obj.ResultCode="0"
	}
	else
	{
		tro
		s obj.ResultCode="-1"
	}
	
	d obj.XMLExportToStream(.Xml)
	s objStream=##class(%GlobalCharacterStream).%New()
	d objStream.Write("<Response>")
	d objStream.CopyFrom(Xml)
	d objStream.Write("</Response>")
	q objStream
SendMessageET
    tro
    zn "dhc-app"
    s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response><RegInfoReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.RegInfo程序异常</ResultContent></RegInfoReturn></Response>")
	q objStream
}

}
