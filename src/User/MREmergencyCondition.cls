/// MR Adm Emergency Condition(1157)
Class User.MREmergencyCondition Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_EmergencyCondition, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EMCChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EMC",0))}, SqlColumnNumber = 2, SqlFieldName = EMC_Childsub ];

/// Des Ref to EmergCond
Property EMCEmergCondDR As MRCEmergencyCondition [ SqlColumnNumber = 3, SqlFieldName = EMC_EmergCond_DR ];

/// MR_Adm Parent Reference
Relationship EMCParRef As MRAdm [ Cardinality = parent, Inverse = ChildMREmergencyCondition, Required, SqlFieldName = EMC_ParRef ];

Index RowIDBasedIDKeyIndex On EMCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 131;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MREmergencyCondition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MREmergencyCondition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MREmergencyCondition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MREmergencyCondition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MREmergencyCondition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MREmergencyCondition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MREmergencyCondition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MREmergencyCondition","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MREmergencyCondition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MREmergencyCondition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>131</ExtentSize>
<Property name="EMCChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EMCEmergCondDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="EMCParRef">
<Selectivity>0.8850%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EMC_EmergCond_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EMC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EMC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EMC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EMC_RowId</SqlRowIdName>
<StreamLocation>^User.MREmergencyConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
