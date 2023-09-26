/// CT Zip Keywords(1630)
Class User.CTZipKeywords Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_ZipKeywords, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On KEYWChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Zip Parent Reference
Relationship KEYWParRef As CTZip [ Cardinality = parent, Inverse = ChildCTZipKeywords, Required, SqlFieldName = KEYW_ParRef ];

/// Childsub
Property KEYWChildsub As %Float [ InitialExpression = {$i(^CT("ZIP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"KEYW",0))}, SqlColumnNumber = 2, SqlFieldName = KEYW_Childsub ];

/// Des Ref City
Property KEYWCityDR As CTCity [ SqlColumnNumber = 3, SqlFieldName = KEYW_City_DR ];

/// Description
Property KEYWDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = KEYW_Desc ];

/// Date From
Property KEYWDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = KEYW_DateFrom ];

/// Date To
Property KEYWDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = KEYW_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTZipKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZipKeywords","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTZipKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZipKeywords","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTZipKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZipKeywords","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTZipKeywords).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZipKeywords","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTZipKeywords).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTZipKeywords","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="KEYW_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KEYW_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KEYW_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KEYW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Zip.CTZIP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Zip.CTZIP_RowId}</Expression>
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
<SQLMap name="IndexCityKeyw">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CT_Zip.CTZIP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityKeyw"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_City_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CT_Zip.CTZIP_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyword">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_Zip.CTZIP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ZIP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Keyw"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_Zip.CTZIP_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.CTZipKeywordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
