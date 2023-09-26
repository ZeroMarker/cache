/// Bed Details               (BED,153)
Class User.PACBed Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PAC_Bed, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On BEDChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPACBedAdm As PACBedAdm [ Cardinality = children, Inverse = ADMParRef ];

Relationship ChildPACBedExp As PACBedExp [ Cardinality = children, Inverse = EXPParRef ];

Relationship ChildPACBedDepartmentAllocation As PACBedDepartmentAllocation [ Cardinality = children, Inverse = DEPParRef ];

Relationship ChildPACBedStatusChange As PACBedStatusChange [ Cardinality = children, Inverse = STATParRef ];

Relationship ChildPACBedAvailRestriction As PACBedAvailRestriction [ Cardinality = children, Inverse = AVRParRef ];

/// Des Ref to WARD
Relationship BEDWARDParRef As PACWard [ Cardinality = parent, Inverse = ChildPACBed, Required, SqlFieldName = BED_WARD_ParRef ];

/// Des Ref to ROOM
Property BEDRoomDR As PACRoom [ InitialExpression = {$G(WARD(4))}, SqlColumnNumber = 3, SqlFieldName = BED_Room_DR ];

/// Bed Code / No
Property BEDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = BED_Code ];

/// Des Ref Bed Status
Property BEDStatusDR As PACBedStatus [ SqlColumnNumber = 8, SqlFieldName = BED_Status_DR ];

/// Des Ref to PACBT
Property BEDBedTypeDR As PACBedType [ SqlColumnNumber = 9, SqlFieldName = BED_BedType_DR ];

/// Archived Flag
Property BEDRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = BED_RcFlag ];

/// Child Sub
Property BEDChildsub As %Float [ InitialExpression = {$i(^PAWARD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"BED",0))}, Required, SqlColumnNumber = 14, SqlFieldName = BED_Childsub ];

/// Available flag
Property BEDAvailable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlComputeCode = { s {BED_Available}=$$CO18^at153({BED_RowID})
}, SqlComputed, SqlFieldName = BED_Available, Transient ];

/// Isolated Flag
Property BEDIsolated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = BED_Isolated ];

/// Isolated Date From
Property BEDIsolatedDateFrom As %Date [ SqlColumnNumber = 20, SqlFieldName = BED_IsolatedDateFrom ];

/// Isolated Date To
Property BEDIsolatedDateTo As %Date [ SqlColumnNumber = 21, SqlFieldName = BED_IsolatedDateTo ];

/// Isolated Time From
Property BEDIsolatedTimeFrom As %Time [ SqlColumnNumber = 22, SqlFieldName = BED_IsolatedTimeFrom ];

/// Isolated Time To
Property BEDIsolatedTimeTo As %Time [ SqlColumnNumber = 23, SqlFieldName = BED_IsolatedTimeTo ];

/// BillFlag1
Property BEDBillFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = BED_BillFlag1 ];

/// BillFlag2
Property BEDBillFlag2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = BED_BillFlag2 ];

/// BillFlag3
Property BEDBillFlag3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = BED_BillFlag3 ];

/// Extension No
Property BEDExtNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = BED_ExtNo ];

/// Position Left
Property BEDPositionLeft As %Float [ SqlColumnNumber = 28, SqlFieldName = BED_PositionLeft ];

/// Position Top
Property BEDPositionTop As %Float [ SqlColumnNumber = 29, SqlFieldName = BED_PositionTop ];

/// Position Width
Property BEDPositionWidth As %Float [ SqlColumnNumber = 30, SqlFieldName = BED_PositionWidth ];

/// Position Height
Property BEDPositionHeight As %Float [ SqlColumnNumber = 31, SqlFieldName = BED_PositionHeight ];

/// Sorting Order
Property BEDSortingOrder As %Float [ SqlColumnNumber = 32, SqlFieldName = BED_SortingOrder ];

/// SNAP
Property BEDSNAP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = BED_SNAP ];

/// Date From
Property BEDDateFrom As %Date [ SqlColumnNumber = 34, SqlFieldName = BED_DateFrom ];

/// Date To
Property BEDDateTo As %Date [ SqlColumnNumber = 35, SqlFieldName = BED_DateTo ];

/// 性别 add
Property BEDSex As %String(DISPLAYLIST = ",Male,Female", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",M,F") [ SqlColumnNumber = 36, SqlFieldName = BED_Sex ];

/// BEDSequence add@2020-01-17 索引 ^PAWARD(0,"Sequence",BEDWARDParRef,+BEDSequence,BEDChildsub)
Property BEDSequence As %Float [ SqlColumnNumber = 37, SqlFieldName = BED_Sequence ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACBed).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBed","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACBed).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBed","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACBed).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBed","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACBed).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBed","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACBed).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBed","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMapBED">
<Data name="BED_BedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BED_BillFlag1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BED_BillFlag2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BED_BillFlag3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BED_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BED_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BED_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BED_ExtNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BED_Isolated">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BED_IsolatedDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BED_IsolatedDateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BED_IsolatedTimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BED_IsolatedTimeTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BED_PositionHeight">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BED_PositionLeft">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BED_PositionTop">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BED_PositionWidth">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BED_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BED_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BED_SNAP">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BED_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BED_Sex">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BED_SortingOrder">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BED_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBedType">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BED_BedType_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BED_BedType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtension">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BED_ExtNo})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoom">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BED_Room_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BED_Room_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSequence">
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Sequence"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{BED_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSort">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Sort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BED_SortingOrder}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardRoom">
<Condition>{BED_Room_DR}'=""</Condition>
<Global>^PAWARD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WardRoom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BED_Room_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BED_RowID</SqlRowIdName>
<StreamLocation>^User.PACBedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
