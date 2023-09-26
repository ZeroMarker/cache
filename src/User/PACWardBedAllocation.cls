/// PAC Ward Bed Allocation(1349)
Class User.PACWardBedAllocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WardBedAllocation, StorageStrategy = SQLStorage ]
{

/// Des Ref AllocReason
Property WBALLAllocReasonDR As PACAllocationReason [ SqlColumnNumber = 6, SqlFieldName = WBALL_AllocReason_DR ];

/// Number of Beds
Property WBALLBeds As %Float [ Required, SqlColumnNumber = 5, SqlFieldName = WBALL_Beds ];

/// Des Ref CTLOC
Property WBALLCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = WBALL_CTLOC_DR ];

/// Childsub
Property WBALLChildsub As %Float [ InitialExpression = {$i(^PAWARD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"WBALL",0))}, SqlColumnNumber = 2, SqlFieldName = WBALL_Childsub ];

/// Date
Property WBALLDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = WBALL_Date ];

/// DateTo
Property WBALLDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = WBALL_DateTo ];

/// PAC_Ward Parent Reference
Relationship WBALLParRef As PACWard [ Cardinality = parent, Inverse = ChildPACWardBedAllocation, Required, SqlFieldName = WBALL_ParRef ];

Index RowIDBasedIDKeyIndex On WBALLChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 45;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWardBedAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardBedAllocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWardBedAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardBedAllocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWardBedAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardBedAllocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWardBedAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardBedAllocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWardBedAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardBedAllocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>45</ExtentSize>
<Property name="WBALLAllocReasonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WBALLBeds">
<Selectivity>1</Selectivity>
</Property>
<Property name="WBALLCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WBALLChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="WBALLDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="WBALLDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="WBALLParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="WBALL_AllocReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WBALL_Beds">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WBALL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WBALL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WBALL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WBALL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WBALL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WBALL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOCDR">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>WBALL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WBALL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WBALL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WBALL_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WBALL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WBALL_RowId</SqlRowIdName>
<StreamLocation>^User.PACWardBedAllocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
