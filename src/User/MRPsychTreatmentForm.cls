/// PsychTreatmentForm(2635)
Class User.MRPsychTreatmentForm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PsychTreatmentForm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TFChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_PsychDetails Parent Reference
Relationship TFParRef As MRPsychDetails [ Cardinality = parent, Inverse = ChildMRPsychTreatmentForm, Required, SqlFieldName = TF_ParRef ];

/// Childsub
Property TFChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PSYCH",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"TF",0))}, SqlColumnNumber = 2, SqlFieldName = TF_Childsub ];

/// DateFrom
Property TFDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = TF_DateFrom ];

/// TimeFrom
Property TFTimeFrom As %Time [ SqlColumnNumber = 4, SqlFieldName = TF_TimeFrom ];

/// DateTo
Property TFDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = TF_DateTo ];

/// SecondOpinion
Property TFSecondOpinion As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = TF_SecondOpinion ];

/// Consent
Property TFConsent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TF_Consent ];

/// ConsentObtained
Property TFConsentObtained As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TF_ConsentObtained ];

/// Des Ref TreatForm
Property TFTreatFormDR As PACTreatmentForm [ SqlColumnNumber = 9, SqlFieldName = TF_TreatForm_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPsychTreatmentForm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTreatmentForm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPsychTreatmentForm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTreatmentForm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPsychTreatmentForm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTreatmentForm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPsychTreatmentForm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTreatmentForm","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPsychTreatmentForm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTreatmentForm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="TF_Consent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TF_ConsentObtained">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TF_SecondOpinion">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TF_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TF_TreatForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>TF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TF"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>TF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TF"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TF_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{TF_TimeFrom}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{TF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TF_RowId</SqlRowIdName>
<StreamLocation>^User.MRPsychTreatmentFormS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
