Class User.DHCEQCGroupPicType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GPT_RowID, SqlTableName = DHC_EQCGroupPicType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GPT_GroupDR
Property GPTGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GPT_GroupDR ];

Property GPTPicTypeDR As DHCEQCPicType [ SqlColumnNumber = 3, SqlFieldName = GPT_PicTypeDR ];

Property GPTEditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GPT_EditFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCGroupPicType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GPT_EditFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GPT_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GPT_PicTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCGroupPicType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GPT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>GPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCGroupPicType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GPTGroupDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GPT_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GPT_PicTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPicTypeDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCGroupPicType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GPTPicTypeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GPT_PicTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCGroupPicTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
