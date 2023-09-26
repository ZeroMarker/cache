/// Description:护士长夜查房计划子表
/// Date:2018-05-03
/// Creator:guozj
Class DHCNMG.CHK.MgNurCheckPlanSub Extends %Persistent
{

Relationship Parref As DHCNMG.CHK.MgNurCheckPlan [ Cardinality = parent, Inverse = ChildSub ];

/// 项目
Property Itm As %String [ SqlColumnNumber = 2, SqlFieldName = Itm ];

/// 1月
Property Jan As %String [ SqlColumnNumber = 3, SqlFieldName = Jan ];

/// 2月
Property Feb As %String [ SqlColumnNumber = 4, SqlFieldName = Feb ];

/// 3月
Property Mar As %String [ SqlColumnNumber = 5, SqlFieldName = Mar ];

/// 4月
Property Apr As %String [ SqlColumnNumber = 6, SqlFieldName = Apr ];

/// 5月
Property May As %String [ SqlColumnNumber = 7, SqlFieldName = May ];

/// 6月
Property Jun As %String [ SqlColumnNumber = 8, SqlFieldName = Jun ];

/// 7月
Property Jul As %String [ SqlColumnNumber = 9, SqlFieldName = Jul ];

/// 8月
Property Aug As %String [ SqlColumnNumber = 10, SqlFieldName = Aug ];

/// 9月 
Property Sep As %String [ SqlColumnNumber = 11, SqlFieldName = Sep ];

/// 10月
Property Oct As %String [ SqlColumnNumber = 12, SqlFieldName = Oct ];

/// 11月
Property Nov As %String [ SqlColumnNumber = 13, SqlFieldName = Nov ];

/// 12月
Property Dece As %String [ SqlColumnNumber = 14, SqlFieldName = Dece ];

/// 质控项目ID
Property ItmID As %String [ SqlColumnNumber = 15, SqlFieldName = Itm_ID ];

Index Itm On (Parref, Itm);

Index qual On ItmID;

Storage Default
{
<Data name="MgNurCheckPlanSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Item</Value>
</Value>
<Value name="3">
<Value>Jan</Value>
</Value>
<Value name="4">
<Value>Feb</Value>
</Value>
<Value name="5">
<Value>Mar</Value>
</Value>
<Value name="6">
<Value>Apr</Value>
</Value>
<Value name="7">
<Value>May</Value>
</Value>
<Value name="8">
<Value>Jun</Value>
</Value>
<Value name="9">
<Value>Jul</Value>
</Value>
<Value name="10">
<Value>Aug</Value>
</Value>
<Value name="11">
<Value>Sep</Value>
</Value>
<Value name="12">
<Value>Oct</Value>
</Value>
<Value name="13">
<Value>Nov</Value>
</Value>
<Value name="14">
<Value>Dece</Value>
</Value>
<Value name="15">
<Value>Itm</Value>
</Value>
<Value name="16">
<Value>ItmID</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurCheckPlanSubD</DataLocation>
<DefaultData>MgNurCheckPlanSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurCheckPlanSubI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurCheckPlanSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
