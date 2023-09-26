/// OE Order category(1904)
Class User.OEOrdCateg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdCateg, StorageStrategy = SQLStorage ]
{

/// Des Ref Categ
Property CATCategDR As OECOrderCategory [ SqlColumnNumber = 2, SqlFieldName = CAT_Categ_DR ];

/// OE_Order Parent Reference
Relationship CATParRef As OEOrder [ Cardinality = parent, Inverse = ChildOEOrdCateg, Required, SqlFieldName = CAT_ParRef ];

/// Qty
Property CATQty As %Float [ SqlColumnNumber = 3, SqlFieldName = CAT_Qty ];

Index RowIDBasedIDKeyIndex On CATCategDR [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 150;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdCateg).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdCateg","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdCateg).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdCateg","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdCateg).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdCateg","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdCateg).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdCateg","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdCateg).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdCateg","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>150</ExtentSize>
<Property name="CATCategDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CATParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CATQty">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="CAT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CAT_Categ_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CAT_Categ_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CAT_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdCategS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
