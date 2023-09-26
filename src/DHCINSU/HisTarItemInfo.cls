Class DHCINSU.HisTarItemInfo Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "HisTarItemInfo";

Property TARIRowId As %String;

Property TARICode As %String;

Property TARIDesc As %String;

Property TARIUOMDr As %String;

Property TARIUOMCode As %String;

Property TARIUOMDesc As %String;

Property SubCateCodeDr As %String;

Property SubCateCode As %String;

Property SubCateDesc As %String;

Property SubSubCateCodeDr As %String;

Property SubSubCateCode As %String;

Property SubSubCateDesc As %String;

Property AcctCateCodeDr As %String;

Property AcctCateCode As %String;

Property AcctCateDesc As %String;

Property AcctSubCateCodeDr As %String;

Property AcctSubCateCode As %String;

Property AcctSubCateDesc As %String;

Property OutpatCateCodeDr As %String;

Property OutpatCateCode As %String;

Property OutpatCateDesc As %String;

Property OutpatSubCateCodeDr As %String;

Property OutpatSubCateCode As %String;

Property OutpatSubCateDesc As %String;

Property EMCCateCodeDr As %String;

Property EMCCateCode As %String;

Property EMCCateDesc As %String;

Property EMCSubCateCodeDr As %String;

Property EMCSubCateCode As %String;

Property EMCSubCateDesc As %String;

Property MRCateCodeDr As %String;

Property MRCateCode As %String;

Property MRCateDesc As %String;

Property MRSubCateCodeDr As %String;

Property MRSubCateCode As %String;

Property MRSubCateDesc As %String;

Property InpatCateCodeDr As %String;

Property InpatCateCode As %String;

Property InpatCateDesc As %String;

Property InpatSubCateCodeDr As %String;

Property InpatSubCateCode As %String;

Property InpatSubCateDesc As %String;

Property TARISpecialFlag As %String;

Property TARIActiveFlag As %String;

Property TARIStartDate As %String;

Property TARIEndDate As %String;

Property TARIPrice As %String;

Property TARIAlterPrice1 As %String;

Property TARIAlterPrice2 As %String;

Property TARIExternalCode As %String;

Property TARIJXDr As %String;

Property TARIJXDesc As %String;

Property DrugFlag As %String;

Property TARIREGU As %String;

}
