Class User.DHCEQPrescription Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPrescription, StorageStrategy = SQLStorage ]
{

/// P_SourceType
Property PSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = P_SourceType ];

/// P_HospitalDR
Property PHospitalDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = P_HospitalDR ];

/// P_EquipTypeDR
Property PEquipTypeDR As DHCEQCEquipType [ SqlColumnNumber = 4, SqlFieldName = P_EquipTypeDR ];

/// P_Action
Property PAction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = P_Action ];

/// P_Hold1
Property PHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = P_Hold1 ];

/// P_Hold2
Property PHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = P_Hold2 ];

/// P_Hold3
Property PHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = P_Hold3 ];

/// P_Hold4
Property PHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = P_Hold4 ];

/// P_Hold5
Property PHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = P_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPrescription("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="P_Action">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="P_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="P_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="P_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="P_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="P_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="P_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="P_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="P_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQPrescription</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPrescription">
<Global>^DHCEQPrescription</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>P_RowID</Field>
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
<Expression>+{P_HospitalDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{P_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{P_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{P_Action}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescriptionSort">
<Global>^DHCEQPrescription</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescriptionSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{P_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{P_HospitalDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{P_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{P_Hold1}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>P_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPrescriptionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
