Class DHCExternalService.BillInterface.DHCEntity.CheckChargeOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 0;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// APPCODE	操作是否出错
Property ResultCode As %String(TRUNCATE = 1);

/// ERRORMSG	错误描述
Property ResultContent As %String(TRUNCATE = 1);

/// OUTCHECKDATE	对账日期
Property PayDate As %String(TRUNCATE = 1);

/// OUTRECEIVERNO	操作员编码
Property ExtUserID As %String(TRUNCATE = 1);

/// OUTTOTALCASH	对账总额
Property TotalFee As %String(TRUNCATE = 1);

/// OUTRECCURS	游标
Property Item As list Of DHCExternalService.BillInterface.DHCEntity.OUTRECCUR;

}
