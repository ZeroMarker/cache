/// 名称: 节假日特殊业务代码
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-2-5
Class web.Entity.CT.BDPSpecialService Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPSpecialService";

/// RowId号
Property BDPSSRowId As %String;

/// 业务代码
Property BDPSSCode As %String;

/// 业务描述
Property BDPSSDesc As %String;

/// 备注
Property BDPSSRemark As %String;

/// 是否开启时段标识Y/N 
Property BDPSSTimeRangeFlag As %String;

}
