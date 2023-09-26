Class dbo.BDReactionPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReactionPack, StorageStrategy = Default ]
{

/// Foreign Key FKBDXMPlanReq created via DDL
ForeignKey FKBDRPRea(ReactionDR) References dbo.BDReaction(PKBDREACTION) [ SqlName = FK_BDRP_Rea ];

/// Foreign Key FKBDXMPlanPack created via DDL
ForeignKey FKBDRPPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BDRP_Pack ];

/// Foreign Key FKBDXMPlanAddUser created via DDL
ForeignKey FKBDRPABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_BDRP_ABO ];

/// Foreign Key FKBDXMPlanAddUser created via DDL
ForeignKey FKBDRPRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BDRP_RH ];

/// Foreign Key FKBDXMPlanAddUser created via DDL
ForeignKey FKBDRPAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDRP_AddUser ];

/// Foreign Key FKBDXMPlanLastResult created via DDL
ForeignKey FKBDRPLastResult(XMLastResultDR) References dbo.BBXMLastResult(PKBBXMLASTRESULT) [ SqlName = FK_BDRP_LastResult ];

/// Foreign Key FKBDXMPlanMachineParameter created via DDL
ForeignKey FKBDRPMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BDRP_MachineParameter ];

/// Foreign Key FKBDXMPlanMajorXMConclusion created via DDL
ForeignKey FKBDRPMajorXMConclusion(MajorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BDRP_MajorXMConclusion ];

/// Foreign Key FKBDXMPlanMajorXMDepict created via DDL
ForeignKey FKBDRPMajorXMDepict(MajorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BDRP_MajorXMDepict ];

/// Foreign Key FKBDXMPlanMajorXMResult created via DDL
ForeignKey FKBDRPMajorXMResult(MajorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BDRP_MajorXMResult ];

/// Foreign Key FKBDXMPlanMethod created via DDL
ForeignKey FKBDRPMethod(XMMethodDR) References dbo.BBXMMethod(PKBBXMMETHOD) [ SqlName = FK_BDRP_Method ];

/// Foreign Key FKBDXMPlanMinorXMConclusion created via DDL
ForeignKey FKBDRPMinorXMConclusion(MinorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BDRP_MinorXMConclusion ];

/// Foreign Key FKBDXMPlanMinorXMDepict created via DDL
ForeignKey FKBDRPMinorXMDepict(MinorXMDepictDR) References dbo.BBXMDepict(PKBBXMDEPICT) [ SqlName = FK_BDRP_MinorXMDepict ];

/// Foreign Key FKBDXMPlanMinorXMResult created via DDL
ForeignKey FKBDRPMinorXMResult(MinorXMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BDRP_MinorXMResult ];

/// Foreign Key FKBDXMPlanAddUser created via DDL
ForeignKey FKBDRPCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDRP_CheckUser ];

Index IndexMaster On (ReactionDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

/// DDL Primary Key Specification
Index PKBDXMPLAN On RowID [ PrimaryKey, SqlName = PK_BD_XMPLAN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单  
Property ReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋编号  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 显示顺序  
Property SeqNum As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

/// 增加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 增加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property BloodPhenotype As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

Property AntibodyScreenRes As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

Property AntiglobulinTest As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 13 ];

/// 主侧现象id  
Property MajorXMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 主侧现象描述  
Property MajorXMDepict As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// 主侧结果id  
Property MajorXMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 主侧结果描述  
Property MajorXMResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 主侧结论id  
Property MajorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 湖策结论描述  
Property MajorXMConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 次侧现象id  
Property MinorXMDepictDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 次侧现象描述  
Property MinorXMDepict As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

/// 次侧结果id  
Property MinorXMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 次侧结果描述  
Property MinorXMResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 23 ];

/// 次侧结论ID  
Property MinorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 次侧结论描述  
Property MinorXMConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 25 ];

/// 交叉配血方法  
Property XMMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 交叉配血最终结果id  
Property XMLastResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 交叉配血最终结果描述  
Property XMLastResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 28 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 审核时间   
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 审核人  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Storage Default
{
<Data name="BDReactionPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReactionDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>ABODR</Value>
</Value>
<Value name="8">
<Value>RHDR</Value>
</Value>
<Value name="9">
<Value>BloodPhenotype</Value>
</Value>
<Value name="10">
<Value>AntibodyScreenRes</Value>
</Value>
<Value name="11">
<Value>AntiglobulinTest</Value>
</Value>
<Value name="12">
<Value>MajorXMDepictDR</Value>
</Value>
<Value name="13">
<Value>MajorXMDepict</Value>
</Value>
<Value name="14">
<Value>MajorXMResultDR</Value>
</Value>
<Value name="15">
<Value>MajorXMResult</Value>
</Value>
<Value name="16">
<Value>MajorXMConclusionDR</Value>
</Value>
<Value name="17">
<Value>MajorXMConclusion</Value>
</Value>
<Value name="18">
<Value>MinorXMDepictDR</Value>
</Value>
<Value name="19">
<Value>MinorXMDepict</Value>
</Value>
<Value name="20">
<Value>MinorXMResultDR</Value>
</Value>
<Value name="21">
<Value>MinorXMResult</Value>
</Value>
<Value name="22">
<Value>MinorXMConclusionDR</Value>
</Value>
<Value name="23">
<Value>MinorXMConclusion</Value>
</Value>
<Value name="24">
<Value>XMMethodDR</Value>
</Value>
<Value name="25">
<Value>XMLastResultDR</Value>
</Value>
<Value name="26">
<Value>XMLastResult</Value>
</Value>
<Value name="27">
<Value>MachineParameterDR</Value>
</Value>
<Value name="28">
<Value>CheckDate</Value>
</Value>
<Value name="29">
<Value>CheckTime</Value>
</Value>
<Value name="30">
<Value>CheckUserDR</Value>
</Value>
<Value name="31">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionPackD</DataLocation>
<DefaultData>BDReactionPackDefaultData</DefaultData>
<IdLocation>^dbo.BDReactionPackD</IdLocation>
<IndexLocation>^dbo.BDReactionPackI</IndexLocation>
<StreamLocation>^dbo.BDReactionPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
