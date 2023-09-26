/// 医嘱信息标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 药物医嘱明细
Property MedicalOrderItem As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.MedicalOrderItem(XMLNAME = "medical_order_item", XMLPROJECTION = "ELEMENT");

/// 饮片医嘱信息
Property HerbMedicalOrder As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrder(XMLNAME = "herb_medical_order", XMLPROJECTION = "ELEMENT");

/// 非药物医嘱明细
/// Property NonMedicalOrderItem As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.NonMedicalOrderItem(XMLNAME = "non_medical_order_item", XMLPROJECTION = "ELEMENT");

}
