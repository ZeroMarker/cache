///     
Class dbo.BDAdverseReactionXMTest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AdverseReactionXMTest, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index PKBDAdverFFEE74516D6D3ED9 On RowID [ PrimaryKey, SqlName = PK__BD_Adver__FFEE74516D6D3ED9, Type = index, Unique ];

Index IndexMaster On (AdverseReactionDR, PackDR) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBDAdverseReactionXMTestBBMajorXMCon created via DDL
ForeignKey FKBDAdverseReactionXMTestBBMajorXMCon(MajorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BD_AdverseReactionXMTest_BB_MajorXMCon ];

/// Foreign Key FKBDAdverseReactionXMTestBBMajorXMDepict created via DDL
ForeignKey FKBDAdverseReactionXMTestBBMajorXMDepict(MajorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BD_AdverseReactionXMTest_BB_MajorXMDepict ];

/// Foreign Key FKBDAdverseReactionXMTestBBMajorXMReault created via DDL
ForeignKey FKBDAdverseReactionXMTestBBMajorXMReault(MajorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BD_AdverseReactionXMTest_BB_MajorXMReault ];

/// Foreign Key FKBDAdverseReactionXMTestBBMinorXMCon created via DDL
ForeignKey FKBDAdverseReactionXMTestBBMinorXMCon(MinorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BD_AdverseReactionXMTest_BB_MinorXMCon ];

/// Foreign Key FKBDAdverseReactionXMTestBBMinorXMDepict created via DDL
ForeignKey FKBDAdverseReactionXMTestBBMinorXMDepict(MinorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BD_AdverseReactionXMTest_BB_MinorXMDepict ];

/// Foreign Key FKBDAdverseReactionXMTestBBMinorXMResult created via DDL
ForeignKey FKBDAdverseReactionXMTestBBMinorXMResult(MinorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BD_AdverseReactionXMTest_BB_MinorXMResult ];

/// Foreign Key FKBDAdverseReactionXMTestBBXMLastRealt created via DDL
ForeignKey FKBDAdverseReactionXMTestBBXMLastRealt(XMLastResultDR) References dbo.BBXMLastResult(PKBBXMLASTRESULT) [ SqlName = FK_BD_AdverseReactionXMTest_BB_XMLastRealt ];

/// Foreign Key FKBDAdverseReactionXMTestBBXMMethod created via DDL
ForeignKey FKBDAdverseReactionXMTestBBXMMethod(XMMethodDR) References dbo.BBXMMethod(PKBBXMMETHOD) [ SqlName = FK_BD_AdverseReactionXMTest_BB_XMMethod ];

/// Foreign Key FKBDAdverseReactionXMTestBDAdverseReaction created via DDL
ForeignKey FKBDAdverseReactionXMTestBDAdverseReaction(AdverseReactionDR) References dbo.BDAdverseReaction(PKBDADVERSEREACTION) [ SqlName = FK_BD_AdverseReactionXMTest_BD_AdverseReaction ];

/// Foreign Key FKBDAdverseReactionXMTestBDPACK created via DDL
ForeignKey FKBDAdverseReactionXMTestBDPACK(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_AdverseReactionXMTest_BD_PACK ];

/// Foreign Key FKBDAdverseReactionXMTestBTMIMachine created via DDL
ForeignKey FKBDAdverseReactionXMTestBTMIMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BD_AdverseReactionXMTest_BT_MI_Machine ];

/// Foreign Key FKBDAdverseReactionXMTestSYSCheckUser created via DDL
ForeignKey FKBDAdverseReactionXMTestSYSCheckUser(XMCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AdverseReactionXMTest_SYS_CheckUser ];

/// Foreign Key FKBDAdverseReactionXMTestSYSUser created via DDL
ForeignKey FKBDAdverseReactionXMTestSYSUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AdverseReactionXMTest_SYS_User ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AdverseReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

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

Property XMCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property XMCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property XMCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 27 ];

Storage Default
{
<Data name="BDAdverseReactionXMTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>AdverseReactionDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>MajorXMDepictDR</Value>
</Value>
<Value name="9">
<Value>MajorXMDepictStr</Value>
</Value>
<Value name="10">
<Value>MajorXMResultDR</Value>
</Value>
<Value name="11">
<Value>MajorXMResultStr</Value>
</Value>
<Value name="12">
<Value>MajorXMConclusionDR</Value>
</Value>
<Value name="13">
<Value>MajorXMConclusionStr</Value>
</Value>
<Value name="14">
<Value>MinorXMDepictDR</Value>
</Value>
<Value name="15">
<Value>MinorXMDepictStr</Value>
</Value>
<Value name="16">
<Value>MinorXMResultDR</Value>
</Value>
<Value name="17">
<Value>MinorXMResultStr</Value>
</Value>
<Value name="18">
<Value>MinorXMConclusionDR</Value>
</Value>
<Value name="19">
<Value>MinorXMConclusionStr</Value>
</Value>
<Value name="20">
<Value>XMMethodDR</Value>
</Value>
<Value name="21">
<Value>XMLastResultDR</Value>
</Value>
<Value name="22">
<Value>XMLastResultStr</Value>
</Value>
<Value name="23">
<Value>MachineParameterDR</Value>
</Value>
<Value name="24">
<Value>XMCheckDate</Value>
</Value>
<Value name="25">
<Value>XMCheckTime</Value>
</Value>
<Value name="26">
<Value>XMCheckUserDR</Value>
</Value>
<Value name="27">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAdverseReactionXMTestD</DataLocation>
<DefaultData>BDAdverseReactionXMTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDAdverseReactionXMTestD</IdLocation>
<IndexLocation>^dbo.BDAdverseReactionXMTestI</IndexLocation>
<StreamLocation>^dbo.BDAdverseReactionXMTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
