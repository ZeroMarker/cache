/// 细菌组抗生素
Class dbo.BTOrganismGroupAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismGroupAnt, StorageStrategy = Default ]
{

/// Foreign Key FKBTOrganismGroupAntMICSpecGroupDR created via DDL
ForeignKey FKBTOrganismGroupAntMICSpecGroupDR(MICSpecGroupDR) References dbo.BTMICSpecGroup(PKBTMICSPECGROUP) [ SqlName = FK_BTOrganismGroupAntMICSpecGroupDR ];

/// Foreign Key FKOrgGroup created via DDL
ForeignKey FKOrgGroup(OrganismGroupDR) References dbo.BTOrganismGroup(PKBTORGANISMGROUP) [ SqlName = FK_OrgGroup ];

/// Foreign Key FKOrgGroupAntibiocs created via DDL
ForeignKey FKOrgGroupAntibiocs(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_OrgGroupAntibiocs ];

/// Foreign Key FKOrganismGroupAnt created via DDLAntibioticsClassDR
ForeignKey FKOrganismGroupAnt(AntibioticsGroupDR) References dbo.BTAntibioticsGroup(PKBTAntibioticsGroup) [ SqlName = FK_OrganismGroupAnt ];

/// Foreign Key FKOrganismGroupAnt created via DDLAntibioticsClassDR
ForeignKey FKAntibioticsClassDR(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = PK_BTAntibioticsClass ];

Index IndexAntibioticsGroup On (OrganismGroupDR, AntibioticsGroupDR) [ SqlName = Index_AntibioticsGroup, Type = index ];

Index IndexMaster On (OrganismGroupDR, AntibioticsDR) [ SqlName = Index_Master, Type = index ];

Index IndexSequence On (OrganismGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexSpecGroup On (OrganismGroupDR, MICSpecGroupDR, AntibioticsDR) [ SqlName = Index_SpecGroup, Type = index, Unique ];

Index IndexSpecSequence On (OrganismGroupDR, MICSpecGroupDR, Sequence) [ SqlName = Index_SpecSequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANISMGROUPANT On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMGROUPANT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 细菌组  
Property OrganismGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 药敏结果  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 是否上报  {1:true,0:false}
Property Reported As %Library.Boolean [ SqlColumnNumber = 6 ];

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
<Data name="BTOrganismGroupAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismGroupDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>SensitivityDR</Value>
</Value>
<Value name="5">
<Value>Reported</Value>
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
<DataLocation>^dbo.BTOrganismGroupAntD</DataLocation>
<DefaultData>BTOrganismGroupAntDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTOrganismGroupAntD</IdLocation>
<IndexLocation>^dbo.BTOrganismGroupAntI</IndexLocation>
<StreamLocation>^dbo.BTOrganismGroupAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
