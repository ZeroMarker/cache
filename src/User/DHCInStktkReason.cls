Class User.DHCInStktkReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = ISR_RowId, SqlTableName = DHC_InStktkReason, StorageStrategy = SQLStorage ]
{

Property ISRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ISR_Code ];

Property ISRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ISR_Desc ];

Property ISRType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 4, SqlFieldName = ISR_Type ];

/// 激活标记(缺省为Y)
Property ISRActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = ISR_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINSTKTKREASON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCISR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ISR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({ISR_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ISR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCISR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ISR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({ISR_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ISR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ISR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISR_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCISR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ISR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCInStktkReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
