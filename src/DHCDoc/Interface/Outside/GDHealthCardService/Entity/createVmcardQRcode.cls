Class DHCDoc.Interface.Outside.GDHealthCardService.Entity.createVmcardQRcode Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 接口名称
Property method As %String(XMLNAME = "method");

/// 应用编号
Property appId As %String(XMLNAME = "appId");

/// 随机数
Property nonceStr As %String(XMLNAME = "nonceStr");

/// 接口版本号
Property version As %String(XMLNAME = "version");

/// 请求时间戳
Property timestamp As %String(XMLNAME = "timestamp");

/// 头部信息签名
Property headSign As %String(XMLNAME = "headSign");

/// 上传信息签名
Property bodySign As %String(XMLNAME = "bodySign");

/// 数据签名模式
Property signMode As %String(XMLNAME = "signMode");

/// 数据加密模式
Property encryptMode As %String(XMLNAME = "encryptMode");

Property signature As %String(XMLNAME = "signature");

/// 请求参数集合
Property body As list Of DHCDoc.Interface.Outside.GDHealthCardService.Entity.vmcardQRcode(XMLITEMNAME = "", XMLNAME = "body", XMLPROJECTION = "COLLECTION");

}
