Class User.DHCJFOPCashToBank Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OP_RowId, SqlTableName = DHC_JFOPCashToBank, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OP_Date
Property OPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = OP_Date ];

/// OP_Time
Property OPTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = OP_Time ];

/// OP_Amt
Property OPAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OP_Amt ];

/// OP_User
Property OPUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = OP_User ];

/// OP_AmtYBDZ
Property OPAmtYBDZ As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = OP_AmtYBDZ ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFOPCASHTOBANK)</SqlIdExpression>
<SQLMap name="DHCJFOPCASHTOBANKMaster">
<Data name="OP_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OP_AmtYBDZ">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OP_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OP_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OP_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCJFOPCASHTOBANK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateIndex">
<Global>^DHCJFOPCASHTOBANK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OP_User}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFOPCashToBankS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
