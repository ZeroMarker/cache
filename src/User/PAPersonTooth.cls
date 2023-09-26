/// Person Tooth(2582)
Class User.PAPersonTooth Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonTooth, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TOOTHChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPersonToothHistory As PAPersonToothHistory [ Cardinality = children, Inverse = HISTParRef ];

/// PA_Person Parent Reference
Relationship TOOTHParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonTooth, Required, SqlFieldName = TOOTH_ParRef ];

/// Childsub
Property TOOTHChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TOOTH",0))}, SqlColumnNumber = 2, SqlFieldName = TOOTH_Childsub ];

/// Des Ref Position_DR
Property TOOTHPositionDR As OECToothPosition [ SqlColumnNumber = 3, SqlFieldName = TOOTH_Position_DR ];

/// Des Ref Number_DR
Property TOOTHNumberDR As OECToothNumber [ SqlColumnNumber = 4, SqlFieldName = TOOTH_Number_DR ];

/// Des Ref Type_DR
Property TOOTHTypeDR As OECToothType [ SqlColumnNumber = 5, SqlFieldName = TOOTH_Type_DR ];

/// Des Ref AllCurrentState_DR
Property TOOTHAllCurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 6, SqlFieldName = TOOTH_AllCurrentState_DR ];

/// Des Ref RootCurrentState_DR
Property TOOTHRootCurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 7, SqlFieldName = TOOTH_RootCurrentState_DR ];

/// Des Ref ToothCurrentState_DR
Property TOOTHToothCurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 8, SqlFieldName = TOOTH_ToothCurrentState_DR ];

/// Des Ref Face1CurrentState_DR
Property TOOTHFace1CurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 9, SqlFieldName = TOOTH_Face1CurrentState_DR ];

/// Des Ref Face2CurrentState_DR
Property TOOTHFace2CurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 10, SqlFieldName = TOOTH_Face2CurrentState_DR ];

/// Des Ref Face3CurrentState_DR
Property TOOTHFace3CurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 11, SqlFieldName = TOOTH_Face3CurrentState_DR ];

/// Des Ref Face4CurrentState_DR
Property TOOTHFace4CurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 12, SqlFieldName = TOOTH_Face4CurrentState_DR ];

/// Des Ref Face5CurrentState_DR
Property TOOTHFace5CurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 13, SqlFieldName = TOOTH_Face5CurrentState_DR ];

/// Comments
Property TOOTHComments As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 14, SqlFieldName = TOOTH_Comments, SqlListType = SUBNODE ];

/// Des Ref ColosCurrentState
Property TOOTHColosCurrentStateDR As PAPersonToothHistory [ SqlColumnNumber = 15, SqlFieldName = TOOTH_ColosCurrentState_DR ];

/// Active
Property TOOTHActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = TOOTH_Active ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonTooth).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonTooth","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonTooth).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonTooth","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonTooth).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonTooth","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonTooth).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonTooth","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonTooth).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonTooth","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="TOOTH_Active">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TOOTH_AllCurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TOOTH_ColosCurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TOOTH_Comments">
<Node>"CMNT"</Node>
</Data>
<Data name="TOOTH_Face1CurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TOOTH_Face2CurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TOOTH_Face3CurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TOOTH_Face4CurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TOOTH_Face5CurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TOOTH_Number_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TOOTH_Position_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TOOTH_RootCurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TOOTH_ToothCurrentState_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TOOTH_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TOOTH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TOOTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TOOTH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TOOTH_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonToothS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
