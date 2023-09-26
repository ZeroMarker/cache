Class web.DHCPE.Service.SystemStatus Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

/// 医嘱号,必填
Property OEOrdItemID As %String;

/// 检查部位
Property Position As %String;

/// 检查号
Property ExamID As %String;

/// 状态,必填 （AP:申请;SC:登记;CM:检查完成;RP:报告;CHARGE:收费）
Property Status As %String;

/// 操作人工号,必填
Property UserID As %String;

/// 操作人姓名,必填
Property UserName As %String;

/// 操作时间日期,必填
Property UpDateTime As %String;

/// 来源系统,必填  
Property SourceSystem As %String;

/// 备注  
Property Notes As %String;

/// 操作科室代码,必填
Property OperateDeptCode As %String;

/// 操作科室名称,必填
Property OperateDept As %String;

}
