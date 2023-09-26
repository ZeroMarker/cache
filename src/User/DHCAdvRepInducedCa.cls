Class User.DHCAdvRepInducedCa Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ARIC_RowId, SqlTableName = DHC_AdvRepInducedCa, StorageStrategy = SQLStorage ]
{

Property ARICReportId As %String [ SqlColumnNumber = 2, SqlFieldName = ARIC_ReportId ];

Property ARICTypeDr As %String [ SqlColumnNumber = 3, SqlFieldName = ARIC_Type_Dr ];

Property ARICCauseDr As %String [ SqlColumnNumber = 4, SqlFieldName = ARIC_Cause_Dr ];

Property ARICstrategyDr As %String [ SqlColumnNumber = 5, SqlFieldName = ARIC_strategy_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVRINDCAU)</SqlIdExpression>
<SQLMap name="IndexReport">
<Global>^DHCADVRINDCAU</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReportType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARIC_ReportId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARIC_Type_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ARIC_Cause_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARIC_ReportId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARIC_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARIC_strategy_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVRINDCAU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ARIC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepInducedCaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
