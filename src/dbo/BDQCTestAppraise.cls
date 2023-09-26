///     
Class dbo.BDQCTestAppraise Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BDQC_TestAppraise ]
{

/// Foreign Key FKBDQCTestAppraiseMaterialDR created via DDL
ForeignKey FKBDQCTestAppraiseMaterialDR(MaterialDR) References dbo.BBQCMaterial(PKBBQCMATERIAL) [ SqlName = FK_BDQCTestAppraiseMaterialDR ];

/// Foreign Key FKBDQCTestAppraiseAddUserDR created via DDL
ForeignKey FKBDQCTestAppraiseAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDQCTestAppraiseAddUserDR ];

/// DDL Primary Key Specification
Index PKBDQCTESTAPPRAISE On RowID [ PrimaryKey, SqlName = PK_BDQC_TESTAPPRAISE, Type = index, Unique ];

Index IndexMaster On (MaterialDR, AppDate) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AppDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDQCTestAppraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>AppDate</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
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
</Data>
<DataLocation>^dbo.BDQCTestAppraiseD</DataLocation>
<DefaultData>BDQCTestAppraiseDefaultData</DefaultData>
<IdLocation>^dbo.BDQCTestAppraiseD</IdLocation>
<IndexLocation>^dbo.BDQCTestAppraiseI</IndexLocation>
<StreamLocation>^dbo.BDQCTestAppraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
