/// PAC Concept Keywords(1940)
Class User.PACSnomedConceptKeywords Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SnomedConceptKeywords, StorageStrategy = SQLStorage ]
{

/// Childsub
Property KEYWChildsub As %Float [ InitialExpression = {$i(^PAC("SNOC",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"KEYW",0))}, SqlColumnNumber = 2, SqlFieldName = KEYW_Childsub ];

/// Code
Property KEYWCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = KEYW_Code ];

/// Description
Property KEYWDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = KEYW_Desc ];

/// PAC_SnomedConcept Parent Reference
Relationship KEYWParRef As PACSnomedConcept [ Cardinality = parent, Inverse = ChildPACSnomedConceptKeywords, Required, SqlFieldName = KEYW_ParRef ];

/// Des Ref Term
Property KEYWTermDR As PACSnomedTerms [ SqlColumnNumber = 8, SqlFieldName = KEYW_Term_DR ];

/// Text
Property KEYWText As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = KEYW_Text ];

/// Text1
Property KEYWText1 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = KEYW_Text1 ];

/// Text2
Property KEYWText2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = KEYW_Text2 ];

Index RowIDBasedIDKeyIndex On KEYWChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1000000;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSnomedConceptKeywords).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACSnomedConceptKeywords","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSnomedConceptKeywords).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACSnomedConceptKeywords","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSnomedConceptKeywords).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACSnomedConceptKeywords","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSnomedConceptKeywords).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACSnomedConceptKeywords","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSnomedConceptKeywords).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACSnomedConceptKeywords","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="KEYWChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWTermDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWText">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWText1">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWText2">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="KEYW_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KEYW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="KEYW_Term_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="KEYW_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KEYW_Text1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KEYW_Text2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_SnomedConcept.SNOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_SnomedConcept.SNOC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAC_SnomedConcept.SNOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"KeywCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAC_SnomedConcept.SNOC_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyw1">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PAC_SnomedConcept.SNOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Text1}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Text2}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PAC_SnomedConcept.SNOC_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAC_SnomedConcept.SNOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Text}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAC_SnomedConcept.SNOC_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.PACSnomedConceptKeywordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
