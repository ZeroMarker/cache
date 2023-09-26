Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.DeleteRq Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 基础标签
Property base As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// 医生工号
Property docid As %String(TRUNCATE = 1, XMLNAME = "doc_id");

/// 医生姓名
Property docname As %String(TRUNCATE = 1, XMLNAME = "doc_name");

/// 医嘱信息标签  住院
Property orders As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders(XMLNAME = "orders", XMLPROJECTION = "ELEMENT");

/// 处方及明细信息标签  门诊
Property optprescriptions As DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions(XMLNAME = "opt_prescriptions", XMLPROJECTION = "ELEMENT");

}
