/// PHC Form                 (PHCF,556)
Class User.PHCForm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_Form, StorageStrategy = SQLStorage ]
{

/// Code
Property PHCFCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCF_Code ];

/// Description
Property PHCFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PHCF_Desc ];

/// TIMS No
Property PHCFTIMSno As %String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCF_TIMSno ];

Index PHCFCodeUnqIdx1 On PHCFCode [ Unique ];

Parameter EXTENTSIZE = 265;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCForm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCForm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCForm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCForm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCForm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCForm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCForm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCForm","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCForm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCForm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>265</ExtentSize>
<Property name="PHCFCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCFDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCFTIMSno">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PHCF(0))</SqlIdExpression>
<SQLMap name="DataMasterPHCF">
<Data name="PHCF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCF_TIMSno">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHCF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCFCode">
<Global>^PHCF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCF_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCFDesc">
<Global>^PHCF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCF_RowId</SqlRowIdName>
<StreamLocation>^User.PHCFormS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
