/// Insurance Category(1107)
Class User.ARCInsuranceCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_InsuranceCategory, StorageStrategy = SQLStorage ]
{

Relationship ChildARCInsuranceSubcategory As ARCInsuranceSubcategory [ Cardinality = children, Inverse = SUBParRef ];

/// Code
Property INSCCode As %String(COLLATION = "Upper", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = INSC_Code ];

/// Description
Property INSCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = INSC_Desc ];

Index INSCCodeUnqIdx1 On INSCCode [ Unique ];

Parameter EXTENTSIZE = 20;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsuranceCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceCategory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsuranceCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>20</ExtentSize>
<Property name="INSCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSCDesc">
<Selectivity>6.2500%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("INSC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({INSC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INSC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INSC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsuranceCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
