Class BILL.EINV.DTO.AXNHTA.SendBackInvRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property sendbackinvrecordhead As BILL.EINV.DTO.AXNHTA.SendBackInvRecordhead;

// sendbackinvrecorditem

Property sendbackinvrecorditem As list Of BILL.EINV.DTO.AXNHTA.OPListDetail(CAPTION = "清单项目明细", XMLPROJECTION = "ELEMENT");

}
