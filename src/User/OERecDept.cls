/// OE Receive Department   (OEREC,574)
Class User.OERecDept Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_RecDept, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTLOC
Property OERECCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = OEREC_CTLOC_DR ];

/// OEORC Child Sub (New key)
Property OERECChildsub As %Float [ InitialExpression = {$$DEF02^at574($s($d(initvalue):initvalue,1:%d(0)))}, Required, SqlColumnNumber = 2, SqlFieldName = OEREC_Childsub ];

/// Match Field
Property OERECMatch As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlComputeCode = { i $G(XFUNC("MATCH","OEREC"))="" s {OEREC_Match}="" q
 s {OEREC_Match}=$$CO04^at574a({OEREC_RowId})
}, SqlComputed, SqlFieldName = OEREC_Match, Transient ];

/// Des Ref to OEORD
Relationship OERECOEORDParRef As OEOrder [ Cardinality = parent, Inverse = ChildOERecDept, Required, SqlFieldName = OEREC_OEORD_ParRef ];

Index RowIDBasedIDKeyIndex On OERECChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OERecDept).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OERecDept","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OERecDept).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OERecDept","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OERecDept).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OERecDept","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OERecDept).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OERecDept","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OERecDept).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OERecDept","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterOEREC">
<Data name="OEREC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OEREC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEREC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEREC_RowId</SqlRowIdName>
<StreamLocation>^User.OERecDeptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
