/// BTMICQCMaterial
Class dbo.BTMICQCMaterial Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMICQC_Material ]
{

/// Foreign Key FKBTMICQCMaterialMachineDR created via DDL
ForeignKey FKBTMICQCMaterialMachineDR(MachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTMICQCMaterialMachineDR ];

/// Foreign Key FKBTMICQCMaterialOrganismDR created via DDL
ForeignKey FKBTMICQCMaterialOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_BTMICQCMaterialOrganismDR ];

/// DDL IndexMaster
Index IndexMaster On (MachineDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL IndexSampleID
Index IndexSampleID On (MachineDR, SampleID) [ SqlName = Index_SampleID, Type = index ];

/// DDL Primary Key Specification
Index PKBTMICQCMATERIAL On RowID [ PrimaryKey, SqlName = PK_BTMICQC_MATERIAL, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 仪器  
Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 细菌  
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 自动入库  {1:true,0:false}
Property AutoSave As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

/// SampleID  
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

///       
Property CardNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

///       
Property SerialNumber As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 13 ];

///       
Property SenMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTMICQCMaterialDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>MachineDR</Value>
</Value>
<Value name="5">
<Value>OrganismDR</Value>
</Value>
<Value name="6">
<Value>AutoSave</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>SampleID</Value>
</Value>
<Value name="11">
<Value>CardNo</Value>
</Value>
<Value name="12">
<Value>SerialNumber</Value>
</Value>
<Value name="13">
<Value>SenMethod</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICQCMaterialD</DataLocation>
<DefaultData>BTMICQCMaterialDefaultData</DefaultData>
<IdLocation>^dbo.BTMICQCMaterialD</IdLocation>
<IndexLocation>^dbo.BTMICQCMaterialI</IndexLocation>
<StreamLocation>^dbo.BTMICQCMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
