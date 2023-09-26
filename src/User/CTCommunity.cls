/// 地理信息-社区表定义
/// Creator:sunfengchao
Class User.CTCommunity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_Community, StorageStrategy = SQLStorage ]
{

/// Code
Property CTCMUNTCode As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTCMUNT_Code ];

/// Description
Property CTCMUNTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CTCMUNT_Desc ];

/// NationalCode 上一级行政划分
Property CTCMUNTNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 90, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CTCMUNT_NationalCode ];

/// ActiveFlag
Property CTCMUNTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = CTCMUNT_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("CTCMUNT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CTCMUNT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCMUNT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCMUNT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTCMUNT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"CTCMUNT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{CTCMUNT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"CTCMUNT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({CTCMUNT_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CTCMUNT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTCIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"CTCMUNT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({CTCMUNT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CTCMUNT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTCMUNT_RowId</SqlRowIdName>
<StreamLocation>^User.CTCommunityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
