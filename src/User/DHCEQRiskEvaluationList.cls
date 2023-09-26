Class User.DHCEQRiskEvaluationList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = REL_RowID, SqlTableName = DHC_EQRiskEvaluationList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// REL_RiskEvaluationDR
Property RELRiskEvaluationDR As User.DHCEQRiskEvaluation [ SqlColumnNumber = 2, SqlFieldName = REL_RiskEvaluationDR ];

/// REL_RiskItemValueDR
Property RELRiskItemValueDR As User.DHCEQCRiskItemValue [ SqlColumnNumber = 3, SqlFieldName = REL_RiskItemValueDR ];

/// REL_Weight
Property RELWeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = REL_Weight ];

/// REL_Hold1
Property RELHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = REL_Hold1 ];

/// REL_Hold2
Property RELHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = REL_Hold2 ];

/// REL_Hold3
Property RELHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = REL_Hold3 ];

/// REL_Hold4
Property RELHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = REL_Hold4 ];

/// REL_Hold5
Property RELHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = REL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQRiskEvaluationList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REL_RiskEvaluationDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REL_RiskItemValueDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REL_Weight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQRiskEvaluationList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>REL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{REL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRELRiskItemValue">
<Global>^DHCEQRiskEvaluationList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>REL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RELRiskItemValue"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REL_RiskItemValueDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRiskEvaluation">
<Global>^DHCEQRiskEvaluationList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>REL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RiskEvaluation"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REL_RiskEvaluationDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQRiskEvaluationListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
