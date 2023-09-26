/// ARC Service Tax Rate(1406)
Class User.ARCServTaxRate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ServTaxRate, StorageStrategy = SQLStorage ]
{

/// Childsub
Property RATChildsub As %Float [ InitialExpression = {$i(^ARC("ARCST",$p(%d(0),$c(1)),"RAT",0))}, SqlColumnNumber = 2, SqlFieldName = RAT_Childsub ];

/// Date From
Property RATDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = RAT_DateFrom ];

/// Date To
Property RATDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = RAT_DateTo ];

/// InPatient Rate
Property RATIPRate As %Float(MAXVAL = 100, MINVAL = 0) [ Required, SqlColumnNumber = 6, SqlFieldName = RAT_IPRate ];

/// OutPatient Rate
Property RATOPRate As %Float(MAXVAL = 100, MINVAL = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = RAT_OPRate ];

/// ARC_ServTax Parent Reference
Relationship RATParRef As ARCServTax [ Cardinality = parent, Inverse = ChildARCServTaxRate, Required, SqlFieldName = RAT_ParRef ];

Index RowIDBasedIDKeyIndex On RATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCServTaxRate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTaxRate","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCServTaxRate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTaxRate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCServTaxRate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTaxRate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCServTaxRate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTaxRate","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCServTaxRate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTaxRate","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="RATChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RATDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RATDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RATIPRate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RATOPRate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RATParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RAT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RAT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RAT_IPRate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RAT_OPRate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ServTax.ARCST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ARCST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ServTax.ARCST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ServTax.ARCST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ARCST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ServTax.ARCST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RAT_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RAT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCServTaxRateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
