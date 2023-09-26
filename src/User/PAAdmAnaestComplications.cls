/// PA Adm Anaest Complic(1790)
Class User.PAAdmAnaestComplications Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmAnaestComplications, StorageStrategy = SQLStorage ]
{

/// Des REf AnaestComplic_DR
Property ANCAnaestComplicDR As ORCAnaestComplications [ SqlColumnNumber = 3, SqlFieldName = ANC_AnaestComplic_DR ];

/// Childsub
Property ANCChildsub As %Float [ InitialExpression = {$i(^PAADM($p(%d(0),$c(1)),"ANC",0))}, SqlColumnNumber = 2, SqlFieldName = ANC_Childsub ];

/// PA_Adm Parent Reference
Relationship ANCParREf As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmAnaestComplications, Required, SqlFieldName = ANC_ParREf ];

Index RowIDBasedIDKeyIndex On ANCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmAnaestComplications).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmAnaestComplications","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmAnaestComplications).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmAnaestComplications","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmAnaestComplications).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmAnaestComplications","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmAnaestComplications).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmAnaestComplications","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmAnaestComplications).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmAnaestComplications","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANC_AnaestComplic_DR">
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
<Field>ANC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ANC_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmAnaestComplicationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
