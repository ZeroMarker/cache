Class User.DHCEQDepreMonReportList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMRL_RowID, SqlTableName = DHC_EQDepreMonReportList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DMRL_DepreMonthReportDR
Property DMRLDepreMonthReportDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DMRL_DepreMonthReportDR ];

/// DMRL_EquipTypeDR
Property DMRLEquipTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DMRL_EquipTypeDR ];

/// DMRL_UseTotalFee
Property DMRLUseTotalFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DMRL_UseTotalFee ];

/// DMRL_NewDepreFee
Property DMRLNewDepreFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DMRL_NewDepreFee ];

/// DMRL_DisDepreFee
Property DMRLDisDepreFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DMRL_DisDepreFee ];

/// DMRL_DepreTotalFee
Property DMRLDepreTotalFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DMRL_DepreTotalFee ];

/// DMRL_Hold1
Property DMRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DMRL_Hold1 ];

/// DMRL_Hold2
Property DMRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DMRL_Hold2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDepreMonReportList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DMRL_DepreMonthReportDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMRL_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DMRL_DisDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMRL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DMRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DMRL_NewDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DMRL_UseTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQDepreMonReportList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DMRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMonthEquipType">
<Global>^DHCEQDepreMonReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Month"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMRL_DepreMonthReportDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDepreMonReportListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
