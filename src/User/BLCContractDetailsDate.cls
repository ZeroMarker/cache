/// BLC Contract Details Date(1490)
Class User.BLCContractDetailsDate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_ContractDetailsDate, StorageStrategy = SQLStorage ]
{

Relationship ChildBLCContractDetailsDateItem As BLCContractDetailsDateItems [ Cardinality = children, Inverse = ITMParRef ];

Relationship ChildBLCContractDetailsDateSele As BLCContractDetailsDateSelection [ Cardinality = children, Inverse = SELParRef ];

/// Childsub
Property DATEChildsub As %Float [ InitialExpression = {$i(^BLC("CONTR",$p(%d(0),$c(1)),"DATE",0))}, SqlColumnNumber = 2, SqlFieldName = DATE_Childsub ];

/// Date From
Property DATEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DATE_DateFrom ];

/// Date To
Property DATEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DATE_DateTo ];

/// BLC_ContractDetails Parent Reference
Relationship DATEParRef As BLCContractDetails [ Cardinality = parent, Inverse = ChildBLCContractDetailsDate, Required, SqlFieldName = DATE_ParRef ];

/// Override VAT
Property DATEVATDR As ARCServTax [ SqlColumnNumber = 5, SqlFieldName = DATE_VAT_DR ];

Index RowIDBasedIDKeyIndex On DATEChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 41;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDate","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCContractDetailsDate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDate","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCContractDetailsDate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDate","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>41</ExtentSize>
<Property name="DATEChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DATEDateFrom">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="DATEDateTo">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DATEParRef">
<Selectivity>2.5000%</Selectivity>
</Property>
<Property name="DATEVATDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DATE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DATE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DATE_VAT_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DATE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DATE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DATE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DATE_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DATE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DATE_RowId</SqlRowIdName>
<StreamLocation>^User.BLCContractDetailsDateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
