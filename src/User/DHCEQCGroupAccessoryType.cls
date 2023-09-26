Class User.DHCEQCGroupAccessoryType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GAT_RowID, SqlTableName = DHC_EQCGroupAccessoryType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GAT_GroupDR
Property GATGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = GAT_GroupDR ];

/// GAT_AccessoryTypeDR
Property GATAccessoryTypeDR As User.DHCEQCAccessory [ SqlColumnNumber = 3, SqlFieldName = GAT_AccessoryTypeDR ];

/// GAT_DefaultFlag
Property GATDefaultFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GAT_DefaultFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupAccessoryType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GAT_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GAT_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GAT_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupAccessoryType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GAT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>GAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCGroupAccessoryType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GAT_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GAT_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupAccessoryTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
