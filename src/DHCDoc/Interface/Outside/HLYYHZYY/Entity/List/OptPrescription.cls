/// 处方和处方明细信息列表
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescription Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 处方信息
Property OptPrescriptionInfo As DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionInfo(XMLNAME = "opt_prescription_info", XMLPROJECTION = "ELEMENT");

/// 处方明细信息
Property OptPrescriptionItem As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionItem(XMLNAME = "opt_prescription_item", XMLPROJECTION = "ELEMENT");

}
