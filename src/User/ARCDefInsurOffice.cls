/// ARC Default Insurance Office(1658)
Class User.ARCDefInsurOffice Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_DefInsurOffice, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property DEFINSAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 3, SqlFieldName = DEFINS_AuxInsType_DR ];

/// Des Ref Hospital
Property DEFINSHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = DEFINS_Hospital_DR ];

/// Des Ref InsAssoc
Property DEFINSInsAssocDR As ARCInsurAssociation [ SqlColumnNumber = 4, SqlFieldName = DEFINS_InsAssoc_DR ];

/// Des Ref InsType
Property DEFINSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 2, SqlFieldName = DEFINS_InsType_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCDefInsurOffice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDefInsurOffice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCDefInsurOffice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDefInsurOffice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCDefInsurOffice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDefInsurOffice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCDefInsurOffice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDefInsurOffice","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCDefInsurOffice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDefInsurOffice","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="DEFINSAuxInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEFINSHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEFINSInsAssocDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEFINSInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("DEFINS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="DEFINS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEFINS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEFINS_InsAssoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEFINS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DEFINS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFINS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEFINS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuxIns">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DEFINS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFINS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AuxIns"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEFINS_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEFINS_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DEFINS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DEFINS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFINS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEFINS_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEFINS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEFINS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCDefInsurOfficeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
