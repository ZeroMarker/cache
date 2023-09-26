/// PA Medical Record(1734)
Class User.PAMedicalRecord Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_MedicalRecord, StorageStrategy = SQLStorage ]
{

/// Childsub
Property MRNChildsub As %Float [ InitialExpression = {$i(^PAPER($p(%d(0),$c(1)),"MRN",0))}, SqlColumnNumber = 2, SqlFieldName = MRN_Childsub ];

/// MRN No
Property MRNNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MRN_No ];

/// PA_PatMas Parent Reference
Relationship MRNParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAMedicalRecord, Required, SqlFieldName = MRN_ParRef ];

/// Des Ref RefHosp
Property MRNRefHospDR As CTRefClin [ SqlColumnNumber = 3, SqlFieldName = MRN_RefHosp_DR ];

Index RowIDBasedIDKeyIndex On MRNChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAMedicalRecord).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMedicalRecord","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAMedicalRecord).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMedicalRecord","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAMedicalRecord).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMedicalRecord","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAMedicalRecord).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMedicalRecord","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAMedicalRecord).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMedicalRecord","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MRN_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRN_RefHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MRN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMRNO">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MRN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExtMRN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({MRN_No})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRN_RefHosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRN_RowId</SqlRowIdName>
<StreamLocation>^User.PAMedicalRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
