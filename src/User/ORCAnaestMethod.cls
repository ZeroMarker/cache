/// Anaesthesia Method(1003)
Class User.ORCAnaestMethod Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_AnaestMethod, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCOS
Property ANMETARCOSDR As ARCOrdSets [ SqlColumnNumber = 5, SqlFieldName = ANMET_ARCOS_DR ];

/// Anaesth. Method Code
Property ANMETCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ANMET_Code ];

/// Date From
Property ANMETDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = ANMET_DateFrom ];

/// Date To
Property ANMETDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = ANMET_DateTo ];

/// Anaesth. Method Description
Property ANMETDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ANMET_Desc ];

/// Des Ref Type
Property ANMETTypeDR As ORCAnaestType [ SqlColumnNumber = 4, SqlFieldName = ANMET_Type_DR ];

Index ANMETCodeUnqIdx1 On ANMETCode [ Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCAnaestMethod).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestMethod","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCAnaestMethod).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestMethod","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCAnaestMethod).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestMethod","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCAnaestMethod).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestMethod","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCAnaestMethod).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCAnaestMethod","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="ANMETARCOSDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANMETCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANMETDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANMETDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANMETDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANMETTypeDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^ORC("ANMET",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANMET_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANMET_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANMET_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANMET_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANMET_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANMET_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANMET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANMET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANMET_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANMET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANMET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ANMET_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANMET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANMET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ANMET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ANMET_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANMET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANMET_RowId</SqlRowIdName>
<StreamLocation>^User.ORCAnaestMethodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
