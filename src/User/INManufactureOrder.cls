/// IN Manufacture Order(1088)
Class User.INManufactureOrder Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Manufacture_Order, StorageStrategy = SQLStorage ]
{

Relationship ChildINManufactureOrderBatch As INManufactureOrderBatch [ Cardinality = children, Inverse = MOBATParRef ];

Relationship ChildINManufactureOrderINCI As INManufactureOrderINCI [ Cardinality = children, Inverse = INCIParRef ];

/// Order No
Property INMANNo As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ InitialExpression = "NEW", Required, SqlColumnNumber = 2, SqlFieldName = INMAN_No ];

/// Date of Order
Property INMANDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = INMAN_Date ];

/// Des Ref to INCI
Property INMANINCIDR As INCItm [ Required, SqlColumnNumber = 4, SqlFieldName = INMAN_INCI_DR ];

/// Des Ref to CTUOM
Property INMANUOMDR As CTUOM [ Required, SqlColumnNumber = 5, SqlFieldName = INMAN_UOM_DR ];

/// Quantity to Manufacture
Property INMANQty As %Float(MINVAL = .001) [ Required, SqlColumnNumber = 6, SqlFieldName = INMAN_Qty ];

/// Start Date
Property INMANStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = INMAN_Start_Date ];

/// Start_Time
Property INMANStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = INMAN_Start_Time ];

/// Status (Completed/Aborted)
Property INMANStatus As %String(DISPLAYLIST = ",Completed,Aborted", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",C,A") [ SqlColumnNumber = 9, SqlFieldName = INMAN_Status ];

/// Remarks
Property INMANRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INMAN_Remarks, SqlListType = subnode ];

/// End Date of Manufacture
Property INMANEndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = INMAN_End_Date ];

/// End Time
Property INMANEndTime As %Time [ SqlColumnNumber = 12, SqlFieldName = INMAN_End_Time ];

/// Full Status
Property INMANFullStatus As %String(DISPLAYLIST = ",Pending,In Progress,Completed,Aborted", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",P,I,C,A") [ SqlColumnNumber = 13, SqlFieldName = INMAN_Full_Status, Transient ];

/// Expire Date
Property INMANExpireDate As %Date [ SqlColumnNumber = 14, SqlFieldName = INMAN_Expire_Date ];

/// Batch No
Property INMANBatchNo As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = INMAN_Batch_No ];

/// Des Ref to CTLOC
Property INMANCTLOCDR As CTLoc [ Required, SqlColumnNumber = 16, SqlFieldName = INMAN_CTLOC_DR ];

/// Des Ref to INCLB
Property INMANINCLBDR As INCItmLcBt [ SqlColumnNumber = 17, SqlFieldName = INMAN_INCLB_DR ];

/// Amount of Drug Manufactured
Property INMANAmount As %Float [ SqlColumnNumber = 18, SqlFieldName = INMAN_Amount ];

/// Des Ref to SSU
Property INMANUserDR As SSUser [ Required, SqlColumnNumber = 19, SqlFieldName = INMAN_User_DR ];

/// Flag Sterile
Property INMANSterile As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = INMAN_Sterile ];

/// User Completed
Property INMANUserCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INMAN_UserCompleted ];

/// RecNumber
Property INMANRecNumber As %Float [ SqlColumnNumber = 22, SqlFieldName = INMAN_RecNumber ];

/// Des Ref OrigRcp
Property INMANOrigRcpDR As INCItmRcp [ SqlColumnNumber = 23, SqlFieldName = INMAN_OrigRcp_DR ];

/// CancelReason
Property INMANCancelReason As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = INMAN_CancelReason ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INManufactureOrder).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrder","OnAfterInsert")
 d POFILINS^MVBSTMO
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INManufactureOrder).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrder","OnAfterUpdate")
 d POFILUPD^MVBSTMO
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INManufactureOrder).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrder","OnBeforeDelete")
 d PREFDEL^MVBSTMO
 d VALDEL^at1088
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INManufactureOrder).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrder","OnBeforeUpdate")
 d VALUPD^at1088
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrder","OnBeforeInsert")
 d VALINS^at1088
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INManufactureOrder).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INManufactureOrder","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INMAN(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INMAN_Amount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INMAN_Batch_No">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INMAN_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INMAN_CancelReason">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INMAN_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INMAN_End_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INMAN_End_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INMAN_Expire_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INMAN_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INMAN_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INMAN_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INMAN_OrigRcp_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INMAN_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INMAN_RecNumber">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INMAN_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INMAN_Start_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INMAN_Start_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INMAN_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INMAN_Sterile">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INMAN_UOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INMAN_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INMAN_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^INMAN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INMAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INMAN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INMAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^INMAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^INMAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^INMAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^INMAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INMAN_RowId</SqlRowIdName>
<StreamLocation>^User.INManufactureOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
