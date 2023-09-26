/// RBC Session Type(1486)
Class User.RBCSessionType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_SessionType, StorageStrategy = SQLStorage ]
{

Relationship ChildRBCSessionTypeAvail As RBCSessionTypeAvail [ Cardinality = children, Inverse = AVLParRef ];

/// Code
Property SESSCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SESS_Code ];

/// Description
Property SESSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SESS_Desc ];

/// Des Ref Session Type
Property SESSSessionTypeDR As RBCSessionType [ SqlColumnNumber = 4, SqlFieldName = SESS_SessionType_DR ];

/// Number Of Days
Property SESSNumberOfDays As %Float [ SqlColumnNumber = 5, SqlFieldName = SESS_NumberOfDays ];

/// Enable By Default
Property SESSEnableByDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SESS_EnableByDefault ];

/// Date From
Property SESSDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = SESS_DateFrom ];

/// Date To
Property SESSDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = SESS_DateTo ];

/// ReleaseDays
Property SESSReleaseDays As %Float [ SqlColumnNumber = 9, SqlFieldName = SESS_ReleaseDays ];

/// ConvertPeriod(mins)
Property SESSConvertPeriod As %Float [ SqlColumnNumber = 10, SqlFieldName = SESS_ConvertPeriod ];

/// GenFrequency
Property SESSGenFrequency As %Float [ SqlColumnNumber = 11, SqlFieldName = SESS_GenFrequency ];

/// GenPeriod
Property SESSGenPeriod As %String(DISPLAYLIST = ",Day,Month,Week,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,M,W,Y") [ SqlColumnNumber = 12, SqlFieldName = SESS_GenPeriod ];

/// 归类 （普通Normal、专家Specialist、主任Director、副主任DeputyDirector、急诊Emergency）
Property SESSCategory As %String(DISPLAYLIST = ",Normal,Specialist,Director,DeputyDirector,Emergency", VALUELIST = ",N,S,D,DP,E") [ SqlColumnNumber = 13, SqlFieldName = SESS_Category ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCSessionType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCSessionType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCSessionType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCSessionType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCSessionType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCSessionType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("SESS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SESS_Category">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SESS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SESS_ConvertPeriod">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SESS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SESS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SESS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SESS_EnableByDefault">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SESS_GenFrequency">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SESS_GenPeriod">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SESS_NumberOfDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SESS_ReleaseDays">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SESS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SESS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SESS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SESS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SESS_RowId</SqlRowIdName>
<StreamLocation>^User.RBCSessionTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
