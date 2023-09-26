Class User.DHCEQCEvaluationList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EL_RowID, SqlTableName = DHC_EQCEvaluationList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EL_EvaluationDR
Property ELEvaluationDR As User.DHCEQCEvaluation [ SqlColumnNumber = 2, SqlFieldName = EL_EvaluationDR ];

/// EL_EvaluateTypeDR
Property ELEvaluateTypeDR As User.DHCEQCEvaluateType [ SqlColumnNumber = 3, SqlFieldName = EL_EvaluateTypeDR ];

/// EL_ItemScore
Property ELItemScore As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EL_ItemScore ];

/// EL_EvaluateGroupDR
Property ELEvaluateGroupDR As User.DHCEQCEvaluateGroup [ SqlColumnNumber = 5, SqlFieldName = EL_EvaluateGroupDR ];

/// EL_ShowOrder
Property ELShowOrder As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EL_ShowOrder ];

/// EL_Hold1
Property ELHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EL_Hold1 ];

/// EL_Hold2
Property ELHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EL_Hold2 ];

/// EL_Hold3
Property ELHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EL_Hold3 ];

/// EL_Hold4
Property ELHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EL_Hold4 ];

/// EL_Hold5
Property ELHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCEvaluationList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EL_EvaluateGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EL_EvaluateTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EL_EvaluationDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EL_ItemScore">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EL_ShowOrder">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCEvaluationList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEvaluateGroupType">
<Global>^DHCEQCEvaluationList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EvaluateGroupType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EL_EvaluationDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EL_EvaluateGroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EL_EvaluateTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEvaluation">
<Global>^DHCEQCEvaluationList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Evaluation"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EL_EvaluationDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCEvaluationListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
