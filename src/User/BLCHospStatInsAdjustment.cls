/// HospStat Insurance Adjust(1182)
Class User.BLCHospStatInsAdjustment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_HospStatInsAdjustment, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ADJChildsub As %Float [ InitialExpression = {$i(^BLC("HOSST",$p(%d(0),$c(1)),"ADJ",0))}, SqlColumnNumber = 2, SqlFieldName = ADJ_Childsub ];

/// Date From
Property ADJDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = ADJ_DateFrom ];

/// Date To
Property ADJDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ADJ_DateTo ];

/// Des Ref InsType
Property ADJInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 6, SqlFieldName = ADJ_InsType_DR ];

/// BLC_HospitalStatus Parent Reference
Relationship ADJParRef As BLCHospitalStatus [ Cardinality = parent, Inverse = ChildBLCHospStatInsAdjustment, Required, SqlFieldName = ADJ_ParRef ];

/// % Adjustment
Property ADJPerc As %Float [ SqlColumnNumber = 5, SqlFieldName = ADJ_Perc ];

Index RowIDBasedIDKeyIndex On ADJChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCHospStatInsAdjustment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospStatInsAdjustment","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCHospStatInsAdjustment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospStatInsAdjustment","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCHospStatInsAdjustment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospStatInsAdjustment","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCHospStatInsAdjustment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospStatInsAdjustment","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCHospStatInsAdjustment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospStatInsAdjustment","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADJ_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADJ_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADJ_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADJ_Perc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_HospitalStatus.HOSST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_HospitalStatus.HOSST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADJ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsTYpeDate">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BLC_HospitalStatus.HOSST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ADJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsFrom"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADJ_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADJ_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BLC_HospitalStatus.HOSST_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADJ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeTo">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BLC_HospitalStatus.HOSST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ADJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsTo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADJ_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADJ_DateTo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BLC_HospitalStatus.HOSST_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADJ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADJ_RowId</SqlRowIdName>
<StreamLocation>^User.BLCHospStatInsAdjustmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
