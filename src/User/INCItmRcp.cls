/// INC Item Manuf Recep(1061)
Class User.INCItmRcp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmRcp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INRECChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildINCItmRecIngr As INCItmRecIngr [ Cardinality = children, Inverse = INRINParRef ];

/// INC_Itm Parent Reference
Relationship INRECParRef As INCItm [ Cardinality = parent, Inverse = ChildINCItmRcp, Required, SqlFieldName = INREC_ParRef ];

/// Childsub
Property INRECChildsub As %Float [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REC",0))}, SqlColumnNumber = 2, SqlFieldName = INREC_Childsub ];

/// Des Ref to CTUOM
Property INRECCTUOMDR As CTUOM [ Required, SqlColumnNumber = 3, SqlFieldName = INREC_CTUOM_DR ];

/// Qty Manufactured
Property INRECQtyManuf As %Float(MINVAL = .001) [ Required, SqlColumnNumber = 4, SqlFieldName = INREC_Qty_Manuf ];

/// Quarantine Time
Property INRECQuarTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INREC_Quar_Time ];

/// Remarks
Property INRECRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = INREC_Remarks, SqlListType = SUBNODE ];

/// Date Created
Property INRECDateCreated As %Date [ SqlColumnNumber = 7, SqlFieldName = INREC_Date_Created ];

/// Date Updated
Property INRECDateUpdated As %Date [ SqlColumnNumber = 8, SqlFieldName = INREC_Date_Updated ];

/// Time Created
Property INRECTimeCreated As %Time [ SqlColumnNumber = 9, SqlFieldName = INREC_Time_Created ];

/// Time Updated
Property INRECTimeUpdated As %Time [ SqlColumnNumber = 10, SqlFieldName = INREC_Time_Updated ];

/// User Creat Des Ref to SSU
Property INRECUserCreatDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = INREC_UserCreat_DR ];

/// User Updated Des Ref to SSU
Property INRECUserUpdatedDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = INREC_User_Updated_DR ];

/// Manufacturing Time
Property INRECManufTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INREC_Manuf_Time ];

/// Sterile Set
Property INRECSterile As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INREC_Sterile ];

/// Description
Property INRECDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = INREC_Desc ];

/// Modify
Property INRECModify As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INREC_Modify ];

/// Manufacture Instruction
Property INRECManufInstruction As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 17, SqlFieldName = INREC_ManufInstruction, SqlListType = SUBNODE ];

/// Expdate有效月数
Property INRECExpDateMonth As %Float [ SqlColumnNumber = 18, SqlFieldName = INREC_ExpDateMonth ];

/// 附加费用
Property INRECAddCost As %Float [ SqlColumnNumber = 19, SqlFieldName = INREC_AddCost ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmRcp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmRcp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmRcp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmRcp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmRcp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmRcp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmRcp).getOld($g(%d(1)))
 d VALDEL^at1061
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmRcp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d VALINS^at1061
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmRcp).getOld($g(%d(1)))
 d VALUPD^at1061
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmRcp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INREC_AddCost">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INREC_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INREC_Date_Created">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INREC_Date_Updated">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INREC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INREC_ExpDateMonth">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INREC_ManufInstruction">
<Node>"INSTR"</Node>
</Data>
<Data name="INREC_Manuf_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INREC_Modify">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INREC_Qty_Manuf">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INREC_Quar_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INREC_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INREC_Sterile">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INREC_Time_Created">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INREC_Time_Updated">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INREC_UserCreat_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INREC_User_Updated_DR">
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
<Field>INREC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INREC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INREC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INREC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INREC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INREC_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmRcpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
