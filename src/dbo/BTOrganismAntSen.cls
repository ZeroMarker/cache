/// 菌抗生素折点
Class dbo.BTOrganismAntSen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismAntSen, StorageStrategy = Default ]
{

/// Foreign Key FKOrganismAntSen created via DDL
ForeignKey FKOrganismAntSen(OrganismAntDR) References dbo.BTOrganismAnt(PKBTORGANISMANT) [ SqlName = FK_OrganismAntSen ];

/// Foreign Key FKOrganismAntSenRes created via DDL
ForeignKey FKOrganismAntSenRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_OrganismAntSenRes ];

Index IndexMaster On (OrganismAntDR, SenMethod, SensitivityDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTORGANISMANTSEN On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMANTSEN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 细菌关联抗生素  
Property OrganismAntDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 实验方法  {1:KB,2:MIC,3:ETEST}
Property SenMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 药敏结果  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 操作符  
Property Operand As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 6 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 描述  
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTOrganismAntSenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismAntDR</Value>
</Value>
<Value name="3">
<Value>SenMethod</Value>
</Value>
<Value name="4">
<Value>SensitivityDR</Value>
</Value>
<Value name="5">
<Value>Operand</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismAntSenD</DataLocation>
<DefaultData>BTOrganismAntSenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTOrganismAntSenD</IdLocation>
<IndexLocation>^dbo.BTOrganismAntSenI</IndexLocation>
<StreamLocation>^dbo.BTOrganismAntSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
