Class User.DHCEQInspectItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ISI_RowID, SqlTableName = DHC_EQInspectItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ISI_InspectDR
Property ISIInspectDR As User.DHCEQInspect [ SqlColumnNumber = 2, SqlFieldName = ISI_InspectDR ];

/// ISI_InspectPartDR
Property ISIInspectPartDR As User.DHCEQCPart [ SqlColumnNumber = 3, SqlFieldName = ISI_InspectPartDR ];

/// ISI_InspectItemDR
Property ISIInspectItemDR As User.DHCEQCInspectItem [ SqlColumnNumber = 4, SqlFieldName = ISI_InspectItemDR ];

/// ISI_InspectState
Property ISIInspectState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ISI_InspectState ];

/// ISI_Remark
Property ISIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ISI_Remark ];

/// ISI_Hold1
Property ISIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ISI_Hold1 ];

/// ISI_Hold2
Property ISIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ISI_Hold2 ];

/// ISI_Hold3
Property ISIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ISI_Hold3 ];

/// ISI_Hold4
Property ISIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ISI_Hold4 ];

/// ISI_Hold5
Property ISIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ISI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInspectItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ISI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ISI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ISI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ISI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ISI_InspectDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISI_InspectItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISI_InspectPartDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISI_InspectState">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQInspectItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ISI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInspectItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
