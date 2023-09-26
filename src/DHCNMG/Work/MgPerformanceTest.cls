/// creator:xbl
/// createdate:20181030
/// description:护理工作量管理操作项考试成绩列表
Class DHCNMG.Work.MgPerformanceTest Extends %Persistent
{

/// 病区
Property ScoreStaArea As %String [ SqlColumnNumber = 2, SqlFieldName = ScoreSta_Area ];

/// 护士
Property TestNur As %String [ SqlColumnNumber = 3, SqlFieldName = PerformanceTest_Nur ];

/// 考试时间
Property TestDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PerformanceTest_Date ];

/// 操作项目
Property Performance As %String [ SqlColumnNumber = 5, SqlFieldName = Performance ];

/// 成绩
Property TestScore As %String [ SqlColumnNumber = 6, SqlFieldName = PerformanceTest_Score ];

/// 合格与否
Property TestValue As %String [ SqlColumnNumber = 7, SqlFieldName = PerformanceTest_Result ];

/// 缺考原因
Property Reason As %String [ SqlColumnNumber = 8, SqlFieldName = Reason ];

/// 考试年度
Property TestYear As %String [ SqlColumnNumber = 9, SqlFieldName = PerformanceTest_Year ];

Index Nur On TestNur;

Index NurYear On (TestYear, Performance, TestNur);

Index DateWardStu On (TestDate, ScoreStaArea, TestNur);

Storage Default
{
<Data name="MgPerformanceTestDefaultData">
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
<Value>Performance</Value>
</Value>
<Value name="6">
<Value>TestScore</Value>
</Value>
<Value name="7">
<Value>TestValue</Value>
</Value>
<Value name="8">
<Value>LeaveReason</Value>
</Value>
<Value name="9">
<Value>TestYear</Value>
</Value>
<Value name="10">
<Value>Reason</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgPerformanceTestD</DataLocation>
<DefaultData>MgPerformanceTestDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgPerformanceTestD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgPerformanceTestI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgPerformanceTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
