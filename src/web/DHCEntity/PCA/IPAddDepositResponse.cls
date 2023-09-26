/// Creator:wangjian
/// CreatDate:2013-02-20
/// Description:住院预交金充值出参
Class web.DHCEntity.PCA.IPAddDepositResponse Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 0;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// ResultCode	交易结果 非0失败
Property ResultCode As %String(TRUNCATE = 1);

/// ResultContent	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// DepositAmount	院内账户预交金余额
Property DepositAmount As %String(TRUNCATE = 1);

/// InvoiceNo	预交金收据号
Property InvoiceNo As %String(TRUNCATE = 1);

}
