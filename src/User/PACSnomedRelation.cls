/// PAC Snomed Relation(1942)
Class User.PACSnomedRelation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SnomedRelation, StorageStrategy = SQLStorage ]
{

/// Relation ID
Property SNORRelID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SNOR_RelID ];

/// Des Ref Concept1
Property SNORConcept1DR As PACSnomedConcept [ SqlColumnNumber = 3, SqlFieldName = SNOR_Concept1_DR ];

/// Relation Type
Property SNORRelationType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SNOR_RelationType ];

/// Des Ref Concept2
Property SNORConcept2DR As PACSnomedConcept [ SqlColumnNumber = 5, SqlFieldName = SNOR_Concept2_DR ];

/// Characteristic Type
Property SNORCharacteristicType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SNOR_CharacteristicType ];

/// Refinability
Property SNORRefinability As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SNOR_Refinability ];

/// Des Ref Concept
Property SNORRelationTypeDR As PACSnomedConcept [ SqlColumnNumber = 8, SqlFieldName = SNOR_RelationType_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACSnomedRelation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedRelation","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACSnomedRelation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedRelation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACSnomedRelation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedRelation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACSnomedRelation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedRelation","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACSnomedRelation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedRelation","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSnomedRelation","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>29</ExtentSize>
<Property name="SNORCharacteristicType">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SNORConcept1DR">
<Selectivity>5.0000%</Selectivity>
</Property>
<Property name="SNORConcept2DR">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="SNORRefinability">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SNORRelID">
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="SNORRelationType">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="SNORRelationTypeDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("SNOR",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SNOR_CharacteristicType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SNOR_Concept1_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNOR_Concept2_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNOR_Refinability">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SNOR_RelID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNOR_RelationType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SNOR_RelationType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SNOR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConcSource">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ConcSource"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNOR_Concept1_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SNOR_RelID})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConcTarget">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ConcTarget"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNOR_Concept2_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SNOR_RelID})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConcepts">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Conc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNOR_Concept1_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOR_Concept2_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRelId">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNOR_RelID})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType1">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNOR_Concept1_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOR_RelationType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNOR_Concept2_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SNOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType2">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SNOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SNOR_Concept2_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNOR_RelationType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SNOR_Concept1_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SNOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNOR_RowId</SqlRowIdName>
<StreamLocation>^User.PACSnomedRelationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
