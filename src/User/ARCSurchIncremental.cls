/// ARC Surcharge Incremental(1326)
Class User.ARCSurchIncremental Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchIncremental, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INCRChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_SurchargeCode Parent Reference
Relationship INCRParRef As ARCSurchargeCode [ Cardinality = parent, Inverse = ChildARCSurchIncremental, Required, SqlFieldName = INCR_ParRef ];

/// Childsub
Property INCRChildsub As %Float [ InitialExpression = {$i(^ARC("SURC",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INCR",0))}, SqlColumnNumber = 2, SqlFieldName = INCR_Childsub ];

/// Date From
Property INCRDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = INCR_DateFrom ];

/// Date To
Property INCRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = INCR_DateTo ];

/// Des Ref InsType
Property INCRInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = INCR_InsType_DR ];

/// Time From
Property INCRTimeFrom As %Float [ SqlColumnNumber = 6, SqlFieldName = INCR_TimeFrom ];

/// Time Until
Property INCRTimeUntil As %Float [ SqlColumnNumber = 7, SqlFieldName = INCR_TimeUntil ];

/// Increment Time
Property INCRIncremTime As %Float [ SqlColumnNumber = 8, SqlFieldName = INCR_IncremTime ];

/// Increment Price
Property INCRIncrementPrice As %Float [ SqlColumnNumber = 9, SqlFieldName = INCR_IncrementPrice ];

/// Des Ref Tariff
Property INCRTariffDR As ARCTariff [ SqlColumnNumber = 10, SqlFieldName = INCR_Tariff_DR ];

/// Des Ref AuxInstype
Property INCRAuxInstypeDR As ARCAuxilInsurType [ SqlColumnNumber = 11, SqlFieldName = INCR_AuxInstype_DR ];

/// Des Ref RoomType
Property INCRRoomTypeDR As PACRoomType [ SqlColumnNumber = 12, SqlFieldName = INCR_RoomType_DR ];

/// AmtPerMinute
Property INCRAmtPerMinute As %Float [ SqlColumnNumber = 13, SqlFieldName = INCR_AmtPerMinute ];

/// Des Ref CTCP
Property INCRCTCPDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = INCR_CTCP_DR ];

/// Des Ref EpisodeSubType
Property INCREpisodeSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 15, SqlFieldName = INCR_EpisodeSubType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchIncremental).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSurchIncremental","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchIncremental).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSurchIncremental","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchIncremental).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSurchIncremental","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchIncremental).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSurchIncremental","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchIncremental).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSurchIncremental","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSurchIncremental","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INCR_AmtPerMinute">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCR_AuxInstype_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCR_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCR_EpisodeSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCR_IncremTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCR_IncrementPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCR_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCR_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCR_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCR_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCR_TimeUntil">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INCR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INCR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsTypeDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INCR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INCR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"InsTypeDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCR_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCR_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INCR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTariffDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INCR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INCR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TarDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCR_Tariff_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCR_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INCR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchIncrementalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
