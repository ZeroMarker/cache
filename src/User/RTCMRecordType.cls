/// RTC Med Record Type(1450)
Class User.RTCMRecordType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_MRecordType, StorageStrategy = SQLStorage ]
{

Relationship ChildRTCMRecordTypeVolumes As RTCMRecordTypeVolumes [ Cardinality = children, Inverse = VOLParRef ];

Relationship ChildRTCMRecordTypeLinkTypes As RTCMRecordTypeLinkTypes [ Cardinality = children, Inverse = LINKParRef ];

/// Code
Property TYPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = TYP_Code ];

/// Description
Property TYPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = TYP_Desc ];

/// Prefix
Property TYPPref As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TYP_Pref ];

/// Suffix
Property TYPSuf As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TYP_Suf ];

/// Length
Property TYPLength As %Float [ SqlColumnNumber = 6, SqlFieldName = TYP_Length ];

/// MR No Policy
Property TYPMRNoPolicy As %String(DISPLAYLIST = ",Registration No,System Generated,Manually Allocated in MR Office,Generated in MR Office,Manual or Generated in MR Office,Manual or allocated on Registration,Allocate On Registration and use as Registration,Multi Hospital", MAXLEN = 48, TRUNCATE = 1, VALUELIST = ",P,S,MO,GO,MGO,MGR,ARR,MH") [ SqlColumnNumber = 7, SqlFieldName = TYP_MRNoPolicy ];

/// Volume Type
Property TYPVolumeType As %String(DISPLAYLIST = ",Episode Based,User Defined", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",E,U") [ SqlColumnNumber = 8, SqlFieldName = TYP_VolumeType ];

/// Des Ref CTLOC
Property TYPCTLOCDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = TYP_CTLOC_DR ];

/// Counter
Property TYPCounter As %Float [ SqlColumnNumber = 10, SqlFieldName = TYP_Counter ];

/// Date From
Property TYPDateFrom As %Date [ SqlColumnNumber = 11, SqlFieldName = TYP_DateFrom ];

/// Date To
Property TYPDateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = TYP_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCMRecordType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCMRecordType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCMRecordType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTCMRecordType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTCMRecordType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RTC("TYPE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TYP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TYP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TYP_Counter">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TYP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TYP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TYP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TYP_Length">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TYP_MRNoPolicy">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TYP_Pref">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TYP_Suf">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TYP_VolumeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TYP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TYP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TYP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TYP_RowId</SqlRowIdName>
<StreamLocation>^User.RTCMRecordTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
