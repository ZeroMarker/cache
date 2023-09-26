/// RBC Service Group Payor(1741)
Class User.RBCServiceGroupPayors Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_ServiceGroupPayors, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PAYChildsub As %Float [ InitialExpression = {$i(^RBC("SG",$p(%d(0),$c(1)),"PAY",0))}, SqlColumnNumber = 2, SqlFieldName = PAY_Childsub ];

/// Des Ref InsType
Property PAYInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = PAY_InsType_DR ];

/// Maximum Days
Property PAYMaxDays As %Float [ SqlColumnNumber = 4, SqlFieldName = PAY_MaxDays ];

/// RBC_ServiceGroup Parent Reference
Relationship PAYParREf As RBCServiceGroup [ Cardinality = parent, Inverse = ChildRBCServiceGroupPayors, Required, SqlFieldName = PAY_ParREf ];

Index RowIDBasedIDKeyIndex On PAYChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCServiceGroupPayors).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceGroupPayors","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCServiceGroupPayors).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceGroupPayors","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCServiceGroupPayors).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceGroupPayors","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCServiceGroupPayors).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceGroupPayors","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCServiceGroupPayors).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceGroupPayors","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAY_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAY_MaxDays">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_ServiceGroup.SG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PAY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_ServiceGroup.SG_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPayor">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_ServiceGroup.SG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PAY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_ServiceGroup.SG_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Payor"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAY_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PAY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAY_RowId</SqlRowIdName>
<StreamLocation>^User.RBCServiceGroupPayorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
