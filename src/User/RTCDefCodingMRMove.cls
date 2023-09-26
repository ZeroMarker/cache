/// Default Coding MR Move(2439)
Class User.RTCDefCodingMRMove Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_DefCodingMRMove, StorageStrategy = SQLStorage ]
{

/// Des Ref Hospital
Property DCMMHospitalDR As CTHospital [ SqlColumnNumber = 2, SqlFieldName = DCMM_Hospital_DR ];

/// Des Ref MRType
Property DCMMMRTypeDR As RTCMRecordType [ SqlColumnNumber = 3, SqlFieldName = DCMM_MRType_DR ];

/// Des Ref DestinationLoc
Property DCMMDestinationLocDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = DCMM_DestinationLoc_DR ];

/// Volumes To Move
Property DCMMVolumesToMove As %String(DISPLAYLIST = ",All,Most Recent", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",A,R") [ SqlColumnNumber = 5, SqlFieldName = DCMM_VolumesToMove ];

/// Volume
Property DCMMVolume As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DCMM_Volume ];

/// Telephone
Property DCMMTelephone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DCMM_Telephone ];

/// Contact Person
Property DCMMContactPerson As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DCMM_ContactPerson ];

/// Pager
Property DCMMPager As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DCMM_Pager ];

/// Des Ref ReqReason
Property DCMMReqReasonDR As RTCReasonRequest [ SqlColumnNumber = 10, SqlFieldName = DCMM_ReqReason_DR ];

/// Comments
Property DCMMComments As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DCMM_Comments ];

/// Date From
Property DCMMDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = DCMM_DateFrom ];

/// Date To
Property DCMMDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = DCMM_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCDefCodingMRMove).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCDefCodingMRMove","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCDefCodingMRMove).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCDefCodingMRMove","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCDefCodingMRMove).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCDefCodingMRMove","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCDefCodingMRMove).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCDefCodingMRMove","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCDefCodingMRMove).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCDefCodingMRMove","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RTC("DCMM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DCMM_Comments">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCMM_ContactPerson">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCMM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCMM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCMM_DestinationLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCMM_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCMM_MRType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCMM_Pager">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCMM_ReqReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCMM_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCMM_Volume">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCMM_VolumesToMove">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCMM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DCMM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCMM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCMM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DCMM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCMM_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCMM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCMM_RowId</SqlRowIdName>
<StreamLocation>^User.RTCDefCodingMRMoveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
