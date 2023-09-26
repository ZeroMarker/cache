Class DHCExternalService.CardInterface.Entity.ReturnInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 病人唯一主索引PMI
Property PatientID As %String(TRUNCATE = 1);

/// 银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// 银行业务流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 结果标志(1–成功,-1–失败)
Property ResultCode As %String(TRUNCATE = 1);

/// 错误信息(当ResultCode=-1时有值)
Property ErrorMsg As %String(TRUNCATE = 1);

//签约状态查询使用

/// 签约状态(0=没有签约, 1= 签约)
Property SignedStatus As %String(TRUNCATE = 1);

/// 是否需要激活的标志
Property ActiveFlag As %String(TRUNCATE = 1);

//End

}
