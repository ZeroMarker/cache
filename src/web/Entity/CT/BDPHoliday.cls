/// 名称: 节假日
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-2-5
Class web.Entity.CT.BDPHoliday Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPHoliday";

/// RowId号
Property BDPHDRowId As %String;

/// 节假日代码(日期）
Property BDPHDDate As %String;

/// 节假日描述
Property BDPHDDesc As %String;

/// 节假日类型 工作日Work,节日Holiday，假日Weekend
Property BDPHDType As %String;

/// 半天标识1
Property BDPHDHalf1 As %String;

/// 半天标识2
Property BDPHDHalf2 As %String;

/// 用户
Property BDPHDUser As %String;

/// 备注
Property BDPHDRemark As %String;

/// 医院
Property BDPHDHospitalDR As %String;

}
