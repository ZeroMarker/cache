/// ARC Bill Sub desc(1855)
Class User.ARCBillSubDesc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_BillSubDesc, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DESChildsub As %Float [ InitialExpression = {$i(^ARCBG($p(%d(0),"||"),"SG",$p(%d(0),"||",2),"DES",0))}, SqlColumnNumber = 2, SqlFieldName = DES_Childsub ];

/// Description
Property DESDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DES_Desc ];

/// Des Ref InsType
Property DESInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = DES_InsType_DR ];

/// ARC_BillSub Parent Reference
Relationship DESParRef As ARCBillSub [ Cardinality = parent, Inverse = ChildARCBillSubDesc, Required, SqlFieldName = DES_ParRef ];

Index RowIDBasedIDKeyIndex On DESChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillSubDesc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubDesc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillSubDesc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubDesc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillSubDesc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubDesc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillSubDesc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubDesc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillSubDesc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillSubDesc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DES_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DES_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCBG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_BillSub.ARCSG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_BillSub.ARCSG_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARCBG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_BillGrp.ARCBG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_BillSub.ARCSG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_BillSub.ARCSG_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DES_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DES_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillSubDescS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
