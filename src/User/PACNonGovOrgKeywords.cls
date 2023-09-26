/// NonGovOrgKeywords(2793)
Class User.PACNonGovOrgKeywords Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_NonGovOrgKeywords, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On KEYWChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_NonGovOrg Parent Reference
Relationship KEYWParRef As PACNonGovOrg [ Cardinality = parent, Inverse = ChildPACNonGovOrgKeywords, Required, SqlFieldName = KEYW_ParRef ];

/// Childsub
Property KEYWChildsub As %Float [ InitialExpression = {$i(^PAC("NGO",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"KEYW",0))}, SqlColumnNumber = 2, SqlFieldName = KEYW_Childsub ];

/// Text
Property KEYWText As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = KEYW_Text ];

/// School
Property KEYWSchool As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = KEYW_School ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACNonGovOrgKeywords).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrgKeywords","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACNonGovOrgKeywords).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrgKeywords","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACNonGovOrgKeywords).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrgKeywords","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACNonGovOrgKeywords).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrgKeywords","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrgKeywords","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACNonGovOrgKeywords).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrgKeywords","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="KEYW_School">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KEYW_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_NonGovOrg.NGO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_NonGovOrg.NGO_RowId}</Expression>
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
<SQLMap name="IndexSchoolText">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAC_NonGovOrg.NGO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SchoolText"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_School}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Text})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAC_NonGovOrg.NGO_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAC_NonGovOrg.NGO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAC_NonGovOrg.NGO_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.PACNonGovOrgKeywordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
