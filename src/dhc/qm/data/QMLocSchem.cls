Class dhc.qm.data.QMLocSchem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QMLocSchem_rowid, SqlTableName = QMLocSchem ]
{

/// QMLocSchem_DepartDr
Property QMLocSchemDepartDr As User.RBCDepartmentGroup [ SqlColumnNumber = 2, SqlFieldName = QMLocSchem_DepartDr ];

/// QMLocSchem_QMSchemDr
Property QMLocSchemQMSchemDr As dhc.qm.data.QMSchem [ SqlColumnNumber = 3, SqlFieldName = QMLocSchem_QMSchemDr ];

Index QMschemDrDepartDr On (QMLocSchemDepartDr, QMLocSchemQMSchemDr);

Storage Default
{
<Data name="QMLocSchemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMLocSchemDepartDr</Value>
</Value>
<Value name="3">
<Value>QMLocSchemQMSchemDr</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMQMLocSchemD</DataLocation>
<DefaultData>QMLocSchemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMQMLocSchemD</IdLocation>
<IndexLocation>^DHCCJXQMQMLocSchemI</IndexLocation>
<StreamLocation>^DHCCJXQMQMLocSchemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
