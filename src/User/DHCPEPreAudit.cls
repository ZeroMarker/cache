Class User.DHCPEPreAudit Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PA_RowId, SqlTableName = DHC_PE_PreAudit, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreAudit";

Parameter EXTENTSIZE = 250;

/// PA_ADMType
Property PAADMType As %Library.String(COLLATION = "Exact", MAXLEN = 1, SELECTIVITY = "50.0000%", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PA_ADMType ];

/// PA_AccountAmount
Property PAAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 7, SqlFieldName = PA_AccountAmount ];

/// PA_AuditDate
Property PAAuditDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 13, SqlFieldName = PA_AuditDate ];

/// PA_AuditTime
Property PAAuditTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = PA_AuditTime ];

/// PA_AuditUser_DR
Property PAAuditUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PA_AuditUser_DR ];

/// PA_AuditedStatus
Property PAAuditedStatus As %Library.String(COLLATION = "Exact", MAXLEN = 15, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PA_AuditedStatus ];

/// PA_CRMADM
Property PACRMADM As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PA_CRMADM ];

/// PA_CancelDate
Property PACancelDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 17, SqlFieldName = PA_CancelDate ];

/// PA_CancelTime
Property PACancelTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = PA_CancelTime ];

/// PA_CancelUser_DR
Property PACancelUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PA_CancelUser_DR ];

/// PA_ChargedStatus
Property PAChargedStatus As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PA_ChargedStatus ];

/// PA_ContractNo
Property PAContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PA_ContractNo ];

/// PA_DiscountedAmount
Property PADiscountedAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 8, SqlFieldName = PA_DiscountedAmount ];

/// PA_FactAmount
Property PAFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 10, SqlFieldName = PA_FactAmount ];

/// PA_GIADM
Property PAGIADM As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PA_GIADM ];

/// PA_PrivilegeMode
Property PAPrivilegeMode As %Library.String(DISPLAYLIST = ",NoPrivilege,TotalPrivilege,OrderRebate,OrderPrivilege", MAXLEN = 14, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",NP,TP,OR,OP") [ SqlColumnNumber = 20, SqlFieldName = PA_PrivilegeMode ];

/// PA_Rebate
Property PARebate As %Library.Numeric(SCALE = 3) [ SqlColumnNumber = 6, SqlFieldName = PA_Rebate ];

/// PA_Remark
Property PARemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PA_Remark ];

/// PA_SaleAmount
Property PASaleAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 9, SqlFieldName = PA_SaleAmount ];

/// PA_Status
Property PAStatus As %Library.String(DISPLAYLIST = ",Use,NoUse", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",U,NU") [ SqlColumnNumber = 22, SqlFieldName = PA_Status ];

/// PA_Type
Property PAType As %Library.String(DISPLAYLIST = ",PreReg,AddOrder", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",PRE,ADD") [ SqlColumnNumber = 21, SqlFieldName = PA_Type ];

/// PA_CRMTeam
Property PACRMTeam As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PA_CRMTeam ];

/// PA_GTeam
Property PAGTeam As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PA_GTeam ];

/// PA_NoPrivilege
Property PANoPrivilege As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PA_NoPrivilege ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEPreA)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEPreA">
<Data name="PA_ADMType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PA_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PA_AuditedStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PA_CRMADM">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_CRMTeam">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PA_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PA_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PA_CancelUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PA_ChargedStatus">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PA_ContractNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PA_DiscountedAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PA_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PA_GIADM">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PA_GTeam">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PA_NoPrivilege">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PA_PrivilegeMode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PA_Rebate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PA_SaleAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PA_Status">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PA_Type">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCPEPreA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAStatus">
<Global>^DHCPEPreA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AStatus"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_AuditedStatus}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCRMADM">
<Global>^DHCPEPreA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CRMADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_ADMType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PA_CRMADM}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCStatus">
<Global>^DHCPEPreA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CStatus"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_ChargedStatus}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContractNo">
<Global>^DHCPEPreA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ContractNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_ContractNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGIADM">
<Global>^DHCPEPreA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GIADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_ADMType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PA_GIADM}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEPreA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
