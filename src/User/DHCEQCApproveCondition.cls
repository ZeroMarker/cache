Class User.DHCEQCApproveCondition Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AC_RowID, SqlTableName = DHC_EQCApproveCondition, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AC_ApproveSetDR
Property ACApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 2, SqlFieldName = AC_ApproveSetDR ];

/// AC_ConditionFieldsDR
Property ACConditionFieldsDR As User.DHCEQCConditionFields [ SqlColumnNumber = 3, SqlFieldName = AC_ConditionFieldsDR ];

/// AC_Value
Property ACValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AC_Value ];

/// AC_ToValue
Property ACToValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AC_ToValue ];

/// AC_Hold1
Property ACHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AC_Hold1 ];

/// AC_Hold2
Property ACHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AC_Hold2 ];

/// AC_Hold3
Property ACHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AC_Hold3 ];

/// AC_Hold4
Property ACHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AC_Hold4 ];

/// AC_Hold5
Property ACHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AC_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCApproveCondition",0))</SqlIdExpression>
<SQLMap name="ApproveSetIndex">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveCondition"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AC_ConditionFieldsDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="AC_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_ConditionFieldsDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AC_ToValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AC_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCApproveCondition"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCApproveConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
