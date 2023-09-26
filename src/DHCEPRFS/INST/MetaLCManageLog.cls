Class DHCEPRFS.INST.MetaLCManageLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property TableRowID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property FieldRowID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property FieldName As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property ActDate As %Date [ SqlColumnNumber = 6 ];

Property ActTime As %Time [ SqlColumnNumber = 7 ];

Property ActUserType As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Property ActUserCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Property ActType As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property OldValue As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 11 ];

Property NewValue As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 12 ];

Index IndexMain On TableRowID;

Index IndexFieldRowID On (TableRowID, FieldRowID, ActDate, ActTime);

Index IndexTableRowID On (TableRowID, ActDate, ActTime);

Storage Default
{
<Data name="MetaLCManageLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>TableRowID</Value>
</Value>
<Value name="4">
<Value>FieldRowID</Value>
</Value>
<Value name="5">
<Value>FieldName</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>ActUserType</Value>
</Value>
<Value name="9">
<Value>ActUserCode</Value>
</Value>
<Value name="10">
<Value>ActType</Value>
</Value>
<Value name="11">
<Value>OldValue</Value>
</Value>
<Value name="12">
<Value>NewValue</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MetaLCManageLogD</DataLocation>
<DefaultData>MetaLCManageLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.MetaLCManageLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MetaLCManageLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MetaLCManageLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
