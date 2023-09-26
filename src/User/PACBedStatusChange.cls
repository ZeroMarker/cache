/// PAC Bed Status Change(1485)
Class User.PACBedStatusChange Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BedStatusChange, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STATChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_Bed Parent Reference
Relationship STATParRef As PACBed [ Cardinality = parent, Inverse = ChildPACBedStatusChange, Required, SqlFieldName = STAT_ParRef ];

/// Childsub
Property STATChildsub As %Float [ InitialExpression = {$i(^PAWARDA($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"BED",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"STAT",0))}, SqlColumnNumber = 2, SqlFieldName = STAT_Childsub ];

/// Date
Property STATDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = STAT_Date ];

/// Time
Property STATTime As %Time [ Required, SqlColumnNumber = 4, SqlFieldName = STAT_Time ];

/// Des Ref Status
Property STATStatusDR As PACBedStatus [ SqlColumnNumber = 5, SqlFieldName = STAT_Status_DR ];

/// Des Ref User
Property STATUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = STAT_User_DR ];

/// Date To
Property STATDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = STAT_DateTo ];

/// Time To
Property STATTimeTo As %Time [ SqlColumnNumber = 8, SqlFieldName = STAT_TimeTo ];

/// Des Ref ReasonNotAvail
Property STATReasonNotAvailDR As PACBedReasonNotAvail [ SqlColumnNumber = 9, SqlFieldName = STAT_ReasonNotAvail_DR ];

/// UpdateDate
Property STATUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = STAT_UpdateDate ];

/// UpdateTime
Property STATUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = STAT_UpdateTime ];

/// Des Ref UpdateHospital
Property STATUpdateHospitalDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = STAT_UpdateHospital_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACBedStatusChange).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedStatusChange","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACBedStatusChange).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedStatusChange","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACBedStatusChange).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedStatusChange","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACBedStatusChange).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedStatusChange","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedStatusChange","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACBedStatusChange).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedStatusChange","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="STAT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STAT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STAT_ReasonNotAvail_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STAT_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STAT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STAT_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STAT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STAT_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STAT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STAT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAWARDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAC_Bed.BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>STAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Bed.BED_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^PAWARDA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAC_Bed.BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>STAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Bed.BED_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{STAT_Date}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{STAT_Time}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{STAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STAT_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedStatusChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
