Class DHCENS.LIS.CheckUp Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "CheckUpReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod CheckUp(inputs As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.LIS.CheckUp).%New()
    ts
    s Len=$L(inputs,"/")
    for i=1:1:Len
    {
	    s input=$P(inputs,"/",i)
        s Rowid=$P(input,"^",2)
        s Rowid=##class(DHCENS.Method.BaseMethod).ReplaceStr(Rowid,"_","||")
        s LabNo=$P(input,"^",1)
        s BilledFlag=$P(input,"^",3)
        s ExeInfo=$P(input,"^",4)
        s ExeCode=$P($g(ExeInfo),"@",1)
        s ExeName=$P($g(ExeInfo),"@",2)
        s AcceptDate=$P(input,"^",5)
        s AcceptTime=$P(input,"^",6)
        //修改医嘱状态为IP(处理中)
		s StatusDr=##class(DHCENS.Method.BaseMethod).OrderStatusDr("E")
		s ExeUserDr=##class(DHCENS.Method.BaseMethod).GetUserDrByUserCode(ExeCode)
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
    d objStream.Write("<Response><CheckUpReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.CheckUpReport程序异常</ResultContent></CheckUpReturn></Response>")
	q objStream
}

}
