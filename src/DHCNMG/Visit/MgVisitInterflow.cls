/// 
/// 
/// 参观交流
/// 
Class DHCNMG.Visit.MgVisitInterflow Extends %Persistent
{

Relationship ChildSub As DHCNMG.Visit.MgVisitFlowSub [ Cardinality = children, Inverse = Parref ];

/// 参观病区
Property VisitWard As list Of %String [ SqlColumnNumber = 2, SqlFieldName = Visit_Ward ];

/// 开始日期
Property VisitStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Visit_StDate ];

/// 结束日期
Property VisitEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Visit_EndDate ];

/// 省份
Property VisitProvince As %String [ SqlColumnNumber = 5, SqlFieldName = Visit_Province ];

/// 状态
Property VisitStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Visit_Status ];

/// 创建者
Property VisitUser As %String [ SqlColumnNumber = 7, SqlFieldName = Visit_User ];

Property VisitContent As %String(MAXLEN = 2000) [ SqlColumnNumber = 8, SqlFieldName = Visit_Content ];

Index Date On VisitStDate;

Storage Default
{
<Data name="MgVisitInterflowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitWard</Value>
</Value>
<Value name="3">
<Value>VisitStDate</Value>
</Value>
<Value name="4">
<Value>VisitEndDate</Value>
</Value>
<Value name="5">
<Value>VisitProvince</Value>
</Value>
<Value name="6">
<Value>VisitPerson</Value>
</Value>
<Value name="7">
<Value>VisitJob</Value>
</Value>
<Value name="8">
<Value>VisitPost</Value>
</Value>
<Value name="9">
<Value>VisitUnit</Value>
</Value>
<Value name="10">
<Value>VisitCall</Value>
</Value>
<Value name="11">
<Value>VisitStatus</Value>
</Value>
<Value name="12">
<Value>VisitUser</Value>
</Value>
<Value name="13">
<Value>VisitContent</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Visit.MgVisitInterflowD</DataLocation>
<DefaultData>MgVisitInterflowDefaultData</DefaultData>
<IdLocation>^DHCNMG.Visit.MgVisitInterflowD</IdLocation>
<IndexLocation>^DHCNMG.Visit.MgVisitInterflowI</IndexLocation>
<StreamLocation>^DHCNMG.Visit.MgVisitInterflowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
