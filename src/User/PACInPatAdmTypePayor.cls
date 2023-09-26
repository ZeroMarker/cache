/// InPatAdmTypePayor(2420)
Class User.PACInPatAdmTypePayor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_InPatAdmTypePayor, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property INSAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 4, SqlFieldName = INS_AuxInsType_DR ];

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^PAC("IPAT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Des Ref InsType
Property INSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = INS_InsType_DR ];

/// PAC_InPatAdmissionType Parent Reference
Relationship INSParRef As PACInPatAdmissionType [ Cardinality = parent, Inverse = ChildPACInPatAdmTypePayor, Required, SqlFieldName = INS_ParRef ];

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmTypePayor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypePayor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmTypePayor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypePayor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmTypePayor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypePayor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACInPatAdmTypePayor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypePayor","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACInPatAdmTypePayor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypePayor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_InPatAdmissionType.IPAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_InPatAdmissionType.IPAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPayor">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_InPatAdmissionType.IPAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_InPatAdmissionType.IPAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Payor"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlan">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_InPatAdmissionType.IPAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_InPatAdmissionType.IPAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Plan"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.PACInPatAdmTypePayorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
