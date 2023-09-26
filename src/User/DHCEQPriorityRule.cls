Class User.DHCEQPriorityRule Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQPriorityRule, StorageStrategy = SQLStorage ]
{

/// PR_SourceType
Property PRSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PR_SourceType ];

/// PR_Rule
Property PRRule As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PR_Rule ];

/// PR_InvalidFlag
Property PRInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PR_InvalidFlag ];

/// PR_Hold1
Property PRHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PR_Hold1 ];

/// PR_Hold2
Property PRHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PR_Hold2 ];

/// PR_Hold3
Property PRHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PR_Hold3 ];

/// PR_Hold4
Property PRHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PR_Hold4 ];

/// PR_Hold5
Property PRHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PR_Hold5 ];

/// PR_HospitalDR
Property PRHospitalDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PR_HospitalDR ];

/// PR_EquipTypeDR
Property PREquipTypeDR As DHCEQCEquipType [ SqlColumnNumber = 11, SqlFieldName = PR_EquipTypeDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQPriorityRule("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PR_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_Rule">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQPriorityRule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRule">
<Global>^DHCEQPriorityRule</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Rule"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>+{PR_HospitalDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PR_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{PR_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PR_InvalidFlag}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQPriorityRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
