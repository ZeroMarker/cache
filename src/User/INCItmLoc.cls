/// INC Item Location       (INCIL,309)
Class User.INCItmLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INCILChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildINStkBal As INStkBal [ Cardinality = children, Inverse = INSBINCILParref ];

Relationship ChildINCItmLcBt As INCItmLcBt [ Cardinality = children, Inverse = INCLBINCILParRef ];

Relationship ChildINCItmLcDailyTotal As INCItmLcDailyTotal [ Cardinality = children, Inverse = DAYParRef ];

/// Des Ref To INCI
Relationship INCILINCIParRef As INCItm [ Cardinality = parent, Inverse = ChildINCItmLoc, Required, SqlFieldName = INCIL_INCI_ParRef ];

/// INCIL Childsub (New Key)
Property INCILChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"IL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INCIL_ChildSub ];

/// Des Ref To CTLOC
Property INCILCTLOCDR As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = INCIL_CTLOC_DR ];

/// Des Ref To INCSB
Property INCILINCSBDR As INCStkBin [ SqlColumnNumber = 5, SqlFieldName = INCIL_INCSB_DR ];

/// Logical Quantity
Property INCILLogQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ InitialExpression = 0, SqlColumnNumber = 7, SqlComputeCode = { i {INCIL_CTLOC_DR}="" s {INCIL_LogQty}="" q
 s {INCIL_LogQty}=0
}, SqlComputed, SqlComputeOnChange = INCILCTLOCDR, SqlFieldName = INCIL_LogQty ];

/// Replenish Level
Property INCILRepLev As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = INCIL_RepLev ];

/// Replenish Quantity
Property INCILRepQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = INCIL_RepQty ];

/// Maximum Quantity (Limit of Storage)
Property INCILMaxQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 13, SqlFieldName = INCIL_MaxQty ];

/// Minimum Quantity
Property INCILMinQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 14, SqlFieldName = INCIL_MinQty ];

/// Des Ref to CTLOC
Property INCILWareHouseDR As CTLoc [ SqlColumnNumber = 15, SqlFieldName = INCIL_WareHouse_DR ];

/// Dirty Quantity
Property INCILDirtyQty As %Float [ SqlColumnNumber = 17, SqlFieldName = INCIL_DirtyQty ];

/// Reserved Qty
Property INCILReservedQty As %Float [ SqlColumnNumber = 18, SqlFieldName = INCIL_ReservedQty ];

/// Available Qty
Property INCILAvailQty As %Float [ SqlColumnNumber = 19, SqlComputeCode = { s {INCIL_AvailQty}={INCIL_LogQty}-{INCIL_ReservedQty}
}, SqlComputed, SqlFieldName = INCIL_AvailQty, Transient ];

/// Ward Stock Replenishment option
Property INCILWardStock As %String(DISPLAYLIST = ",Fixed Replenishment Qty,Replenish up to Replenishment Qty", MAXLEN = 33, TRUNCATE = 1, VALUELIST = ",F,E") [ SqlColumnNumber = 20, SqlFieldName = INCIL_WardStock ];

/// Free Storage Bin
Property INCILFreeStorageBin As %String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = INCIL_FreeStorageBin ];

/// Issue Transfer Flag
Property INCILIsTrfFlag As %String(DISPLAYLIST = ",Issue Only,Transfer Only,Both Iss & Trf", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",I,T,B") [ SqlColumnNumber = 22, SqlFieldName = INCIL_IsTrfFlag ];

/// DateFrom
Property INCILDateFrom As %Date [ SqlColumnNumber = 23, SqlFieldName = INCIL_DateFrom ];

/// DateTo
Property INCILDateTo As %Date [ SqlColumnNumber = 24, SqlFieldName = INCIL_DateTo ];

/// 冻结数量
Property INCILFreezeQty As %Float [ SqlColumnNumber = 25, SqlFieldName = INCIL_FreezeQty ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLoc","OnAfterInsert")
 ;d POFILINS^at309		;此方法内有job命令,会引起加锁错误
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmLoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLoc","OnBeforeDelete")
 &sql(DELETE FROM INC_ItmLcBt WHERE INCLB_INCIL_ParRef=:%d(1))
 &sql(DELETE FROM INC_ItmLcDailyTotal WHERE DAY_ParRef=:%d(1))
 ;d VALDEL^at309({INCIL_RowId})
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmLoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLoc","OnBeforeUpdate")
 d VALUPD^at309
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLoc","OnBeforeInsert")
 d VALINS^at309
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLoc","OnAfterDelete")
 d POFILDEL^at309
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINCIL">
<Data name="INCIL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCIL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCIL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INCIL_DirtyQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCIL_FreeStorageBin">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCIL_FreezeQty">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCIL_INCSB_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCIL_IsTrfFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCIL_LogQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCIL_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCIL_MinQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCIL_RepLev">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCIL_RepQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCIL_ReservedQty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCIL_WardStock">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCIL_WareHouse_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INCIL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCICTLOCDR">
<Condition>{INCIL_CTLOC_DR}'=""</Condition>
<ConditionFields>INCIL_CTLOC_DR</ConditionFields>
<Global>^INCI</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INCIL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IL_LOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INCIL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCIL_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
