Class web.DHCENS.STBLL.DOCU.MODEL.MOHDocument Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "MOH_Document";

Property MOHDDocumentID As %Library.String(XMLNAME = "MOHD_DocumentID");

Property MOHDSerialNumber As %Library.String(XMLNAME = "MOHD_SerialNumber");

Property MOHDPatientID As %Library.String(XMLNAME = "MOHD_PatientID");

Property MOHDVisitNumber As %Library.String(XMLNAME = "MOHD_VisitNumber");

Property MOHDPatientName As %Library.String(XMLNAME = "MOHD_PatientName");

Property MOHDIdentityCardID As %Library.String(XMLNAME = "MOHD_IdentityCardID");

Property MOHDHealthCardID As %Library.String(XMLNAME = "MOHD_HealthCardID");

Property MOHDOrganId As %Library.String(XMLNAME = "MOHD_OrganId");

Property MOHDOrganName As %Library.String(XMLNAME = "MOHD_OrganName");

Property MOHDVersionNumber As %Library.String(XMLNAME = "MOHD_VersionNumber");

Property MOHDTypeCode As %Library.String(XMLNAME = "MOHD_TypeCode");

Property MOHDUrl As %Library.String(XMLNAME = "MOHD_Url");

Property MOHDUpdateUserCode As %Library.String(XMLNAME = "MOHD_UpdateUserCode");

Property MOHDUpdateDate As %Library.String(XMLNAME = "MOHD_UpdateDate");

Property MOHDUpdateTime As %Library.String(XMLNAME = "MOHD_UpdateTime");

Property MOHDFlag As %Library.String(XMLNAME = "MOHD_Flag");

}
