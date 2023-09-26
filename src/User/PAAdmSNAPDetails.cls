/// AdmSNAPDetails(2475)
Class User.PAAdmSNAPDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmSNAPDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SNAPDChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_AdmSNAP Parent Reference
Relationship SNAPDParRef As PAAdmSNAP [ Cardinality = parent, Inverse = ChildPAAdmSNAPDetails, Required, SqlFieldName = SNAPD_ParRef ];

/// Childsub
Property SNAPDChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"SNAP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = SNAPD_Childsub ];

/// Date
Property SNAPDDate As %Date [ SqlColumnNumber = 3, SqlFieldName = SNAPD_Date ];

/// Des Ref ADLSubType
Property SNAPDADLSubTypeDR As PACADLSubType [ SqlColumnNumber = 4, SqlFieldName = SNAPD_ADLSubType_DR ];

/// Score
Property SNAPDScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SNAPD_Score ];

/// Des Ref Phase
Property SNAPDPhaseDR As PACSNAPPhases [ SqlColumnNumber = 6, SqlFieldName = SNAPD_Phase_DR ];

/// UpdateDate
Property SNAPDUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = SNAPD_UpdateDate ];

/// UpdateTime
Property SNAPDUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = SNAPD_UpdateTime ];

/// Des Ref UpdateUserHospital
Property SNAPDUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = SNAPD_UpdateUserHospital_DR ];

/// Des Ref UpdateUser
Property SNAPDUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = SNAPD_UpdateUser_DR ];

/// Time
Property SNAPDTime As %Time [ SqlColumnNumber = 11, SqlFieldName = SNAPD_Time ];

/// Converted
Property SNAPDConverted As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = SNAPD_Converted ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmSNAPDetails).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAPDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmSNAPDetails).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAPDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmSNAPDetails).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAPDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmSNAPDetails).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAPDetails","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmSNAPDetails).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmSNAPDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SNAPD_ADLSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNAPD_Converted">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SNAPD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNAPD_Phase_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNAPD_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SNAPD_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SNAPD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SNAPD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SNAPD_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SNAPD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmSNAP.SNAP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SNAPD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SNAP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmSNAP.SNAP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNAPD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmSNAP.SNAP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>SNAPD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SNAP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmSNAP.SNAP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SNAPD_Date}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SNAPD_ADLSubType_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SNAPD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNAPD_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmSNAPDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
