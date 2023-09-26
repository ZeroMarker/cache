Class User.DHCWMRContents Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_Contents, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCWMRContSub As User.DHCWMRContSub [ Cardinality = children, Inverse = ParRef ];

/// Code
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Description
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRCNT)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWMRCNT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRContentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
