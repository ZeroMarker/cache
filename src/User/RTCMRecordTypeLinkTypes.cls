/// MRecordTypeLinkTypes(2448)
Class User.RTCMRecordTypeLinkTypes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_MRecordTypeLinkTypes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LINKChildsub [ IdKey, PrimaryKey, Unique ];

/// RTC_MRecordType Parent Reference
Relationship LINKParRef As RTCMRecordType [ Cardinality = parent, Inverse = ChildRTCMRecordTypeLinkTypes, Required, SqlFieldName = LINK_ParRef ];

/// Childsub
Property LINKChildsub As %Float [ InitialExpression = {$i(^RTC("TYPE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LINK",0))}, SqlColumnNumber = 2, SqlFieldName = LINK_Childsub ];

/// Des Ref MRType
Property LINKMRTypeDR As RTCMRecordType [ SqlColumnNumber = 3, SqlFieldName = LINK_MRType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTCMRecordTypeLinkTypes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordTypeLinkTypes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTCMRecordTypeLinkTypes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordTypeLinkTypes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTCMRecordTypeLinkTypes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTCMRecordTypeLinkTypes","OnAfterUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="LINK_MRType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTC_MRecordType.TYP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RTC_MRecordType.TYP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LINK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLink1">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RTC_MRecordType.TYP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Link1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LINK_MRType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTC_MRecordType.TYP_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LINK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTC_MRecordType.TYP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RTC_MRecordType.TYP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LINK_MRType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LINK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LINK_RowId</SqlRowIdName>
<StreamLocation>^User.RTCMRecordTypeLinkTypesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
