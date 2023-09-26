Class User.DHCEQMergeOrderList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ML_RowID, SqlTableName = DHC_EQMergeOrderList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ML_MergeOrderDR
Property MLMergeOrderDR As User.DHCEQMergeOrder [ SqlColumnNumber = 2, SqlFieldName = ML_MergeOrderDR ];

/// ML_SourceID
Property MLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ML_SourceID ];

/// ML_RequestNum
Property MLRequestNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ML_RequestNum ];

/// ML_AduitNum
Property MLAduitNum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ML_AduitNum ];

/// ML_AuditedFlag
Property MLAuditedFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ML_AuditedFlag ];

/// ML_Remark
Property MLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ML_Remark ];

/// ML_Hold1
Property MLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ML_Hold1 ];

/// ML_Hold2
Property MLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ML_Hold2 ];

/// ML_Hold3
Property MLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ML_Hold3 ];

/// ML_Hold4
Property MLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ML_Hold4 ];

/// ML_Hold5
Property MLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ML_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMergeOrderList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ML_AduitNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ML_AuditedFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ML_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ML_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ML_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ML_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ML_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ML_MergeOrderDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ML_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ML_RequestNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ML_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQMergeOrderList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ML_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMergeOrderDR">
<Global>^DHCEQMergeOrderList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MergeOrderDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ML_MergeOrderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMergeOrderListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
