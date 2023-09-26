/// 名称:私有数据关联医院
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-02-12
Class web.Entity.BDP.BDPMappingHosp Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPMappingHosp";

// RowId

Property ID As %String;

// 表名称

Property BDPMPHTableName As %String;

// 对应表数据RowID

Property BDPMPHDataReference As %String;

// 关联的医院

Property BDPMPHHospital As %String;

}
