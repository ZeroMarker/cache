/// Body Site(1103)
Class User.OECBodySite Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_BodySite, StorageStrategy = SQLStorage ]
{

/// Code
Property BODSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BODS_Code ];

/// Description
Property BODSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = BODS_Desc ];

Index BODSCodeUnqIdx1 On BODSCode [ Unique ];

Parameter EXTENTSIZE = 9;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECBodySite).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECBodySite","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECBodySite).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECBodySite","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECBodySite).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECBodySite","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECBodySite).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECBodySite","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECBodySite).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECBodySite","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>9</ExtentSize>
<Property name="BODSCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="BODSDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("BODS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BODS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BODS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BODS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BODS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BODS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BODS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BODS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BODS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BODS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BODS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BODS_RowId</SqlRowIdName>
<StreamLocation>^User.OECBodySiteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
