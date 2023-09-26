Class User.DHCEQPlanExecuteList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PEL_RowID, SqlTableName = DHC_EQPlanExecuteList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property PELPlanExecuteDR As User.DHCEQPlanExecute [ SqlColumnNumber = 2, SqlFieldName = PEL_PlanExecuteDR ];

Property PELEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = PEL_EquipDR ];

Property PELMaintDR As User.DHCEQMaint [ SqlColumnNumber = 4, SqlFieldName = PEL_MaintDR ];

Property PELExecuteFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PEL_ExecuteFlag ];

Property PELExecuteResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PEL_ExecuteResult ];

Property PELRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PEL_Remark ];

Property PELHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PEL_Hold1 ];

Property PELHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PEL_Hold2 ];

Property PELHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PEL_Hold3 ];

Property PELHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PEL_Hold4 ];

Property PELHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PEL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPlanExecuteList(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PEL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PEL_ExecuteFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PEL_ExecuteResult">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PEL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PEL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PEL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PEL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PEL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PEL_MaintDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PEL_PlanExecuteDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PEL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQPlanExecuteList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PEL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PEL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPlanExecute">
<Global>^DHCEQPlanExecuteList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PEL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlanExecute"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PEL_PlanExecuteDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PEL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexMaint">
<Global>^DHCEQPlanExecuteList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PEL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Maint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PEL_MaintDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PEL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPlanExecuteListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
