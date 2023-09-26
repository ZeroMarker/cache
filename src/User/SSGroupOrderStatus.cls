/// SS Group Order Status(1353)
Class User.SSGroupOrderStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupOrderStatus, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OSTATChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_Group Parent Reference
Relationship OSTATParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupOrderStatus, Required, SqlFieldName = OSTAT_ParRef ];

/// Childsub
Property OSTATChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"OSTAT",0))}, SqlColumnNumber = 2, SqlFieldName = OSTAT_Childsub ];

/// Des Ref OrdStat
Property OSTATOrdStatDR As OECOrderStatus [ SqlColumnNumber = 3, SqlFieldName = OSTAT_OrdStat_DR ];

/// Allow To D/C
Property OSTATAllowToDC As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = OSTAT_AllowToDC ];

/// Allow To DC Paid
Property OSTATAllowToDCPaid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = OSTAT_AllowToDCPaid ];

/// Allow To DC Packed
Property OSTATAllowToDCPacked As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = OSTAT_AllowToDCPacked ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupOrderStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupOrderStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupOrderStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupOrderStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupOrderStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupOrderStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OSTAT_AllowToDC">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OSTAT_AllowToDCPacked">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OSTAT_AllowToDCPaid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OSTAT_OrdStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OSTAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OSTAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSTAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OSTAT_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupOrderStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
