/// creator:xbl
/// createdate:20181018
/// description:护理工作量管理季度考试成绩列表
Class DHCNMG.Work.MgQuarterExam Extends %Persistent
{

/// 病区
Property ScoreStaArea As %String [ SqlColumnNumber = 2, SqlFieldName = QuarterExam_Area ];

/// 护士
Property TestNur As %String [ SqlColumnNumber = 3, SqlFieldName = QuarterExam_Nur ];

/// 考试时间
Property TestDate As %Date [ SqlColumnNumber = 4, SqlFieldName = QuarterExam_Date ];

/// 季度
Property TestQuarter As %String [ SqlColumnNumber = 5, SqlFieldName = QuarterExam_Quarter ];

/// 成绩
Property TestScore As %String [ SqlColumnNumber = 6, SqlFieldName = QuarterExam_Score ];

/// 合格与否
Property TestValue As %String [ SqlColumnNumber = 7, SqlFieldName = QuarterExam_Result ];

/// 缺考原因
Property Reason As %String [ SqlColumnNumber = 8, SqlFieldName = Reason ];

/// 考试年度
Property TestYear As %String [ SqlColumnNumber = 9, SqlFieldName = QuarterExam_Year ];

Index Nur On TestNur;

Index NurYear On (TestYear, TestQuarter, TestNur);

Storage Default
{
<Data name="MgQuarterExamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreStaArea</Value>
</Value>
<Value name="3">
<Value>TestNur</Value>
</Value>
<Value name="4">
<Value>TestDate</Value>
</Value>
<Value name="5">
<Value>TestQuarter</Value>
</Value>
<Value name="6">
<Value>TestScore</Value>
</Value>
<Value name="7">
<Value>TestValue</Value>
</Value>
<Value name="8">
<Value>Reason</Value>
</Value>
<Value name="9">
<Value>TestYear</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgQuarterExamD</DataLocation>
<DefaultData>MgQuarterExamDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgQuarterExamD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgQuarterExamI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgQuarterExamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
