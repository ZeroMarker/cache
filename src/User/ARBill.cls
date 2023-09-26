/// Old Table - To be Deleted
Class User.ARBill Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_Bill, StorageStrategy = SQLStorage ]
{

/// Add Date
Property ARBILAddDate As %Date [ InitialExpression = "T", SqlColumnNumber = 39, SqlFieldName = ARBIL_AddDate ];

/// Add Time
Property ARBILAddTime As %Time [ InitialExpression = "N", SqlColumnNumber = 40, SqlFieldName = ARBIL_AddTime ];

/// Add User ID
Property ARBILAddUserID As SSUser [ SqlColumnNumber = 38, SqlFieldName = ARBIL_AddUserID ];

/// Patient Admission Type (same as PAADM_Type)
Property ARBILAdmType As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,Pre Admission,New Born", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",I,O,E,P,N") [ SqlColumnNumber = 37, SqlFieldName = ARBIL_AdmType ];

/// Invoice Amount
Property ARBILAmount As %Float [ InitialExpression = 0.00, Required, SqlColumnNumber = 8, SqlFieldName = ARBIL_Amount ];

/// Invoice Date
Property ARBILDate As %Date [ Required, SqlColumnNumber = 7, SqlFieldName = ARBIL_Date ];

/// Expected Payment Date
Property ARBILDateCashFlow As %Date [ SqlColumnNumber = 13, SqlFieldName = ARBIL_DateCashFlow ];

/// Invoice Due Date
Property ARBILDateDue As %Date [ SqlColumnNumber = 12, SqlFieldName = ARBIL_DateDue ];

/// Invoice End Date (needed?)
Property ARBILDateEnd As %Date [ SqlColumnNumber = 11, SqlFieldName = ARBIL_DateEnd ];

/// Invoice Start Date (needed?)
Property ARBILDateStart As %Date [ SqlColumnNumber = 10, SqlFieldName = ARBIL_DateStart ];

/// Not Used Des Ref to ARCDR
Property ARBILDebtorDR As ARCDebtor [ SqlColumnNumber = 5, SqlFieldName = ARBIL_Debtor_DR ];

/// Doctor Fee Processing Flag
Property ARBILDocFeeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 35, SqlFieldName = ARBIL_DocFeeFlag ];

/// Financial Period - des ref to CTFPR
Property ARBILFinPerDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 16, SqlFieldName = ARBIL_FinPer_DR ];

/// GL Batch
Property ARBILGlBatch As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ARBIL_GlBatch ];

/// des ref to CTLOC (invoice dept)
Property ARBILLocationDR As CTLoc [ SqlColumnNumber = 33, SqlFieldName = ARBIL_Location_DR ];

/// Bill Number
Property ARBILNo As %Float(MAXVAL = 999999999, MINVAL = 0) [ InitialExpression = 0, Required, SqlColumnNumber = 3, SqlFieldName = ARBIL_No ];

/// Outstanding Amount
Property ARBILOsAmt As %Float [ InitialExpression = 0.00, SqlColumnNumber = 23, SqlFieldName = ARBIL_OsAmt ];

/// des ref to PAPER
Property ARBILPAPERDR As PAPerson [ SqlColumnNumber = 41, SqlFieldName = ARBIL_PAPER_DR ];

/// Payment Amount
Property ARBILPayAmt As %Float [ InitialExpression = 0.00, SqlColumnNumber = 9, SqlFieldName = ARBIL_PayAmt ];

/// Print Count
Property ARBILPrintCount As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 19, SqlFieldName = ARBIL_PrintCount ];

/// Archive Flag
Property ARBILRcFlg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = ARBIL_RcFlg ];

/// Remarks
Property ARBILRemark As list Of %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = ARBIL_Remark, SqlListType = SUBNODE ];

/// Billing Status
Property ARBILStatus As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ARBIL_Status ];

/// Bill Type
Property ARBILType As %String(DISPLAYLIST = ",Interim,Final,Restaurant,Cash,Other", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,F,R,C,O") [ Required, SqlColumnNumber = 28, SqlFieldName = ARBIL_Type ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARBill).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARBill","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARBill).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARBill","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARBill).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARBill","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARBill).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARBill","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARBill).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARBill","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARBIL(0))</SqlIdExpression>
<SQLMap name="DataMasterARBIL">
<Data name="ARBIL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARBIL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ARBIL_AddUserID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARBIL_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARBIL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARBIL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARBIL_DateCashFlow">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARBIL_DateDue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARBIL_DateEnd">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARBIL_DateStart">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARBIL_Debtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARBIL_DocFeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARBIL_FinPer_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARBIL_GlBatch">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARBIL_Location_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARBIL_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARBIL_OsAmt">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARBIL_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ARBIL_PayAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARBIL_PrintCount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARBIL_RcFlg">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARBIL_Remark">
<Node>"RMK"</Node>
</Data>
<Data name="ARBIL_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARBIL_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARBIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARBIL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARBIL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDebtor">
<Global>^ARBIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARBIL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARBIL_Debtor_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARBIL_Debtor_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARBIL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPERDR">
<Global>^PAPERDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARBIL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARBIL_PAPER_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BIL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARBIL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARBIL_RowId</SqlRowIdName>
<StreamLocation>^User.ARBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
