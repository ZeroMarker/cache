/// ARC Service Tax         (ARCST,173)
Class User.ARCServTax Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ServTax, StorageStrategy = SQLStorage ]
{

/// Des Ref AccruedAccount
Property ARCSTAccruedAccountDR As GLCAcct [ SqlColumnNumber = 7, SqlFieldName = ARCST_AccruedAccount_DR ];

/// Service Tax Code
Property ARCSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ARCST_Code ];

/// Description
Property ARCSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ARCST_Desc ];

/// Inpatient Rate
Property ARCSTIpRate As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = ARCST_IpRate ];

/// Outpatient Rate
Property ARCSTOpRate As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = ARCST_OpRate ];

/// Archived Flag
Property ARCSTRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = {N}, SqlColumnNumber = 6, SqlFieldName = ARCST_RcFlag ];

Relationship ChildARCServTaxRate As ARCServTaxRate [ Cardinality = children, Inverse = RATParRef ];

Index ARCSTCodeUnqIdx1 On ARCSTCode [ Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCServTax).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTax","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCServTax).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTax","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCServTax).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTax","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCServTax).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTax","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCServTax).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCServTax","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ARCSTAccruedAccountDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCSTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ARCSTDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCSTIpRate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCSTOpRate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ARCSTRcFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("ARCST",0))</SqlIdExpression>
<SQLMap name="DataMasterARCST">
<Data name="ARCST_AccruedAccount_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCST_IpRate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCST_OpRate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCST_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARCST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ARCST"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARCST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCSTCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ARCST"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCST_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCSTDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ARCST"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCST_RowId</SqlRowIdName>
<StreamLocation>^User.ARCServTaxS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
