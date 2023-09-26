/// ARC Derived Fee Rules(1699)
Class User.ARCDerivedFeeRules Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_DerivedFeeRules, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM1
Property DFRARCIM1DR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = DFR_ARCIM1_DR ];

/// Des Ref ARCIM2
Property DFRARCIM2DR As ARCItmMast [ SqlColumnNumber = 7, SqlFieldName = DFR_ARCIM2_DR ];

/// Fixed Amount
Property DFRAmount1 As %Float [ SqlColumnNumber = 5, SqlFieldName = DFR_Amount1 ];

/// Fixed Amount
Property DFRAmount2 As %Float [ SqlColumnNumber = 8, SqlFieldName = DFR_Amount2 ];

/// Amount3
Property DFRAmount3 As %Float [ SqlColumnNumber = 10, SqlFieldName = DFR_Amount3 ];

/// Code
Property DFRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DFR_Code ];

/// Description
Property DFRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DFR_Desc ];

/// Fee Per Patient
Property DFRFeePerPatient As %Float [ SqlColumnNumber = 9, SqlFieldName = DFR_FeePerPatient ];

/// Number Of Patients
Property DFRNumberOfPatients As %Float [ SqlColumnNumber = 6, SqlFieldName = DFR_NumberOfPatients ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCDerivedFeeRules).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDerivedFeeRules","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCDerivedFeeRules).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDerivedFeeRules","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCDerivedFeeRules).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDerivedFeeRules","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCDerivedFeeRules).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDerivedFeeRules","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCDerivedFeeRules).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCDerivedFeeRules","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="DFRARCIM1DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRARCIM2DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRAmount1">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRAmount2">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRAmount3">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRFeePerPatient">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DFRNumberOfPatients">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("DFR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DFR_ARCIM1_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DFR_ARCIM2_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DFR_Amount1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DFR_Amount2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DFR_Amount3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DFR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DFR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DFR_FeePerPatient">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DFR_NumberOfPatients">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DFR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DFR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DFR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DFR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DFR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DFR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DFR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DFR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DFR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DFR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DFR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DFR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCDerivedFeeRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
