Class User.DHCVISPlayPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_VIS_PlayPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PlanName
Property PlanName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// SysFlag
Property SysFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3 ];

/// ServerDR
Property ServerDR As User.DHCVISVoiceServer [ SqlColumnNumber = 4 ];

/// ClientDR
Property ClientDR As User.DHCVISVoiceClient [ SqlColumnNumber = 5 ];

/// URL
Property URL As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// UpdateUser
Property UpdateUser As User.SSUser [ SqlColumnNumber = 7 ];

/// UpdateDate
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8 ];

/// UpdateTime
Property UpdateTime As %Library.Time [ SqlColumnNumber = 9 ];

/// Note
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISPlan)</SqlIdExpression>
<SQLMap name="IndexClientDR">
<Global>^DHCVISPlani</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClientDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ClientDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServerDR">
<Global>^DHCVISPlani</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ServerDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ServerDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSysFlag">
<Global>^DHCVISPlani</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SysFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SysFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCVISPlan">
<Data name="ClientDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PlanName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ServerDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URL">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCVISPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISPlayPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
