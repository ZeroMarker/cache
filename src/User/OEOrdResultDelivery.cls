/// OE Ord Result Delivery(1612)
Class User.OEOrdResultDelivery Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdResultDelivery, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DELChildsub As %Float [ InitialExpression = {$i(^OEORD($p(%d(0),"||"),"I",$p(%d(0),"||",2),"RES",$p(%d(0),"||",3),"DEL",0))}, SqlColumnNumber = 2, SqlFieldName = DEL_Childsub ];

/// Date
Property DELDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DEL_Date ];

/// Delivered To
Property DELDeliveredTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DEL_DeliveredTo ];

/// DEs Ref Method
Property DELMethodDR As OECResDeliveryMethod [ SqlColumnNumber = 4, SqlFieldName = DEL_Method_DR ];

/// OE_OrdResult Parent Reference
Relationship DELParREf As OEOrdResult [ Cardinality = parent, Inverse = ChildOEOrdResultDelivery, Required, SqlFieldName = DEL_ParREf ];

/// Time
Property DELTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DEL_Time ];

/// User
Property DELUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DEL_User ];

Index RowIDBasedIDKeyIndex On DELChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdResultDelivery).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultDelivery","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdResultDelivery).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultDelivery","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdResultDelivery).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultDelivery","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdResultDelivery).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultDelivery","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdResultDelivery).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultDelivery","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DEL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEL_DeliveredTo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEL_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEL_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEL_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OE_OrdResult.RES_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>DEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdResult.RES_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DEL_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdResultDeliveryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
