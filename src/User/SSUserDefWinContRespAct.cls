/// UserDefWinContRespAct(2688)
Class User.SSUserDefWinContRespAct Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserDefWinContRespAct, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ACTChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_UserDefWinContResp Parent Reference
Relationship ACTParRef As SSUserDefWinContResp [ Cardinality = parent, Inverse = ChildSSUserDefWinContRespAct, Required, SqlFieldName = ACT_ParRef ];

/// Childsub
Property ACTChildsub As %Float [ InitialExpression = {$i(^SSU("WIN",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"CON",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"RESP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"ACT",0))}, SqlColumnNumber = 2, SqlFieldName = ACT_Childsub ];

/// Des Ref UsDefWinCont
Property ACTControlDR As SSUserDefWindowControls [ SqlColumnNumber = 3, SqlFieldName = ACT_Control_DR ];

/// Score
Property ACTScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ACT_Score ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserDefWinContRespAct).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContRespAct","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserDefWinContRespAct).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContRespAct","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserDefWinContRespAct).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContRespAct","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserDefWinContRespAct).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContRespAct","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserDefWinContRespAct).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContRespAct","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ACT_Control_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACT_Score">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_UserDefWindow.WIN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SS_UserDefWindowControls.CON_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SS_UserDefWinContResp.RESP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>ACT_Childsub</Field>
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
<Expression>{SS_UserDefWindowControls.CON_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"RESP"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SS_UserDefWinContResp.RESP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ACT"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ACT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ACT_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserDefWinContRespActS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
