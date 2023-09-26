/// RTC RequestDivert(2323)
Class User.RTCRequestDivert Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_RequestDivert, StorageStrategy = SQLStorage ]
{

/// Des Ref ReqReason
Property REQDIVReqReasonDR As RTCReasonRequest [ SqlColumnNumber = 2, SqlFieldName = REQDIV_ReqReason_DR ];

/// Des Ref RecordType
Property REQDIVRecordTypeDR As RTCMRecordType [ SqlColumnNumber = 3, SqlFieldName = REQDIV_RecordType_DR ];

/// Des Ref Hospital
Property REQDIVHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = REQDIV_Hospital_DR ];

/// Des Ref CTLOC
Property REQDIVMRLocationDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = REQDIV_MRLocation_DR ];

/// Show Home
Property REQDIVShowHome As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = REQDIV_ShowHome ];

/// CT Significant Facility DR
Property REQDIVSignFacDR As CTSignificantFacility [ SqlColumnNumber = 7, SqlFieldName = REQDIV_SignFacDR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCRequestDivert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCRequestDivert","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCRequestDivert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCRequestDivert","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCRequestDivert).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCRequestDivert","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCRequestDivert).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCRequestDivert","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCRequestDivert).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCRequestDivert","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RTC("REQDIV",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="REQDIV_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REQDIV_MRLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REQDIV_RecordType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REQDIV_ReqReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REQDIV_ShowHome">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REQDIV_SignFacDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REQDIV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REQDIV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REQDIV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRecordTypeHosp">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>REQDIV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REQDIV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQDIV_RecordType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{REQDIV_Hospital_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REQDIV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REQDIV_RowId</SqlRowIdName>
<StreamLocation>^User.RTCRequestDivertS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
