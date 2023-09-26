/// 版本定义表Entity类
/// User.BDPTableVersion
/// 基础数据平台-杨帆
/// 2019年12月19日
Class web.Entity.BDP.BDPTableVersion Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPTableVersion";

/// RowId
Property RowID As %String;

/// 表名称（MRC_ICDDx)
Property TableName As %String;

/// 版本号
Property Version As %String;

/// 是否启用（Y/N)
Property ActiveFlag As %String;

/// 备注
Property Remarks As %String;

}
