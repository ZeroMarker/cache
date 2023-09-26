/// HospitalReciprocalHosp(2456)
Class User.CTHospitalReciprocalHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_HospitalReciprocalHosp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RECChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Hospital Parent Reference
Relationship RECParRef As CTHospital [ Cardinality = parent, Inverse = ChildCTHospitalReciprocalHosp, Required, SqlFieldName = REC_ParRef ];

/// Childsub
Property RECChildsub As %Float [ InitialExpression = {$i(^CT("HOSP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REC",0))}, SqlColumnNumber = 2, SqlFieldName = REC_Childsub ];

/// Des Ref Hospital
Property RECHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = REC_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHospitalReciprocalHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalReciprocalHosp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHospitalReciprocalHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalReciprocalHosp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHospitalReciprocalHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalReciprocalHosp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHospitalReciprocalHosp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalReciprocalHosp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHospitalReciprocalHosp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalReciprocalHosp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="REC_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>REC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRecHosp">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>REC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REC_Hospital_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{REC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REC_RowId</SqlRowIdName>
<StreamLocation>^User.CTHospitalReciprocalHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
