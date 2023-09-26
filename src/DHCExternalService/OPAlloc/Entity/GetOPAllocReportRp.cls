Class DHCExternalService.OPAlloc.Entity.GetOPAllocReportRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 记录数量
Property RecordCount As %String(TRUNCATE = 1);

Property ReportInfo As list Of DHCExternalService.OPAlloc.Entity.List.OPAllocReport;

}
