Class User.DHCINVPRTInsuPaym Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPMInsu_Rowid, SqlTableName = DHC_INVPRTInsuPaym, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IPMInsuSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRTInsu Parent Reference
Relationship IPMInsuPrtParref As User.DHCINVPRTInsu [ Cardinality = parent, Inverse = ChildDHCINVPRTInsuPaym, Required, SqlFieldName = IPMInsu_Prt_Parref ];

/// Child subscript
Property IPMInsuSub As %Library.Float [ InitialExpression = {$i(^DHCINVPRTInsu($p(%d(0),$c(1),1),"P",0))}, SqlColumnNumber = 2, SqlFieldName = IPMInsu_Sub ];

/// IPMInsu_PayMode_DR
Property IPMInsuPayModeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IPMInsu_PayMode_DR ];

/// IPMInsu_Amt
Property IPMInsuAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = IPMInsu_Amt ];

/// IPMInsu_BankDR
Property IPMInsuBankDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IPMInsu_BankDR ];

/// IPMInsu_CardNo
Property IPMInsuCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPMInsu_CardNo ];

/// IPMInsu_Date
Property IPMInsuDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = IPMInsu_Date ];

/// IPMInsu_Time
Property IPMInsuTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = IPMInsu_Time ];

/// IPMInsu_AccPLDR
Property IPMInsuAccPLDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IPMInsu_AccPLDR ];

/// IPMInsu_Unit
Property IPMInsuUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IPMInsu_Unit ];

/// IPMInsu_PayAccNo
Property IPMInsuPayAccNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IPMInsu_PayAccNo ];

/// IPMInsu_ChequeDate
Property IPMInsuChequeDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 13, SqlFieldName = IPMInsu_ChequeDate ];

/// IPMInsu_Note1
Property IPMInsuNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IPMInsu_Note1 ];

/// IPMInsu_Note2
Property IPMInsuNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IPMInsu_Note2 ];

/// IPMInsu_Note3
Property IPMInsuNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IPMInsu_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="indexaccpl">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_INVPRTInsu.PrtInsu_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>IPMInsu_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ACCPL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_INVPRTInsu.PrtInsu_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMInsu_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpaym">
<Global>^DHCINVPRTInsu</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_INVPRTInsu.PrtInsu_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>IPMInsu_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Paym"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_INVPRTInsu.PrtInsu_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMInsu_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="master">
<Data name="IPMInsu_AccPLDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPMInsu_Amt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPMInsu_BankDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPMInsu_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPMInsu_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPMInsu_Date">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPMInsu_Note1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPMInsu_Note2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPMInsu_Note3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPMInsu_PayAccNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPMInsu_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPMInsu_Time">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPMInsu_Unit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINVPRTInsu</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRTInsu.PrtInsu_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IPMInsu_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_INVPRTInsu.PrtInsu_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPMInsu_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTInsuPaymS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
