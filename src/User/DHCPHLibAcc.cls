Class User.DHCPHLibAcc Extends (%Persistent, User.Abstract) [ SqlRowIdName = PHLAC_RowId, SqlTableName = DHC_PHLibAcc, StorageStrategy = NewStorage1 ]
{

Property PHLACPointer As %String [ SqlColumnNumber = 2, SqlFieldName = PHLAC_Pointer ];

Property PHLACType As %String [ SqlColumnNumber = 3, SqlFieldName = PHLAC_Type ];

Property PHLACLibDr As %String [ SqlColumnNumber = 4, SqlFieldName = PHLAC_Lib_Dr ];

Property PHLACLabelDr As User.DHCPHInstLabel [ SqlColumnNumber = 5, SqlFieldName = PHLAC_Label_Dr ];

Property PHLACItemDr As User.DHCPHLibItemFeild [ SqlColumnNumber = 6, SqlFieldName = PHLAC_Item_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHLIBACC)</SqlIdExpression>
<SQLMap name="IndexLabel">
<Global>^DHCPHLIBACC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHLAC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLAC_Lib_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLAC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLAC_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHLAC_Label_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHLAC_Item_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHLAC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLAC_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHLAC_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHLAC_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLAC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLAC_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHLIBACC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLAC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHLAC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibAccS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
