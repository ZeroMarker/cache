/// RBC Hospital Services Price(1643)
Class User.RBCHospitalServicesPrice Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_HospitalServices_Price, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PRICEChildsub As %Float [ InitialExpression = {$i(^RBC("HSER",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PRICE",0))}, SqlColumnNumber = 2, SqlFieldName = PRICE_Childsub ];

/// Cost
Property PRICECost As %Float [ SqlColumnNumber = 7, SqlFieldName = PRICE_Cost ];

/// Des Ref Currency
Property PRICECurrencyDR As CTCurrency [ SqlColumnNumber = 10, SqlFieldName = PRICE_Currency_DR ];

/// Date From
Property PRICEDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = PRICE_DateFrom ];

/// Date To
Property PRICEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PRICE_DateTo ];

/// Doctor %
Property PRICEDoctorPerc As %Float [ SqlColumnNumber = 9, SqlFieldName = PRICE_DoctorPerc ];

/// No Of Slots
Property PRICENoOfSlots As %Float [ SqlColumnNumber = 8, SqlFieldName = PRICE_NoOfSlots ];

/// RBC_HospitalServices Parent Reference
Relationship PRICEParRef As RBCHospitalServices [ Cardinality = parent, Inverse = ChildRBCHospitalServicesPrice, Required, SqlFieldName = PRICE_ParRef ];

/// Price
Property PRICEPrice As %Float [ SqlColumnNumber = 6, SqlFieldName = PRICE_Price ];

/// Des Ref Tariff
Property PRICETariffDR As ARCTariff [ SqlColumnNumber = 5, SqlFieldName = PRICE_Tariff_DR ];

Index RowIDBasedIDKeyIndex On PRICEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCHospitalServicesPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServicesPrice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCHospitalServicesPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServicesPrice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCHospitalServicesPrice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServicesPrice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCHospitalServicesPrice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServicesPrice","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCHospitalServicesPrice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCHospitalServicesPrice","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PRICE_Cost">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRICE_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRICE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRICE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRICE_DoctorPerc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRICE_NoOfSlots">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRICE_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRICE_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_HospitalServices.HSER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PRICE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_HospitalServices.HSER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRICE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_HospitalServices.HSER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PRICE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_HospitalServices.HSER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PRICE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Tariff"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRICE_Tariff_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PRICE_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PRICE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRICE_RowId</SqlRowIdName>
<StreamLocation>^User.RBCHospitalServicesPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
