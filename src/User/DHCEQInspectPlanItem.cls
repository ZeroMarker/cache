Class User.DHCEQInspectPlanItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPI_RowID, SqlTableName = DHC_EQInspectPlanItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IPI_InspectPlanDR
Property IPIInspectPlanDR As User.DHCEQInspectPlan [ SqlColumnNumber = 2, SqlFieldName = IPI_InspectPlanDR ];

/// IPI_InspectPartDR
Property IPIInspectPartDR As User.DHCEQCPart [ SqlColumnNumber = 3, SqlFieldName = IPI_InspectPartDR ];

/// IPI_InspectItemDR
Property IPIInspectItemDR As User.DHCEQCInspectItem [ SqlColumnNumber = 4, SqlFieldName = IPI_InspectItemDR ];

/// IPI_Remark
Property IPIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IPI_Remark ];

/// IPI_Hold1
Property IPIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPI_Hold1 ];

/// IPI_Hold2
Property IPIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IPI_Hold2 ];

/// IPI_Hold3
Property IPIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IPI_Hold3 ];

/// IPI_Hold4
Property IPIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IPI_Hold4 ];

/// IPI_Hold5
Property IPIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IPI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInspectPlanItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPI_InspectItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPI_InspectPartDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPI_InspectPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQInspectPlanItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IPI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInspectPlanItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
