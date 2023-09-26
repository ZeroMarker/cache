Class User.DHCEQLifeFee Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LF_RowID, SqlTableName = DHC_EQLifeFee, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LF_EquipDR
Property LFEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = LF_EquipDR ];

/// LF_SourceDR
Property LFSourceDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LF_SourceDR ];

/// LF_CostAllotDR
Property LFCostAllotDR As User.DHCEQCostAllot [ SqlColumnNumber = 4, SqlFieldName = LF_CostAllotDR ];

/// LF_UseFee
Property LFUseFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = LF_UseFee ];

/// LF_FeeDate
Property LFFeeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = LF_FeeDate ];

/// LF_UseLocDR
Property LFUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LF_UseLocDR ];

/// LF_ManagerLocDR
Property LFManagerLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LF_ManagerLocDR ];

/// LF_FeeTypeDR
Property LFFeeTypeDR As User.DHCEQCFeeMode [ SqlColumnNumber = 9, SqlFieldName = LF_FeeTypeDR ];

/// LF_InvoiceNo
Property LFInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = LF_InvoiceNo ];

/// LF_InvoiceDate
Property LFInvoiceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = LF_InvoiceDate ];

/// LF_InvoiceDept
Property LFInvoiceDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = LF_InvoiceDept ];

/// LF_IsInputFlag
Property LFIsInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = LF_IsInputFlag ];

/// LF_Remark
Property LFRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = LF_Remark ];

/// LF_AddUserDR
Property LFAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = LF_AddUserDR ];

/// LF_AddDate
Property LFAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = LF_AddDate ];

/// LF_AddTime
Property LFAddTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = LF_AddTime ];

/// LF_UpdateUserDR
Property LFUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = LF_UpdateUserDR ];

/// LF_UpdateDate
Property LFUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = LF_UpdateDate ];

/// LF_UpdateTime
Property LFUpdateTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = LF_UpdateTime ];

/// LF_AuditUserDR
Property LFAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = LF_AuditUserDR ];

/// LF_AuditDate
Property LFAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = LF_AuditDate ];

/// LF_AuditTime
Property LFAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = LF_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQLifeFee("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LF_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="LF_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="LF_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="LF_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="LF_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="LF_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="LF_CostAllotDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LF_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LF_FeeDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LF_FeeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LF_InvoiceDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LF_InvoiceDept">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LF_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LF_IsInputFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LF_ManagerLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="LF_SourceDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="LF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="LF_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="LF_UseFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LF_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQLifeFee</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQLifeFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LF_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQLifeFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LF_FeeTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LF_SourceDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQLifeFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
