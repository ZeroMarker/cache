Class User.DHCIPBillPatOrderConfirm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ConfSub_RowId, SqlTableName = DHC_IPBillPatOrderConfirm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ConfSubChildSub [ IdKey, PrimaryKey, Unique ];

/// PBO_ChildSub
Property ConfSubChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCIPBillPatFeeConfirm($p(%d(0),$c(1),1),"O",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ConfSub_ChildSub ];

/// DHC_PatientBill Parent Reference
Relationship ConfSubParRef As User.DHCIPBillPatFeeConfirm [ Cardinality = parent, Inverse = ChildDHCIPBillPatOrderConfirm, Required, SqlFieldName = ConfSub_ParRef ];

/// ConfSub_Ord_dr
Property ConfSubOrddr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ConfSub_Ord_dr ];

/// ConfSubConfirmDate
Property ConfSubConfirmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ConfSub_ConfirmDate ];

/// ConfSubConfirmTime
Property ConfSubConfirmTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = ConfSub_ConfirmTime ];

/// ConfSubConfirmUser
Property ConfSubConfirmUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ConfSub_ConfirmUser ];

/// ConfSubConfirmStatus
Property ConfSubConfirmStatus As %Library.String(DISPLAYLIST = ",UnConfirm,Confirm,Recall,Deny", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",U,C,R,D") [ SqlColumnNumber = 7, SqlFieldName = ConfSub_ConfirmStatus ];

/// ConfSub_Ord_dr
Property ConfSubPBOdr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ConfSub_PBO_dr ];

/// ConfSub_Ord_dr
Property ConfSubRefReason As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ConfSub_RefReason ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ConfSub_ConfirmDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ConfSub_ConfirmStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ConfSub_ConfirmTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ConfSub_ConfirmUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ConfSub_Ord_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ConfSub_PBO_dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ConfSub_RefReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCIPBillPatFeeConfirm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPBillPatFeeConfirm.Confirm_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ConfSub_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_IPBillPatFeeConfirm.Confirm_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfSub_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOrd">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPBillPatFeeConfirm.Confirm_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ConfSub_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfSub_Ord_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPBillPatFeeConfirm.Confirm_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ConfSub_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofdate">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dateusr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfSub_ConfirmDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ConfSub_ConfirmUser}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_IPBillPatFeeConfirm.Confirm_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ConfSub_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofpbo">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPBillPatFeeConfirm.Confirm_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ConfSub_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ConfSub_PBO_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPBillPatFeeConfirm.Confirm_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ConfSub_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillPatOrderConfirmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
