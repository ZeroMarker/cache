/// ARC OrdSetDate Item Price(1863)
Class User.ARCOrdSetDateItemPrice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetDateItemPrice, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PRICEChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_OrdSetDateItem Parent Reference
Relationship PRICEParRef As ARCOrdSetDateItem [ Cardinality = parent, Inverse = ChildARCOrdSetDateItemPrice, Required, SqlFieldName = PRICE_ParRef ];

/// Childsub
Property PRICEChildsub As %Float [ InitialExpression = {$i(^ARCOS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITM",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"PRICE",0))}, SqlColumnNumber = 2, SqlFieldName = PRICE_Childsub ];

/// Date From
Property PRICEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = PRICE_DateFrom ];

/// Date To
Property PRICEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PRICE_DateTo ];

/// Des Ref Tariff
Property PRICETariffDR As ARCTariff [ SqlColumnNumber = 5, SqlFieldName = PRICE_Tariff_DR ];

/// Price
Property PRICEPrice As %Float [ SqlColumnNumber = 6, SqlFieldName = PRICE_Price ];

/// Hospital DR
Property PRICEHodpitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = PRICE_Hodpital_DR ];

/// Episode Type
Property PRICEEpisodeType As %String(DISPLAYLIST = ",Emergency,HealthPromotion,InPatient,OutPatient", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",E,H,I,O") [ SqlColumnNumber = 8, SqlFieldName = PRICE_EpisodeType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetDateItemPrice).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetDateItemPrice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetDateItemPrice).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetDateItemPrice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetDateItemPrice).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetDateItemPrice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOrdSetDateItemPrice).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetDateItemPrice","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOrdSetDateItemPrice).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetDateItemPrice","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetDateItemPrice","OnBeforeInsert")
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
<Data name="PRICE_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRICE_Hodpital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRICE_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRICE_Tariff_DR">
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
<Field>ARC_OrdSetDateItem.ITM_Childsub</Field>
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
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_OrdSetDateItem.ITM_Childsub}</Expression>
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
<Field>ARC_OrdSetDateItem.ITM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
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
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_OrdSetDateItem.ITM_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="7">
<Expression>0</Expression>
</Subscript>
<Subscript name="8">
<Expression>"Tariff"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PRICE_Tariff_DR}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{PRICE_DateFrom}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{PRICE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRICE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetDateItemPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
