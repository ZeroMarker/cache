/// ARC Bill Grp Desc(1854)
Class User.ARCBillGrpDesc Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_BillGrpDesc, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DESChildsub As %Float [ InitialExpression = {$i(^ARCBG($p(%d(0),$c(1)),"DES",0))}, SqlColumnNumber = 2, SqlFieldName = DES_Childsub ];

/// Description
Property DESDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DES_Desc ];

/// Des Ref InsType
Property DESInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = DES_InsType_DR ];

/// ARC_BillGrp Parent Reference
Relationship DESParRef As ARCBillGrp [ Cardinality = parent, Inverse = ChildARCBillGrpDesc, Required, SqlFieldName = DES_ParRef ];

Index RowIDBasedIDKeyIndex On DESChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillGrpDesc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillGrpDesc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillGrpDesc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillGrpDesc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillGrpDesc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillGrpDesc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillGrpDesc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillGrpDesc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillGrpDesc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCBillGrpDesc","OnBeforeUpdate")
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
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="3">
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
<Expression>{L6}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_BillGrp.ARCBG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DES_InsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DES_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillGrpDescS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
