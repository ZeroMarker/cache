/// InPatAdmTypeSNAPCare(2488)
Class User.PACInPatAdmTypeSNAPCare Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_InPatAdmTypeSNAPCare, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SNAPChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_InPatAdmissionType Parent Reference
Relationship SNAPParRef As PACInPatAdmissionType [ Cardinality = parent, Inverse = ChildPACInPatAdmTypeSNAPCare, Required, SqlFieldName = SNAP_ParRef ];

/// Childsub
Property SNAPChildsub As %Float [ InitialExpression = {$i(^PAC("IPAT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SNAP",0))}, SqlColumnNumber = 2, SqlFieldName = SNAP_Childsub ];

/// Des Ref SNAPCareType
Property SNAPSNAPCareTypeDR As PACSNAPCareType [ SqlColumnNumber = 3, SqlFieldName = SNAP_SNAPCareType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmTypeSNAPCare).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypeSNAPCare","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmTypeSNAPCare).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypeSNAPCare","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmTypeSNAPCare).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypeSNAPCare","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACInPatAdmTypeSNAPCare).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypeSNAPCare","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACInPatAdmTypeSNAPCare).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmTypeSNAPCare","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SNAP_SNAPCareType_DR">
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
<Field>SNAP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_InPatAdmissionType.IPAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SNAP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNAP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_InPatAdmissionType.IPAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SNAP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_InPatAdmissionType.IPAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SNAP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SNAPCT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNAP_SNAPCareType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SNAP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNAP_RowId</SqlRowIdName>
<StreamLocation>^User.PACInPatAdmTypeSNAPCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
