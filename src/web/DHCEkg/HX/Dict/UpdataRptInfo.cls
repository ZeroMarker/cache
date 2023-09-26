Class web.DHCEkg.HX.Dict.UpdataRptInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "UpdataRptInfo";

/// 医嘱号
Property OrdRowID As %String;

/// 就诊类型
Property AdmType As %String;

/// 审核医生
Property ArbiterUser As %String;

/// 诊断结论
Property DiagInfo As %String;

/// 诊断意见
Property ExtInfo As %String;

}
