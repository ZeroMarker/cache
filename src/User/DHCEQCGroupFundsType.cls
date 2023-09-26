Class User.DHCEQCGroupFundsType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GFT_RowID, SqlTableName = DHC_EQCGroupFundsType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GFT_FundsTypeDR
Property GFTFundsTypeDR As User.DHCEQCFundsType [ SqlColumnNumber = 3, SqlFieldName = GFT_FundsTypeDR ];

/// GFT_GroupDR
Property GFTGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GFT_GroupDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupFundsType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GFT_FundsTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GFT_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GFT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupFundsType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GFT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>GFT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCGroupFundsType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GFT_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GFT_FundsTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GFT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupFundsTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
