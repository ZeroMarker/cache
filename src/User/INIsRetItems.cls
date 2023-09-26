/// IN Issue Return Items(1785)
Class User.INIsRetItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_IsRetItems, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INIRIChildsub As %Float [ InitialExpression = {$i(^INIR($p(%d(0),$c(1)),"IRI",0))}, SqlColumnNumber = 2, SqlFieldName = INIRI_Childsub ];

/// Des Ref IsItm
Property INIRIIsItmDR As INIsTrfItm [ SqlColumnNumber = 3, SqlFieldName = INIRI_IsItm_DR ];

/// IN_IsRet Parent Reference
Relationship INIRIParRef As INIsRet [ Cardinality = parent, Inverse = ChildINIsRetItems, Required, SqlFieldName = INIRI_ParRef ];

/// Qty
Property INIRIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = INIRI_Qty ];

Index RowIDBasedIDKeyIndex On INIRIChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INIsRetItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsRetItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INIsRetItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsRetItems","OnAfterInsert")
 d POFILINS^at1785
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INIsRetItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsRetItems","OnAfterUpdate")
 d POFILUPD^at1785
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INIsRetItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsRetItems","OnBeforeInsert")
 d PREFDEL^at1785
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INIsRetItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INIsRetItems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INIRI_IsItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INIRI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^INIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_IsRet.INIR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INIRI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_IsRet.INIR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IRI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIRI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INIRI_RowId</SqlRowIdName>
<StreamLocation>^User.INIsRetItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
