Class User.DHCAdvInducedCause Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AIC_RowId, SqlTableName = DHC_AdvInducedCause, StorageStrategy = SQLStorage ]
{

Property AICCode As %String [ SqlColumnNumber = 2, SqlFieldName = AIC_Code ];

Property AICDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AIC_Desc ];

Property AICParentRowId As %String [ SqlColumnNumber = 4, SqlFieldName = AIC_ParentRowId ];

Property AICActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AIC_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVINDCAU)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVINDCAU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AIC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentRowId">
<Global>^DHCADVINDCAU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParentRowId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIC_ParentRowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MaserData">
<Data name="AIC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIC_ParentRowId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVINDCAU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{AIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AIC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvInducedCauseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
