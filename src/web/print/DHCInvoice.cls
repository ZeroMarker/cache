Class web.print.DHCInvoice Extends (%RegisteredObject, %XML.Adaptor)
{

/// "web.print.Test.GetData" 
Property XMLClassQuery As %String(XMLPROJECTION = "ATTRIBUTE");

/// "web.print.Test.FindPat" 
Property XMLClassMethod As %String(XMLPROJECTION = "ATTRIBUTE");

Property width As %String(XMLPROJECTION = "ATTRIBUTE");

Property height As %String(XMLPROJECTION = "ATTRIBUTE");

Property PrtDirection As %String(XMLPROJECTION = "ATTRIBUTE");

Property LandscapeOrientation As %String(XMLPROJECTION = "ATTRIBUTE");

Property PrtPaperSet As %String(XMLPROJECTION = "ATTRIBUTE");

Property PrtDevice As %String(XMLPROJECTION = "ATTRIBUTE");

Property PrtPage As %String(XMLPROJECTION = "ATTRIBUTE");

Property TxtData As list Of web.print.DHCTxtDataPara(XMLITEMNAME = "txtdatapara");

Property ListData As web.print.DHCListData(XMLITEMNAME = "ListData");

Property ListData2 As %String(XMLITEMNAME = "Listdatapara");

Property PICData As list Of web.print.DHCPICDataPara(XMLITEMNAME = "PICdatapara");

Property PLData As list Of web.print.DHCPLine(XMLITEMNAME = "PLine");

Property BeiFenData As list Of web.print.DHCTxtDataPara(XMLITEMNAME = "txtdatapara");

Property PLDataTest As list Of web.print.DHCPLine(XMLITEMNAME = "PLine");

Property TestParamData As %String(MAXLEN = 5000, XMLITEMNAME = "TestParamData");

}
