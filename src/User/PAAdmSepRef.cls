/// PA_AdmSepRef(2132)
Class User.PAAdmSepRef Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmSepRef, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SEPREFChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SEPREF",0))}, SqlColumnNumber = 2, SqlFieldName = SEPREF_Childsub ];

/// PA_Adm Parent Reference
Relationship SEPREFParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmSepRef, Required, SqlFieldName = SEPREF_ParRef ];

/// Des Ref SepRef
Property SEPREFSepRefDR As PACSeparationReferral [ SqlColumnNumber = 3, SqlFieldName = SEPREF_SepRef_DR ];

Index RowIDBasedIDKeyIndex On SEPREFChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 9;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmSepRef).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmSepRef","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmSepRef).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmSepRef","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmSepRef).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmSepRef","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmSepRef).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmSepRef","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmSepRef).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmSepRef","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>9</ExtentSize>
<Property name="SEPREFChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SEPREFParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="SEPREFSepRefDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="SEPREF_SepRef_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SEPREF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEPREF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SEPREF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SEPREF_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmSepRefS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
