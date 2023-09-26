/// PA Mother Prenatal Problems(1323)
Class User.PAMotherPrenProblem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_MotherPrenProblem, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PREPChildsub As %Float [ InitialExpression = {$i(^PAMTH($p(%d(0),$c(1)),"PREP",0))}, SqlColumnNumber = 2, SqlFieldName = PREP_Childsub ];

/// PA_Mother Parent Reference
Relationship PREPParRef As PAMother [ Cardinality = parent, Inverse = ChildPAMotherPrenProblem, Required, SqlFieldName = PREP_ParRef ];

/// Des Ref to PrenProbl
Property PREPPrenProblDR As PACPrenatalProblems [ SqlColumnNumber = 3, SqlFieldName = PREP_PrenProbl_DR ];

Index RowIDBasedIDKeyIndex On PREPChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAMotherPrenProblem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMotherPrenProblem","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAMotherPrenProblem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMotherPrenProblem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAMotherPrenProblem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMotherPrenProblem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAMotherPrenProblem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMotherPrenProblem","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAMotherPrenProblem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMotherPrenProblem","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PREP_PrenProbl_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAMTH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Mother.MOTH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PREP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Mother.MOTH_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PREP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PREP_RowId</SqlRowIdName>
<StreamLocation>^User.PAMotherPrenProblemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
