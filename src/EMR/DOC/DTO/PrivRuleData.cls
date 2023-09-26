/// 名称:	EMR.DOC.DTO.PrivRuleData
/// 描述:	权限规则脚本数据传输对象
/// 编写者：	yejian
/// 编写日期: 	2022-8-10
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.PrivRuleData Extends %RegisteredObject
{

/// 就诊号
Property admid As %String;

/// 用户ID
Property userid As %String;

/// 住院号
Property patientid As %String;

/// 文档ID
Property documentid As %String;

/// 科室ID
Property userloc As %String;

/// 模板ID
Property templateid As %String;

/// 安全组ID
Property ssgroupid As %String;

/// 标题
Property categoryid As %String;

/// 业务活动记录编码
Property doccode As %String;

/// 业务活动记录名称
Property docname As %String;

/// seesionID
Property sessionid As %String;

/// 项目标识
Property productcode As %String;

/// 病历实例ID集合
Property documentids As %DynamicArray;

}
