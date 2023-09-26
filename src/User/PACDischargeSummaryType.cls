/// DischargeSummaryType(2380)
Class User.PACDischargeSummaryType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DischargeSummaryType, StorageStrategy = SQLStorage ]
{

/// Code
Property DISCSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DISCST_Code ];

/// Description
Property DISCSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DISCST_Desc ];

/// Document Type
Property DISCSTDocumentType As %String(DISPLAYLIST = ",Word,Crystal Report", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",W,C") [ SqlColumnNumber = 4, SqlFieldName = DISCST_DocumentType ];

/// Document Name
Property DISCSTDocumentName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DISCST_DocumentName ];

/// Chart
Property DISCSTChart As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DISCST_Chart ];

/// Date From
Property DISCSTDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = DISCST_DateFrom ];

/// Date To
Property DISCSTDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = DISCST_DateTo ];

/// Multiple Versions
Property DISCSTMultipleVersions As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DISCST_MultipleVersions ];

/// EpisodeType
Property DISCSTEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DISCST_EpisodeType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACDischargeSummaryType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeSummaryType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACDischargeSummaryType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeSummaryType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACDischargeSummaryType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeSummaryType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACDischargeSummaryType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeSummaryType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACDischargeSummaryType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeSummaryType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("DISCST",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="DISCST_Chart">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DISCST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISCST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DISCST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DISCST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DISCST_DocumentName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DISCST_DocumentType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DISCST_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DISCST_MultipleVersions">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DISCST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DISCST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DISCST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DISCST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISCST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DISCST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DISCST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISCST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DISCST_RowId</SqlRowIdName>
<StreamLocation>^User.PACDischargeSummaryTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
