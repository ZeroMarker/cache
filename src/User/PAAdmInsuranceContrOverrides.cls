/// PA Adm Ins Contr Override(1786)
Class User.PAAdmInsuranceContrOverrides Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmInsuranceContrOverrides, StorageStrategy = SQLStorage ]
{

/// Childsub
Property COVChildsub As %Float [ InitialExpression = {$i(^PAADM($p(%d(0),"||"),"INS",$p(%d(0),"||",2),"COV",0))}, SqlColumnNumber = 2, SqlFieldName = COV_Childsub ];

/// Date
Property COVDate As %Date [ SqlColumnNumber = 3, SqlFieldName = COV_Date ];

/// Fixed Pat Share
Property COVFixedPatShare As %Float [ SqlColumnNumber = 8, SqlFieldName = COV_FixedPatShare ];

/// PA_AdmInsurance Parent Reference
Relationship COVParRef As PAAdmInsurance [ Cardinality = parent, Inverse = ChildPAAdmInsuranceContrOverrid, Required, SqlFieldName = COV_ParRef ];

/// Pay From
Property COVPayFrom As %Float [ SqlColumnNumber = 6, SqlFieldName = COV_PayFrom ];

/// Pay Until
Property COVPayUntil As %Float [ SqlColumnNumber = 7, SqlFieldName = COV_PayUntil ];

/// PayorShare
Property COVPayorShare As %Float [ SqlColumnNumber = 5, SqlFieldName = COV_PayorShare ];

/// Time
Property COVTime As %Time [ SqlColumnNumber = 4, SqlFieldName = COV_Time ];

Index RowIDBasedIDKeyIndex On COVChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmInsuranceContrOverrides).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmInsuranceContrOverrides","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmInsuranceContrOverrides).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmInsuranceContrOverrides","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmInsuranceContrOverrides).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmInsuranceContrOverrides","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmInsuranceContrOverrides).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmInsuranceContrOverrides","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmInsuranceContrOverrides).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmInsuranceContrOverrides","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="COV_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COV_FixedPatShare">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="COV_PayFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="COV_PayUntil">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COV_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="COV_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmInsurance.INS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>COV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmInsurance.INS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"COV"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COV_Childsub}</Expression>
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
<Field>PA_AdmInsurance.INS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>COV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmInsurance.INS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"COV"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{COV_Date}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{COV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>COV_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmInsuranceContrOverriS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
