Class User.DHCEQFinancialReviewEquip Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQFinancialReviewEquip, StorageStrategy = SQLStorage ]
{

/// FRE_FinancialReviewListDR
Property FREFinancialReviewListDR As DHCEQFinancialReviewList [ SqlColumnNumber = 2, SqlFieldName = FRE_FinancialReviewListDR ];

/// FRE_EquipDR
Property FREEquipDR As DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = FRE_EquipDR ];

/// FRE_EQNo
Property FREEQNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FRE_EQNo ];

/// FRE_PurposeType
Property FREPurposeType As DHCEQCPurposeType [ SqlColumnNumber = 6, SqlFieldName = FRE_PurposeType ];

/// FRE_TransAsSetDate
Property FRETransAsSetDate As %Date [ SqlColumnNumber = 7, SqlFieldName = FRE_TransAsSetDate ];

/// FRE_LocationDR
Property FRELocationDR As DHCEQCLocation [ SqlColumnNumber = 4, SqlFieldName = FRE_LocationDR ];

/// FRE_Hold1
Property FREHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = FRE_Hold1 ];

/// FRE_Hold2
Property FREHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = FRE_Hold2 ];

/// FRE_Hold3
Property FREHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = FRE_Hold3 ];

/// FRE_Hold4
Property FREHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = FRE_Hold4 ];

/// FRE_Hold5
Property FREHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FRE_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQFinancialReviewEquip("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FRE_EQNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FRE_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FRE_FinancialReviewListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FRE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FRE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FRE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FRE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FRE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FRE_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FRE_PurposeType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FRE_TransAsSetDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQFinancialReviewEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FRE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{FRE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFinicalReviewList">
<Global>^DHCEQFinancialReviewEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FinancialReviewList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FRE_FinancialReviewListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FRE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FRE_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQFinancialReviewEquipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
