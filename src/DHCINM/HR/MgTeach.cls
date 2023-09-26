Class DHCINM.HR.MgTeach Extends %Persistent
{

/// 人员档案id
Property TeachPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Teach_PerDR ];

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
<DataLocation>^DHCINM.HR.MgTeachD</DataLocation>
<DefaultData>MgTeachDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgTeachD</IdLocation>
<IndexLocation>^DHCINM.HR.MgTeachI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgTeachS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
