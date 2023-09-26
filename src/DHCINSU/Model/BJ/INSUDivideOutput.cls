Class DHCINSU.Model.BJ.INSUDivideOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "output";

Property tradeinfo As DHCINSU.Model.BJ.INSUTradeinfo;

Property sumpay As DHCINSU.Model.BJ.INSUSumpay(XMLNAME = "sumpay");

Property feeitemarray As DHCINSU.Model.BJ.INSUFeeitemarray;

// <sumpay>

// <payinfo>

Property payinfo As DHCINSU.Model.BJ.INSUPayinfo(XMLNAME = "payinfo");

//<medicatalog>

Property medicatalog As DHCINSU.Model.BJ.INSUMedicatalog(XMLNAME = "medicatalog");

//<medicatalog2>

Property medicatalog2 As DHCINSU.Model.BJ.INSUMedicatalog2(XMLNAME = "medicatalog2");

}
