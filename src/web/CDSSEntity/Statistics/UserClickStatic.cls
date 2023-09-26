/// 名称：用户使用CDSS数据统计表
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2022-01-22
Class web.CDSSEntity.Statistics.UserClickStatic Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Statistics.UserClickStatic";

Property RowId As %String;

/// 用户ID 
Property UserID As %String;

/// 用户名
Property UserName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称
Property CTLocDesc As %String;

/// 就诊类型（急诊、门诊、住院）
Property VisitType As %String;

/// 用户点击时间
Property ClickTime As %String;

/// 操作目的（开立、写回、查看、下载）
Property OperType As %String;

/// 点击项目模块（诊断决策、治疗决策、预警信息、患者画像）
Property ClickModule As %String;

/// 点击项目类型（确诊诊断、检索框、推荐治疗方案、推荐出院指导等）
Property ClickProType As %String;

/// 点击项目名称、检索类型（脑梗死/检索类型）
Property ClickProName As %String;

/// 点击内容（检索内容，治疗方案细项等）
Property ClickText As %String(MAXLEN = "");

/// 点击类型,方便百科等统计（诊断、检验、检查、手术、护理、出院指导）
Property ClickType As %String;

/// 备注
Property Remark As %String;

}
