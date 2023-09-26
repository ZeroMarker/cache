Class DHCENS.BC.GetAppForm Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "GetAppFormReturn";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

/// 申请单内容 
Property FormContent As %String(TRUNCATE = 1);

ClassMethod GetAppForm(OrdId As %String) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s obj=##class(DHCENS.BC.GetAppForm).%New()
	
	s Rowid=##class(DHCENS.Method.BaseMethod).ReplaceStr(OrdId,"_","||")
	
	//通过医嘱号获取申请单内容
	s obj.FormContent=##class(web.DHCRisApplicationBill).GetHtmlAppBill(Rowid)
	
	s obj.ResultCode="0"
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
    d objStream.Write("<Response><GetAppFormReturn><ResultCode>-1</ResultCode><ResultContent>DHCENS.BC.GetAppForm程序异常</ResultContent></GetAppFormReturn></Response>")
	q objStream
}

}
