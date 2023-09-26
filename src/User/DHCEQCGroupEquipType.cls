Class User.DHCEQCGroupEquipType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GET_RowID, SqlTableName = DHC_EQCGroupEquipType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GET_DefaultFlag
Property GETDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GET_DefaultFlag ];

/// GET_EquipTypeDR
Property GETEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 3, SqlFieldName = GET_EquipTypeDR ];

/// GET_GroupDR
Property GETGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GET_GroupDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupEquipType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GET_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GET_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GET_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GET_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupEquipType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GET_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>GET_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCGroupEquipType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GET_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GET_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GET_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupEquipTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
