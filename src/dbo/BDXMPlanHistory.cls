///     
Class dbo.BDXMPlanHistory Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_XMPlanHistory, StorageStrategy = Default ]
{

/// Foreign Key FKBDXMPlanHistoryBBXMConclusion created via DDL
ForeignKey FKBDXMPlanHistoryMajorXMConclusion(MajorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BD_XMPlanHistory_BB_XMConclusion ];

/// Foreign Key FKBDXMPlanHistoryBBXMConclusion1 created via DDL
ForeignKey FKBDXMPlanHistoryMinorXMConclusion(MinorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BD_XMPlanHistory_BB_XMConclusion1 ];

/// Foreign Key FKBDXMPlanHistoryBBXMDepict created via DDL
ForeignKey FKBDXMPlanHistoryMajorXMDepict(MajorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BD_XMPlanHistory_BB_XMDepict ];

/// Foreign Key FKBDXMPlanHistoryBBXMDepict1 created via DDL
ForeignKey FKBDXMPlanHistoryMinorXMDepict(MinorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BD_XMPlanHistory_BB_XMDepict1 ];

/// Foreign Key FKBDXMPlanHistoryBBXMLastResult created via DDL
ForeignKey FKBDXMPlanHistoryXMLastResult(XMLastResultDR) References dbo.BBXMLastResult(PKBBXMLASTRESULT) [ SqlName = FK_BD_XMPlanHistory_BB_XMLastResult ];

/// Foreign Key FKBDXMPlanHistoryBBXMMethod created via DDL
ForeignKey FKBDXMPlanHistoryXMMethod(XMMethodDR) References dbo.BBXMMethod(PKBBXMMETHOD) [ SqlName = FK_BD_XMPlanHistory_BB_XMMethod ];

/// Foreign Key FKBDXMPlanHistoryBBXMResult created via DDL
ForeignKey FKBDXMPlanHistoryMajorXMResult(MajorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BD_XMPlanHistory_BB_XMResult ];

/// Foreign Key FKBDXMPlanHistoryBBXMResult1 created via DDL
ForeignKey FKBDXMPlanHistoryMinorXMResult(MinorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BD_XMPlanHistory_BB_XMResult1 ];

/// Foreign Key FKBDXMPlanHistoryBDPack created via DDL
ForeignKey FKBDXMPlanHistoryBDPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_XMPlanHistory_BD_Pack ];

/// Foreign Key FKBDXMPlanHistoryBDXMPlan created via DDL
ForeignKey FKBDXMPlanHistoryBDXMPlan(XMPlanDR) References dbo.BDXMPlan(PKBDXMPLAN) [ SqlName = FK_BD_XMPlanHistory_BD_XMPlan ];

/// Foreign Key FKBDXMPlanHistoryBTMIMachineParameter created via DDL
ForeignKey FKBDXMPlanHistoryBTMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BD_XMPlanHistory_BTMI_MachineParameter ];

/// Foreign Key FKBDXMPlanHistorySYSUser created via DDL
ForeignKey FKBDXMPlanHistorySYSUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_XMPlanHistory_SYS_User ];

Index IndexAddDate On AddDate [ SqlName = IX_BD_XMPlanHistory_1, Type = index ];

/// DDL Primary Key Specification
Index IndexMaster On (XMPlanDR, PackDR, XMMethodDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDXMPlanHistory On RowID [ PrimaryKey, SqlName = PK_BD_XMPlanHistory, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property XMPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property MajorXMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property MajorXMDepictStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

Property MajorXMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property MajorXMResultStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property MajorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property MajorXMConclusionStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Property MinorXMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property MinorXMDepictStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Property MinorXMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property MinorXMResultStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

Property MinorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property MinorXMConclusionStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

Property XMMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property XMLastResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property XMLastResultStr As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 24 ];

Property ItemStatus As %Library.SmallInt [ Required, SqlColumnNumber = 25 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="BDXMPlanHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMPlanDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>MajorXMDepictDR</Value>
</Value>
<Value name="8">
<Value>MajorXMDepictStr</Value>
</Value>
<Value name="9">
<Value>MajorXMResultDR</Value>
</Value>
<Value name="10">
<Value>MajorXMResultStr</Value>
</Value>
<Value name="11">
<Value>MajorXMConclusionDR</Value>
</Value>
<Value name="12">
<Value>MajorXMConclusionStr</Value>
</Value>
<Value name="13">
<Value>MinorXMDepictDR</Value>
</Value>
<Value name="14">
<Value>MinorXMDepictStr</Value>
</Value>
<Value name="15">
<Value>MinorXMResultDR</Value>
</Value>
<Value name="16">
<Value>MinorXMResultStr</Value>
</Value>
<Value name="17">
<Value>MinorXMConclusionDR</Value>
</Value>
<Value name="18">
<Value>MinorXMConclusionStr</Value>
</Value>
<Value name="19">
<Value>XMMethodDR</Value>
</Value>
<Value name="20">
<Value>XMLastResultDR</Value>
</Value>
<Value name="21">
<Value>XMLastResultStr</Value>
</Value>
<Value name="22">
<Value>MachineParameterDR</Value>
</Value>
<Value name="23">
<Value>Remark</Value>
</Value>
<Value name="24">
<Value>ItemStatus</Value>
</Value>
<Value name="25">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BDXMPlanHistoryD</DataLocation>
<DefaultData>BDXMPlanHistoryDefaultData</DefaultData>
<IdLocation>^dbo.BDXMPlanHistoryD</IdLocation>
<IndexLocation>^dbo.BDXMPlanHistoryI</IndexLocation>
<StreamLocation>^dbo.BDXMPlanHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
