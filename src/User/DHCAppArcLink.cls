Class User.DHCAppArcLink Extends %Persistent [ SqlRowIdName = AL_RowID, SqlTableName = DHC_AppArcLink, StorageStrategy = SQLStorage ]
{

/// AL_Arc_Dr	检查项目id	Dr
Property ALArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = AL_Arc_Dr ];

/// AL_Part_Dr	部位id
Property ALPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = AL_Part_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPARCL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AL_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AL_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPARCL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcPart">
<Global>^DHCAPARCL</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AL_Arc_Dr</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AL_Part_Dr</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>AL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArcPart"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AL_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AL_Part_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
