Class DHCDoc.Interface.Outside.GDHealthCardService.Entity.resetVmcardInfoBody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 证件类别 Y、见《身份证类别代码》新的（V1.1变更）
Property idCardTypeCode As %String(XMLNAME = "idCardTypeCode");

/// 证件号码  Y、加密 新的
Property idCode As %String(XMLNAME = "idCode");

/// 姓名  Y、加密 新的
Property name As %String(XMLNAME = "name");

/// 电子健康卡 ID Y 旧的
Property erhcCardNo As %String(XMLNAME = "erhcCardNo");

/* Y 传输代码
	1、APP在线申请
	2、医疗卫生机构自助机申请
	3、医疗卫生机构窗口申请
	4、批量预生成
	5、微信服务号
	6、微信小程序
	7、支付宝生活号
	8、支付宝小程序
	9、其他 */
/// 操作方式
Property appMode As %String(XMLNAME = "appMode");

/// 机构唯一识别码  Y 由应用机构注册备案过的机构唯一识别码
Property orgCode As %String(XMLNAME = "orgCode");

/// 应用备案号
Property appRecordNo As %String(XMLNAME = "appRecordNo");

}
