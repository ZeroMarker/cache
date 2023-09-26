/// PAC Snomed Terms(1941)
Class User.PACSnomedTerms Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SnomedTerms, StorageStrategy = SQLStorage ]
{

/// DescId
Property SNOTDescId As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SNOT_DescId ];

/// Des Ref Concept
Property SNOTConceptDR As PACSnomedConcept [ SqlColumnNumber = 3, SqlFieldName = SNOT_Concept_DR ];

/// Term
Property SNOTTerm As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SNOT_Term ];

/// InitialCapitalStatus
Property SNOTInitialCapitalStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SNOT_InitialCapitalStatus ];

/// Description Status
Property SNOTDescStatus As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SNOT_DescStatus ];

/// Description Type
Property SNOTDescType As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SNOT_DescType ];

/// Language Code
Property SNOTLanguageCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SNOT_LanguageCode ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACSnomedTerms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedTerms","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACSnomedTerms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedTerms","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACSnomedTerms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedTerms","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACSnomedTerms).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedTerms","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACSnomedTerms).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedTerms","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedTerms","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SNOT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SNOT_Concept_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNOT_DescId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNOT_DescStatus">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SNOT_DescType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SNOT_InitialCapitalStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNOT_LanguageCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SNOT_Term">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SNOT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConcept">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Concept"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNOT_Concept_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SNOT_Term})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescId">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOT_DescId})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTerm">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Term"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOT_Term})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNOT_RowId</SqlRowIdName>
<StreamLocation>^User.PACSnomedTermsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
