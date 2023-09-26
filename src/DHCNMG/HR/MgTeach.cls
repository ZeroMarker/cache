/// 
/// 
/// 教材编辑
Class DHCNMG.HR.MgTeach Extends %Persistent
{

/// 人员档案id
Property TeachPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Teach_PerDR ];

/// 教材名称
Property TeachTitle As %String [ SqlColumnNumber = 3, SqlFieldName = Teach_Title ];

/// 出版社
Property TeachPublic As %String [ SqlColumnNumber = 4, SqlFieldName = Teach_Public ];

/// 刊号
Property TeachPubNo As %String [ SqlColumnNumber = 5, SqlFieldName = Teach_PubNo ];

/// 人员类别
Property TeachType As %String [ SqlColumnNumber = 6, SqlFieldName = Teach_Type ];

/// 状态
Property TeachStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Teach_Status ];

Property TeachUser As %String [ SqlColumnNumber = 8, SqlFieldName = Teach_User ];

Index ssid On TeachPerDR;

Storage Default
{
<Data name="MgTeachDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TeachPerDR</Value>
</Value>
<Value name="3">
<Value>TeachTitle</Value>
</Value>
<Value name="4">
<Value>TeachPublic</Value>
</Value>
<Value name="5">
<Value>TeachPubNo</Value>
</Value>
<Value name="6">
<Value>TeachType</Value>
</Value>
<Value name="7">
<Value>TeachStatus</Value>
</Value>
<Value name="8">
<Value>TeachUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgTeachD</DataLocation>
<DefaultData>MgTeachDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgTeachD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgTeachI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgTeachS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
