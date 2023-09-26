/// Description:护士长夜查房计划
/// Date:2018-05-03
/// Creator:gzj
Class DHCNMG.CHK.MgNurCheckPlan Extends %Persistent
{

Relationship ChildSub As DHCNMG.CHK.MgNurCheckPlanSub [ Cardinality = children, Inverse = Parref ];

/// 年份
Property CheckYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Check_Year ];

/// 类型
Property CheckType As %String [ SqlColumnNumber = 3, SqlFieldName = Check_Type ];

Index Type On (CheckYear, CheckType);

Storage Default
{
<Data name="MgNurCheckPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckYear</Value>
</Value>
<Value name="3">
<Value>CheckType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurCheckPlanD</DataLocation>
<DefaultData>MgNurCheckPlanDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurCheckPlanD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurCheckPlanI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurCheckPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
