Class User.DHCEQCEvaluation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = E_RowID, SqlTableName = DHC_EQCEvaluation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// E_AutoEvaluateTime
Property EAutoEvaluateTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = E_AutoEvaluateTime ];

/// E_EquipTypeDR
Property EEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 5, SqlFieldName = E_EquipTypeDR ];

/// E_TimePoint
Property ETimePoint As %Library.String(DISPLAYLIST = ",最终审核,指定动作节点后", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 6, SqlFieldName = E_TimePoint ];

/// E_EvaluationOrder
Property EEvaluationOrder As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = E_EvaluationOrder ];

/// E_Hold1
Property EHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = E_Hold1 ];

/// E_Hold2
Property EHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = E_Hold2 ];

/// E_Hold3
Property EHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = E_Hold3 ];

/// E_Hold5
Property EHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = E_Hold5 ];

/// E_HospitalDR
Property EHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = E_HospitalDR ];

/// E_IndependentFlag
Property EIndependentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = E_IndependentFlag ];

/// E_Hold4
Property ELHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = E_Hold4 ];

/// E_MPEvaluationFlag
Property EMPEvaluationFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = E_MPEvaluationFlag ];

/// E_RoleDR
Property ERoleDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = E_RoleDR ];

/// E_SourceType
Property ESourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = E_SourceType ];

/// E_InvalidFlag
Property EInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = E_InvalidFlag ];

/// E_ActionDR
Property EActionDR As User.DHCEQCAction [ SqlColumnNumber = 17, SqlFieldName = E_ActionDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCEvaluation("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="E_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="E_AutoEvaluateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="E_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="E_EvaluationOrder">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="E_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="E_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="E_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="E_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="E_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="E_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="E_IndependentFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="E_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="E_MPEvaluationFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="E_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="E_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="E_TimePoint">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCEvaluation</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{E_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQCEvaluation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{E_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEvaluation">
<Global>^DHCEQCEvaluation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Evaluation"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{E_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{E_HospitalDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{E_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{E_RoleDR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceTypeSort">
<Global>^DHCEQCEvaluation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceTypeSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{E_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{E_EvaluationOrder}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCEvaluationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
