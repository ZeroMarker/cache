/// UnitSchem
Class dhc.pa.data.UnitDeptSchem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UDS_rowid, SqlTableName = UnitDeptSchem ]
{

/// 绩效单元id
Property JXUnitDr As dhc.pa.data.JXUnit [ Required, SqlColumnNumber = 2, SqlFieldName = UDS_JXUnit ];

/// 自查id
Property DschemDr As dhc.pa.data.DeptSchem [ SqlColumnNumber = 3, SqlFieldName = UDS_DSchemDr ];

Index DschemDrJXUnit On (DschemDr, JXUnitDr);

Index DschemDr On DschemDr;

Index JXUnit On JXUnitDr;

Storage Default
{
<Data name="UnitDeptSchemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JXUnitDr</Value>
</Value>
<Value name="3">
<Value>DschemDr</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAUnitDeptSchemD</DataLocation>
<DefaultData>UnitDeptSchemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAUnitDeptSchemD</IdLocation>
<IndexLocation>^DHCCJXPAUnitDeptSchemI</IndexLocation>
<StreamLocation>^DHCCJXPAUnitDeptSchemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
