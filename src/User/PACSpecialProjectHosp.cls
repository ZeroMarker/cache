/// SpecialProjectHosp(2495)
Class User.PACSpecialProjectHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SpecialProjectHosp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HOSChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_SpecialProject Parent Reference
Relationship HOSParRef As PACSpecialProject [ Cardinality = parent, Inverse = ChildPACSpecialProjectHosp, Required, SqlFieldName = HOS_ParRef ];

/// Childsub
Property HOSChildsub As %Float [ InitialExpression = {$i(^PAC("SPECPRO",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HOS",0))}, SqlColumnNumber = 2, SqlFieldName = HOS_Childsub ];

/// Des Ref Hospital
Property HOSHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = HOS_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSpecialProjectHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialProjectHosp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSpecialProjectHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialProjectHosp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSpecialProjectHosp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialProjectHosp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSpecialProjectHosp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialProjectHosp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSpecialProjectHosp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSpecialProjectHosp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HOS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_SpecialProject.SPECPRO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>HOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_SpecialProject.SPECPRO_RowId}</Expression>
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
<Field>PAC_SpecialProject.SPECPRO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>HOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_SpecialProject.SPECPRO_RowId}</Expression>
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
<StreamLocation>^User.PACSpecialProjectHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
