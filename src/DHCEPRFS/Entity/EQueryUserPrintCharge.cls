/// Desc:用以组织查询操作员打印收费汇总
/// Creator:yangpeng 2015.11.10
Class DHCEPRFS.Entity.EQueryUserPrintCharge Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// 代码
Property UserID As %String(TRUNCATE = 1);

/// 名称
Property UserName As %String(TRUNCATE = 1);

/// 人次
Property Count As %Integer;

/// 邮寄费次数
Property MailCount As %Integer;

/// 邮寄费金额
Property MailAmount As %Float;

/// 基础费次数
Property BasicCount As %Integer;

/// 基础费金额
Property BasicAmount As %Float;

/// 打印费次数
Property PrintCount As %Integer;

/// 打印费金额
Property PrintAmount As %Float;

/// 总金额
Property TotalAmount As %Float;

}
