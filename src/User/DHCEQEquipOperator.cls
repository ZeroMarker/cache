Class User.DHCEQEquipOperator Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EO_RowID, SqlTableName = DHC_EQEquipOperator, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EO_EquipDR
Property EOEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = EO_EquipDR ];

/// EO_UserDR
Property EOUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EO_UserDR ];

/// EO_Percent
Property EOPercent As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = EO_Percent ];

/// EO_Remark
Property EORemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EO_Remark ];

/// EO_FromDate
Property EOFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = EO_FromDate ];

/// EO_ToDate
Property EOToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = EO_ToDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipOperator("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EO_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EO_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EO_Percent">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EO_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EO_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQEquipOperator</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQEquipOperator</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EO_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipOperatorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
