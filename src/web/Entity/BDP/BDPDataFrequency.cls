/// 20170620
/// 用户使用频率
Class web.Entity.BDP.BDPDataFrequency Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPDataFrequency";

/// RowId
Property ID As %String;

/// 表名称
Property BDPDAFTableName As %String;

/// 对应表数据RowId
Property BDPDAFDataReference As %String;

/// 对应表数据描述
Property BDPDAFDesc As %String;

/// 使用频次
Property BDPDAFFrequency As %String;

/// 使用用户
Property BDPDAFUserID As %String;

/// 频次类型
Property BDPDAFType As %String;

/// 用户科室
Property BDPCTLocDR As %String;

}
