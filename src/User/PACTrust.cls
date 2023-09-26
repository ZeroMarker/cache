/// PAC Trust(1943)
Class User.PACTrust Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Trust, StorageStrategy = SQLStorage ]
{

/// Code
Property TRUSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TRUST_Code ];

/// Description
Property TRUSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TRUST_Desc ];

/// Address
Property TRUSTAddress As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = TRUST_Address, SqlListType = SUBNODE ];

/// Des Ref Zip
Property TRUSTZipDR As CTZip [ SqlColumnNumber = 5, SqlFieldName = TRUST_Zip_DR ];

/// Des Ref City
Property TRUSTCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = TRUST_City_DR ];

/// Des Ref HCA
Property TRUSTHCADR As CTHealthCareArea [ SqlColumnNumber = 7, SqlFieldName = TRUST_HCA_DR ];

/// Logo
Property TRUSTLogo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TRUST_Logo ];

/// Date From
Property TRUSTDateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = TRUST_DateFrom ];

/// Date To
Property TRUSTDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = TRUST_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACTrust).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTrust","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACTrust).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTrust","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACTrust).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTrust","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACTrust).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTrust","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACTrust).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTrust","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("TRUST",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRUST_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="TRUST_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRUST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRUST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRUST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRUST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRUST_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRUST_Logo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRUST_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TRUST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRUST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRUST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRUST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRUST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRUST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRUST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRUST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRUST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRUST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRUST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRUST_RowId</SqlRowIdName>
<StreamLocation>^User.PACTrustS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
