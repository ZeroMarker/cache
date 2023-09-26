Class User.DHCVISPlayPlanItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_VIS_PlayPlanItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PlayPlanItem Row ID
Property PlanDR As User.DHCVISPlayPlan [ SqlColumnNumber = 2 ];

/// Play Item File Name
Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Active Flag Yes Or No
Property ActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// SeqNo
Property SeqNo As %Library.Float [ SqlColumnNumber = 5 ];

/// Update User
Property UpdateUser As User.SSUser [ SqlColumnNumber = 6 ];

/// Update Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7 ];

/// Update Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISPlanItem)</SqlIdExpression>
<SQLMap name="IndexFileName">
<Global>^DHCVISPlanItemi</Global>
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
<Expression>"FileName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FileName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlan">
<Global>^DHCVISPlanItemi</Global>
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
<Expression>"Plan"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PlanDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlanSeqNo">
<Global>^DHCVISPlanItemi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlanSeqNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PlanDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SeqNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCVISPlanItem">
<Data name="ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FileName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PlanDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCVISPlanItem</Global>
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
<StreamLocation>^User.DHCVISPlayPlanItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
