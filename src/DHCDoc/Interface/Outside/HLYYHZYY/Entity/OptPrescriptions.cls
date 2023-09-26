/// 处方和处方明细信息标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 处方和处方明细信息列表
Property OptPrescriptions As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescription(XMLNAME = "opt_prescription", XMLPROJECTION = "ELEMENT");

}
