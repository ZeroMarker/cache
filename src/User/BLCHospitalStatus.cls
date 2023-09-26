/// BLC Hospital Status(1181)
Class User.BLCHospitalStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_HospitalStatus, StorageStrategy = SQLStorage ]
{

Relationship ChildBLCHospStatInsAdjustment As BLCHospStatInsAdjustment [ Cardinality = children, Inverse = ADJParRef ];

/// Des Ref to HOSClass
Property HOSSTClassDR As BLCHospitalClass [ SqlColumnNumber = 2, SqlFieldName = HOSST_Class_DR ];

/// Date FRom
Property HOSSTDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = HOSST_DateFrom ];

/// Date To
Property HOSSTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = HOSST_DateTo ];

/// Des Ref Hospital_DR
Property HOSSTHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = HOSST_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCHospitalStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCHospitalStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCHospitalStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCHospitalStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalStatus","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCHospitalStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("HOSST",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HOSST_Class_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HOSST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HOSST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HOSST_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HOSST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HOSST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexbyfromDate">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOSST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FromDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HOSST_DateFrom}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HOSST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOSST_RowId</SqlRowIdName>
<StreamLocation>^User.BLCHospitalStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
