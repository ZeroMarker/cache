Class DHCNMG.Visit.MgVisitFlowSub Extends %Persistent [ Owner = {dhpm1} ]
{

Relationship Parref As DHCNMG.Visit.MgVisitInterflow [ Cardinality = parent, Inverse = ChildSub ];

/// 交流人员
Property VisitPerson As %String [ SqlColumnNumber = 2, SqlFieldName = Visit_Person ];

/// 职称
Property VisitJob As %String [ SqlColumnNumber = 3, SqlFieldName = Visit_Job ];

/// 职务
Property VisitPost As %String [ SqlColumnNumber = 4, SqlFieldName = Visit_Post ];

/// 单位	
Property VisitUnit As %String [ SqlColumnNumber = 5, SqlFieldName = Visit_Unit ];

/// 联系电话	
Property VisitCall As %String [ SqlColumnNumber = 6, SqlFieldName = Visit_Call ];

Storage Default
{
<Data name="MgVisitFlowSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitPerson</Value>
</Value>
<Value name="3">
<Value>VisitJob</Value>
</Value>
<Value name="4">
<Value>VisitPost</Value>
</Value>
<Value name="5">
<Value>VisitUnit</Value>
</Value>
<Value name="6">
<Value>VisitCall</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Visit.MgVisitFlowSubD</DataLocation>
<DefaultData>MgVisitFlowSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Visit.MgVisitFlowSubI</IndexLocation>
<StreamLocation>^DHCNMG.Visit.MgVisitFlowSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
