Class User.DHCOPReceipt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPREC_Rowid, SqlTableName = DHCOPReceipt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPREC_Date
Property OPRECDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = OPREC_Date ];

/// OPRecTime
Property OPRecTime As %Library.Time [ SqlColumnNumber = 3 ];

/// OPRecSum
Property OPRecSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// OPRecUser
Property OPRecUser As User.SSUser [ SqlColumnNumber = 5 ];

/// OPRecFlag
Property OPRecFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// OPRecStDate
Property OPRecStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7 ];

/// OPRecEndDate
Property OPRecEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPReceipt)</SqlIdExpression>
<SQLMap name="indexdate">
<Global>^DHCOPReceipt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPREC_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCOPReceipt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPRecFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCOPReceipt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPRecUser}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterDHCOPReceipt">
<Data name="OPREC_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPRecEndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPRecFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPRecStDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPRecSum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPRecTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPRecUser">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOPReceipt</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCOPReceiptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
