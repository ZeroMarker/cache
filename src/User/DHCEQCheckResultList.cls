Class User.DHCEQCheckResultList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CRL_RowID, SqlTableName = DHC_EQCheckResultList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CRL_CheckResultDR
Property CRLCheckResultDR As User.DHCEQCheckResult [ SqlColumnNumber = 2, SqlFieldName = CRL_CheckResultDR ];

/// CRL_EquipTypeDR
Property CRLEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 3, SqlFieldName = CRL_EquipTypeDR ];

/// CRL_FundsTypeDR
Property CRLFundsTypeDR As User.DHCEQCFundsType [ SqlColumnNumber = 6, SqlFieldName = CRL_FundsTypeDR ];

/// CRL_Hold1
Property CRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CRL_Hold1 ];

/// CRL_Hold2
Property CRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CRL_Hold2 ];

/// CRL_Hold3
Property CRLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CRL_Hold3 ];

/// CRL_Hold4
Property CRLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CRL_Hold4 ];

/// CRL_Hold5
Property CRLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CRL_Hold5 ];

/// CRL_Hold6
Property CRLHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = CRL_Hold6 ];

/// CRL_OriginDR
Property CRLOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 7, SqlFieldName = CRL_OriginDR ];

/// CRL_Other
Property CRLOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CRL_Other ];

/// CRL_ReportDepreFee
Property CRLReportDepreFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CRL_ReportDepreFee ];

/// CRL_ReportDepreTotalFee
Property CRLReportDepreTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CRL_ReportDepreTotalFee ];

/// CRL_ReportNetFee
Property CRLReportNetFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CRL_ReportNetFee ];

/// CRL_ReportOriginalFee
Property CRLReportOriginalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CRL_ReportOriginalFee ];

/// CRL_ReportOther
Property CRLReportOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CRL_ReportOther ];

/// CRL_SnapDepreFee
Property CRLSnapDepreFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CRL_SnapDepreFee ];

/// CRL_SnapDepreTotalFee
Property CRLSnapDepreTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CRL_SnapDepreTotalFee ];

/// CRL_SnapNetFee
Property CRLSnapNetFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CRL_SnapNetFee ];

/// CRL_SnapOriginalFee
Property CRLSnapOriginalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CRL_SnapOriginalFee ];

/// CRL_SnapOther
Property CRLSnapOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CRL_SnapOther ];

/// CRL_StatCatDR
Property CRLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 4, SqlFieldName = CRL_StatCatDR ];

/// CRL_StoreLocDR
Property CRLStoreLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 5, SqlFieldName = CRL_StoreLocDR ];

/// CRL_FinaceItemDR
Property CRLFinaceItemDR As User.DHCEQCFinaceItem [ SqlColumnNumber = 8, SqlFieldName = CRL_FinaceItemDR ];

/// CRL_FunctionCatDR
Property CRLFunctionCatDR As User.DHCEQCFunctionCat [ SqlColumnNumber = 9, SqlFieldName = CRL_FunctionCatDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckResultList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CRL_CheckResultDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CRL_FinaceItemDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CRL_FunctionCatDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CRL_FundsTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CRL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CRL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CRL_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CRL_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CRL_Other">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CRL_ReportDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CRL_ReportDepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CRL_ReportNetFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CRL_ReportOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CRL_ReportOther">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CRL_SnapDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CRL_SnapDepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CRL_SnapNetFee">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CRL_SnapOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CRL_SnapOther">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CRL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRL_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCheckResultList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCheckResult">
<Global>^DHCEQCheckResultList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CheckResultDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CRL_CheckResultDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckResultListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
