Class User.DHCEQPrescriptionList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPrescriptionList, StorageStrategy = SQLStorage ]
{

/// PL_PrescriptionDR
Property PLPrescriptionDR As DHCEQPrescription [ SqlColumnNumber = 2, SqlFieldName = PL_PrescriptionDR ];

/// PL_FromAction
Property PLFromAction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PL_FromAction ];

/// PL_TimeNum
Property PLTimeNum As %Float [ SqlColumnNumber = 4, SqlFieldName = PL_TimeNum ];

/// PL_TimeUnitDR
Property PLTimeUnitDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PL_TimeUnitDR ];

/// PL_AlarmNum
Property PLAlarmNum As %Float [ SqlColumnNumber = 6, SqlFieldName = PL_AlarmNum ];

/// PL_ActiveTimeFlag
Property PLActiveTimeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PL_ActiveTimeFlag ];

/// PL_ActivePreFlag
Property PLActivePreFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PL_ActivePreFlag ];

/// PL_Hold1
Property PLHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PL_Hold1 ];

/// PL_Hold2
Property PLHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PL_Hold2 ];

/// PL_Hold3
Property PLHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PL_Hold3 ];

/// PL_Hold4
Property PLHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PL_Hold4 ];

/// PL_Hold5
Property PLHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PL_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPrescriptionList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PL_ActivePreFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PL_ActiveTimeFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_AlarmNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PL_FromAction">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PL_PrescriptionDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_TimeNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PL_TimeUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQPrescriptionList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPrescription">
<Global>^DHCEQPrescriptionList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Prescription"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PL_PrescriptionDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescriptionSort">
<Global>^DHCEQPrescriptionList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescriptionListSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_PrescriptionDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_ActiveTimeFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PL_Hold1}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPrescriptionListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
