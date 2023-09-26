Class User.DHCAdrEvtWorkFlow Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADREW_RowID, SqlTableName = DHC_AdrEvtWorkFlow, StorageStrategy = NewStorage1 ]
{

Property ADREWCode As %String [ SqlColumnNumber = 2, SqlFieldName = ADREW_Code ];

Property ADREWDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ADREW_Desc ];

Property ADREWEventDr As %String [ SqlColumnNumber = 4, SqlFieldName = ADREW_Event_Dr ];

Property ADREWActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ADREW_Active ];

Relationship ChildDHCAdrEvtWorkFlowItm As User.DHCAdrEvtWorkFlowItm [ Cardinality = children, Inverse = ADREWIADREWParref ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADREVTWF)</SqlIdExpression>
<SQLMap name="IndexDesc">
<Global>^DHCADREVTWF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADREW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ADREW_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADREW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADREW_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADREW_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADREW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADREW_Event_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADREVTWF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADREW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADREW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCADREVTWF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADREW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ADREW_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADREW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexEvent">
<Global>^DHCADREVTWF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADREW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Event"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADREW_Event_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADREW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdrEvtWorkFlowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
