/// SS Print Report(1818)
Class User.SSPrintReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_PrintReport, StorageStrategy = SQLStorage ]
{

/// Report Type
Property PRReportType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PR_ReportType ];

/// Date
Property PRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PR_Date ];

/// Time
Property PRTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PR_Time ];

/// Des Ref User
Property PRUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = PR_User_DR ];

/// Dispensed Flag
Property PRDispensedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PR_DispensedFlag ];

/// Content
Property PRContent As list Of %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PR_Content, SqlListType = SUBNODE ];

/// Des Ref Ward
Property PRWardDR As PACWard [ SqlColumnNumber = 8, SqlFieldName = PR_Ward_DR ];

/// Days
Property PRDays As %Float [ SqlColumnNumber = 9, SqlFieldName = PR_Days ];

/// Des Ref Report_DR
Property PRReportDR As SSPrintReport [ SqlColumnNumber = 10, SqlFieldName = PR_Report_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSPrintReport).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSPrintReport","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSPrintReport).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSPrintReport","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSPrintReport).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSPrintReport","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSPrintReport).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSPrintReport","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSPrintReport).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSPrintReport","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^SST("PR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_Content">
<Node>"REM"</Node>
</Data>
<Data name="PR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PR_Days">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PR_DispensedFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PR_Report_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PR_ReportType})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PR_Ward_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PR_Date}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate1">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PR_ReportType})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PR_RowId</SqlRowIdName>
<StreamLocation>^User.SSPrintReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
