Class DHCNMG.Model.SatiModelGetOrder Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "JWIPAdmInfoList";

Property JWIPAdmInfoList As list Of DHCNMG.Model.SatiPatientInfo(XMLPROJECTION = "ELEMENT");

}
