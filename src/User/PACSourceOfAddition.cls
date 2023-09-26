/// PAC Source Of Addition(1954)
Class User.PACSourceOfAddition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SourceOfAddition, StorageStrategy = SQLStorage ]
{

/// Code
Property SADDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SADD_Code ];

/// Date From
Property SADDDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = SADD_DateFrom ];

/// Date To
Property SADDDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = SADD_DateTo ];

/// Description
Property SADDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SADD_Desc ];

/// National Code
Property SADDNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SADD_NationCode ];

/// Referrer Type
Property SADDRefType As %String(DISPLAYLIST = ",Doctor,Consultant,Dentist,CareProvider,Others", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",GP,CONS,DENT,CP,O") [ SqlColumnNumber = 4, SqlFieldName = SADD_RefType ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSourceOfAddition).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSourceOfAddition).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSourceOfAddition).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSourceOfAddition).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSourceOfAddition).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="SADDCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SADDDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="SADDDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="SADDDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SADDNationCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SADDRefType">
<Selectivity>20.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("SADD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SADD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SADD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SADD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SADD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SADD_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SADD_RefType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SADD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SADD_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SADD_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SADD_RowId</SqlRowIdName>
<StreamLocation>^User.PACSourceOfAdditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
