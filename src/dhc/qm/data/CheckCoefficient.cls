Class dhc.qm.data.CheckCoefficient Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CheckCoefficient_rowid, SqlTableName = CheckCoefficient ]
{

/// CheckCoefficient_CheckDr
Property CheckCoefficientCheckDr As dhc.qm.data.Check [ SqlColumnNumber = 2, SqlFieldName = CheckCoefficient_CheckDr ];

/// CheckCoefficient_Coefficient
Property CheckCoefficientCoefficient As %Library.String [ SqlColumnNumber = 3, SqlFieldName = CheckCoefficient_Coefficient ];

/// CheckCoefficient_SchemDr 2016-7-1 add cyl
Property CheckCoefficientSchemDr As dhc.qm.data.QMSchem [ SqlColumnNumber = 4, SqlFieldName = CheckCoefficient_SchemDr ];

Index CheckCoefficientCheckDr On CheckCoefficientCheckDr;

Storage Default
{
<Data name="CheckCoefficientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckCoefficientCheckDr</Value>
</Value>
<Value name="3">
<Value>CheckCoefficientCoefficient</Value>
</Value>
<Value name="4">
<Value>CheckCoefficientSchemDr</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMCheckCoefficientD</DataLocation>
<DefaultData>CheckCoefficientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMCheckCoefficientD</IdLocation>
<IndexLocation>^DHCCJXQMCheckCoefficientI</IndexLocation>
<StreamLocation>^DHCCJXQMCheckCoefficientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
