/// 名称：评估结果字典表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-01-08
Class web.CDSSEntity.Access.AssConResCondi Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssConResCondi";

Property ID As %String;

/// 评估表指针
Property AssDR As %String;

/// 类型（总分、结论、描述）
Property DataType As %String;

/// 计算方式（累加、平均值、最大值、最小值、公式、特殊）
Property CalculateMethod As %String(MAXLEN = "");

/// 公式/特殊条件
Property CondiContent As %String(MAXLEN = "");

/// 显示内容
Property ShowContent As %String(MAXLEN = "");

/// 备注
Property Remark As %String(MAXLEN = "");

}
