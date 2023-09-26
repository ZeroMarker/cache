/// DHC_ANC_Sheet
Class User.DHCANCSheet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCSH_RowId, SqlTableName = DHC_ANC_Sheet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCANCSheetItem As User.DHCANCSheetItem [ Cardinality = children, Inverse = ANCSHIParref ];

/// ANCSH_Code
Property ANCSHCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCSH_Code ];

/// ANCSH_Interval
Property ANCSHInterval As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = ANCSH_Interval ];

/// ANCSH_FixedItems
Property ANCSHFixedItems As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ANCSH_FixedItems ];

/// ANCSH_Scale1_Dr
Property ANCSHScale1Dr As User.DHCANCScale [ SqlColumnNumber = 5, SqlFieldName = ANCSH_Scale1_Dr ];

/// ANCSH_Scale2_Dr
Property ANCSHScale2Dr As User.DHCANCScale [ SqlColumnNumber = 6, SqlFieldName = ANCSH_Scale2_Dr ];

/// ANCSH_Scale3_Dr
Property ANCSHScale3Dr As User.DHCANCScale [ SqlColumnNumber = 7, SqlFieldName = ANCSH_Scale3_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("Sheet",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCSH_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCSH_FixedItems">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCSH_Interval">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCSH_Scale1_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANCSH_Scale2_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANCSH_Scale3_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCSH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Sheet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCSH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCSheetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
