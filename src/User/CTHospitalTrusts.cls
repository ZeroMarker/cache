/// CT Hospital Trusts(2001)
Class User.CTHospitalTrusts Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_HospitalTrusts, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TRUSTChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Hospital Parent Reference
Relationship TRUSTParRef As CTHospital [ Cardinality = parent, Inverse = ChildCTHospitalTrusts, Required, SqlFieldName = TRUST_ParRef ];

/// Childsub
Property TRUSTChildsub As %Float [ InitialExpression = {$i(^CT("HOSP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRUST",0))}, SqlColumnNumber = 2, SqlFieldName = TRUST_Childsub ];

/// Date From
Property TRUSTDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = TRUST_DateFrom ];

/// Date To
Property TRUSTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = TRUST_DateTo ];

/// Des Ref Trust
Property TRUSTTrustDR As PACTrust [ SqlColumnNumber = 5, SqlFieldName = TRUST_Trust_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHospitalTrusts).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalTrusts","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHospitalTrusts).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalTrusts","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHospitalTrusts).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalTrusts","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHospitalTrusts).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalTrusts","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHospitalTrusts).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalTrusts","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TRUST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRUST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRUST_Trust_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRUST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TRUST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRUST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRUST_Rowid</SqlRowIdName>
<StreamLocation>^User.CTHospitalTrustsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
