/// 人员报表权限
Class dhc.bonus.data.BonusEmpReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusEmpReportID ]
{

Index EmployUnitIndex On (BonusEmployeeID, BonusReportID);

Property BonusEmployeeID As dhc.bonus.data.BonusEmployee [ SqlColumnNumber = 2 ];

Property BonusReportID As dhc.bonus.data.BonusReport [ SqlColumnNumber = 3 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusEmpReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmployeeID</Value>
</Value>
<Value name="3">
<Value>BonusReportID</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsdataBonusEmpReportD</DataLocation>
<DefaultData>BonusEmpReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsdataBonusEmpReportD</IdLocation>
<IndexLocation>^dhcbsdataBonusEmpReportI</IndexLocation>
<StreamLocation>^dhcbsdataBonusEmpReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
