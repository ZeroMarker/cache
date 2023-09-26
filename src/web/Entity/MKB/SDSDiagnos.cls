/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：独立的结构化诊断实体类
/// Table：User.SDSDiagnos
Class web.Entity.MKB.SDSDiagnos Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.SDSDiagnos";

Property SDSRowId As %String;

/// 诊断id
Property SDSTermDR As %String;

/// 属性内容值串
Property SDSValue As %String;

/// 诊断补充信息
Property SDSSupplement As %String;

/// 关联ICD代码
Property SDSIcdCode As %String;

/// 关联ICD描述
Property SDSIcdDesc As %String;

/// 诊断词表id
Property SDSWordDR As %String;

/// 开立日期
Property SDSOpenDate As %String;

/// 顺序
Property SDSSequence As %String;

/// 主诊断
Property SDSMainDiagFlag As %String;

/// 诊断标记
Property SDSTagDR As %String;

/// 级别
Property SDSLevel As %String;

/// 发病日期
Property SDSOnsetDate As %String;

/// 诊断类型
Property SDSTypeDR As %String;

/// 诊断状态
Property SDSStatusDR As %String;

/// 分类
Property SDSCat As %String;

/// 患者指向
Property SDSPMIDR As %String;

/// 就诊指向
Property SDSAdmDR As %String;

}
