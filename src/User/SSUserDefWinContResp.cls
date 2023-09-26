/// UserDefWinContResp(2687)
Class User.SSUserDefWinContResp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserDefWinContResp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RESPChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildSSUserDefWinContRespAct As SSUserDefWinContRespAct [ Cardinality = children, Inverse = ACTParRef ];

/// SS_UserDefWindowControls Parent Reference
Relationship RESPParRef As SSUserDefWindowControls [ Cardinality = parent, Inverse = ChildSSUserDefWinContResp, Required, SqlFieldName = RESP_ParRef ];

/// Childsub
Property RESPChildsub As %Float [ InitialExpression = {$i(^SSU("WIN",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"CON",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"RESP",0))}, SqlColumnNumber = 2, SqlFieldName = RESP_Childsub ];

/// Code
Property RESPCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RESP_Code ];

/// Description
Property RESPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RESP_Desc ];

/// Score
Property RESPScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RESP_Score ];

/// DateFrom
Property RESPDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = RESP_DateFrom ];

/// DateTo
Property RESPDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = RESP_DateTo ];

/// Des Ref ClinPathway
Property RESPClinPathwayDR As MRCClinicalPathways [ SqlColumnNumber = 8, SqlFieldName = RESP_ClinPathway_DR ];

/// Generated
Property RESPGenerated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = RESP_Generated ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserDefWinContResp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContResp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserDefWinContResp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContResp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserDefWinContResp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContResp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserDefWinContResp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContResp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserDefWinContResp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUserDefWinContResp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="RESP_ClinPathway_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RESP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RESP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RESP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RESP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RESP_Generated">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RESP_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
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
<Field>RESP_Childsub</Field>
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
<Expression>{RESP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RESP_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserDefWinContRespS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
