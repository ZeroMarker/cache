/// IN Manufacture Request(1087)
Class User.INManufRequest Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Manuf_Request, StorageStrategy = SQLStorage ]
{

/// Approved
Property INMRQApproved As %String(DISPLAYLIST = ",Pending,Approved,Rejected", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",P,A,R") [ InitialExpression = "Pending", Required, SqlColumnNumber = 10, SqlFieldName = INMRQ_Approved ];

/// Des REf to CTCP (req.Doctor)
Property INMRQCTCPDR As CTCareProv [ Required, SqlColumnNumber = 4, SqlFieldName = INMRQ_CTCP_DR ];

/// Date of Request
Property INMRQDate As %Date [ InitialExpression = "T", Required, SqlColumnNumber = 3, SqlFieldName = INMRQ_Date ];

/// Date of Approval
Property INMRQDateApproved As %Date [ SqlColumnNumber = 9, SqlFieldName = INMRQ_Date_Approved ];

/// Date Created
Property INMRQDateCreated As %Date [ InitialExpression = "T", Required, SqlColumnNumber = 12, SqlFieldName = INMRQ_Date_Created ];

/// Des Ref to INCI
Property INMRQINCIDR As INCItm [ SqlColumnNumber = 5, SqlFieldName = INMRQ_INCI_DR ];

/// Ingredients
Property INMRQIngredients As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = INMRQ_Ingredients, SqlListType = SUBNODE ];

/// Man. Request No
Property INMRQNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ InitialExpression = "New", Required, SqlColumnNumber = 2, SqlFieldName = INMRQ_No ];

/// Reason for Request
Property INMRQReason As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = INMRQ_Reason, SqlListType = SUBNODE ];

/// Remarks
Property INMRQRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = INMRQ_Remarks, SqlListType = SUBNODE ];

/// Stock Code
Property INMRQStockCode As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = INMRQ_StockCode ];

/// Time Created
Property INMRQTimeCreated As %Time [ InitialExpression = "N", Required, SqlColumnNumber = 13, SqlFieldName = INMRQ_Time_Created ];

/// Des Ref to SSU
Property INMRQUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",1))}, SqlColumnNumber = 11, SqlFieldName = INMRQ_User_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INManufRequest).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufRequest","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INManufRequest).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufRequest","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INManufRequest).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufRequest","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INManufRequest).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufRequest","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INManufRequest).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INManufRequest","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INMRQ(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INMRQ_Approved">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INMRQ_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INMRQ_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INMRQ_Date_Approved">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INMRQ_Date_Created">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INMRQ_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INMRQ_Ingredients">
<Node>"ING"</Node>
</Data>
<Data name="INMRQ_No">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INMRQ_Reason">
<Node>"REA"</Node>
</Data>
<Data name="INMRQ_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INMRQ_StockCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INMRQ_Time_Created">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INMRQ_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^INMRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INMRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INMRQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INMRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMRQ_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINMRQNo">
<Global>^INMRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMRQ_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INMRQ_RowId</SqlRowIdName>
<StreamLocation>^User.INManufRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
