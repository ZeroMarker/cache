/// Res Eff Date Session Var(2322)
Class User.RBResEffDateSessionVar Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSessionVar, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On VARChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_ResEffDateSession Parent Reference
Relationship VARParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessionVar, Required, SqlFieldName = VAR_ParRef ];

/// Childsub
Property VARChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"VAR",0))}, SqlColumnNumber = 2, SqlFieldName = VAR_Childsub ];

/// Time Arrived
Property VARTimeArrived As %Time [ SqlColumnNumber = 3, SqlFieldName = VAR_TimeArrived ];

/// Time Departed
Property VARTimeDeparted As %Time [ SqlColumnNumber = 4, SqlFieldName = VAR_TimeDeparted ];

/// Des Ref ReasonForVariance
Property VARReasonForVarianceDR As RBCReasonForVariance [ SqlColumnNumber = 5, SqlFieldName = VAR_ReasonForVariance_DR ];

/// SessDate
Property VARSessDate As %Date [ SqlColumnNumber = 6, SqlFieldName = VAR_SessDate ];

/// LastUpdateDate
Property VARLastUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = VAR_LastUpdateDate ];

/// LastUpdateTime
Property VARLastUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = VAR_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property VARLastUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = VAR_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property VARLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = VAR_LastUpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessionVar).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionVar","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessionVar).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionVar","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessionVar).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionVar","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSessionVar).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionVar","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSessionVar).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionVar","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="VAR_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VAR_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VAR_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VAR_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VAR_ReasonForVariance_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VAR_SessDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VAR_TimeArrived">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VAR_TimeDeparted">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>VAR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"VAR"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{VAR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VAR_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessionVarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
