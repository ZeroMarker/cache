Class DHCExternalService.BillInterface.DHCEntity.IPCostInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode	交易结果 非0 错误
Property ResultCode As %String(TRUNCATE = 1);

/// ResultContent	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 总费用
Property totalAmout As %String(TRUNCATE = 1);

/// 预交金总额
Property prepayAmout As %String(TRUNCATE = 1);

/// 未结金额
Property unsettled As %String(TRUNCATE = 1);

Property settled As %String(TRUNCATE = 1);

/// 剩余预交金
Property validPrepayAmout As %String(TRUNCATE = 1);

Property balance As %String(TRUNCATE = 1);

Property billAmout As %String(TRUNCATE = 1);

/// DOB	出生日期
Property feeInfo As list Of DHCExternalService.BillInterface.DHCEntity.TarOCCateItem;

}
