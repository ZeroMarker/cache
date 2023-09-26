/// RB Service Override(1719)
Class User.RBServiceOverride Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ServiceOverride, StorageStrategy = SQLStorage ]
{

/// Des Ref Resource
Property SOVResourceDR As RBResource [ SqlColumnNumber = 2, SqlFieldName = SOV_Resource_DR ];

/// Des Ref DOW
Property SOVDOWDR As CTDayOfWeek [ SqlColumnNumber = 3, SqlFieldName = SOV_DOW_DR ];

/// Date
Property SOVDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SOV_Date ];

/// Start Time
Property SOVStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = SOV_StartTime ];

/// End Time
Property SOVEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = SOV_EndTime ];

/// Des Ref Service Group
Property SOVServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 7, SqlFieldName = SOV_ServiceGroup_DR ];

/// Service Key
Property SOVServiceKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SOV_ServiceKey ];

/// Des REf RBSession
Property SOVRBSessionDR As RBResEffDateSession [ SqlColumnNumber = 9, SqlFieldName = SOV_RBSession_DR ];

/// NumberOfServices
Property SOVNumberOfServices As %Float [ SqlColumnNumber = 10, SqlFieldName = SOV_NumberOfServices ];

/// Message
Property SOVMessage As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = SOV_Message, SqlListType = SUBNODE ];

/// DateTo
Property SOVDateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = SOV_DateTo ];

/// Des Ref RBSessServ
Property SOVRBSessServDR As RBResEffDateSessServices [ SqlColumnNumber = 13, SqlFieldName = SOV_RBSessServ_DR ];

/// Text
Property SOVText As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 14, SqlFieldName = SOV_Text, SqlListType = SUBNODE ];

/// Des Ref Session1
Property SOVSession1DR As RBResEffDateSession [ SqlColumnNumber = 15, SqlFieldName = SOV_Session1_DR ];

/// Update Date
Property SOVUpdateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = SOV_UpdateDate ];

/// Update Time
Property SOVUpdateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = SOV_UpdateTime ];

/// Des Ref UpdateUser
Property SOVUpdateUserDR As SSUser [ SqlColumnNumber = 18, SqlFieldName = SOV_UpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property SOVLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 19, SqlFieldName = SOV_LastUpdateHospital_DR ];

/// Des Ref Service
Property SOVServiceDR As RBCServices [ SqlColumnNumber = 20, SqlFieldName = SOV_Service_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBServiceOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBServiceOverride","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBServiceOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBServiceOverride","OnAfterInsert")
 d POFILINS^at1719
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBServiceOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBServiceOverride","OnAfterUpdate")
 d POFILUPD^at1719
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBServiceOverride).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBServiceOverride","OnBeforeDelete")
 d VALDEL^at1719
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d VALINS^at1719
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBServiceOverride).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBServiceOverride","OnBeforeUpdate")
 d VALUPD^at1719
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RB("SOV",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SOV_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SOV_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SOV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SOV_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SOV_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SOV_Message">
<Node>"MESS"</Node>
</Data>
<Data name="SOV_NumberOfServices">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SOV_RBSessServ_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SOV_RBSession_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SOV_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SOV_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SOV_ServiceKey">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SOV_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SOV_Session1_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SOV_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SOV_Text">
<Node>"TXT"</Node>
</Data>
<Data name="SOV_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SOV_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SOV_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SOV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDOW">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResDOW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_DOW_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SOV_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SOV_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SOV_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SOV_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMessage">
<Condition>{SOV_Message}'=""</Condition>
<ConditionFields>SOV_Message</ConditionFields>
<Global>^RB</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Mess"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SOV_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceDOW">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SerDOW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_DOW_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SOV_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SOV_ServiceKey}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceDate">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SerDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SOV_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SOV_ServiceKey}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceDate1">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L9}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ServDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_DOW_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SOV_ServiceKey}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SOV_StartTime}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SOV_Date}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSessServDR">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SessServ"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_RBSessServ_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSessionDR">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SOV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Sess"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SOV_RBSession_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SOV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SOV_RowId</SqlRowIdName>
<StreamLocation>^User.RBServiceOverrideS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
