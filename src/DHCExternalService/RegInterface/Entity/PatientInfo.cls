Class DHCExternalService.RegInterface.Entity.PatientInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Property eventNo As %String(TRUNCATE = 1);

Property eventType As %String(TRUNCATE = 1);

Property eventData As list Of DHCExternalService.RegInterface.Entity.PatientInfoDetail(XMLPROJECTION = "ELEMENT");

}
