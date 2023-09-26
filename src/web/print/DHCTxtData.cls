Class web.print.DHCTxtData Extends (%RegisteredObject, %XML.Adaptor)
{

Property RePrtHeadFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N", XMLPROJECTION = "ATTRIBUTE");

Property TxtDataParas As list Of web.print.DHCTxtDataPara(XMLITEMNAME = "txtdatapara");

}
