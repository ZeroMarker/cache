/// ARC SurchargeSpecialist(1312)
Class User.ARCSurchSpecialist Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchSpecialist, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SPECChildsub As %Float [ InitialExpression = {$i(^ARC("SURC",$p(%d(0),$c(1)),"SPEC",0))}, SqlColumnNumber = 2, SqlFieldName = SPEC_Childsub ];

/// Date From
Property SPECDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = SPEC_DateFrom ];

/// Date To
Property SPECDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = SPEC_DateTo ];

/// Fixed Amt
Property SPECFixedAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = SPEC_FixedAmt ];

/// Description
Property SPECName As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SPEC_Name ];

/// ARC_SurchargeCode Parent Reference
Relationship SPECParRef As ARCSurchargeCode [ Cardinality = parent, Inverse = ChildARCSurchSpecialist, Required, SqlFieldName = SPEC_ParRef ];

/// % Charge
Property SPECPerc As %Float [ SqlColumnNumber = 6, SqlFieldName = SPEC_Perc ];

/// Visit Type
Property SPECVisitType As %String(DISPLAYLIST = ",Normal,First Visit,Second and Other", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 7, SqlFieldName = SPEC_VisitType ];

Index RowIDBasedIDKeyIndex On SPECChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchSpecialist).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchSpecialist","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchSpecialist).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchSpecialist","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchSpecialist).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchSpecialist","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchSpecialist).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchSpecialist","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchSpecialist).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchSpecialist","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPEC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEC_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SPEC_Name">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SPEC_Perc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPEC_VisitType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SPEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVisTypeDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>SPEC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"VisTypeDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SPEC_VisitType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SPEC_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SPEC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPEC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchSpecialistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
