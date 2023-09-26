/// Snomed Qualifiers(2769)
Class User.MRSnomedQualifiers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_SnomedQualifiers, StorageStrategy = SQLStorage ]
{

/// Des Ref Snomed Concept
Property SNQConceptDR As PACSnomedConcept [ SqlColumnNumber = 2, SqlFieldName = SNQ_Concept_DR ];

/// Des Ref Relationship
Property SNQRelationshipDR As PACSnomedRelation [ SqlColumnNumber = 3, SqlFieldName = SNQ_Relationship_DR ];

/// Des Ref Qualifier
Property SNQQualifierDR As MRSnomedQualifiers [ SqlColumnNumber = 4, SqlFieldName = SNQ_Qualifier_DR ];

/// Des Ref SubjectFindings
Property SNQSubjectFindingsDR As MRSubjectFindings [ SqlColumnNumber = 5, SqlFieldName = SNQ_SubjectFindings_DR ];

/// Des Ref Diagnos
Property SNQDiagnosDR As MRDiagnos [ SqlColumnNumber = 6, SqlFieldName = SNQ_Diagnos_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRSnomedQualifiers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSnomedQualifiers","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRSnomedQualifiers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSnomedQualifiers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRSnomedQualifiers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSnomedQualifiers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRSnomedQualifiers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSnomedQualifiers","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRSnomedQualifiers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSnomedQualifiers","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSnomedQualifiers","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PA("SNQ",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SNQ_Concept_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNQ_Diagnos_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SNQ_Qualifier_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SNQ_Relationship_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNQ_SubjectFindings_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SNQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SNQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDiagnos">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Diag"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNQ_Diagnos_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubFind">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SubFind"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNQ_SubjectFindings_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNQ_RowId</SqlRowIdName>
<StreamLocation>^User.MRSnomedQualifiersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
