Class BILL.EINV.DTO.TBTCA.InitHeaderInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 获取授权接口报文编号
Property MsgNo As %String(XMLPROJECTION = "ELEMENT");

/// 机构代码(财政统一分配)
Property Organ As %String(XMLPROJECTION = "ELEMENT");

/// 用户名(需要传实际操作人帐号)
Property User As %String(XMLPROJECTION = "ELEMENT");

/// 版本号，默认 1.0
Property Version As %String(XMLPROJECTION = "ELEMENT");

/// 应用账号,从财政部门获取
Property AppId As %String(XMLPROJECTION = "ELEMENT");

/// 业务请求编号
Property MsgId As %String(XMLPROJECTION = "ELEMENT");

/// 报文参考号
Property MsgRef As %String(XMLPROJECTION = "ELEMENT");

/// 请求时间
Property DateTime As %String(XMLPROJECTION = "ELEMENT");

/// 预留字段
Property Reserve As %String(XMLPROJECTION = "ELEMENT");

}
