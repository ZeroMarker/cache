Class web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property paobservationsList As list Of web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.PAObservations(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
