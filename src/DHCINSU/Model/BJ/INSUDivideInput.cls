Class DHCINSU.Model.BJ.INSUDivideInput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "input";

Property tradeinfo As DHCINSU.Model.BJ.INSUTradeinfo;

Property recipearray As DHCINSU.Model.BJ.INSURecipearray;

Property feeitemarray As DHCINSU.Model.BJ.INSUFeeitemarray;

}
