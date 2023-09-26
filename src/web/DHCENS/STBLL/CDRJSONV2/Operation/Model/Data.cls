Class web.DHCENS.STBLL.CDRJSONV2.Operation.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property paoperationapplicationList As list Of web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property paoperationrecordList As list Of web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
