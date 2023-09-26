Class User.DHCAppArcLinkPos Extends %Persistent [ SqlRowIdName = ALP_RowID, SqlTableName = DHC_AppArcLinkPos, StorageStrategy = SQLStorage ]
{

Property ALPArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ALP_Arc_Dr ];

Property ALPPosDr As User.DHCAppPosition [ SqlColumnNumber = 3, SqlFieldName = ALP_Pos_Dr ];

/// ALP_Part_Dr	部位id
Property ALPPartDr As User.DHCAppPart [ SqlColumnNumber = 4, SqlFieldName = ALP_Part_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCPO)</SqlIdExpression>
<SQLMap name="ArcPos">
<Global>^DHCAPARCPO</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArcPos"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALP_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALP_Pos_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexALPArcDr">
<Global>^DHCAPARCPO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ALP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALP_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ALP_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALP_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALP_Pos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPARCPO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ALP_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ALP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ALP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppArcLinkPosS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
