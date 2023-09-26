/// 微生物质控结果
Class dbo.MICQCTestResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MICQC_TestResult ]
{

/// DDL IndexMaster
Index IndexMaster On (MachineParameterDR, AntibioticsDR, TestDate, TestTime) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKMICQCTestResultMICQCMaterialDR created via DDL
ForeignKey FKMICQCTestResultMICQCMaterialDR(MICQCMaterialDR) References dbo.BTMICQCMaterial(PKBTMICQCMATERIAL) [ SqlName = FK_MICQCTestResultMICQCMaterialDR ];

/// Foreign Key FKMICQCTestResultAntibioticsDR created via DDL
ForeignKey FKMICQCTestResultAntibioticsDR(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_MICQCTestResultAntibioticsDR ];

/// Foreign Key FKMICQCTestResultMachineParameterDR created via DDL
ForeignKey FKMICQCTestResultMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MICQCTestResultMachineParameterDR ];

/// Foreign Key FKMICQCTestResultAddUserDR created via DDL
ForeignKey FKMICQCTestResultAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MICQCTestResultAddUserDR ];

/// Foreign Key FKMICQCTestResultUpdateUserDR created via DDL
ForeignKey FKMICQCTestResultUpdateUserDR(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MICQCTestResultUpdateUserDR ];

/// Foreign Key FKMICQCTestResultAutUserDR created via DDL
ForeignKey FKMICQCTestResultAutUserDR(AutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MICQCTestResultAutUserDR ];

/// Foreign Key FKBTMICQCMaterialOrganismDR created via DDL
ForeignKey FKBTMICQCMaterialOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_BTMICQCMaterialOrganismDR ];

/// DDL Primary Key Specification
Index PKMICQCTESTRESULT On RowID [ PrimaryKey, SqlName = PK_MICQC_TESTRESULT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物  
Property MICQCMaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 菌  
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 时间  
Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 标识  
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 文本结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 仪器标识  
Property MachineFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 状态  
Property DQIVStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

/// 排除类型  
Property ExcludeType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

/// 结果类型  
Property ResultType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// 原始结果  
Property OriginalValue As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 添加人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 更新人  
Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 23 ];

/// 审核人  
Property AutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="MICQCTestResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MICQCMaterialDR</Value>
</Value>
<Value name="3">
<Value>OrganismDR</Value>
</Value>
<Value name="4">
<Value>AntibioticsDR</Value>
</Value>
<Value name="5">
<Value>TestDate</Value>
</Value>
<Value name="6">
<Value>TestTime</Value>
</Value>
<Value name="7">
<Value>MachineParameterDR</Value>
</Value>
<Value name="8">
<Value>SampleID</Value>
</Value>
<Value name="9">
<Value>Result</Value>
</Value>
<Value name="10">
<Value>TextRes</Value>
</Value>
<Value name="11">
<Value>MachineFlag</Value>
</Value>
<Value name="12">
<Value>DQIVStatus</Value>
</Value>
<Value name="13">
<Value>ExcludeType</Value>
</Value>
<Value name="14">
<Value>ResultType</Value>
</Value>
<Value name="15">
<Value>OriginalValue</Value>
</Value>
<Value name="16">
<Value>AddDate</Value>
</Value>
<Value name="17">
<Value>AddTime</Value>
</Value>
<Value name="18">
<Value>AddUserDR</Value>
</Value>
<Value name="19">
<Value>UpdateDate</Value>
</Value>
<Value name="20">
<Value>UpdateTime</Value>
</Value>
<Value name="21">
<Value>UpdateUserDR</Value>
</Value>
<Value name="22">
<Value>Remark</Value>
</Value>
<Value name="23">
<Value>AutUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.MICQCTestResultD</DataLocation>
<DefaultData>MICQCTestResultDefaultData</DefaultData>
<IdLocation>^dbo.MICQCTestResultD</IdLocation>
<IndexLocation>^dbo.MICQCTestResultI</IndexLocation>
<StreamLocation>^dbo.MICQCTestResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
