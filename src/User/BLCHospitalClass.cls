/// BLC Hospital Class(1180)
Class User.BLCHospitalClass Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_HospitalClass, StorageStrategy = SQLStorage ]
{

/// Code
Property HOSCLCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HOSCL_Code ];

/// Description
Property HOSCLDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = HOSCL_Desc ];

Index HOSCLCodeUnqIdx1 On HOSCLCode [ Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCHospitalClass).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalClass","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCHospitalClass).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalClass","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCHospitalClass).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalClass","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCHospitalClass).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalClass","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCHospitalClass).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCHospitalClass","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="HOSCLCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="HOSCLDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("HOSCL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HOSCL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HOSCL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HOSCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HOSCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HOSCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HOSCL_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HOSCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HOSCL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOSCL_RowId</SqlRowIdName>
<StreamLocation>^User.BLCHospitalClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
