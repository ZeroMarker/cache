/// 菌科抗生素
Class dbo.BTOrganismFamilyAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismFamilyAnt ]
{

/// Foreign Key FKBTOrganismFamilyAntMICSpecGroupDR created via DDL
ForeignKey FKBTOrganismFamilyAntMICSpecGroupDR(MICSpecGroupDR) References dbo.BTMICSpecGroup(PKBTMICSPECGROUP) [ SqlName = FK_BTOrganismFamilyAntMICSpecGroupDR ];

/// Foreign Key FKOrganismGroupAnt created via DDLAntibioticsClassDR
ForeignKey FKOrganismGroupAnt(AntibioticsGroupDR) References dbo.BTAntibioticsGroup(PKBTAntibioticsGroup) [ SqlName = FK_OrganismGroupAnt ];

/// Foreign Key FKOrganismGroupAnt created via DDLAntibioticsClassDR
ForeignKey FKAntibioticsClassDR(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = PK_BTAntibioticsClass ];

/// Foreign Key FKOrganismFamily created via DDL
ForeignKey FKOrganismFamily(OrganismFamilyDR) References dbo.BTOrganismFamily(PKBTORGANISMFAMILY) [ SqlName = FK_OrganismFamily ];

/// Foreign Key FKOrganismFamilyAntibiocs created via DDL
ForeignKey FKOrganismFamilyAntibiocs(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_OrganismFamilyAntibiocs ];

/// Foreign Key FKOrganismFamilySen created via DDL
ForeignKey FKOrganismFamilySen(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_OrganismFamilySen ];

Index IndexMaster On (OrganismFamilyDR, AntibioticsDR) [ SqlName = Index_Master, Type = index ];

Index IndexSequence On (OrganismFamilyDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexSpecGroup On (OrganismFamilyDR, MICSpecGroupDR, AntibioticsDR) [ SqlName = Index_SpecGroup, Type = index, Unique ];

Index IndexSpecSequence On (OrganismFamilyDR, MICSpecGroupDR, Sequence) [ SqlName = Index_SpecSequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANISMFAMILYANT On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMFAMILYANT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 菌科  
Property OrganismFamilyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否上报  {1:true,0:false}
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
<Data name="BTOrganismFamilyAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismFamilyDR</Value>
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
<DataLocation>^dbo.BTOrganismFamilyAntD</DataLocation>
<DefaultData>BTOrganismFamilyAntDefaultData</DefaultData>
<IdLocation>^dbo.BTOrganismFamilyAntD</IdLocation>
<IndexLocation>^dbo.BTOrganismFamilyAntI</IndexLocation>
<StreamLocation>^dbo.BTOrganismFamilyAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
