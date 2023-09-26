/// Person Tooth History(2583)
Class User.PAPersonToothHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonToothHistory, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HISTChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PersonTooth Parent Reference
Relationship HISTParRef As PAPersonTooth [ Cardinality = parent, Inverse = ChildPAPersonToothHistory, Required, SqlFieldName = HIST_ParRef ];

/// Childsub
Property HISTChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"TOOTH",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"HIST",0))}, SqlColumnNumber = 2, SqlFieldName = HIST_Childsub ];

/// DR OEc_ToothArea
Property HISTToothAreaDR As OECToothArea [ SqlColumnNumber = 3, SqlFieldName = HIST_ToothArea_DR ];

/// OEOrdItem_DR
Property HISTOEOrdItemDR As OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = HIST_OEOrdItem_DR ];

/// Des Ref DentalState_DR
Property HISTDentalStateDR As OECDentalState [ SqlColumnNumber = 5, SqlFieldName = HIST_DentalState_DR ];

/// LastUpdateDate
Property HISTLastUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = HIST_LastUpdateDate ];

/// LastUpdateTime
Property HISTLastUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = HIST_LastUpdateTime ];

/// Des Ref LastUpdateUser_DR
Property HISTLastUpdateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = HIST_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital_DR
Property HISTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = HIST_LastUpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonToothHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonToothHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonToothHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonToothHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonToothHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonToothHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonToothHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonToothHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonToothHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonToothHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="HIST_DentalState_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HIST_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HIST_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HIST_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HIST_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HIST_OEOrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HIST_ToothArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PersonTooth.TOOTH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>HIST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TOOTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_PersonTooth.TOOTH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"HIST"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HIST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSite">
<Global>^PAPER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PersonTooth.TOOTH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>HIST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TOOTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_PersonTooth.TOOTH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"HIST"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Site"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{HIST_ToothArea_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{HIST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HIST_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonToothHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
