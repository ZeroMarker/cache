Class DHCENS.BC.BookedInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "BookedInfoReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod BookedInfo(input As %String) As %String
{
	
	s $ZTrap = "SendMessageET"
	s ^input=input
	s obj=##class(DHCENS.BC.BookedInfo).%New()
	s flag=""
	ts
	s len=$l(input,"/")
	f i=1:1:len
	{
		s tmpStr=$p(input,"/",i)
		s flag=..SetBookedInfo(tmpStr)
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
    d objStream.Write("<Response><BookedInfoReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.BookedInfo程序异常</ResultContent></BookedInfoReturn></Response>")
	q objStream
}

ClassMethod SetBookedInfo(Info As %String) As %String
{
	s OEOrdItemID=##class(DHCENS.Method.BaseMethod).ReplaceStr($p(Info,"^",1),"_","||")   ////获得医嘱ROWID 
	s ResourceInfo=$p(Info,"^",2) ; 获得资源信息，可能是医护人员，也可能设备
	s BookedDate=$p(Info,"^",3) ; 预约日期(格式：2008-09-15)
	s BookedTime=$p(Info,"^",4)  ;预约时间(格式：08:30:30) 操作员(代码@名称)
	s OperaterInfo=$p(Info,"^",5)  ; 操作员(代码@名称)
	s NoteInfo=$p(Info,"^",6)      ; 注意事项
	s OtherInfo=$p(Info,"^",7)     ; 其他信息
	; 说明TRAK 的预约是放在TRAK的资源排版的里面，从外部系统预约返回给TRAK统一存放在^DHCRISBOOKEDINFO 里面
	; 在病区查询或者其他地方查询信息的时候，考虑是否是TRAK的预约，不是从该GLOBAL 里面获得病人的预约信息
	s ^DHCRISBOOKEDINFO(OEOrdItemID)=ResourceInfo_"^"_BookedDate_"^"_BookedTime_"^"_OperaterInfo_"^"_NoteInfo_"^"_OtherInfo
	q 0
}

}
