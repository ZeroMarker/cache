/// 
/// 
/// 调查选项
Class DHCNMG.DB.MgNurSurveyCheck Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgNurSurveyTypeSub [ Cardinality = parent, Inverse = ChildSub ];

/// 选项内容
Property CheckItem As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Check_Item ];

/// 分数
Property CheckScore As %String [ SqlColumnNumber = 3, SqlFieldName = Check_Score ];

Storage Default
{
<Data name="MgNurSurveyCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckItem</Value>
</Value>
<Value name="3">
<Value>CheckScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurSurveyCheckD</DataLocation>
<DefaultData>MgNurSurveyCheckDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurSurveyCheckI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurSurveyCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
