/// Creator:李欣
/// CreateDate:20170824
Class web.Entity.BDP.BDPDataHistory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPDataHistory";

/// RowId
Property ID As %String;

Property BDPDAHTableName As %String;

/// 表名称
/// 对应表数据RowId
Property BDPDAHDataReference As %String;

/// 对应表数据描述
Property BDPDAHDesc As %String;

/// 使用日期和时间 节点5  保存时存$h
Property BDPDAHDate As %String;

/// 使用用户 节点6  从seeeion取——$Get(%session.Data("LOGON.USERID"))
Property BDPDAHUserID As %String;

}
