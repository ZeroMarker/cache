/// 名称: 特别节假日情况关联记录表
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-2-5
Class web.Entity.CT.BDPHolidayService Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPHolidayService";

/// RowId号
Property BDPHSRowId As %String;

/// 节假日代码(日期）
Property BDPHSDate As %String;

/// 特别业务
Property BDPHSServiceDR As %String;

/// 标识，包含Include/例外Exclude
Property BDPHSIEFlag As %String;

/// 备注
Property BDPHSDesc As %String;

/// 医院
Property BDPHSHospitalDR As %String;

/// 时段 医生排班出诊时段设置表
Property BDPHSTimeRangeDR As %String;

/// 类型
Property BDPHSType As %String;

}
