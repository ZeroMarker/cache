Class DHCENS.LIS.ModifyStatus Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "ModifyStatusReturn";

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod ModifyStatus(input As %String) As %GlobalCharacterStream
{
	
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.LIS.ModifyStatus).%New()
	ts
	s len=$l(input,"^")
	f i=1:1:len
	{
		s tmpStr=$p(input,"^",i)
		s Rowid=$p(tmpStr,"/",1)
		s Rowid=##class(DHCENS.Method.BaseMethod).ReplaceStr(Rowid,"_","||")
		s Status=$p($p(tmpStr,"/",2),"@",1)
		s StatusDr=##class(DHCENS.Method.BaseMethod).OrderStatusDr(Status)
		s ExeUser=$p($p(tmpStr,"/",3),"@",1)
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
    d objStream.Write("<Response><ModifyStatusReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.LIS.ModifyStatus程序异常</ResultContent></ModifyStatusReturn></Response>")
	q objStream
}

}
