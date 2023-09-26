Class User.DHCRBCItemScheme Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIS_RowID, SqlTableName = DHCRBC_ItemScheme, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSS_Name
Property DISName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DIS_Name ];

/// DSS_Value
Property DISValue As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DIS_Value ];

/// DIS_LocID
Property DISLocID As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = DIS_LocID ];

/// DIS_Expressions
Property DISExpressions As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DIS_Expressions ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItemScheme)</SqlIdExpression>
<SQLMap name="Datamastermap">
<Data name="DIS_Expressions">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIS_LocID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIS_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIS_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCItemScheme</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocID">
<Global>^DHCRBCItemSchemei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIS_LocID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemSchemeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
