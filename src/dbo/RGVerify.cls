Class dbo.RGVerify Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Verify, StorageStrategy = Default ]
{

Index IndexMaster On (LotDR, FilePathDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexVerifyNo On VerifyNo [ SqlName = PK_RG_VerifyNo, Type = index, Unique ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index PKRGVERIFY On RowID [ PrimaryKey, SqlName = PK_RG_VERIFY, Type = index, Unique ];

ForeignKey FKRGVerifyLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_Verify_Lot ];

ForeignKey FKRGVerifyFilePath(FilePathDR) References dbo.RGFilePath(PKRGFILEPATH) [ SqlName = FK_RG_Verify_FilePath ];

ForeignKey FKRGVerifyCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Verify_Creator ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VerifyNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property FilePathDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RGVerifyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VerifyNo</Value>
</Value>
<Value name="3">
<Value>LotDR</Value>
</Value>
<Value name="4">
<Value>FilePathDR</Value>
</Value>
<Value name="5">
<Value>CreatorDR</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGVerifyD</DataLocation>
<DefaultData>RGVerifyDefaultData</DefaultData>
<IdLocation>^dbo.RGVerifyD</IdLocation>
<IndexLocation>^dbo.RGVerifyI</IndexLocation>
<StreamLocation>^dbo.RGVerifyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
