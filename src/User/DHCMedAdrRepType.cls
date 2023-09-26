Class User.DHCMedAdrRepType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDTYP_RowID, SqlTableName = DHC_MedAdrRepType, StorageStrategy = NewStorage1 ]
{

Property MEDTYPPointer As %String [ SqlColumnNumber = 2, SqlFieldName = MEDTYP_Pointer ];

Property MEDTYPType As %String [ SqlColumnNumber = 3, SqlFieldName = MEDTYP_Type ];

Property MEDTYPAdvTypeDr As %String [ SqlColumnNumber = 4, SqlFieldName = MEDTYP_AdvType_Dr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMEDREPTYP)</SqlIdExpression>
<SQLMap name="IndexPointer">
<Global>^DHCMEDREPTYP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDTYP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDTYP_AdvType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDTYP_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDTYP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MEDTYP_AdvType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDTYP_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDTYP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMEDREPTYP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDTYP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDTYP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrRepTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
