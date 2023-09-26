/// AR Charges Override(1649)
Class User.ARChargesOverride Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_ChargesOverride, StorageStrategy = SQLStorage ]
{

/// Des Ref OEORI
Property COVOEORIDR As OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = COV_OEORI_DR ];

/// Des Ref InsType
Property COVInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = COV_InsType_DR ];

/// Des Ref AuxInsType
Property COVAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 4, SqlFieldName = COV_AuxInsType_DR ];

/// Amount
Property COVAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = COV_Amount ];

/// Price
Property COVPrice As %Float [ SqlColumnNumber = 6, SqlFieldName = COV_Price ];

/// Percentage
Property COVPercentage As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = COV_Percentage ];

/// Des Ref Insurance Type
Property COVInsuranceExclude As ARCInsuranceType [ SqlColumnNumber = 8, SqlFieldName = COV_InsuranceExclude ];

/// Key
Property COVKey As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = COV_Key ];

/// Des Ref InsAssoc
Property COVInsAssocDR As ARCInsurAssociation [ SqlColumnNumber = 10, SqlFieldName = COV_InsAssoc_DR ];

/// Apply GST
Property COVApplyGST As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = COV_ApplyGST ];

/// Des Ref ServTax
Property COVServTaxDR As ARCServTax [ SqlColumnNumber = 12, SqlFieldName = COV_ServTax_DR ];

/// DateFrom
Property COVDateFrom As %Date [ SqlColumnNumber = 13, SqlFieldName = COV_DateFrom ];

/// DateTo
Property COVDateTo As %Date [ SqlColumnNumber = 14, SqlFieldName = COV_DateTo ];

/// ItemGroup
Property COVItemGroup As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = COV_ItemGroup ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARChargesOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARChargesOverride","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARChargesOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARChargesOverride","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARChargesOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARChargesOverride","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARChargesOverride).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARChargesOverride","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARChargesOverride).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARChargesOverride","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^AR("COV",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="COV_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="COV_ApplyGST">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="COV_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="COV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="COV_InsAssoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="COV_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COV_InsuranceExclude">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="COV_ItemGroup">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="COV_Key">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="COV_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="COV_Percentage">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="COV_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COV_ServTax_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>COV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"COV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{COV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>COV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"COV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COV_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{COV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>COV_RowId</SqlRowIdName>
<StreamLocation>^User.ARChargesOverrideS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
