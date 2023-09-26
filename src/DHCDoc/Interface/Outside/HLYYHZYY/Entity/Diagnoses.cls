/// 诊断信息标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Diagnoses Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 诊断信息列表(门诊)
Property OptDiagnosis As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Diagnose(XMLNAME = "opt_diagnosis", XMLPROJECTION = "ELEMENT");

/// 诊断信息列表(住院)
Property IptDiagnosis As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Diagnose(XMLNAME = "ipt_diagnosis", XMLPROJECTION = "ELEMENT");

}
