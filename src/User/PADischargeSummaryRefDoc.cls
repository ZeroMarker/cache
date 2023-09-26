/// DischargeSummaryRefDoc(2542)
Class User.PADischargeSummaryRefDoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_DischargeSummaryRefDoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REFChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_DischargeSummary Parent Reference
Relationship REFParRef As PADischargeSummary [ Cardinality = parent, Inverse = ChildPADischargeSummaryRefDoc, Required, SqlFieldName = REF_ParRef ];

/// Childsub
Property REFChildsub As %Float [ InitialExpression = {$i(^PA("DISSUM",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REF",0))}, SqlColumnNumber = 2, SqlFieldName = REF_Childsub ];

/// Des Ref RefDoc
Property REFRefDocDR As PACRefDoctor [ SqlColumnNumber = 3, SqlFieldName = REF_RefDoc_DR ];

/// Des Ref RefDocClinic
Property REFRefDocClinicDR As PACRefDoctorClinic [ SqlColumnNumber = 4, SqlFieldName = REF_RefDocClinic_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADischargeSummaryRefDoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryRefDoc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADischargeSummaryRefDoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryRefDoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADischargeSummaryRefDoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryRefDoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADischargeSummaryRefDoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryRefDoc","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADischargeSummaryRefDoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryRefDoc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="REF_RefDocClinic_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REF_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>REF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REF_RowId</SqlRowIdName>
<StreamLocation>^User.PADischargeSummaryRefDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
