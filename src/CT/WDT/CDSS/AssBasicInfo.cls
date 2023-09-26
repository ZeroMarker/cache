/// Creator:李得原
/// CreatDate:2021-03-19
/// Description：评估表基本信息表
/// User:CT.WDT.CDSS.AssBasicInfo
Class CT.WDT.CDSS.AssBasicInfo Extends (%Persistent, User.Abstract)
{

/// 评估表指针
Property AssDR As CT.WDT.CDSS.AssBase [ Required ];

/// 文献出处
Property DocSource As %String(MAXLEN = "");

/// 展示名
Property DisplayName As %String(MAXLEN = "");

/// 第三方URL
Property LinkURL As %String(MAXLEN = "");

/// 第三方评估表ID
Property DocumentID As %String;

/// 开始日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

/// 页眉
Property PageHeader As %String(MAXLEN = "");

/// 页脚
Property PageFooter As %String(MAXLEN = "");

/// 结果解读
Property ResultExplain As %String(MAXLEN = "");

/// 相关解释
Property RelatedExplain As %String(MAXLEN = "");

/// 备注
Property Remark As %String(MAXLEN = "");

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

Index AssIndex On AssDR;

Index DocIDIndex On DocumentID As Exact;

Storage Default
{
<Data name="AssBasicInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssDR</Value>
</Value>
<Value name="3">
<Value>DocSource</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>LinkURL</Value>
</Value>
<Value name="6">
<Value>DocumentID</Value>
</Value>
<Value name="7">
<Value>StartDate</Value>
</Value>
<Value name="8">
<Value>EndDate</Value>
</Value>
<Value name="9">
<Value>PageHeader</Value>
</Value>
<Value name="10">
<Value>PageFooter</Value>
</Value>
<Value name="11">
<Value>ResultExplain</Value>
</Value>
<Value name="12">
<Value>RelatedExplain</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>VisitType</Value>
</Value>
<Value name="15">
<Value>ShowScoreFlag</Value>
</Value>
<Value name="16">
<Value>ShowResultFlag</Value>
</Value>
<Value name="17">
<Value>ShowConclusionFlag</Value>
</Value>
<Value name="18">
<Value>ScoreCalculateType</Value>
</Value>
<Value name="19">
<Value>ShowRatingUser</Value>
</Value>
<Value name="20">
<Value>BaseFlag</Value>
</Value>
<Value name="21">
<Value>AliasName</Value>
</Value>
<Value name="22">
<Value>ShowPriority</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssBasicInfoD</DataLocation>
<DefaultData>AssBasicInfoDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssBasicInfoD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssBasicInfoI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssBasicInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
