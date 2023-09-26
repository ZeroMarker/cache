/// ARC Ord Set Date OS Price(1864)
Class User.ARCOrdSetDateOSPrice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetDateOSPrice, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PRICEChildsub As %Float [ InitialExpression = {$i(^ARCOS($p(%d(0),"||"),"DATE",$p(%d(0),"||",2),"OS",$p(%d(0),"||",3),"PRICE",0))}, SqlColumnNumber = 2, SqlFieldName = PRICE_Childsub ];

/// Date From
Property PRICEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = PRICE_DateFrom ];

/// Date To
Property PRICEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PRICE_DateTo ];

/// ARC_OrdSetDateOS Parent Reference
Relationship PRICEParRef As ARCOrdSetDateOS [ Cardinality = parent, Inverse = ChildARCOrdSetDateOSPrice, Required, SqlFieldName = PRICE_ParRef ];

/// Price
Property PRICEPrice As %Float [ SqlColumnNumber = 5, SqlFieldName = PRICE_Price ];

Index RowIDBasedIDKeyIndex On PRICEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetDateOSPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetDateOSPrice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetDateOSPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetDateOSPrice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetDateOSPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetDateOSPrice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOrdSetDateOSPrice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetDateOSPrice","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOrdSetDateOSPrice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOrdSetDateOSPrice","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PRICE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRICE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRICE_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_OrdSetDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ARC_OrdSetDateOS.OS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>PRICE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_OrdSetDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_OrdSetDateOS.OS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PRICE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_OrdSetDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ARC_OrdSetDateOS.OS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L10}</Expression>
<Field>PRICE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_OrdSetDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_OrdSetDateOS.OS_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="7">
<Expression>0</Expression>
</Subscript>
<Subscript name="8">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PRICE_DateFrom}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{PRICE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRICE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetDateOSPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
