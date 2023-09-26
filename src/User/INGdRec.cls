/// IN Goods Receive         (INGR,297)
Class User.INGdRec Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_GdRec, StorageStrategy = SQLStorage ]
{

Relationship ChildINGdRecItm As INGdRecItm [ Cardinality = children, Inverse = INGRIINGRParRef ];

Relationship ChildINGdRet As INGdRet [ Cardinality = children, Inverse = INGRRINGRParRef ];

/// Goods Receive Note No
Property INGRNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ InitialExpression = "0", Required, SqlColumnNumber = 2, SqlFieldName = INGR_No ];

/// Delivery Order No
Property INGRDONo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = INGR_DO_No ];

/// Des Ref to APCVM
Property INGRAPCVMDR As APCVendor [ Required, SqlColumnNumber = 5, SqlFieldName = INGR_APCVM_DR ];

/// Date Of Delivery (DO Date)
Property INGRDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6, SqlFieldName = INGR_Date ];

/// Des Ref to CTCUR
Property INGRCTCURDR As CTCurrency [ Required, SqlColumnNumber = 7, SqlFieldName = INGR_CTCUR_DR ];

/// Exchange Rate
Property INGRExRate As %Float(MAXVAL = 999999.9999, MINVAL = 0) [ Required, SqlColumnNumber = 8, SqlComputeCode = { i {INGR_CTCUR_DR}="" s {INGR_ExRate}="" q
 i {INGR_Date}="" s {INGR_ExRate}="" q
 s {INGR_ExRate}=$$COFO08^at297({INGR_Date},{INGR_CTCUR_DR},{INGR_ExRate})
}, SqlComputed, SqlComputeOnChange = (INGRCTCURDR, INGRDate), SqlFieldName = INGR_ExRate ];

/// Handling Charges
Property INGRHandChg As %Float(MAXVAL = 99999999999, MINVAL = 0) [ InitialExpression = 0.00, Required, SqlColumnNumber = 9, SqlFieldName = INGR_HandChg ];

/// Des Ref to SSUSR
Property INGRSSUSRDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = INGR_SSUSR_DR ];

/// Remarks
Property INGRRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INGR_Remarks, SqlListType = subnode ];

/// Time of Delivery
Property INGRTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 13, SqlFieldName = INGR_Time ];

/// Overall Discount
Property INGROverallDiscount As %Float(MAXVAL = 99999.99, MINVAL = 0) [ SqlColumnNumber = 14, SqlFieldName = INGR_OverallDiscount ];

/// Purchase Order
Property INGRINPODR As INPO [ SqlColumnNumber = 15, SqlFieldName = INGR_INPO_DR ];

/// Completed Flag
Property INGRCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INGR_Completed ];

/// Docket Date
Property INGRDocketDate As %Date [ SqlColumnNumber = 17, SqlFieldName = INGR_DocketDate ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INGdRec).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRec","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INGdRec).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRec","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INGdRec).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRec","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INGdRec).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRec","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRec","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INGdRec).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRec","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INGR(0))</SqlIdExpression>
<SQLMap name="DataMasterINGR">
<Data name="INGR_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGR_CTCUR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGR_Completed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGR_DO_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGR_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGR_DocketDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGR_ExRate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGR_HandChg">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGR_INPO_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGR_OverallDiscount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGR_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INGR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGR_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^INGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPCVMDR">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGR_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDONo">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INGR_DO_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRDate">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DODate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRNo">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INGR_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINPODR">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGR_INPO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGR_RowId</SqlRowIdName>
<StreamLocation>^User.INGdRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
