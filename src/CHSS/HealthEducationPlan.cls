Class CHSS.HealthEducationPlan Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PlanRowId, SqlTableName = HealthEducationPlan ]
{

Index CommunityCodeIndex On CommunityCode;

Index NameIndex On PlanName;

//计划名称

Property PlanName As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PlanName ];

//计划类型

Property PlanType As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PlanType ];

//内容

Property PlanContent As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PlanContent ];

//目的

Property PlanTarget As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PlanTarget ];

//实施情况

Property ProgressInfo As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ProgressInfo ];

//总结

Property Summarize As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Summarize ];

//创建日期

Property DateOfCreate As %Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DateOfCreate ];

//开始日期

Property DateOfStart As %Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DateOfStart ];

//结束日期

Property DateOfEnd As %Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DateOfEnd ];

//创建人员

Property StaffOfCreate As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = StaffOfCreate ];

//社区编码

Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CommunityCode ];

Storage Default
{
<Data name="HealthEducationPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommunityCode</Value>
</Value>
<Value name="3">
<Value>DateOfCreate</Value>
</Value>
<Value name="4">
<Value>DateOfEnd</Value>
</Value>
<Value name="5">
<Value>DateOfStart</Value>
</Value>
<Value name="6">
<Value>PlanContent</Value>
</Value>
<Value name="7">
<Value>PlanName</Value>
</Value>
<Value name="8">
<Value>PlanTarget</Value>
</Value>
<Value name="9">
<Value>PlanType</Value>
</Value>
<Value name="10">
<Value>ProgressInfo</Value>
</Value>
<Value name="11">
<Value>StaffOfCreate</Value>
</Value>
<Value name="12">
<Value>Summarize</Value>
</Value>
</Data>
<DataLocation>^CHSS.HealthEducationPlanD</DataLocation>
<DefaultData>HealthEducationPlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HealthEducationPlanD</IdLocation>
<IndexLocation>^CHSS.HealthEducationPlanI</IndexLocation>
<StreamLocation>^CHSS.HealthEducationPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
