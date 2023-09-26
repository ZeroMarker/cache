Class dhc.bonus.inter.InterMethodParam Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterMethodParam_rowid, SqlTableName = InterMethodParam ]
{

Parameter EXTENTSIZE = 250;

/// InterMethodParam_MethodDr
Property InterLocMethodDr As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 2, SqlFieldName = InterLocMethod_rowid ];

/// 取InterParam中InterParamType=1
Property InterParamCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterMethodParam_ParamCode ];

/// 1:固定参数，2：动态参数
Property InterParamFlag As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterMethodParam_ParamFlag ];

/// 当InterParamFlag=1 时，该项需要录入值
Property InterParamValue As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterMethodParam_ParamValue ];

Property InterParamOrder As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InterMethodParam_ParamOrder ];

Index InterLocMethodID On (InterLocMethodDr, InterParamOrder);

Storage Default
{
<Data name="InterMethodParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterLocMethodDr</Value>
</Value>
<Value name="3">
<Value>InterParamCode</Value>
</Value>
<Value name="4">
<Value>InterParamFlag</Value>
</Value>
<Value name="5">
<Value>InterParamValue</Value>
</Value>
<Value name="6">
<Value>InterParamOrder</Value>
</Value>
</Data>
<DataLocation>^dhcbsMethodParamD</DataLocation>
<DefaultData>InterMethodParamDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhcbsMethodParamD</IdLocation>
<IndexLocation>^dhcbsMethodParamI</IndexLocation>
<StreamLocation>^dhcbsMethodParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
