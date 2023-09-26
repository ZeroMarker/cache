/// AdmissionPointHosp(2494)
Class User.PACAdmissionPointHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AdmissionPointHosp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HOSChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_AdmissionPoint Parent Reference
Relationship HOSParRef As PACAdmissionPoint [ Cardinality = parent, Inverse = ChildPACAdmissionPointHosp, Required, SqlFieldName = HOS_ParRef ];

/// Childsub
Property HOSChildsub As %Float [ InitialExpression = {$i(^PAC("ADMPOINT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HOS",0))}, SqlColumnNumber = 2, SqlFieldName = HOS_Childsub ];

/// Des Ref Hospital
Property HOSHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = HOS_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAdmissionPointHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmissionPointHosp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAdmissionPointHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmissionPointHosp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAdmissionPointHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmissionPointHosp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAdmissionPointHosp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmissionPointHosp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAdmissionPointHosp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmissionPointHosp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="HOS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_AdmissionPoint.ADMPOINT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>HOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMPOINT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_AdmissionPoint.ADMPOINT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_AdmissionPoint.ADMPOINT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>HOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMPOINT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_AdmissionPoint.ADMPOINT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HOS_Hospital_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{HOS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOS_RowId</SqlRowIdName>
<StreamLocation>^User.PACAdmissionPointHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
