/// 报表用于数据的转换和保存
/// 这个类的属性作为DHC_INVPRTReports
/// 的必添项
Class web.DHCEntity.OPC.Report Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 计算的实际收款
Property CalGetTotal As %String(TRUNCATE = 1, XMLNAME = "GetTotal");

Property HISAmount As %String(TRUNCATE = 1, XMLNAME = "HISAmount");

/// 计算的实际退款
Property CalGiveTotal As %String(TRUNCATE = 1, XMLNAME = "GiveTotal");

Property HISDate As %String(TRUNCATE = 1);

Property HISEndDate As %String(TRUNCATE = 1, XMLNAME = "EndDate");

Property HISEndTime As %String(TRUNCATE = 1, XMLNAME = "EndTime");

/// 保存在数据库中的实际收款
Property HISNormalSum As %String(TRUNCATE = 1, XMLNAME = "HISNormalSum");

Property HISParkINVInfo As %String(TRUNCATE = 1, XMLNAME = "ParkINV");

Property HISParkNum As %String(TRUNCATE = 1, XMLNAME = "CancelNUM");

Property HISParkSum As %String(TRUNCATE = 1, XMLNAME = "CancelSUM");

/// 操作员实际上缴额
Property HISPatSum As %String(TRUNCATE = 1, XMLNAME = "HandSum");

/// 打印票据号码
Property HISRcptNO As %String(TRUNCATE = 1, XMLNAME = "INVNOinfo");

Property HISRefundINVInfo As %String(TRUNCATE = 1, XMLNAME = "RefundINV");

Property HISRefundNum As %String(TRUNCATE = 1, XMLNAME = "RefundNUM");

Property HISRefundSum As %String(TRUNCATE = 1, XMLNAME = "RefundSUM");

Property HISStartDate As %String(TRUNCATE = 1, XMLNAME = "StartDate");

/// 报表类型
Property HISReportType As %String(TRUNCATE = 1);

Property HISStartTime As %String(TRUNCATE = 1, XMLNAME = "StartTime");

Property HISTime As %String(TRUNCATE = 1);

Property HISUser As %String(TRUNCATE = 1);

/// 打印票据数量
Property HisNum As %String(TRUNCATE = 1, XMLNAME = "INVTotalNum");

Property HISUserName As %String(TRUNCATE = 1, XMLNAME = "sUser");

/// 打印的票据金额累计
Property HISINVTotalSum As %String(TRUNCATE = 1, XMLNAME = "TotalFee");

}
