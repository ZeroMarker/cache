Class User.DHCJFOPRetrunData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPRD_Rowid, SqlTableName = DHC_JFOPRetrunData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPRD_InvPrt_Dr
Property OPRDInvPrtDr As User.DHCINVPRT [ SqlColumnNumber = 2, SqlFieldName = OPRD_InvPrt_Dr ];

/// OPRD_InvNo
Property OPRDInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OPRD_InvNo ];

/// OPRD_Date
Property OPRDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = OPRD_Date ];

/// OPRD_Time
Property OPRDTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = OPRD_Time ];

/// OPRD_User
Property OPRDUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = OPRD_User ];

/// OPRD_Commont1
Property OPRDComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OPRD_Comment1 ];

/// OPRD_Comment2
Property OPRDComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OPRD_Comment2 ];

/// OPRD_Comment3
Property OPRDComment3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OPRD_Comment3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFOPReturnData)</SqlIdExpression>
<SQLMap name="indexComm1">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COMM1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_Comment1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexComm2">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COMM2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_Comment2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexComm3">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COMM3"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_Comment3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinvno">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReturnInvNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_InvNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinvprtdr">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvPrtDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_InvPrt_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReturnUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="inexdate">
<Global>^DHCJFOPReturnData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReturnDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPRD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterindex">
<Data name="OPRD_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPRD_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPRD_Comment3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPRD_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPRD_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPRD_InvPrt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPRD_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPRD_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCJFOPReturnData</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OPRD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFOPRetrunDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
