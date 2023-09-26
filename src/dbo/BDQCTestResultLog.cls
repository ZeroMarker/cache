///     
Class dbo.BDQCTestResultLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BDQC_TestResultLog ]
{

/// Foreign Key FKBDQCTestResultLogMaterialItemDR created via DDL
ForeignKey FKBDQCTestResultLogMaterialItemDR(MaterialItemDR) References dbo.BBQCMaterialItem(PKBBQCMATERIALITEM) [ SqlName = FK_BDQCTestResultLogMaterialItemDR ];

/// Foreign Key FKBDQCTestResultLogAddUserDR created via DDL
ForeignKey FKBDQCTestResultLogAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDQCTestResultLogAddUserDR ];

/// DDL Primary Key Specification
Index PKBDQCTESTRESULTLOG On RowID [ PrimaryKey, SqlName = PK_BDQC_TESTRESULTLOG, Type = index, Unique ];

Index IndexMaster On (MaterialItemDR, TestReagentID, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On (AddDate, OperateType) [ SqlName = Index_AddDate, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestReagentID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OperateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

Property ResValue As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BDQCTestResultLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialItemDR</Value>
</Value>
<Value name="3">
<Value>TestReagentID</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>OperateType</Value>
</Value>
<Value name="7">
<Value>TestDate</Value>
</Value>
<Value name="8">
<Value>TestTime</Value>
</Value>
<Value name="9">
<Value>SampleID</Value>
</Value>
<Value name="10">
<Value>Result</Value>
</Value>
<Value name="11">
<Value>ResValue</Value>
</Value>
<Value name="12">
<Value>AddUserDR</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>IPAddress</Value>
</Value>
</Data>
<DataLocation>^dbo.BDQCTestResultLogD</DataLocation>
<DefaultData>BDQCTestResultLogDefaultData</DefaultData>
<IdLocation>^dbo.BDQCTestResultLogD</IdLocation>
<IndexLocation>^dbo.BDQCTestResultLogI</IndexLocation>
<StreamLocation>^dbo.BDQCTestResultLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
