Class DHCExternalService.RegInterface.Entity.ScheduleCancel Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property eventNo As %String(TRUNCATE = 1);

Property eventType As %String(TRUNCATE = 1);

Property eventData As list Of DHCExternalService.RegInterface.Entity.ScheduleCancelDetail(XMLPROJECTION = "ELEMENT");

}
