Class User.DHCLabCTIP Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLIP_RowID, SqlTableName = DHC_LabCTIP, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCLabCTIPLocation As User.DHCLabCTIPLocation [ Cardinality = children, Inverse = DLILParRef ];

/// DLIP_IPAddress
Property DLIPIPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DLIP_IPAddress ];

/// DLIP_Date
Property DLIPDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = DLIP_Date ];

/// DLIP_Time
Property DLIPTime As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DLIP_Time ];

/// DLIP_Sequence
Property DLIPSequence As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DLIP_Sequence ];

/// DLIP_AdmType
Property DLIPAdmType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DLIP_AdmType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLabCTIP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DLIP_AdmType">
<Delimiter>"\"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLIP_Date">
<Delimiter>"\"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLIP_IPAddress">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLIP_Sequence">
<Delimiter>"\"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLIP_Time">
<Delimiter>"\"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCLabCTIP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DLIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DLIP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIP">
<Global>^DHCLabCTIP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DLIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLIP_IPAddress}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSequence">
<Global>^DHCLabCTIP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DLIP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLIP_Sequence}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLIP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLabCTIPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
