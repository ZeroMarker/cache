Class DHCENS.BC.ReturnReports Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "ReturnReportsReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod ReturnReports(input As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"

	s obj=##class(DHCENS.BC.ReturnReports).%New()
	s tmpinput=$p(input,"/",1)
	
	//转换医嘱rowid，为RIS接收的形式
	s RisRowid=##class(DHCENS.Method.BaseMethod).ReplaceStr($p(tmpinput,"^",1),"||","_")
	s tmpinput = RisRowid_"^"_$P(tmpinput,"^",2,$L(tmpinput,"^"))

	s EyeSee=$p(input,"/",2)
	s ExamSee=$p(input,"/",3)
	s Diagnose=$p(input,"/",4)
	;s ^input(1)=tmpinput
    ;s ^input(2)=EyeSee
    ;s ^input(3)=ExamSee
    ;s ^input(4)=Diagnose   
    ;s tmpinput=^input(1)
    ;s EyeSee=^input(2)
    ;s ExamSee=^input(3)
    ;s Diagnose=^input(4)

	zn "Ris"
	s flag=##class(web.DHCRisOutInterface).SetReportInfo(tmpinput,EyeSee,ExamSee,Diagnose)
	zn "dhc-app"

	if (flag=0)
	{
		s obj.ResultCode="0"
		s obj.ResultContent="成功"
	}
	else
	{
		s obj.ResultCode=flag
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
    d objStream.Write("<Response><ReturnReportsReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.ReturnReports程序异常</ResultContent></ReturnReportsReturn></Response>")
	q objStream
}

}
