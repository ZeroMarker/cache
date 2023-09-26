Class User.DHCEQPlanExecute Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PE_RowID, SqlTableName = DHC_EQPlanExecute, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property PEPlanExecuteNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PE_PlanExecuteNo ];

Property PEMaintPlanDR As User.DHCEQMaintPlan [ SqlColumnNumber = 3, SqlFieldName = PE_MaintPlanDR ];

Property PEExecuteLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PE_ExecuteLocDR ];

Property PETotalNum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PE_TotalNum ];

Property PEExecutedNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PE_ExecutedNum ];

Property PEStatus As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PE_Status ];

Property PEBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PE_BeginDate ];

Property PEBeginTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PE_BeginTime ];

Property PEBeginUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PE_BeginUserDR ];

Property PERemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PE_Remark ];

Property PEHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PE_Hold1 ];

Property PEHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PE_Hold2 ];

Property PEHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PE_Hold3 ];

Property PEHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PE_Hold4 ];

Property PEHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PE_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPlanExecute(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PE_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PE_BeginTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PE_BeginUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PE_ExecuteLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PE_ExecutedNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PE_MaintPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PE_PlanExecuteNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PE_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PE_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PE_TotalNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQPlanExecute</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExecuteNo">
<Global>^DHCEQPlanExecute</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlanExecuteNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PE_PlanExecuteNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMaintPlan">
<Global>^DHCEQPlanExecute</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MaintPlan"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PE_MaintPlanDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPlanExecuteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
