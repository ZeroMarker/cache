Class CHSS.PersonCarePlan Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PlanRowId, SqlTableName = PersonCarePlan ]
{

//管理计划内容

Property CaseHisRowId As CHSS.PersonCaseHis [ Required ];

Property PlanName As %String(MAXLEN = 60, TRUNCATE = 1);

Property PlanContent As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="PersonCarePlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CaseHisRowId</Value>
</Value>
<Value name="3">
<Value>PlanContent</Value>
</Value>
<Value name="4">
<Value>PlanName</Value>
</Value>
<Value name="5">
<Value>PlanRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonCarePlanD</DataLocation>
<DefaultData>PersonCarePlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonCarePlanD</IdLocation>
<IndexLocation>^CHSS.PersonCarePlanI</IndexLocation>
<StreamLocation>^CHSS.PersonCarePlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
