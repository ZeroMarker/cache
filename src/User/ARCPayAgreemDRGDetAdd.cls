/// Pay Agreem DRGDet Add Ons(2308)
Class User.ARCPayAgreemDRGDetAdd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemDRGDetAdd, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADDChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PayAgreemDRGDetails Parent Reference
Relationship ADDParRef As ARCPayAgreemDRGDetails [ Cardinality = parent, Inverse = ChildARCPayAgreemDRGDetAdd, Required, SqlFieldName = ADD_ParRef ];

/// Childsub
Property ADDChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DRG",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DET",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"ADD",0))}, SqlColumnNumber = 2, SqlFieldName = ADD_Childsub ];

/// Day From
Property ADDDayFrom As %Float [ SqlColumnNumber = 3, SqlFieldName = ADD_DayFrom ];

/// Day To
Property ADDDayTo As %Float [ SqlColumnNumber = 4, SqlFieldName = ADD_DayTo ];

/// Des Ref RoomType
Property ADDRoomTypeDR As PACRoomType [ SqlColumnNumber = 5, SqlFieldName = ADD_RoomType_DR ];

/// Short Inlier Addon
Property ADDShortInlierAddon As %Float [ SqlColumnNumber = 6, SqlFieldName = ADD_ShortInlierAddon ];

/// Inlier Addon
Property ADDInlierAddon As %Float [ SqlColumnNumber = 7, SqlFieldName = ADD_InlierAddon ];

/// Outlier Addon
Property ADDOutlierAddon As %Float [ SqlColumnNumber = 8, SqlFieldName = ADD_OutlierAddon ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDRGDetAdd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetAdd","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDRGDetAdd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetAdd","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDRGDetAdd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetAdd","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemDRGDetAdd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetAdd","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemDRGDetAdd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDRGDetAdd","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADD_DayFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADD_DayTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADD_InlierAddon">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADD_OutlierAddon">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADD_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADD_ShortInlierAddon">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemDRG.DRG_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ARC_PayAgreemDRGDetails.DET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>ADD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemDRG.DRG_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_PayAgreemDRGDetails.DET_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ADD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRoomType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemDRG.DRG_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ARC_PayAgreemDRGDetails.DET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>ADD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemDRG.DRG_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_PayAgreemDRGDetails.DET_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"RoomType"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ADD_RoomType_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{ADD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADD_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemDRGDetAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
