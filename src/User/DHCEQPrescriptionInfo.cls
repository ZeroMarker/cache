Class User.DHCEQPrescriptionInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPrescriptionInfo, StorageStrategy = SQLStorage ]
{

/// PI_ApproveListDR
Property PIApproveListDR As DHCEQApproveList [ SqlColumnNumber = 2, SqlFieldName = PI_ApproveListDR ];

/// PI_FromActionDate
Property PIFromActionDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PI_FromActionDate ];

/// PI_FromActionTime
Property PIFromActionTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PI_FromActionTime ];

/// PI_ToActionDate
Property PIToActionDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PI_ToActionDate ];

/// PI_ToActionTime
Property PIToActionTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PI_ToActionTime ];

/// PI_TimeNum
Property PITimeNum As %Float [ SqlColumnNumber = 7, SqlFieldName = PI_TimeNum ];

/// PI_TimeUnitDR
Property PITimeUnitDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PI_TimeUnitDR ];

/// PI_TimeAmount
Property PITimeAmount As %Float [ SqlColumnNumber = 9, SqlFieldName = PI_TimeAmount ];

/// PI_FromAction
Property PIFromAction As DHCEQCAction [ SqlColumnNumber = 10, SqlFieldName = PI_FromAction ];

/// PI_ToAction
Property PIToAction As DHCEQCAction [ SqlColumnNumber = 11, SqlFieldName = PI_ToAction ];

/// PI_Hold1
Property PIHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PI_Hold1 ];

/// PI_Hold2
Property PIHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PI_Hold2 ];

/// PI_Hold3
Property PIHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PI_Hold3 ];

/// PI_Hold4
Property PIHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PI_Hold4 ];

/// PI_Hold5
Property PIHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PI_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPrescriptionInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PI_ApproveListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PI_FromAction">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PI_FromActionDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PI_FromActionTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PI_TimeAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PI_TimeNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PI_TimeUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PI_ToAction">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PI_ToActionDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PI_ToActionTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQPrescriptionInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveList">
<Global>^DHCEQPrescriptionInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ApproveList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PI_ApproveListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPrescriptionInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
