Class dhc.qm.data.Condition Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Condition_rowid, SqlTableName = Condition ]
{

/// Condition_code
Property ConditionCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Condition_code ];

/// Condition_name
Property ConditionName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Condition_name ];

/// Condition_shortcut
Property ConditionShortcut As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Condition_shortcut ];

/// Condition_desc
Property ConditionDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Condition_desc ];

/// Condition_active
Property ConditionActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = Condition_active ];

Index ConditionCode On ConditionCode;

Index ConditionName On ConditionName;

Storage Default
{
<Data name="ConditionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConditionCode</Value>
</Value>
<Value name="3">
<Value>ConditionName</Value>
</Value>
<Value name="4">
<Value>ConditionShortcut</Value>
</Value>
<Value name="5">
<Value>ConditionDesc</Value>
</Value>
<Value name="6">
<Value>ConditionActive</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMConditionD</DataLocation>
<DefaultData>ConditionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMConditionD</IdLocation>
<IndexLocation>^DHCCJXQMConditionI</IndexLocation>
<StreamLocation>^DHCCJXQMConditionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
