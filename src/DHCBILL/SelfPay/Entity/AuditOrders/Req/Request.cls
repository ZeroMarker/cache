/// Creator: TianZJ
/// CreatDate: 2022-08-15
/// Description:门诊退费审核接口获取医嘱审核信息
Class DHCBILL.SelfPay.Entity.AuditOrders.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

// =0 XML属性不按照顺序解析；=1 XML元素和类的属性顺序必须一致，否则解析时将被忽略。

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

// =0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

// =1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

// =inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// InvID	发票ID
Property InvID As %String(TRUNCATE = 1);

/// UserCode	操作员工号
Property UserCode As %String(TRUNCATE = 1);

/// AuditStr	审核信息串
Property AuditStr As %String(TRUNCATE = 1);

/// AuditReason	退费原因
Property AuditReason As %String(TRUNCATE = 1);

/// Loc	退费科室
Property Loc As %String(TRUNCATE = 1);

/// Grp	退费审核安全组
Property Group As %String(TRUNCATE = 1);

/// Hospital 院区
Property Hospital As %String(TRUNCATE = 1);

}
