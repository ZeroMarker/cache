/// PAC Snomed Concept(1939)
Class User.PACSnomedConcept Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SnomedConcept, StorageStrategy = SQLStorage ]
{

Relationship ChildPACSnomedConceptKeywords As PACSnomedConceptKeywords [ Cardinality = children, Inverse = KEYWParRef ];

/// ConceptID
Property SNOCConceptID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SNOC_ConceptID ];

/// FullySpecifiedName
Property SNOCFullDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SNOC_FullDesc ];

/// Status
Property SNOCStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SNOC_Status ];

/// CTV3ID
Property SNOCCTV3ID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SNOC_CTV3ID ];

/// SNOMEDID
Property SNOCSNOMEDID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SNOC_SNOMEDID ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACSnomedTerms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedConcept","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACSnomedConcept).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedConcept","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACSnomedConcept).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedConcept","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACSnomedConcept).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedConcept","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACSnomedConcept).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedConcept","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedConcept","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SNOC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SNOC_CTV3ID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNOC_ConceptID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNOC_FullDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNOC_SNOMEDID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SNOC_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SNOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SNOC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTV3ID">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTV3ID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOC_CTV3ID})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConcID">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ConcID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOC_ConceptID})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOC_FullDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSNOMEDID">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SNOMEDID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOC_SNOMEDID})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNOC_RowId</SqlRowIdName>
<StreamLocation>^User.PACSnomedConceptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
