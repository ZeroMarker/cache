/// 名称：医学组数据运维统计表
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2022-01-22
Class web.CDSSEntity.Statistics.MKBStatistics Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Statistics.MKBStatistics";

Property RowId As %String;

/// 医学组数据统计配置表指针
Property ConfigDr As %String;

/// 总数据量
Property TotalNum As %Integer;

/// 编辑中的数据量
Property EditNum As %Integer;

/// 待审核
Property StayNum As %Integer;

/// 已审核的数据量（审核通过+已上线）
Property PassedNum As %Integer;

/// 统计日期
Property StatisticsDate As %String;

/// 备注
Property Remark As %String;

}
