Class DHCENS.BC.CancelBookedInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "CancelBookedInfoReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod CancelBookedInfo(input As %String) As %String
{
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.BC.CancelBookedInfo).%New()
	s flag=""
	ts
	s len=$l(input,"/")
	f i=1:1:len
	{
		s tmpStr=$p(input,"/",i)
		s flag=..SetCancelBookedInfo(tmpStr)
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
    d objStream.Write("<Response><CancelBookedInfoReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.CancelBookedInfo程序异常</ResultContent></CancelBookedInfoReturn></Response>")
	q objStream
}

/// 取消预约信息
ClassMethod SetCancelBookedInfo(OEOrdItemID) As %String
{
	s OEOrdItemID=##class(DHCENS.Method.BaseMethod).ReplaceStr(OEOrdItemID,"_","||")   ////获得医嘱ROWID 
	k ^DHCRISBOOKEDINFO(OEOrdItemID)
	q "0"
}

}
