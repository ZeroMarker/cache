Class DHCENS.BC.CancelReport Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "CancelReportReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

ClassMethod CancelReport(input As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.BC.CancelReport).%New()

    s Rowid=$P(input,"^",1)
    s Rowid=##class(DHCENS.Method.BaseMethod).ReplaceStr(Rowid,"_","||")
    
    s StudyNo=$P(input,"^",2)
    s DocInfo=$P(input,"^",3)
    s DocCode=$P($g(DocInfo),"@",1)
    s DocName=$P($g(DocInfo),"@",2)
    
    s CancelDate=$P(input,"^",4)
    s CancelTime=$P(input,"^",5)

    /*
     *暂时未对取得的信息做处理
     *返回固定的成功信息
     */
    s obj.ResultCode=0
    s obj.ResultContent="成功"
    
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
    d objStream.Write("<Response><CancelReportReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.CancelReport程序异常</ResultContent></CancelReportReturn></Response>")
	q objStream
}

}
