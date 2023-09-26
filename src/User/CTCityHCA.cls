/// CT City - Health Care Area(1579)
Class User.CTCityHCA Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_City_HCA, StorageStrategy = SQLStorage ]
{

/// Des Ref City
Property CITHCACityDR As CTCity [ SqlColumnNumber = 2, SqlFieldName = CITHCA_City_DR ];

/// Des Ref HCA
Property CITHCAHCADR As CTHealthCareArea [ SqlColumnNumber = 3, SqlFieldName = CITHCA_HCA_DR ];

Parameter EXTENTSIZE = 19;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCityHCA).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCityHCA","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCityHCA).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCityHCA","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCityHCA).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCityHCA","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCityHCA).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCityHCA","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCityHCA).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCityHCA","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="CITHCACityDR">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="CITHCAHCADR">
<Selectivity>14.2857%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("CITHCA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CITHCA_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CITHCA_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CITHCA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITHCA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CITHCA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCity">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CITHCA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITHCA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"City"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CITHCA_City_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CITHCA_HCA_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CITHCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHCA">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CITHCA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CITHCA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HCA"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CITHCA_HCA_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CITHCA_City_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CITHCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CITHCA_RowId</SqlRowIdName>
<StreamLocation>^User.CTCityHCAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
