Class DHCExternalService.BillInterface.DHCEntity.CheckChargeInput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 0;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// TradeCode
Property TradeCode As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %String(TRUNCATE = 1);

/// 结束日期
Property EndDate As %String(TRUNCATE = 1);

/// 支付方式
Property PayMode As %String(TRUNCATE = 1);

/// 用户
Property ExtUserID As %String(TRUNCATE = 1);

}
