Class DHCINSU.InsuTarContrastInfo Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "InsuTarContrastInfo";

/// INTCT_His_Dr
Property INTCTRowid As %String;

/// INTCT_His_Dr
Property INTCTHisDr As %String;

/// INTCT_HisCode
Property INTCTHisCode As %String;

/// INTCT_HisDesc
Property INTCTHisDesc As %String;

/// INTCT_Insu_Dr
Property INTCTInsuDr As %String;

/// INTCT_InsuCode
Property INTCTInsuCode As %String;

/// INTCT_InsuDesc
Property INTCTInsuDesc As %String;

/// INTCT_Class
Property INTCTClass As %String;

/// INTCT_Level
Property INTCTLevel As %String;

/// INTCT_PatType
Property INTCTPatTypeDr As %String;

/// INTCT_Amount
Property INTCTAmount As %String;

/// INTCT_DrAddFlag
Property INTCTDrAddFlag As %String;

/// INTCT_ActiveDate
Property INTCTActiveDate As %String;

/// INTCT_ZText
Property INTCTZText As %String;

/// INTCT_DicType
Property INTCTDicType As %String;

/// INTCT_User_Dr
Property INTCTUserDr As %String;

/// INTCT_Date
Property INTCTDate As %String;

/// INTCT_Time
Property INTCTTime As %String;

/// INTCT_ADDIP
Property INTCTADDIP As %String;

/// INTCT_Unique
Property INTCTUnique As %String;

}
