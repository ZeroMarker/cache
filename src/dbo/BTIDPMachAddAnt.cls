/// 上机类型添加抗生素
Class dbo.BTIDPMachAddAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_MachAddAnt ]
{

Index IndexMaster On (IDPMachDR, AntibioticsDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKIDPMachAddAntMachDR created via DDL
ForeignKey FKIDPMachAddAntMachDR(IDPMachDR) References dbo.BTIDPMach(PKBTIDPMACH) [ SqlName = FK_IDPMachAddAntMachDR ];

/// Foreign Key FKIDPMachAddAntAnt created via DDL
ForeignKey FKIIDPMachAddAntAnt(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_IIDPMachAddAntAnt ];

/// DDL Primary Key Specification
Index PKBTIDPMACHADDANT On RowID [ PrimaryKey, SqlName = PK_BTIDP_MACHADDANT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 上机仪器
Property IDPMachDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTIDPMachAddAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPMachDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPMachAddAntD</DataLocation>
<DefaultData>BTIDPMachAddAntDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPMachAddAntD</IdLocation>
<IndexLocation>^dbo.BTIDPMachAddAntI</IndexLocation>
<StreamLocation>^dbo.BTIDPMachAddAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
