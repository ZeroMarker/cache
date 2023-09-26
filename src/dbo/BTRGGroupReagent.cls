///     
Class dbo.BTRGGroupReagent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_GroupReagent, StorageStrategy = Default ]
{

Index IndexGroupReagent On (ReagentGroupDR, ReagentDR) [ SqlName = Index_Group_Reagent, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGGROUPREAGENT On RowID [ PrimaryKey, SqlName = PK_BTRG_GROUPREAGENT, Type = index, Unique ];

/// Foreign Key FKRGGroupReagentGroup created via DDL
ForeignKey FKRGGroupReagentGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_GroupReagent_Group ];

/// Foreign Key FKRGGroupReagentReagent created via DDL
ForeignKey FKRGGroupReagentReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_GroupReagent_Reagent ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property MixQty As %Library.Float [ SqlColumnNumber = 5 ];

Property MaxQty As %Library.Float [ SqlColumnNumber = 6 ];

Property StandardQty As %Library.Float [ SqlColumnNumber = 7 ];

Property WarnDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTRGGroupReagentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>MixQty</Value>
</Value>
<Value name="5">
<Value>MaxQty</Value>
</Value>
<Value name="6">
<Value>StandardQty</Value>
</Value>
<Value name="7">
<Value>WarnDays</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGGroupReagentD</DataLocation>
<DefaultData>BTRGGroupReagentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGGroupReagentD</IdLocation>
<IndexLocation>^dbo.BTRGGroupReagentI</IndexLocation>
<StreamLocation>^dbo.BTRGGroupReagentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
