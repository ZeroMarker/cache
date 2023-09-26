Class DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.personInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 证件类型
Property idCardTypeCode As %String(XMLNAME = "idCardTypeCode");

/// 证件号
Property idCode As %String(XMLNAME = "idCode");

/// 电子健康码 ID
Property erhcCardNo As %String(XMLNAME = "erhcCardNo");

/// 操作方式
Property appMode As %String(XMLNAME = "appMode");

/// 机构唯一识别码
Property orgCode As %String(XMLNAME = "orgCode");

/// 应用备案号
Property appRecordNo As %String(XMLNAME = "appRecordNo");

}
