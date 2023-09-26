Class DHCINM.Intern.MgWardPerRange Extends %Persistent
{

/// 病区
Property Ward As %String [ SqlColumnNumber = 2, SqlFieldName = Range_Ward ];

/// 上限
Property Max As %String [ SqlColumnNumber = 3, SqlFieldName = Range_Max ];

/// 下限
Property Min As %String [ SqlColumnNumber = 4, SqlFieldName = Range_Min ];

Index ward On Ward;

Storage Default
{
<Data name="MgWardPerRangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Ward</Value>
</Value>
<Value name="3">
<Value>Max</Value>
</Value>
<Value name="4">
<Value>Min</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgWardPerRangeD</DataLocation>
<DefaultData>MgWardPerRangeDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgWardPerRangeD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgWardPerRangeI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgWardPerRangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
