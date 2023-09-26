Class DHCDoc.Interface.Outside.GDHealthCardService.Entity.activeQrCode Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 电子健康码 ID
Property erhcCardNo As %String(XMLNAME = "erhcCardNo");

/// 操作方式
Property appMode As %String(XMLNAME = "appMode");

/// 机构唯一识别码
Property orgCode As %String(XMLNAME = "orgCode");

/// 应用备案号
Property appRecordNo As %String(XMLNAME = "appRecordNo");

}
