/// PAC Counter Type(1532)
Class User.PACCounterType Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CounterType, StorageStrategy = SQLStorage ]
{

/// Counter
Property CNTCounter As %Float [ SqlColumnNumber = 6, SqlFieldName = CNT_Counter ];

/// Description
Property CNTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CNT_Desc ];

/// Length
Property CNTLength As %Float [ Required, SqlColumnNumber = 5, SqlFieldName = CNT_Length ];

/// Prefix
Property CNTPrefix As %String(COLLATION = "AlphaUp", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CNT_Prefix ];

/// Suffix
Property CNTSuffix As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CNT_Suffix ];

Index CNTDescUnqIdx1 On CNTDesc [ Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACCounterType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACCounterType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACCounterType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACCounterType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACCounterType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="CNTCounter">
<Selectivity>1</Selectivity>
</Property>
<Property name="CNTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CNTLength">
<Selectivity>1</Selectivity>
</Property>
<Property name="CNTPrefix">
<Selectivity>1</Selectivity>
</Property>
<Property name="CNTSuffix">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("CNTTYPE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CNT_Counter">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CNT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CNT_Length">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CNT_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CNT_Suffix">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^COUNT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CNT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CNTTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CNT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^COUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CNT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CNTTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CNT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CNT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CNT_RowId</SqlRowIdName>
<StreamLocation>^User.PACCounterTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
