Class DHCNMG.Arg.MgDNCheckSub Extends %Persistent
{

Relationship Parref As DHCNMG.Arg.MgDutyNurCheck [ Cardinality = parent, Inverse = ChildSub ];

/// 病区
Property CheckWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Check_WardDR ];

/// 存在问题
Property CheckProblem As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = Check_Problem ];

/// 责任人
Property DutyPerson As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Duty_Person ];

/// 加减分
Property CheckScore As %String [ SqlColumnNumber = 8, SqlFieldName = Check_Score ];

/// 备注
Property CheckRemark As %String [ SqlColumnNumber = 9, SqlFieldName = Check_Remark ];

Index Ward On CheckWardDR;

Storage Default
{
<Data name="MgDNCheckSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckWardDR</Value>
</Value>
<Value name="3">
<Value>CheckProblem</Value>
</Value>
<Value name="4">
<Value>DutyPerson</Value>
</Value>
<Value name="5">
<Value>CheckScore</Value>
</Value>
<Value name="6">
<Value>CheckRemark</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgDNCheckSubD</DataLocation>
<DefaultData>MgDNCheckSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgDNCheckSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgDNCheckSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
