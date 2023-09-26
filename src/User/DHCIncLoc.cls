Class User.DHCIncLoc Extends (%Persistent, User.Abstract) [ SqlRowIdName = IncLoc_ROWID, SqlTableName = DHC_IncLoc, StorageStrategy = SQLStorage ]
{

Property IncLocINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = IncLoc_INCI_DR ];

Property IncLocLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = IncLoc_Loc_DR ];

Property IncLocMarkTypeDR As User.DHCMarkType [ SqlColumnNumber = 4, SqlFieldName = IncLoc_MarkTypeDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINCLOC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IncLoc_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IncLoc_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IncLoc_MarkTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINCLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IncLoc_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IncLoc_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCINCLOC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IncLoc_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IncLoc_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IncLoc_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IncLoc_ROWID</SqlRowIdName>
<StreamLocation>^User.DHCIncLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
