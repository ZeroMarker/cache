/// PAC Bed Admission(1355)
Class User.PACBedAdm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BedAdm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADMChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_Bed Parent Reference
Relationship ADMParRef As PACBed [ Cardinality = parent, Inverse = ChildPACBedAdm, Required, SqlFieldName = ADM_ParRef ];

/// Childsub
Property ADMChildsub As %Float [ InitialExpression = {$i(^PAWARDA($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"BED",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ADM",0))}, SqlColumnNumber = 2, SqlFieldName = ADM_Childsub ];

/// Des Ref PAADM
Property ADMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = ADM_PAADM_DR ];

/// Booked Status
Property ADMBookedStatus As %String(DISPLAYLIST = ",Booked,Occupied,Requested", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",B,O,R") [ SqlColumnNumber = 4, SqlFieldName = ADM_BookedStatus ];

/// Des Ref PAADM Trans
Property ADMTransDR As PAAdmTransaction [ SqlColumnNumber = 5, SqlFieldName = ADM_Trans_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACBedAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedAdm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACBedAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedAdm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACBedAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedAdm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACBedAdm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedAdm","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACBedAdm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedAdm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADM_BookedStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADM_Trans_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Field>ADM_Childsub</Field>
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
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^PAWARDA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PAC_Bed.BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAC_Bed.BED_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADM_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
