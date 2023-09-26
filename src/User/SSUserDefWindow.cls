/// SS User Defind Window(1809)
Class User.SSUserDefWindow Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserDefWindow, StorageStrategy = SQLStorage ]
{

Relationship ChildSSUserDefWindowControls As SSUserDefWindowControls [ Cardinality = children, Inverse = CONParREf ];

/// Code
Property WINCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WIN_Code ];

/// Description
Property WINDesc As %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WIN_Desc ];

/// UsedFlag
Property WINUsedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = WIN_UsedFlag ];

/// Document
Property WINDocument As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = WIN_Document ];

/// Score
Property WINScore As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = WIN_Score ];

/// Des Ref WindowGroup
Property WINWindowGroupDR As SSUserDefWinGroup [ SqlColumnNumber = 7, SqlFieldName = WIN_WindowGroup_DR ];

/// GenerateError
Property WINGenerateError As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WIN_GenerateError ];

/// WebFlag
Property WINWebFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = WIN_WebFlag ];

/// OldQuestionnaire
Property WINOldQuestionnaire As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = WIN_OldQuestionnaire ];

/// LastGenDate
Property WINLastGenDate As %Date [ SqlColumnNumber = 11, SqlFieldName = WIN_LastGenDate ];

/// LastGenTime
Property WINLastGenTime As %Time [ SqlColumnNumber = 12, SqlFieldName = WIN_LastGenTime ];

/// Des Ref LastGenUser
Property WINLastGenUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = WIN_LastGenUser_DR ];

/// Des Ref LastGenHospital
Property WINLastGenHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = WIN_LastGenHospital_DR ];

/// Inactive
Property WINInactive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = WIN_Inactive ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.SSUserDefWindow).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindow","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.SSUserDefWindow).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindow","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.SSUserDefWindow).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindow","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.SSUserDefWindow).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindow","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindow","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.SSUserDefWindow).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindow","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^SSU("WIN",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WIN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WIN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WIN_Document">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WIN_GenerateError">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WIN_Inactive">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WIN_LastGenDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WIN_LastGenHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WIN_LastGenTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WIN_LastGenUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WIN_OldQuestionnaire">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WIN_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WIN_UsedFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WIN_WebFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WIN_WindowGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WIN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WIN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INdexCode">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WIN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WIN_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WIN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WIN_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WIN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WIN_WindowGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WIN_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserDefWindowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
