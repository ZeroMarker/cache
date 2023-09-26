Class web.DHCENS.STBLL.DRUG.MODEL.UpdateOPDrugStatus Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "UpdateOPDrugStatus";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property AdviceCode As %String(TRUNCATE = 1, XMLNAME = "ADVICE_CODE");

Property DrugCode As %String(TRUNCATE = 1, XMLNAME = "DRUG_CODE");

Property Quantity As %String(TRUNCATE = 1, XMLNAME = "QUANTITY");

}
