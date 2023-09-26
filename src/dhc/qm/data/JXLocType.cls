Class dhc.qm.data.JXLocType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXLocType_rowid, SqlTableName = JXLocType ]
{

/// JXLocType_code
Property JXLocTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JXLocType_code ];

/// JXLocType_name
Property JXLocTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXLocType_name ];

/// JXLocType_desc
Property JXLocTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXLocType_desc ];

/// JXLocType_active
Property JXLocTypeActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = JXLocType_active ];

Index JXLocTypeCode On JXLocTypeCode;

Index JXLocTypeName On JXLocTypeName;

Storage Default
{
<Data name="JXLocTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JXLocTypeCode</Value>
</Value>
<Value name="3">
<Value>JXLocTypeName</Value>
</Value>
<Value name="4">
<Value>JXLocTypeDesc</Value>
</Value>
<Value name="5">
<Value>JXLocTypeActive</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMJXLocTypeD</DataLocation>
<DefaultData>JXLocTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMJXLocTypeD</IdLocation>
<IndexLocation>^DHCCJXQMJXLocTypeI</IndexLocation>
<StreamLocation>^DHCCJXQMJXLocTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
