/// 模板关联抗生素
Class dbo.BTAntibioticsPanelDetails Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AntibioticsPanelDetails, StorageStrategy = Default ]
{

Index IndexMaster On (AntibioticsPanelDR, AntibioticsDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (AntibioticsPanelDR, Sequence, AntibioticsDR) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTANTIBIOTICSPANELDETAILS On RowID [ PrimaryKey, SqlName = PK_BT_ANTIBIOTICSPANELDETAILS, Type = index, Unique ];

/// Foreign Key FKAntibiocsPanelAnt created via DDL
ForeignKey FKAntibiocsPanelAnt(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_AntibiocsPanelAnt ];

/// Foreign Key FKAntibiocsPanelPnl created via DDL
ForeignKey FKAntibiocsPanelPnl(AntibioticsPanelDR) References dbo.BTAntibioticsPanel(PKBTANTIBIOTICSPANEL) [ SqlName = FK_AntibiocsPanelPnl ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 模板  
Property AntibioticsPanelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否报告  {1:true,0:false}
Property Reported As %Library.Boolean [ SqlColumnNumber = 5 ];

///       
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTAntibioticsPanelDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntibioticsPanelDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>Reported</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>SensitivityDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntibioticsPanelDetailsD</DataLocation>
<DefaultData>BTAntibioticsPanelDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAntibioticsPanelDetailsD</IdLocation>
<IndexLocation>^dbo.BTAntibioticsPanelDetailsI</IndexLocation>
<StreamLocation>^dbo.BTAntibioticsPanelDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
