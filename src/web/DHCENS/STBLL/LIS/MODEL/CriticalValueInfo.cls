Class web.DHCENS.STBLL.LIS.MODEL.CriticalValueInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CriticalValueInfo";

Property PATPatientID As %Library.String(MAXLEN = 50, XMLNAME = "PATPatientID");

Property PAADMVisitNumber As %Library.String(MAXLEN = 50, XMLNAME = "PAADMVisitNumber");

Property SpecimenID As %Library.String(MAXLEN = 50, XMLNAME = "SpecimenID");

Property OEORIOrdSubCatCode As %Library.String(MAXLEN = 20, XMLNAME = "OEORIOrdSubCatCode");

Property OEORIOrdSubCatDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIOrdSubCatDesc");

Property OEORIOrdCatCode As %Library.String(MAXLEN = 20, XMLNAME = "OEORIOrdCatCode");

Property OEORIOrdCatDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIOrdCatDesc");

Property OEORIOrdItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdItemID");

Property CheckDate As %Library.String(MAXLEN = 50, XMLNAME = "CheckDate");

Property CheckTime As %Library.String(MAXLEN = 50, XMLNAME = "CheckTime");

Property CheckPersonCode As %Library.String(MAXLEN = 50, XMLNAME = "CheckPersonCode");

Property CheckPerson As %Library.String(MAXLEN = 50, XMLNAME = "CheckPerson");

Property Telephone As %Library.String(MAXLEN = 50, XMLNAME = "Telephone");

Property Remark As %Library.String(MAXLEN = 50, XMLNAME = "Remark");

Property UpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserCode");

Property UpdateDate As %Library.String(MAXLEN = 50, XMLNAME = "UpdateDate");

Property UpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "UpdateTime");

Property CriticalValueId As %Library.String(MAXLEN = 50, XMLNAME = "CriticalValueId");

}
