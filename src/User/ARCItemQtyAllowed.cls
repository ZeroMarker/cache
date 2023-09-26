/// ARCIM Qty Allowed(1119)
Class User.ARCItemQtyAllowed Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemQtyAllowed, StorageStrategy = SQLStorage ]
{

/// Des Ref to ARCQtyAll
Property QTYALARCQtyAllDR As ARCQtyAllowed [ Required, SqlColumnNumber = 5, SqlFieldName = QTYAL_ARCQtyAll_DR ];

/// Childsub
Property QTYALChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"QTYAL",0))}, SqlColumnNumber = 2, SqlFieldName = QTYAL_Childsub ];

/// Eff. Date From
Property QTYALDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = QTYAL_DateFrom ];

/// Eff. Date To
Property QTYALDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = QTYAL_DateTo ];

/// Des Ref to ARCInsType
Property QTYALInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 6, SqlFieldName = QTYAL_InsType_DR ];

/// ARC_ItmMast Parent Reference
Relationship QTYALParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemQtyAllowed, Required, SqlFieldName = QTYAL_ParRef ];

Index RowIDBasedIDKeyIndex On QTYALChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemQtyAllowed).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemQtyAllowed","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemQtyAllowed).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemQtyAllowed","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemQtyAllowed).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemQtyAllowed","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemQtyAllowed).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemQtyAllowed","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemQtyAllowed).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemQtyAllowed","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QTYAL_ARCQtyAll_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QTYAL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTYAL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QTYAL_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>QTYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"QTYAL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QTYAL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>QTYAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"QTYAL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QTYAL_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QTYAL_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{QTYAL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QTYAL_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemQtyAllowedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
