Class User.DHCEQEvaluate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = E_RowID, SqlTableName = DHC_EQEvaluate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// E_SourceType
Property ESourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = E_SourceType ];

/// E_SourceID
Property ESourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = E_SourceID ];

/// E_Content
Property EContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = E_Content ];

/// E_RoleDR
Property ERoleDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = E_RoleDR ];

/// E_UserDR
Property EUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = E_UserDR ];

/// E_EvaluationDate
Property EEvaluationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = E_EvaluationDate ];

/// E_EvaluationTime
Property EEvaluationTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = E_EvaluationTime ];

/// E_Remark
Property ERemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = E_Remark ];

/// E_Hold1
Property EHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = E_Hold1 ];

/// E_Hold2
Property EHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = E_Hold2 ];

/// E_Hold3
Property EHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = E_Hold3 ];

/// E_Hold4
Property EHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = E_Hold4 ];

/// E_Hold5
Property EHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = E_Hold5 ];

/// E_ActionDR
Property EActionDR As User.DHCEQCAction [ SqlColumnNumber = 15, SqlFieldName = E_ActionDR ];

/// E_EvaluationDR
Property EEvaluationDR As User.DHCEQCEvaluation [ SqlColumnNumber = 16, SqlFieldName = E_EvaluationDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEvaluate("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="E_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="E_Content">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="E_EvaluationDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="E_EvaluationDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="E_EvaluationTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="E_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="E_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="E_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="E_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="E_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="E_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="E_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="E_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="E_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="E_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQEvaluate</Global>
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
<SQLMap name="IndexSERoleUser">
<Global>^DHCEQEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SERoleUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{E_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{E_EvaluationDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{E_RoleDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{E_UserDR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{E_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceRole">
<Global>^DHCEQEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceRole"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{E_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{E_RoleDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceRoleUser">
<Global>^DHCEQEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceRoleUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{E_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{E_RoleDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{E_UserDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEvaluateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
