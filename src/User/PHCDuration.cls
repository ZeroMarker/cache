/// PHC Duration            (PHCDU,129)
Class User.PHCDuration Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_Duration, StorageStrategy = SQLStorage ]
{

/// Code
Property PHCDUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCDU_Code ];

/// Description (Local Language)
Property PHCDUDesc1 As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = PHCDU_Desc1 ];

/// Description (Foreign Language)
Property PHCDUDesc2 As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCDU_Desc2 ];

/// Factor
Property PHCDUFactor As %Float(MAXVAL = 99999999, MINVAL = 0) [ Required, SqlColumnNumber = 3, SqlFieldName = PHCDU_Factor ];

/// Date From
Property PHCDUDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = PHCDU_DateFrom ];

/// Date To
Property PHCDUDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = PHCDU_DateTo ];

Parameter EXTENTSIZE = 14;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDuration).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDuration","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDuration).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDuration","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDuration).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDuration","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDuration).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDuration","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDuration).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDuration","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>14</ExtentSize>
<Property name="PHCDUCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCDUDesc1">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCDUDesc2">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCDUFactor">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PHCDU(0))</SqlIdExpression>
<SQLMap name="DataMasterPHCDU">
<Data name="PHCDU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCDU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCDU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCDU_Desc1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCDU_Desc2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCDU_Factor">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCDU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCDU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCDU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCDUCode">
<Global>^PHCDU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCDU_RowId</Field>
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
<Expression>$$ALPHAUP({PHCDU_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCDUDesc1">
<Global>^PHCDU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCDU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCDU_Desc1})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCDU_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDurationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
