Class User.DHCDocIPBookingStateChange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPBSC_RowId, SqlTableName = DHCDocIPBookingStateChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000000;

Index RowIDBasedIDKeyIndex On (IPBSCParRef, IPBSCChildSub) [ IdKey, PrimaryKey, Unique ];

/// IPBSC_ParRef
Property IPBSCParRef As User.DHCDocIPBooking [ Required, SqlColumnNumber = 2, SqlFieldName = IPBSC_ParRef ];

/// IPBSC_Childsub
Property IPBSCChildSub As %Float(MINVAL = 1) [ InitialExpression = {$i(^DHCDocIPBKStatus(+$s($d(initvalue):initvalue,1:%d(2))))}, Required, SqlColumnNumber = 3, SqlFieldName = IPBSC_ChildSub ];

/// IPBSC_Date
Property IPBSCDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = IPBSC_Date ];

/// IPBSC_Time
Property IPBSCTime As %Time [ SqlColumnNumber = 5, SqlFieldName = IPBSC_Time ];

Property IPBSCStatusDR As User.DHCDocIPBDictory [ Required, SqlColumnNumber = 6, SqlFieldName = IPBSC_Status_DR ];

Property IPBSCUpUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = IPBSC_UpUser_DR ];

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IPBSC_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPBSC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPBSC_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPBSC_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPBSC_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPBSC_UpUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocIPBKStatus</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPBSC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>IPBSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IPBSC_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{IPBSC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIPBSCDate">
<Global>^DHCDocIPBKStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IPBSC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>IPBSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPBSC_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPBSC_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPBSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCDocIPBKStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPBSC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>IPBSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPBSC_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPBSC_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPBSC_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPBSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="InsexUpUser">
<Global>^DHCDocIPBKStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPBSC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>IPBSC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UPUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPBSC_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPBSC_UpUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPBSC_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPBSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IPBSC_RowId</SqlRowIdName>
<StreamLocation>^DHCDocIPBKStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
