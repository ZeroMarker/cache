/// IN Stock Balance         (INSB,319)
Class User.INStkBal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_StkBal, StorageStrategy = SQLStorage ]
{

/// INSB ChildSub (New Key)
Property INSBChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"IL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SB",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INSB_ChildSub ];

/// Des Ref To INCIL
Relationship INSBINCILParref As INCItmLoc [ Cardinality = parent, Inverse = ChildINStkBal, Required, SqlFieldName = INSB_INCIL_Parref ];

/// Opening Balance Quantity
Property INSBOpeningQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 7, SqlFieldName = INSB_OpeningQty ];

/// Opening Balance Value
Property INSBOpeningVal As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 8, SqlFieldName = INSB_OpeningVal ];

/// Financial Period
Property INSBPeriod As %Float(MAXVAL = 12, MINVAL = 1) [ SqlColumnNumber = 6, SqlFieldName = INSB_Period ];

/// Financial Year
Property INSBYr As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = INSB_Yr ];

Index RowIDBasedIDKeyIndex On INSBChildSub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INStkBal).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkBal","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INStkBal).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkBal","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INStkBal).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkBal","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INStkBal).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkBal","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INStkBal).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkBal","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINSB">
<Data name="INSB_OpeningQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSB_OpeningVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSB_Period">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSB_Yr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INC_ItmLoc.INCIL_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSB_ChildSub</Field>
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
<Expression>{INC_ItmLoc.INCIL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"SB"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INSB_RowId</SqlRowIdName>
<StreamLocation>^User.INStkBalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
