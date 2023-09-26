/// 名称:地理信息-省实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-10
Class web.Entity.CT.CTProvince Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTProvince";

Property PROVRowId As %String;

// 代码

Property PROVCode As %String;

// 省

Property PROVDesc As %String;

// 开始日期

Property PROVDateFrom As %String;

// 结束日期

Property PROVDateTo As %String;

// 区域

Property PROVRegionDR As %String;

// 区域描述

Property PROVRegionDRDesc As %String;

/// 省级行政区罗马代码add@20220923
Property PROVRomanCode As %String;

/// 省级行政区罗马名称
Property PROVRomanDesc As %String;

/// 国家-外键
Property PROVCountryCode As %String;

/// 国家-描述
Property PROVCountryDesc As %String;

/// 是否有效(Y/N)
Property PROVActivity As %String;

/// 系统创建日期
Property PROVCreateDate As %String;

/// 系统创建时间
Property PROVCreateTime As %String;

/// 系统创建人
Property PROVCreateUser As %String;

/// 系统排序号
Property PROVSeqNo As %String;

/// 系统最后更新日期
Property PROVLastUpdateDate As %String;

/// 系统最后更新时间
Property PROVLastUpdateTime As %String;

/// 系统最新更新人
Property PROVLastUpdateUser As %String;

/// 拼音码
Property PROVPYCode As %String;

/// 五笔码
Property PROVWBCode As %String;

/// 备注
Property PROVMark As %String;

}
