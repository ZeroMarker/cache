/// RB Res Eff date Sess Serv  (RBRD3)
Class User.RBResEffDateSessServices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSessServices, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SERChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildRBResEffDateSessServRTMasV As RBResEffDateSessServRTMasVol [ Cardinality = children, Inverse = RTMAVParRef ];

/// RB_ResEffDateSession Parent Reference
Relationship SERParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessServices, Required, SqlFieldName = SER_ParRef ];

/// Childsub
Property SERChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"SER",0))}, SqlColumnNumber = 2, SqlFieldName = SER_Childsub ];

/// Des Ref RBC Service
Property SERRBCServiceDR As RBCServices [ SqlColumnNumber = 3, SqlFieldName = SER_RBC_Service_DR ];

/// Des Ref CTLOC
Property SERCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlComputeCode = { s {SER_CTLOC_DR}=$$CO04^at1512({SER_ParRef})
}, SqlComputed, SqlFieldName = SER_CTLOC_DR, Transient ];

/// Des Ref Resource
Property SERResourceDR As RBResource [ SqlColumnNumber = 5, SqlComputeCode = { s {SER_Resource_DR}=$$CO05^at1512({SER_ParRef})
}, SqlComputed, SqlFieldName = SER_Resource_DR, Transient ];

/// Des Ref Day Of Week
Property SERDayOfWeekDR As CTDayOfWeek [ SqlColumnNumber = 6, SqlFieldName = SER_DayOfWeek_DR ];

/// Start Time
Property SERStartTime As %Time [ SqlColumnNumber = 7, SqlFieldName = SER_StartTime ];

/// Desc
Property SERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s {SER_Desc}=$$CO08^at1512({SER_RBC_Service_DR})
}, SqlComputed, SqlFieldName = SER_Desc, Transient ];

/// ARCIM/ARCOS
Property SERARCIMARCOS As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlComputeCode = { s {SER_ARCIM_ARCOS}=$$CO09^at1512({SER_RBC_Service_DR})
}, SqlComputed, SqlFieldName = SER_ARCIM_ARCOS, Transient ];

/// Minutes
Property SERMinutes As %Float [ SqlColumnNumber = 10, SqlFieldName = SER_Minutes ];

/// No Of Times Book
Property SERNoOfTimesBook As %Float [ SqlColumnNumber = 11, SqlFieldName = SER_NoOfTimesBook ];

/// ReminderDays
Property SERReminderDays As %Float [ SqlColumnNumber = 12, SqlFieldName = SER_ReminderDays ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessServices","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSessServices).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessServices","OnBeforeDelete")
 
 d VALDEL^at1512
 &sql(DELETE FROM RB_ResEffDateSessServRTMasVol WHERE RTMAV_ParRef=:%d(1))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
	d VALINS^at1512
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSessServices).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessServices","OnBeforeUpdate")
 
 d VALUPD^at1512
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SER_DayOfWeek_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SER_Minutes">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SER_NoOfTimesBook">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SER_RBC_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SER_ReminderDays">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SER_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Field>SER_Childsub</Field>
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
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOCServD">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L10}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocSERD1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SER_RBC_Service_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLOCService">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocSER1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDayOfWeek">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L10}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DOW1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_DayOfWeek_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SER_StartTime}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceServD">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L10}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResSERD1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SER_RBC_Service_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceService">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResSER1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
