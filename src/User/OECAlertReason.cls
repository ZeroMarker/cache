/// OEC Alert Reason(1857)
Class User.OECAlertReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_AlertReason, StorageStrategy = SQLStorage ]
{

/// Code
Property ALRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ALR_Code ];

/// Description
Property ALRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALR_Desc ];

/// DateFrom
Property ALRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ALR_DateFrom ];

/// DateTo
Property ALRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ALR_DateTo ];

Trigger OECAlertReasonafterinsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d insert^SSAUDIT(1857)
}

Trigger OECAlertReasonafterupdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
 d update^SSAUDIT(1857)
}

Trigger OECAlertReasonafterdelete [ Event = DELETE, Order = 1, Time = AFTER ]
{
 d delete^SSAUDIT(1857)
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEC("ALR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ALR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ALR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ALR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALR_RowId</SqlRowIdName>
<StreamLocation>^User.OECAlertReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
