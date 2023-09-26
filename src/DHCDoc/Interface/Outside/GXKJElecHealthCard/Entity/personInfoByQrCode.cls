Class DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.personInfoByQrCode Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 二维码
Property qrCode As %String(XMLNAME = "qrCode");

/// 终端编号
Property terminalCode As %String(XMLNAME = "terminalCode");

/// 诊疗环节 ID
Property medStepCode As %String(XMLNAME = "medStepCode");

/// 操作方式
Property appMode As %String(XMLNAME = "appMode");

/// 机构唯一识别码
Property orgCode As %String(XMLNAME = "orgCode");

/// 应用备案号
Property appRecordNo As %String(XMLNAME = "appRecordNo");

/// 支付金额（V1.1新增，当诊疗环节为010105收费的情况下，必填）
Property payAmount As %String(XMLNAME = "payAmount");

/// 支付渠道（V1.1新增，当诊疗环节为010105收费的情况下，必填）参照附录《支付渠道编码》
Property payChannel As %String(XMLNAME = "payChannel");

}
