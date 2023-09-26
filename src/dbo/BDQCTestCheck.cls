///     
Class dbo.BDQCTestCheck Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BDQC_TestCheck ]
{

/// Foreign Key FKBDQCTestCheckMaterialDR created via DDL
ForeignKey FKBDQCTestCheckMaterialDR(MaterialDR) References dbo.BBQCMaterial(PKBBQCMATERIAL) [ SqlName = FK_BDQCTestCheckMaterialDR ];

/// Foreign Key FKBDQCTestCheckCheckUserDR created via DDL
ForeignKey FKBDQCTestCheckCheckUserDR(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDQCTestCheckCheckUserDR ];

/// DDL Primary Key Specification
Index PKBDQCTESTCHECK On RowID [ PrimaryKey, SqlName = PK_BDQC_TESTCHECK, Type = index, Unique ];

Index IndexMaster On (MaterialDR, ResultDate, TestNum) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property QCStatus As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 9 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDQCTestCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>TestNum</Value>
</Value>
<Value name="4">
<Value>CheckDate</Value>
</Value>
<Value name="5">
<Value>CheckTime</Value>
</Value>
<Value name="6">
<Value>CheckUserDR</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>QCStatus</Value>
</Value>
<Value name="9">
<Value>ResultDate</Value>
</Value>
</Data>
<DataLocation>^dbo.BDQCTestCheckD</DataLocation>
<DefaultData>BDQCTestCheckDefaultData</DefaultData>
<IdLocation>^dbo.BDQCTestCheckD</IdLocation>
<IndexLocation>^dbo.BDQCTestCheckI</IndexLocation>
<StreamLocation>^dbo.BDQCTestCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
