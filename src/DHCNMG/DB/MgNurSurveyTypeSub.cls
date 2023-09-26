Class DHCNMG.DB.MgNurSurveyTypeSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgNurSurveyType [ Cardinality = parent, Inverse = ChildSub ];

Relationship ChildSub As DHCNMG.DB.MgNurSurveyCheck [ Cardinality = children, Inverse = Parref ];

/// 项目内容
Property ItemOption As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Item_Option ];

/// 项目类型【R：radio W:input】
Property ItemType As %String [ SqlColumnNumber = 3, SqlFieldName = Item_Type ];

Storage Default
{
<Data name="MgNurSurveyTypeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckOption</Value>
</Value>
<Value name="3">
<Value>CheckType</Value>
</Value>
<Value name="4">
<Value>ItemOption</Value>
</Value>
<Value name="5">
<Value>ItemType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurSurveyTypeSubD</DataLocation>
<DefaultData>MgNurSurveyTypeSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurSurveyTypeSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurSurveyTypeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
