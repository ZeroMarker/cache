/// ARC Ins Type Descr(1853)
Class User.ARCInsTypeDescr Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_InsTypeDescr, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property DESARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = DES_ARCIM_DR ];

/// Des Ref BillGrp
Property DESBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = DES_BillGrp_DR ];

/// Des Ref BillSub
Property DESBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = DES_BillSub_DR ];

/// Childsub
Property DESChildsub As %Float [ InitialExpression = {$i(^ARC("INST",$p(%d(0),$c(1)),"DES",0))}, SqlColumnNumber = 2, SqlFieldName = DES_Childsub ];

/// Description
Property DESDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DES_Desc ];

/// ARC_InsuranceType Parent Reference
Relationship DESParRef As ARCInsuranceType [ Cardinality = parent, Inverse = ChildARCInsTypeDescr, Required, SqlFieldName = DES_ParRef ];

Index RowIDBasedIDKeyIndex On DESChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsTypeDescr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsTypeDescr","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsTypeDescr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsTypeDescr","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsTypeDescr).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsTypeDescr","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsTypeDescr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsTypeDescr","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsTypeDescr).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsTypeDescr","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DES_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DES_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DES_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DES_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_InsuranceType.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_InsuranceType.INST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_InsuranceType.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_InsuranceType.INST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DES_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Condition>'{DES_BillSub_DR}</Condition>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_InsuranceType.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_InsuranceType.INST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DES_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillSub">
<Condition>'{DES_ARCIM_DR}</Condition>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_InsuranceType.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_InsuranceType.INST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillSub"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DES_BillSub_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DES_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsTypeDescrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
