/// 手术信息标签 门诊为<opt_operations>标签，住院为<ipt_operations>标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Operations Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 手术列表(门诊)
Property OptOperation As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Operation(XMLNAME = "opt_operation", XMLPROJECTION = "ELEMENT");

/// 手术列表(住院)
Property IptOperation As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Operation(XMLNAME = "ipt_operation", XMLPROJECTION = "ELEMENT");

}
