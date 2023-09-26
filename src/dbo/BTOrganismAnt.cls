/// 菌关联抗生素
Class dbo.BTOrganismAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismAnt ]
{

/// Foreign Key FKBTOrganismAntMICSpecGroupDR created via DDL
ForeignKey FKBTOrganismAntMICSpecGroupDR(MICSpecGroupDR) References dbo.BTMICSpecGroup(PKBTMICSPECGROUP) [ SqlName = FK_BTOrganismAntMICSpecGroupDR ];

/// Foreign Key FKOrganismGroupAnt created via DDLAntibioticsClassDR
ForeignKey FKOrganismGroupAnt(AntibioticsGroupDR) References dbo.BTAntibioticsGroup(PKBTAntibioticsGroup) [ SqlName = FK_OrganismGroupAnt ];

/// Foreign Key FKOrganismGroupAnt created via DDLAntibioticsClassDR
ForeignKey FKAntibioticsClassDR(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = PK_BTAntibioticsClass ];

/// Foreign Key FKOrganism created via DDL
ForeignKey FKOrganism(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_Organism ];

/// Foreign Key FKOrganismAntibiocs created via DDL
ForeignKey FKOrganismAntibiocs(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_OrganismAntibiocs ];

/// Foreign Key FKOrganismSen created via DDL
ForeignKey FKOrganismSen(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_OrganismSen ];

Index IndexMaster On (OrganismDR, AntibioticsDR) [ SqlName = Index_Master, Type = index ];

Index IndexSequence On (OrganismDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexSpecGroup On (OrganismDR, MICSpecGroupDR, AntibioticsDR) [ SqlName = Index_SpecGroup, Type = index, Unique ];

Index IndexSpecSequence On (OrganismDR, MICSpecGroupDR, Sequence) [ SqlName = Index_SpecSequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANISMANT On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMANT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 细菌  
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否报告  {1:true,0:false}
Property Reported As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 药敏结果  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 分组  
Property AntibioticsGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 抗生素报告组  
Property AntibioticsClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 给药方案  
Property DosageRegimen As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ SqlColumnNumber = 10 ];

/// 必填  {1:true,0:false}
Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 标本组  
Property MICSpecGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 折点来源 
Property Source As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 13 ];

/// 终止折点版本 
Property EndVersion As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 来源说明 
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTOrganismAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>Reported</Value>
</Value>
<Value name="5">
<Value>SensitivityDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>AntibioticsGroupDR</Value>
</Value>
<Value name="8">
<Value>AntibioticsClassDR</Value>
</Value>
<Value name="9">
<Value>DosageRegimen</Value>
</Value>
<Value name="10">
<Value>IsMandatory</Value>
</Value>
<Value name="11">
<Value>MICSpecGroupDR</Value>
</Value>
<Value name="12">
<Value>Source</Value>
</Value>
<Value name="13">
<Value>EndVersion</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismAntD</DataLocation>
<DefaultData>BTOrganismAntDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTOrganismAntD</IdLocation>
<IndexLocation>^dbo.BTOrganismAntI</IndexLocation>
<StreamLocation>^dbo.BTOrganismAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
