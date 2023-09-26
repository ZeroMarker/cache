/// OE Order Accept(1691)
Class User.OEOrdAccept Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdAccept, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ACCChildsub As %Float [ InitialExpression = {$i(^OEORD($p(%d(0),$c(1)),"AC",0))}, SqlColumnNumber = 2, SqlFieldName = ACC_Childsub ];

/// Date Accepted
Property ACCDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ACC_Date ];

/// Time Doctor accepted
Property ACCDoctorTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ACC_DoctorTime ];

/// OE_Order Parent Reference
Relationship ACCParRef As OEOrder [ Cardinality = parent, Inverse = ChildOEOrdAccept, Required, SqlFieldName = ACC_ParRef ];

/// Time Pharmacist accepted
Property ACCPharmTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ACC_PharmTime ];

/// Des Ref User
Property ACCUserDoctorDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = ACC_UserDoctor_DR ];

/// Des Ref User
Property ACCUserPharmacistDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = ACC_UserPharmacist_DR ];

Index RowIDBasedIDKeyIndex On ACCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdAccept).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdAccept","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdAccept).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdAccept","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdAccept).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdAccept","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdAccept).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdAccept","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdAccept).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdAccept","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ACC_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACC_DoctorTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACC_PharmTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACC_UserDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACC_UserPharmacist_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ACC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ACC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACC_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACC_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdAcceptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
