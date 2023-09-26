Class User.DHCEQLandLendRentInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LLR_RowID, SqlTableName = DHC_EQLandLendRentInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LLR_LandDR
Property LLRLandDR As User.DHCEQLand [ SqlColumnNumber = 2, SqlFieldName = LLR_LandDR ];

/// LLR_Area
Property LLRArea As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = LLR_Area ];

/// LLR_UseLocDR
Property LLRUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LLR_UseLocDR ];

/// LLR_LendTypeDR
Property LLRLendTypeDR As User.DHCEQCLendType [ SqlColumnNumber = 5, SqlFieldName = LLR_LendTypeDR ];

/// LLR_Company
Property LLRCompany As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = LLR_Company ];

/// LLR_ContractPerson
Property LLRContractPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LLR_ContractPerson ];

/// LLR_Purpose
Property LLRPurpose As User.DHCEQCLandPurpose [ SqlColumnNumber = 8, SqlFieldName = LLR_Purpose ];

/// LLR_OriginalFee
Property LLROriginalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = LLR_OriginalFee ];

/// LLR_RentFee
Property LLRRentFee As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = LLR_RentFee ];

/// LLR_RentFeeType
Property LLRRentFeeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = LLR_RentFeeType ];

/// LLR_BeginDate
Property LLRBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = LLR_BeginDate ];

/// LLR_EndDate
Property LLREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = LLR_EndDate ];

/// LLR_UserDR
Property LLRUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = LLR_UserDR ];

/// LLR_Date
Property LLRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = LLR_Date ];

/// LLR_SubmitUserDR
Property LLRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = LLR_SubmitUserDR ];

/// LLR_SubmitDate
Property LLRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = LLR_SubmitDate ];

/// LLR_SubmitTime
Property LLRSubmitTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = LLR_SubmitTime ];

/// LLR_AuditUserDR
Property LLRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = LLR_AuditUserDR ];

/// LLR_AuditDate
Property LLRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = LLR_AuditDate ];

/// LLR_AuditTime
Property LLRAuditTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = LLR_AuditTime ];

/// LLR_Status
Property LLRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 22, SqlFieldName = LLR_Status ];

/// LLR_Hold1
Property LLRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = LLR_Hold1 ];

/// LLR_Hold2
Property LLRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = LLR_Hold2 ];

/// LLR_Hold3
Property LLRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = LLR_Hold3 ];

/// LLR_Hold4
Property LLRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = LLR_Hold4 ];

/// LLR_Hold5
Property LLRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = LLR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQLANDLENDRENTINFO("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LLR_Area">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LLR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="LLR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="LLR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="LLR_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LLR_Company">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LLR_ContractPerson">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LLR_Date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="LLR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LLR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="LLR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="LLR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="LLR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="LLR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="LLR_LandDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LLR_LendTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LLR_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LLR_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LLR_RentFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LLR_RentFeeType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LLR_Status">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="LLR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="LLR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="LLR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="LLR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LLR_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQLandLendRentInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LLR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LLR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBeginDate">
<Global>^DHCEQLandLendRentInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LLR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BeginDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LLR_LendTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LLR_BeginDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LLR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLand">
<Global>^DHCEQLandLendRentInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LLR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Land"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LLR_LandDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LLR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQLandLendRentInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
