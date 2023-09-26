/// Order Set Package Price(1458)
Class User.ARCOrdSetPrice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetPrice, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PRICEChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_OrdSets Parent Reference
Relationship PRICEParRef As ARCOrdSets [ Cardinality = parent, Inverse = ChildARCOrdSetPrice, Required, SqlFieldName = PRICE_ParRef ];

/// Childsub
Property PRICEChildsub As %Float [ InitialExpression = {$i(^ARCOS($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PRICE",0))}, SqlColumnNumber = 2, SqlFieldName = PRICE_Childsub ];

/// PRICE_DateFrom
Property PRICEDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = PRICE_DateFrom ];

/// Date To
Property PRICEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PRICE_DateTo ];

/// Des Ref Tariff
Property PRICETariffDR As ARCTariff [ SqlColumnNumber = 5, SqlFieldName = PRICE_Tariff_DR ];

/// Price
Property PRICEPrice As %Float [ SqlColumnNumber = 6, SqlFieldName = PRICE_Price ];

/// Des Ref Currency
Property PRICECurrencyDR As CTCurrency [ SqlColumnNumber = 7, SqlFieldName = PRICE_Currency_DR ];

/// Adjustment Only
Property PRICEAdjustmentOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PRICE_AdjustmentOnly ];

/// Hospital DR
Property PRICEHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = PRICE_HospitalDR ];

/// Episode Type
Property PRICEEpisodeType As %String(DISPLAYLIST = ",Emergency,HealthPromotion,InPatient,OutPatient", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",E,H,I,O") [ SqlColumnNumber = 10, SqlFieldName = PRICE_EpisodeType ];

/// Payor Share
Property PRICEPayorShare As %Float [ SqlColumnNumber = 11, SqlFieldName = PRICE_PayorShare ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetPrice).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetPrice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetPrice).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetPrice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetPrice).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetPrice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOrdSetPrice).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetPrice","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOrdSetPrice).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetPrice","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetPrice","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PRICE_AdjustmentOnly">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRICE_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
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
<Piece>8</Piece>
</Data>
<Data name="PRICE_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRICE_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
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
<Field>PRICE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRICE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTariffDate">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PRICE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Tariff"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRICE_Tariff_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRICE_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PRICE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRICE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
