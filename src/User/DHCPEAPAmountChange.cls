Class User.DHCPEAPAmountChange Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APAC_RowID, SqlTableName = DHC_PE_APAmountChange, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEAPAmountChange";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APACChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_AdvancePayment Parent Reference
Relationship APACParRef As User.DHCPEAdvancePayment [ Cardinality = parent, Inverse = ChildDHCPEAPAmountChange, Required, SqlFieldName = APAC_ParRef ];

/// APAC_ChildSub
Property APACChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEAP($p(%d(0),$c(1),1),"AC",0))}, Required, SqlColumnNumber = 2, SqlFieldName = APAC_ChildSub ];

/// APAC_Type
Property APACType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = APAC_Type ];

/// APAC_Amount
Property APACAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 4, SqlFieldName = APAC_Amount ];

/// APAC_RemainAmount
Property APACRemainAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 5, SqlFieldName = APAC_RemainAmount ];

/// APAC_SourceNo
Property APACSourceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = APAC_SourceNo ];

/// APAC_UpdateDate
Property APACUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = APAC_UpdateDate ];

/// APAC_UpdateTime
Property APACUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = APAC_UpdateTime ];

/// APAC_UpdateUser_DR
Property APACUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = APAC_UpdateUser_DR ];

/// APAC_Remark
Property APACRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = APAC_Remark ];

// Property APACReportDR As User.DHCPEUSERREPORT [ SqlColumnNumber = 11, SqlFieldName = APAC_Report_DR ];

// 计费日结报表DHCINVPRTReports

/// APAC_Report_DR
Property APACReportDR As User.DHCINVPRTReports [ SqlColumnNumber = 11, SqlFieldName = APAC_Report_DR ];

/// APAC_PayMode_DR
Property APACPayModeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = APAC_PayMode_DR ];

/// APAC_1
Property APAC1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = APAC_1 ];

/// APAC_2
Property APAC2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = APAC_2 ];

/// APAC_3
Property APAC3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = APAC_3 ];

/// APAC_3
Property APAC4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = APAC_4 ];

/// APAC_Hospital_DR 院区
Property APACHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = APAC_Hospital_DR ];

/// APAC_RPDate 日结日期
Property APACRPDate As %Library.Date [ SqlColumnNumber = 18, SqlFieldName = APAC_RPDate ];

/// APAC_RPTime 日结时间
Property APACRPTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = APAC_RPTime ];

/// APAC_RPUser 日结人
Property APACRPUser As %Library.String(COLLATION = "Exact", MAXLEN = 31, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = APAC_RPUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="APAC4Index">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APAC4"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_4}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="APAC_1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APAC_2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APAC_3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="APAC_4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="APAC_Amount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APAC_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="APAC_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APAC_RPDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="APAC_RPTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="APAC_RPUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="APAC_RemainAmount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APAC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APAC_Report_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APAC_SourceNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APAC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APAC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APAC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APAC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPEAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonthReport">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MonthReport"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRPDate">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RPDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_RPDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReport">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_Report_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReportFlag">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReportFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APAC_1}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceNo">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APAC_SourceNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>APAC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APAC_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APAC_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APAC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEAPAmountChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
