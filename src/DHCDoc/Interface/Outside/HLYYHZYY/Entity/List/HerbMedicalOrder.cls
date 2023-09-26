/// 饮片医嘱信息
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 饮片医嘱汇总信息
Property HerbMedicalOrderInfo As DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrderInfo(XMLNAME = "herb_medical_order_info", XMLPROJECTION = "ELEMENT");

/// 饮片医嘱明细
Property HerbMedicalOrderItem As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrderItem(XMLNAME = "herb_medical_order_item", XMLPROJECTION = "ELEMENT");

}
