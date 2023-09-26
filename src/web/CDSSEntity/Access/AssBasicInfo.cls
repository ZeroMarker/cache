/// 名称：评估表基础信息表
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2021-03-19
Class web.CDSSEntity.Access.AssBasicInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Access.AssBasicInfo";

Property RowId As %String;

/// 评估表指针
Property AssDR As %String;

/// 文献出处
Property DocSource As %String;

/// 展示名
Property DisplayName As %String;

/// 第三方URL
Property LinkURL As %String;

/// 第三方评估表ID
Property DocumentID As %String;

/// 开始日期
Property StartDate As %String;

/// 结束日期
Property EndDate As %String;

/// 页眉
Property PageHeader As %String;

/// 页脚
Property PageFooter As %String;

/// 结果解读
Property ResultExplain As %String;

/// 相关解释
Property RelatedExplain As %String;

/// 备注
Property Remark As %String;

/// 就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)
Property VisitType As %String;

/// 是否显示总分(1-不显示或空，0-显示)
Property ShowScoreFlag As %String;

/// 是否显示评估结果(1-不显示；空或0-显示)
Property ShowResultFlag As %String;

/// 是否显示结论(1-不显示；空或0-显示)
Property ShowConclusionFlag As %String;

/// 评分结果计算类型(Sum-累加；Avg-计算平均值；Max-取所有选项最大值。默认值是累加)
Property ScoreCalculateType As %String;

/// 历史记录是否显示评定人
Property ShowRatingUser As %String;

/// 是否基础评估表
Property BaseFlag As %String;

/// 别名
Property AliasName As %String;

/// 展示优先级 2023-03-22
Property ShowPriority As %String;

}
