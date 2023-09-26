/// RVC Review Type(1274)
Class User.RVCReviewType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVC_ReviewType, StorageStrategy = SQLStorage ]
{

/// Code
Property RTYPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = RTYP_Code ];

/// Description
Property RTYPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RTYP_Desc ];

/// Patient Type
Property RTYPPatientType As %String(DISPLAYLIST = ",OutPatient,InPatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",O,I") [ SqlColumnNumber = 5, SqlFieldName = RTYP_PatientType ];

/// Type
Property RTYPType As %String(DISPLAYLIST = ",Upgradable,Final,Batched", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",U,F,B") [ Required, SqlColumnNumber = 4, SqlFieldName = RTYP_Type ];

Index RTYPCodeUnqIdx1 On RTYPCode [ Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVCReviewType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCReviewType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVCReviewType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCReviewType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVCReviewType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCReviewType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVCReviewType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCReviewType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVCReviewType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCReviewType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="RTYPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTYPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="RTYPPatientType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RTYPType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^RVC("RTYP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RTYP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTYP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTYP_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTYP_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RVC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RTYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RTYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RTYP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RTYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RTYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RTYP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RTYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RTYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RTYP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTYP_RowId</SqlRowIdName>
<StreamLocation>^User.RVCReviewTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
