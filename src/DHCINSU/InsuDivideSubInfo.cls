Class DHCINSU.InsuDivideSubInfo Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "InsuDivideSubInfo";

/// INDIS_rowid
Property INDISRowid As %String;

/// INDIS_DivideDr
Property INDISDivideDr As %String;

/// INDIS_ArcimDr
Property INDISArcimDr As %String;

/// INDIS_TarItmDr
Property INDISTarItmDr As %String;

/// INDIS_INSUItmDr
Property INDISINSUItmDr As %String;

/// INDIS_OEORI_Dr
Property INDISOEORIDr As %String;

/// INDIS_PB_Dr
Property INDISPBDr As %String;

/// INDIS_PBD_Dr
Property INDISPBDDr As %String;

/// INDIS_INSUCode
Property INDISINSUCode As %String;

/// INDIS_INSUDesc
Property INDISINSUDesc As %String;

/// INDIS_INSUXMLB
Property INDISINSUXMLB As %String;

/// INDIS_Qty
Property INDISQty As %String;

/// INDIS_Price
Property INDISPrice As %String;

/// INDIS_Amount
Property INDISAmount As %String;

/// INDIS_TarCate
Property INDISTarCate As %String;

/// INDIS_Scale
Property INDISScale As %String;

/// INDIS_Fund
Property INDISFund As %String;

/// INDIS_Self
Property INDISSelf As %String;

/// INDIS_Flag
Property INDISFlag As %String;

/// INDIS_Sequence1
Property INDISSequence1 As %String;

/// INDIS_Sequence2
Property INDISSequence2 As %String;

/// INDIS_Date
Property INDISDate As %String;

/// INDIS_Time
Property INDISTime As %String;

/// INDIS_UserDr
Property INDISUserDr As %String;

/// INDIS_INSUFlag
Property INDISINSUFlag As %String;

/// INDIS_INSUMaxPrice
Property INDISINSUMaxPrice As %String;

/// INDIS_Demo1
Property INDISDemo1 As %String;

/// INDIS_Demo2
Property INDISDemo2 As %String;

/// INDIS_Demo3
Property INDISDemo3 As %String;

/// INDIS_Demo4
Property INDISDemo4 As %String;

/// INDIS_Demo5
Property INDISDemo5 As %String;

}
