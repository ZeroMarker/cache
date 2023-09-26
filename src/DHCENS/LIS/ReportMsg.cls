Class DHCENS.LIS.ReportMsg Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "ReportMsgReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

//d ##class(DHCENS.LIS.ReportMsg).ReportMsg("")

//s input="11||349"_$C(2)_"001"_$c(2)_"2011-08-14 11:47:42"_$c(2)_"001"_$C(2)_"2011-08-14 11:47:42"_$c(2)_"001"_$c(2)_"2011-08-14 11:48:02"_$c(2)_""_"^"_"ESR"_$c(2)_"血沉"_$c(2)_"ESR"_$c(2)_"20"_$c(2)_"mm/h"_$c(2,0,2,0,2,0,2,0,2)_"N"_$c(2,0,28,2)_"OB"_$c(2)_"隐血"_$c(2)_"OB"_$c(2)_"陰性(-)"_$c(2,0,2,0,2,0,2,0,2,0,2)_"N"_$c(2,0,28,2)_"ST-BLOOD"_$c(2)_"血"_$c(2)_"ST-BLOOD"_$c(2)_"未见"_$c(2,0,2,0,2,0,2,0,2,0,2)_"N"_$c(2,0)_"^"

//s input="11||244^16106@徐明杨^2010-08-21 22:13:00^16106@徐明杨^2010-08-21 22:13:00^16106@徐明杨^2010-08-21 22:13:00^备注^www.baidu.com^危急值###1000000203^ESR^血沉^ESR^30^mm/h^备注信息^N^6-9^S^MF^MN^危急值~1000000204^OB^隐血^OB^45^mm/h^备注信息^N^6-9^S^N^MN^危急值"

ClassMethod ReportMsg(input As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s obj = ##class(DHCENS.LIS.ReportMsg).%New()
	s ReportMsg=$P(input,"###",1)
	s ResultMsg=$P(input,"###",2)
	s OrgResultMsg=$P(input,"###",3)
	s LisRowid=##class(DHCENS.Method.BaseMethod).ReplaceStr($p(ReportMsg,"^",1),"_","||")
	s ReportMsg = LisRowid_"^"_$P(ReportMsg,"^",2,$L(ReportMsg,"^"))
    s ReportMsg=##class(DHCENS.Method.BaseMethod).ReplaceStr(ReportMsg,"^",$char(2))
    
    s ResultMsg=##class(DHCENS.Method.BaseMethod).ReplaceStr(ResultMsg,"~",$char(28))
    s ResultMsg=##class(DHCENS.Method.BaseMethod).ReplaceStr(ResultMsg,"^",$char(2))
    
    s OrgResultMsg=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrgResultMsg,"~",$char(28))
    s OrgResultMsg=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrgResultMsg,"^",$char(2))

	s ^test=ReportMsg
	//存储报告信息
	S retval=##class(DHCIntergration.ILISGetReportControl).SaveReportInfo(ReportMsg,ResultMsg,OrgResultMsg)

	if (retval=0)
	{
		s obj.ResultCode="0"
		s obj.ResultContent="成功"
	}
	else
	{
		s obj.ResultCode=retval
		s obj.ResultContent="保存失败"
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
    d objStream.Write("<Response><ReportMsgReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.LIS.ReportMsgReturn程序异常</ResultContent></ReportMsgReturn></Response>")
	q objStream
}

}
