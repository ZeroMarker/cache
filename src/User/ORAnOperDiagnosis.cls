/// OR Ana Oper Diagnosis(1562)
Class User.ORAnOperDiagnosis Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_Diagnosis, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DIAChildsub As %Float [ InitialExpression = {$i(^OR($p(%d(0),"||"),"ANA",$p(%d(0),"||",2),"OP",$p(%d(0),"||",3),"DIA",0))}, SqlColumnNumber = 2, SqlFieldName = DIA_Childsub ];

/// Des Ref ICD
Property DIAICDDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = DIA_ICD_DR ];

/// OR_Anaest_Operation Parent Reference
Relationship DIAParREf As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperDiagnosis, Required, SqlFieldName = DIA_ParREf ];

Index RowIDBasedIDKeyIndex On DIAChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnOperDiagnosis).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperDiagnosis","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnOperDiagnosis).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperDiagnosis","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnOperDiagnosis).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperDiagnosis","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnOperDiagnosis).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperDiagnosis","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnOperDiagnosis).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORAnOperDiagnosis","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="DIAChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DIAICDDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DIAParREf">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DIA_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>DIA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DIA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DIA_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
