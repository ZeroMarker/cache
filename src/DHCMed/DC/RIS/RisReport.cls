/// 名称 : DHCMed.DC.RIS.RisReport
/// 说明 : 检查报告
Class DHCMed.DC.RIS.RisReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID/检查登记ID
Property ResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱ID
Property OEItemID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检查号
Property StudyNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检查所见
Property ExamDesc As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 诊断意见
Property ResultDesc As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 登记日期
Property RegDate As %Date;

/// 登记时间
Property RegTime As %Time;

/// 登记医生
Property RegUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告医生
Property RepUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Storage Default
{
<Data name="RisReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResultID</Value>
</Value>
<Value name="3">
<Value>OEItemID</Value>
</Value>
<Value name="4">
<Value>StudyNo</Value>
</Value>
<Value name="5">
<Value>ExamDesc</Value>
</Value>
<Value name="6">
<Value>ResultDesc</Value>
</Value>
<Value name="7">
<Value>RegDate</Value>
</Value>
<Value name="8">
<Value>RegTime</Value>
</Value>
<Value name="9">
<Value>RegUser</Value>
</Value>
<Value name="10">
<Value>RepDate</Value>
</Value>
<Value name="11">
<Value>RepTime</Value>
</Value>
<Value name="12">
<Value>RepUser</Value>
</Value>
<Value name="13">
<Value>IsActive</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.RIS.RisReportD</DataLocation>
<DefaultData>RisReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.RIS.RisReportD</IdLocation>
<IndexLocation>^DHCMed.DC.RIS.RisReportI</IndexLocation>
<StreamLocation>^DHCMed.DC.RIS.RisReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
