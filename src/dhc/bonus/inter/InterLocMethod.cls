/// InterParam
Class dhc.bonus.inter.InterLocMethod Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterLocMethod_rowid, SqlTableName = InterLocMethod ]
{

Parameter EXTENTSIZE = 250;

/// InterLocMethod_methodName
Property InterLocMethodCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InterLocMethod_methodCode ];

/// InterLocMethod_methodName
Property InterLocMethodName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterLocMethod_methodName ];

/// InterLocMethod_globalName
Property InterLocMethodReturnType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterLocMethod_ReturnType ];

/// InterLocMethod_globalName
Property InterLocMethodrtnName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterLocMethod_ReturnName ];

/// InterLocMethod_locSetDr
Property InterLocSetSetDr As dhc.bonus.inter.InterLocSet [ SqlColumnNumber = 6, SqlFieldName = InterLocSet_rowid ];

Property InterLocMethodorder As %Library.Integer [ SqlColumnNumber = 7, SqlFieldName = InterLocMethod_order ];

/// InterLocMethod_active
Property InterLocMethodActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = InterLocMethod_active ];

/// InterLocMethod_active
Property InterLocMethodDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = InterLocMethod_methodDesc ];

Storage Default
{
<Data name="InterLocMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterLocMethodCode</Value>
</Value>
<Value name="3">
<Value>InterLocMethodName</Value>
</Value>
<Value name="4">
<Value>InterLocMethodReturnType</Value>
</Value>
<Value name="5">
<Value>InterLocMethodrtnName</Value>
</Value>
<Value name="6">
<Value>InterLocSetSetDr</Value>
</Value>
<Value name="7">
<Value>InterLocMethodorder</Value>
</Value>
<Value name="8">
<Value>InterLocMethodActive</Value>
</Value>
<Value name="9">
<Value>InterLocMethodDesc</Value>
</Value>
</Data>
<DataLocation>^dhcbsInterLocMethodD</DataLocation>
<DefaultData>InterLocMethodDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhcbsInterLocMethodD</IdLocation>
<IndexLocation>^dhcbsInterLocMethodI</IndexLocation>
<StreamLocation>^dhcbsInterLocMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
