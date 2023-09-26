Class DHCINM.DB.MgMoveData Extends %Persistent
{

/// 类型
Property Type As %String [ SqlColumnNumber = 2, SqlFieldName = Type ];

/// 4.0ID
Property OldID As %String [ SqlColumnNumber = 3, SqlFieldName = OldID ];

/// 4.1ID
Property NewID As %String [ SqlColumnNumber = 4, SqlFieldName = NewID ];

Index type On (Type, OldID, NewID);

Storage Default
{
<Data name="MgMoveDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>OldID</Value>
</Value>
<Value name="4">
<Value>NewID</Value>
</Value>
</Data>
<DataLocation>^DHCINM.DB.MgMoveDataD</DataLocation>
<DefaultData>MgMoveDataDefaultData</DefaultData>
<IdLocation>^DHCINM.DB.MgMoveDataD</IdLocation>
<IndexLocation>^DHCINM.DB.MgMoveDataI</IndexLocation>
<StreamLocation>^DHCINM.DB.MgMoveDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
