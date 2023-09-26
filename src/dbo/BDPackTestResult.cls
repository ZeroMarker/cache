/// 血袋检测结果
Class dbo.BDPackTestResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackTestResult, StorageStrategy = Default ]
{

/// Foreign Key FKBDPTestItemCheckUser created via DDL
ForeignKey FKBDPTestItemCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PTestItem_CheckUser ];

/// Foreign Key FKBDPTestItemMParameter created via DDL
ForeignKey FKBDPTestItemMParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BD_PTestItem_MParameter ];

/// Foreign Key FKBDPTestItemMethod created via DDL
ForeignKey FKBDPTestItemMethod(MethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_BD_PTestItem_Method ];

/// Foreign Key FKBDPTestItemPack created via DDL
ForeignKey FKBDPTestItemPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PTestItem_Pack ];

/// Foreign Key FKBDPTestItemTestCode created via DDL
ForeignKey FKBDPTestItemTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BD_PTestItem_TestCode ];

/// Foreign Key FKBDPTestItemTestSet created via DDL
ForeignKey FKBDPTestItemTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BD_PTestItem_TestSet ];

/// Foreign Key FKBDPTestItemTestUser created via DDL
ForeignKey FKBDPTestItemTestUser(TestUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PTestItem_TestUser ];

/// Foreign Key FKBDPTestItemTestPACKTEST created via DDL
ForeignKey FKBDPTestItemTestPACKTEST(PackTestDR) References dbo.BDPackTest(PKBDPACKTEST) [ SqlName = FK_BD_PTestItem_PACKTEST ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexMaster On (PackDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (PackDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

Index IndexTestDate On TestDate [ SqlName = Index_TestDate, Type = index ];

Index IndexTestSet On (PackDR, TestSetDR) [ SqlName = Index_TestSet, Type = index ];

Index IndexTestUser On (TestUserDR, TestDate) [ SqlName = Index_TestUser, Type = index ];

Index IndexPackTest On PackTestDR [ SqlName = Index_PackTest, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKTESTRESULT On RowID [ PrimaryKey, SqlName = PK_BD_PACKTESTRESULT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 血袋信息  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

/// 结果说明  
Property ResNotes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 检测方法  
Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 显示序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 项目组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 检测日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 检测时间  
Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 检测者  
Property TestUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 审核者  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 血袋检测ID  
Property PackTestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 结果类型   ABO.RH,BG,RHM
Property ResType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BDPackTestResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>ResNotes</Value>
</Value>
<Value name="6">
<Value>Unit</Value>
</Value>
<Value name="7">
<Value>RefRanges</Value>
</Value>
<Value name="8">
<Value>MethodDR</Value>
</Value>
<Value name="9">
<Value>MachineParameterDR</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>TestSetDR</Value>
</Value>
<Value name="12">
<Value>TestDate</Value>
</Value>
<Value name="13">
<Value>TestTime</Value>
</Value>
<Value name="14">
<Value>TestUserDR</Value>
</Value>
<Value name="15">
<Value>CheckDate</Value>
</Value>
<Value name="16">
<Value>CheckTime</Value>
</Value>
<Value name="17">
<Value>CheckUserDR</Value>
</Value>
<Value name="18">
<Value>PackTestDR</Value>
</Value>
<Value name="19">
<Value>ResType</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackTestResultD</DataLocation>
<DefaultData>BDPackTestResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackTestResultD</IdLocation>
<IndexLocation>^dbo.BDPackTestResultI</IndexLocation>
<StreamLocation>^dbo.BDPackTestResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
