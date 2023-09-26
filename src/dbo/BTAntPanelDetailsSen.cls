/// 抗生素模板折点
Class dbo.BTAntPanelDetailsSen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AntPanelDetailsSen, StorageStrategy = Default ]
{

/// Foreign Key FKBTAntibioticsPanelDetails created via DDL
ForeignKey FKAntibioticsPanelDetails(AntibioticsPanelDetailsDR) References dbo.BTAntibioticsPanelDetails(PKBTANTIBIOTICSPANELDETAILS) [ SqlName = FK_BTAntibioticsPanelDetails ];

/// Foreign Key FKOrganismGroupAntSenRes created via DDL
ForeignKey FKOrganismGroupAntSenRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_OrganismGroupAntSenRes ];

Index IndexMaster On (AntibioticsPanelDetailsDR, SenMethod, SensitivityDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTANTPANELDETAILSSEN On RowID [ PrimaryKey, SqlName = PK_BT_ANTPANELDETAILSSEN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 抗生素模板明细  
Property AntibioticsPanelDetailsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

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
<Data name="BTAntibioticsPanelDetailsSenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTAntibioticsPanelDetailsDR</Value>
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
<Value>AntibioticsPanelDetailsDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntPanelDetailsSenD</DataLocation>
<DefaultData>BTAntPanelDetailsSenDefaultData</DefaultData>
<IdLocation>^dbo.BTAntPanelDetailsSenD</IdLocation>
<IndexLocation>^dbo.BTAntPanelDetailsSenI</IndexLocation>
<StreamLocation>^dbo.BTAntPanelDetailsSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
