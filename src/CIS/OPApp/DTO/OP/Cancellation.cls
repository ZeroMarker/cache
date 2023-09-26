Class CIS.OPApp.DTO.OP.Cancellation Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Cancellation";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Appointments As list Of CIS.OPApp.DTO.OP.Appointment;

}
