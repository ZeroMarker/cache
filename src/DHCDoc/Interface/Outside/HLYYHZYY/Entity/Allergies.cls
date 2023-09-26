/// 过敏信息标签 门诊为<opt_allergies>标签，住院为<ipt_allergies>标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Allergies Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 过敏列表(门诊)
Property OptAllergy As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Allergy(XMLNAME = "opt_allergy", XMLPROJECTION = "ELEMENT");

/// 过敏列表(住院)
Property IptAllergy As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Allergy(XMLNAME = "ipt_allergy", XMLPROJECTION = "ELEMENT");

}
