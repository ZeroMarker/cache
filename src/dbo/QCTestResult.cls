/// 质控结果
Class dbo.QCTestResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_TestResult, StorageStrategy = Default ]
{

/// Foreign Key FKTestResultAddUser created via DDL
ForeignKey FKTestResultAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultAddUser ];

/// Foreign Key FKTestResultLot created via DDL
ForeignKey FKTestResultLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_TestResultLot ];

/// Foreign Key FKTestResultMachine created via DDL
ForeignKey FKTestResultMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_TestResultMachine ];

/// Foreign Key FKTestResultRule created via DDL
ForeignKey FKTestResultRule(QCRulesDR) References dbo.BTQCRules(PKBTQCRULES) [ SqlName = FK_TestResultRule ];

/// Foreign Key FKTestResultTCParam created via DDL
ForeignKey FKTestResultTCParam(MaterialLotTCParamDR) References dbo.BTQCMaterialLotTCParam(PKBTQCMATERIALLOTTCPARAM) [ SqlName = FK_TestResultTCParam ];

/// Foreign Key FKTestResultTestCode created via DDL
ForeignKey FKTestResultTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestResultTestCode ];

/// Foreign Key FKTestResultUpdateUser created via DDL
ForeignKey FKTestResultUpdateUser(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultUpdateUser ];

/// Foreign Key FKTestResultUpdateUser created via DDL
ForeignKey FKTestResultAutUserDR(AutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TestResultAutUserDR ];

Index IndexAddTime On (AddDate, AddTime, MachineParameterDR, TestCodeDR, LevelNo) [ SqlName = Index_AddTime, Type = index ];

Index IndexMachine On (MachineParameterDR, TestCodeDR, LevelNo, TestDate, TestTime) [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (MaterialLotDR, TestCodeDR, LevelNo, TestDate, TestTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestTime On (TestDate, TestTime, MachineParameterDR, TestCodeDR, LevelNo) [ SqlName = Index_TestTime, Type = index ];

Index IndexTestTimeMatLot On (TestDate, TestTime, MachineParameterDR, MaterialLotDR, TestCodeDR, LevelNo) [ SqlName = Index_TestTimeMatLot, Type = index ];

/// DDL Primary Key Specification
Index PKQCTESTRESULT On RowID [ PrimaryKey, SqlName = PK_QC_TESTRESULT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 批次  
Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 浓度  
Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 测试日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 测试时间  
Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 质控标示  
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 文本结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 仪器标识  
Property MachineFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 质控规则  
Property QCRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

///       
Property DQIVStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14, SqlFieldName = DQIV_Status ];

/// 排除类型  
Property ExcludeType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// 结果类型  
Property ResultType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

/// 原始结果  
Property OriginalValue As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 添加人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 更新人  
Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 24 ];

/// 批次项目参数  
Property MaterialLotTCParamDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 审核用户  
Property AutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 颜色      
Property ResColor As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 27 ];

/// 靶值，供任务同步给SQL用 
Property Mean As %Library.Float [ SqlColumnNumber = 28 ];

/// 标准差，供任务同步给SQL用   
Property SD As %Library.Float [ SqlColumnNumber = 29 ];

/// 是否是平行质控数据  {1:true,0:false}
Property IsParallel As %Library.Boolean [ SqlColumnNumber = 30 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Storage Default
{
<Data name="QCTestResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
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
<Value>QCRulesDR</Value>
</Value>
<Value name="13">
<Value>DQIVStatus</Value>
</Value>
<Value name="14">
<Value>ExcludeType</Value>
</Value>
<Value name="15">
<Value>ResultType</Value>
</Value>
<Value name="16">
<Value>OriginalValue</Value>
</Value>
<Value name="17">
<Value>AddDate</Value>
</Value>
<Value name="18">
<Value>AddTime</Value>
</Value>
<Value name="19">
<Value>AddUserDR</Value>
</Value>
<Value name="20">
<Value>UpdateDate</Value>
</Value>
<Value name="21">
<Value>UpdateTime</Value>
</Value>
<Value name="22">
<Value>UpdateUserDR</Value>
</Value>
<Value name="23">
<Value>Remark</Value>
</Value>
<Value name="24">
<Value>MaterialLotTCParamDR</Value>
</Value>
<Value name="25">
<Value>AutUserDR</Value>
</Value>
<Value name="26">
<Value>ResColor</Value>
</Value>
<Value name="27">
<Value>Mean</Value>
</Value>
<Value name="28">
<Value>SD</Value>
</Value>
<Value name="29">
<Value>IsParallel</Value>
</Value>
<Value name="30">
<Value>AuthDate</Value>
</Value>
<Value name="31">
<Value>AuthTime</Value>
</Value>
</Data>
<DataLocation>^dbo.QCTestResultD</DataLocation>
<DefaultData>QCTestResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCTestResultD</IdLocation>
<IndexLocation>^dbo.QCTestResultI</IndexLocation>
<StreamLocation>^dbo.QCTestResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
