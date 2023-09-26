/// Reason_RequestHosp(2482)
Class User.RTCReasonRequestHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_Reason_RequestHosp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HOSChildsub [ IdKey, PrimaryKey, Unique ];

/// RTC_Reason_Request Parent Reference
Relationship HOSParRef As RTCReasonRequest [ Cardinality = parent, Inverse = ChildRTCReasonRequestHosp, Required, SqlFieldName = HOS_ParRef ];

/// Childsub
Property HOSChildsub As %Float [ InitialExpression = {$i(^RTC("REA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HOSP",0))}, SqlColumnNumber = 2, SqlFieldName = HOS_Childsub ];

/// Des Ref Hospital
Property HOSHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = HOS_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCReasonRequestHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonRequestHosp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCReasonRequestHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonRequestHosp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCReasonRequestHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonRequestHosp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCReasonRequestHosp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonRequestHosp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCReasonRequestHosp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCReasonRequestHosp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="HOS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTC_Reason_Request.REA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>HOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RTC_Reason_Request.REA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTC_Reason_Request.REA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>HOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RTC_Reason_Request.REA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HOS_Hospital_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{HOS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOS_RowId</SqlRowIdName>
<StreamLocation>^User.RTCReasonRequestHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
