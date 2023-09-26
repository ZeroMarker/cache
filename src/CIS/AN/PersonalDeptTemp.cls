Class CIS.AN.PersonalDeptTemp Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PersonalDeptTemp ]
{

/// 用户所在科室ID
Property UserLocID As %String [ SqlColumnNumber = 2 ];

/// 用户ID
Property UserID As %String [ SqlColumnNumber = 3 ];

/// 用户信息
Property UserPersonalInfo As %String [ SqlColumnNumber = 4 ];

Index User On (UserID As Exact, UserLocID As Exact);

Storage Default
{
<Data name="PersonalDeptTempDefaultData">
<Value name="1">
<Value>UserLocID</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserPersonalInfo</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PersonalDeptTempD</DataLocation>
<DefaultData>PersonalDeptTempDefaultData</DefaultData>
<IdLocation>^CIS.AN.PersonalDeptTempD</IdLocation>
<IndexLocation>^CIS.AN.PersonalDeptTempI</IndexLocation>
<StreamLocation>^CIS.AN.PersonalDeptTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
