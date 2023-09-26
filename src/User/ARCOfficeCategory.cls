/// ARC Office Category(1656)
Class User.ARCOfficeCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OfficeCategory, StorageStrategy = SQLStorage ]
{

/// Code
Property OFCATCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OFCAT_Code ];

/// Description
Property OFCATDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OFCAT_Desc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOfficeCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOfficeCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOfficeCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOfficeCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOfficeCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOfficeCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOfficeCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOfficeCategory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOfficeCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCOfficeCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="OFCATCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OFCATDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("OFCAT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OFCAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OFCAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OFCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OFCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OFCAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OFCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OFCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OFCAT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OFCAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OFCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OFCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OFCAT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OFCAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OFCAT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOfficeCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
