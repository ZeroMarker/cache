Class web.PilotProject.PPA.DHCDocPilotProFreeOrd Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property PPFSttDate As %Library.String(TRUNCATE = 1);

Property PPFSttTime As %Library.String(TRUNCATE = 1);

Property PPFEndDate As %Library.String(TRUNCATE = 1);

Property PPFEndTime As %Library.String(TRUNCATE = 1);

Property PPFItmMastDR As %Library.String(TRUNCATE = 1);

Property PPFFreeNum As %Library.String(TRUNCATE = 1);

Property PPFLimitEntryAfterNoFreeNum As %Library.String(TRUNCATE = 1);

Property PPFPrjStage As %Library.String(TRUNCATE = 1);

/// 不存在表中的属性
Property PPFItmMastDesc As %Library.String(TRUNCATE = 1);

Property PPFBlank As %Library.String(TRUNCATE = 1);

}
