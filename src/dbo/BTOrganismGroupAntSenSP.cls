/// 细菌组抗生素标本折点
Class dbo.BTOrganismGroupAntSenSP Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismGroupAntSenSP ]
{

/// Foreign Key FKOrganismGroupAntSen created via DDL
ForeignKey FKOrganismGroupAntSen(OrganismGroupAntDR) References dbo.BTOrganismGroupAnt(PKBTORGANISMGROUPANT) [ SqlName = FK_OrganismGroupAntSen ];

/// Foreign Key FKOrganismGroupAntSenRes created via DDL
ForeignKey FKOrganismGroupAntSenRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_OrganismGroupAntSenRes ];

/// Foreign Key FKOrganismGroupAntSenRes created via DDL
ForeignKey FKOrganismGroupAntSenResSP(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_OrganismGroupAntSenResSP ];

Index IndexMaster On (OrganismGroupAntDR, SpecimenDR, SenMethod, SensitivityDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTORGANISMGROUPANTSEN On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMGROUPANTSEN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 关联抗生素  
Property OrganismGroupAntDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

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

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTOrganismGroupAntSenSPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismGroupAntDR</Value>
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
<Value name="8">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismGroupAntSenSPD</DataLocation>
<DefaultData>BTOrganismGroupAntSenSPDefaultData</DefaultData>
<IdLocation>^dbo.BTOrganismGroupAntSenSPD</IdLocation>
<IndexLocation>^dbo.BTOrganismGroupAntSenSPI</IndexLocation>
<StreamLocation>^dbo.BTOrganismGroupAntSenSPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
