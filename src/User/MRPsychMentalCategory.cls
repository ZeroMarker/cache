/// PsychMentalCategory(2636)
Class User.MRPsychMentalCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PsychMentalCategory, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MCChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_PsychDetails Parent Reference
Relationship MCParRef As MRPsychDetails [ Cardinality = parent, Inverse = ChildMRPsychMentalCategory, Required, SqlFieldName = MC_ParRef ];

/// Childsub
Property MCChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PSYCH",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"MC",0))}, SqlColumnNumber = 2, SqlFieldName = MC_Childsub ];

/// DateFrom
Property MCDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = MC_DateFrom ];

/// TimeFrom
Property MCTimeFrom As %Time [ SqlColumnNumber = 4, SqlFieldName = MC_TimeFrom ];

/// DateTo
Property MCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = MC_DateTo ];

/// Des Ref MentalCateg
Property MCMentalCategDR As PACMentalCategory [ SqlColumnNumber = 6, SqlFieldName = MC_MentalCateg_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPsychMentalCategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychMentalCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPsychMentalCategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychMentalCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPsychMentalCategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychMentalCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPsychMentalCategory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychMentalCategory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPsychMentalCategory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychMentalCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="MC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MC_MentalCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MC_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Field>MC_Childsub</Field>
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
<Expression>"MC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MC_Childsub}</Expression>
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
<Field>MC_Childsub</Field>
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
<Expression>"MC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MC_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{MC_TimeFrom}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{MC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MC_RowId</SqlRowIdName>
<StreamLocation>^User.MRPsychMentalCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
