Class User.DHCItmRepLoc Extends (%Persistent, User.Abstract) [ SqlRowIdName = RPLC_RowId, SqlTableName = DHC_ItmRepLoc, StorageStrategy = SqlStorage ]
{

Property RPLCCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = RPLC_CTLOC_DR ];

Property RPLCStkCatDR As User.INCStkCat [ SqlColumnNumber = 3, SqlFieldName = RPLC_StkCat_DR ];

Property RPLCRepLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = RPLC_RepLoc_DR ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCItmRepLoc(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RPLC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RPLC_RepLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RPLC_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCItmRepLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RPLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RPLC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCItmRepLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RPLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOCSC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RPLC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RPLC_StkCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RPLC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RPLC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmRepLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
