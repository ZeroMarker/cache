Class User.DHCEQCostAllotList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CAL_RowID, SqlTableName = DHC_EQCostAllotList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CAL_CostAllotDR
Property CALCostAllotDR As User.DHCEQCostAllot [ SqlColumnNumber = 2, SqlFieldName = CAL_CostAllotDR ];

/// CAL_AllotLocDR
Property CALAllotLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CAL_AllotLocDR ];

/// CAL_AllotPercentNum
Property CALAllotPercentNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CAL_AllotPercentNum ];

/// CAL_Remark
Property CALRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CAL_Remark ];

/// CAL_WorkLoadNum
Property CALWorkLoadNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = CAL_WorkLoadNum ];

/// CAL_Hold1
Property CALHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CAL_Hold1 ];

/// CAL_Hold2
Property CALHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CAL_Hold2 ];

/// CAL_Hold3
Property CALHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CAL_Hold3 ];

/// CAL_Hold4
Property CALHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CAL_Hold4 ];

/// CAL_Hold5
Property CALHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CAL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCostAllotList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CAL_AllotLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CAL_AllotPercentNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CAL_CostAllotDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CAL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CAL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CAL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CAL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CAL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CAL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CAL_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCostAllotList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CAL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCostAllot">
<Global>^DHCEQCostAllotList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CostAllotDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CAL_CostAllotDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQCostAllotList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AllotLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CAL_CostAllotDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CAL_AllotLocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCostAllotListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
