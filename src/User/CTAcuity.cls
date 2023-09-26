/// CT Acuity Level           (CTACU,1)
Class User.CTAcuity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Acuity, StorageStrategy = SQLStorage ]
{

/// Acuity Level Code
Property CTACUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTACU_Code ];

/// Acuity Level Description
Property CTACUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTACU_Desc ];

/// Waitnig Time (min)
Property CTACUWaitTime As %Float [ SqlColumnNumber = 5, SqlFieldName = CTACU_WaitTime ];

/// Icon Name
Property CTACUIconName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CTACU_IconName ];

/// Warning Time
Property CTACUWarningTime As %Float [ SqlColumnNumber = 7, SqlFieldName = CTACU_WarningTime ];

/// Unreasonable Time
Property CTACUUnreasonableTime As %Float [ SqlColumnNumber = 8, SqlFieldName = CTACU_UnreasonableTime ];

/// Activity Point
Property CTACUActivityPoint As %Float [ SqlColumnNumber = 9, SqlFieldName = CTACU_ActivityPoint ];

/// Date From
Property CTACUDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = CTACU_DateFrom ];

/// Date To
Property CTACUDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = CTACU_DateTo ];

/// NationalCode
Property CTACUNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CTACU_NationalCode ];

/// 颜色 add by sunfengchao 2017-03-17
Property CTACUColour As %String(MAXLEN = 7) [ SqlColumnNumber = 13, SqlFieldName = CTACU_Colour ];

Index CTACUCodeUnqIdx1 On CTACUCode [ Unique ];

Index CTACUDescUnqIdx2 On CTACUDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTAcuity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAcuity","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTAcuity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAcuity","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTAcuity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAcuity","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTAcuity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAcuity","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTAcuity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAcuity","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("ACU",0))</SqlIdExpression>
<SQLMap name="DataMasterCTACU">
<Data name="CTACU_ActivityPoint">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTACU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTACU_Colour">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTACU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTACU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTACU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTACU_IconName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTACU_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTACU_UnreasonableTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTACU_WaitTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTACU_WarningTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTACU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ACU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTACU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTACUCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTACU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ACU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTACU_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTACU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTACUDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTACU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ACU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTACU_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTACU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTACU_RowId</SqlRowIdName>
<StreamLocation>^User.CTAcuityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
