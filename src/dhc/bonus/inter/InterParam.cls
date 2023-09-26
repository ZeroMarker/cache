/// InterParam
Class dhc.bonus.inter.InterParam Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterParam_rowid, SqlTableName = InterParam ]
{

Parameter EXTENTSIZE = 250;

/// InterParam_className
Property InterParamCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InterParam_ParamCode ];

/// InterParam_methodName
Property InterParamName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterParam_ParamName ];

/// InterParam_paramName
Property InterParamDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterParam_ParamDesc ];

/// InterLocMethod_Type
Property InterParamType As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = InterParam_Type ];

/// InterLocMethod_active
Property InterParamActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = InterParam_active ];

Storage Default
{
<Data name="InterParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterParamCode</Value>
</Value>
<Value name="3">
<Value>InterParamName</Value>
</Value>
<Value name="4">
<Value>InterParamDesc</Value>
</Value>
<Value name="5">
<Value>InterParamType</Value>
</Value>
<Value name="6">
<Value>InterParamActive</Value>
</Value>
</Data>
<DataLocation>^dhcbsInterParamD</DataLocation>
<DefaultData>InterParamDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhcbsInterParamD</IdLocation>
<IndexLocation>^dhcbsInterParamI</IndexLocation>
<StreamLocation>^dhcbsInterParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
