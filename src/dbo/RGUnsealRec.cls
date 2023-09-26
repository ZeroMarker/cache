///     
Class dbo.RGUnsealRec Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_UnsealRec, StorageStrategy = Default ]
{

/// Foreign Key FKRGUnsealRecCloser created via DDL
ForeignKey FKRGUnsealRecCloser(CloserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_UnsealRec_Closer ];

/// Foreign Key FKRGUnsealRecFirSigner created via DDL
ForeignKey FKRGUnsealRecFirSigner(FirSignerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_UnsealRec_FirSigner ];

/// Foreign Key FKRGUnsealRecLotBottle created via DDL
ForeignKey FKRGUnsealRecLotBottle(LotBottleDR) References dbo.RGLotBottle(PKRGLotBottle) [ SqlName = FK_RG_UnsealRec_LotBottle ];

/// Foreign Key FKRGUnsealRecOpener created via DDL
ForeignKey FKRGUnsealRecOpener(OpenerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_UnsealRec_Opener ];

ForeignKey FKRGUnsealRecMachine(MachineDR) References dbo.BTRGMachine(PKBTRGMACHINE) [ SqlName = FK_RG_UnsealRec_Machine ];

/// Foreign Key FKRGUnsealRecSecSigner created via DDL
ForeignKey FKRGUnsealRecSecSigner(SecSignerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_UnsealRec_SecSigner ];

Index IndexMaster On (LotBottleDR, Sequence) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOpenDate On OpenDate [ SqlName = Index_OpenDate, Type = index ];

Index IndexCloseDate On CloseDate [ SqlName = Index_CloseDate, Type = index ];

Index IndexMachineDR On MachineDR [ SqlName = Index_MachineDR, Type = index ];

Index PKRGUNSEALREC On RowID [ SqlName = PK_RG_UNSEALREC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property LotBottleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Amount As %Library.Float [ SqlColumnNumber = 6 ];

Property FirSignerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property FirSignDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property FirSignTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property FirAdvance As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

Property FirApproved As %Library.Boolean [ SqlColumnNumber = 11 ];

Property SecSignerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property SecSignDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property SecSignTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property SecAdvance As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Property SecApproved As %Library.Boolean [ SqlColumnNumber = 16 ];

Property OpenerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property OpenDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property OpenTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CloserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CloseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property CloseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="RGUnsealRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LotBottleDR</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Amount</Value>
</Value>
<Value name="6">
<Value>FirSignerDR</Value>
</Value>
<Value name="7">
<Value>FirSignDate</Value>
</Value>
<Value name="8">
<Value>FirSignTime</Value>
</Value>
<Value name="9">
<Value>FirAdvance</Value>
</Value>
<Value name="10">
<Value>FirApproved</Value>
</Value>
<Value name="11">
<Value>SecSignerDR</Value>
</Value>
<Value name="12">
<Value>SecSignDate</Value>
</Value>
<Value name="13">
<Value>SecSignTime</Value>
</Value>
<Value name="14">
<Value>SecAdvance</Value>
</Value>
<Value name="15">
<Value>SecApproved</Value>
</Value>
<Value name="16">
<Value>OpenerDR</Value>
</Value>
<Value name="17">
<Value>OpenDate</Value>
</Value>
<Value name="18">
<Value>OpenTime</Value>
</Value>
<Value name="19">
<Value>CloserDR</Value>
</Value>
<Value name="20">
<Value>CloseDate</Value>
</Value>
<Value name="21">
<Value>CloseTime</Value>
</Value>
<Value name="22">
<Value>MachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGUnsealRecD</DataLocation>
<DefaultData>RGUnsealRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGUnsealRecD</IdLocation>
<IndexLocation>^dbo.RGUnsealRecI</IndexLocation>
<StreamLocation>^dbo.RGUnsealRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
