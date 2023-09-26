Class web.DHCENS.STBLL.OPERATION.Model.OperationPortalObject Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OperationPortalObject";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 手术名称
Property OpName As %String(MAXLEN = 32767);

/// 手术间
Property OpRoom As %String(MAXLEN = 32767);

/// 台次
Property OrdNo As %String(MAXLEN = 32767);

/// 主刀医生
Property Surgeon As %String(MAXLEN = 32767);

/// 助手
Property Ass As %String(MAXLEN = 32767);

/// 科室
Property Dept As %String(MAXLEN = 32767);

/// 术前诊断
Property PreDiag As %String(MAXLEN = 32767);

/// 病案号
Property MedcareNo As %String(MAXLEN = 32767);

/// 病人姓名
Property PatName As %String(MAXLEN = 32767);

/// 手术日期
Property OpDate As %String(MAXLEN = 32767);

/// 手术时间
Property OpTime As %String(MAXLEN = 32767);

/// 手术患者所在病区
Property OperLoc As %String(MAXLEN = 32767);

}
