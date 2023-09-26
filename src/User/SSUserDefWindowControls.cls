/// SS User Def Win Controls(1810)
Class User.SSUserDefWindowControls Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserDefWindowControls, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSUserDefWinContResp As SSUserDefWinContResp [ Cardinality = children, Inverse = RESPParRef ];

/// SS_UserDefWindow Parent Reference
Relationship CONParREf As SSUserDefWindow [ Cardinality = parent, Inverse = ChildSSUserDefWindowControls, Required, SqlFieldName = CON_ParREf ];

/// Childsub
Property CONChildsub As %Float [ InitialExpression = {$i(^SSU("WIN",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CON",0))}, SqlColumnNumber = 2, SqlFieldName = CON_Childsub ];

/// ControlType
Property CONControlType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CON_ControlType ];

/// Text
Property CONText As %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CON_Text ];

/// Score
Property CONScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CON_Score ];

/// Values
Property CONValues As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CON_Values ];

/// No Longer Used Flag
Property CONNoLongerUsedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CON_NoLongerUsedFlag ];

/// ComboScores
Property CONComboScores As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CON_ComboScores ];

/// Code
Property CONCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CON_Code ];

/// Default Last Question and Answer
Property CONDefaultLastQnAns As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CON_DefaultLastQnAns ];

/// Code Table
Property CONCodeTable As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CON_CodeTable ];

/// QuestionAnswerLink
Property CONQuestionAnswerLink As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CON_QuestionAnswerLink ];

/// ClincalPathwayText
Property CONClincalPathwayText As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CON_ClincalPathwayText ];

/// DisplayAnswer
Property CONDisplayAnswer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = CON_DisplayAnswer ];

/// Generated
Property CONGenerated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = CON_Generated ];

/// Des Ref ObsItem
Property CONObsItemDR As MRCObservationItem [ SqlColumnNumber = 16, SqlFieldName = CON_ObsItem_DR ];

/// Calculation
Property CONCalculation As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CON_Calculation ];

/// SignificantLevel
Property CONSignificantLevel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CON_SignificantLevel ];

/// Decimal Places
Property CONDecPlaces As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CON_DecPlaces ];

/// Des Ref Image
Property CONImageDR As MRCPictureCode [ SqlColumnNumber = 20, SqlFieldName = CON_Image_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserDefWindowControls).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindowControls","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserDefWindowControls).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindowControls","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserDefWindowControls).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindowControls","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserDefWindowControls).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindowControls","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserDefWindowControls).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWindowControls","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CON_Calculation">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CON_ClincalPathwayText">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CON_Code">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CON_CodeTable">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CON_ComboScores">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CON_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CON_DecPlaces">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CON_DefaultLastQnAns">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CON_DisplayAnswer">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CON_Generated">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CON_Image_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CON_NoLongerUsedFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CON_ObsItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CON_QuestionAnswerLink">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CON_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CON_SignificantLevel">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CON_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CON_Values">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_UserDefWindow.WIN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CON_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_UserDefWindow.WIN_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CON"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CON_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSignLevel">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_UserDefWindow.WIN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CON_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_UserDefWindow.WIN_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CON"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Signif"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CON_SignificantLevel}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CON_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CON_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserDefWindowControlsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
