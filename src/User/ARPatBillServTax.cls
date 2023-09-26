/// AR Pat Bill Serv Tax(1681)
Class User.ARPatBillServTax Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillServTax, StorageStrategy = SQLStorage ]
{

/// Base Amount
Property STBaseAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = ST_BaseAmount ];

/// Childsub
Property STChildsub As %Float [ InitialExpression = {$i(^ARPBL($p(%d(0),$c(1)),"ST",0))}, SqlColumnNumber = 2, SqlFieldName = ST_Childsub ];

/// AR_PatientBill Parent Reference
Relationship STParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillServTax, Required, SqlFieldName = ST_ParRef ];

/// Des Ref ServTax
Property STServTaxDR As ARCServTax [ SqlColumnNumber = 3, SqlFieldName = ST_ServTax_DR ];

/// Tax Rate
Property STTaxRate As %Float [ SqlColumnNumber = 4, SqlFieldName = ST_TaxRate ];

Index RowIDBasedIDKeyIndex On STChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 66;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillServTax).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillServTax","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillServTax).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillServTax","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillServTax).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillServTax","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillServTax).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillServTax","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillServTax).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillServTax","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>66</ExtentSize>
<Property name="STBaseAmount">
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="STChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="STParRef">
<Selectivity>1.5152%</Selectivity>
</Property>
<Property name="STServTaxDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="STTaxRate">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ST_BaseAmount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ST_ServTax_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ST_TaxRate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ST"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ST_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillServTaxS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
