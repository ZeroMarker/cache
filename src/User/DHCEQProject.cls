Class User.DHCEQProject Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = P_RowID, SqlTableName = DHC_EQProject, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// P_No
Property PNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = P_No ];

/// P_Name
Property PName As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = P_Name ];

/// P_ShortName
Property PShortName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = P_ShortName ];

/// P_Content
Property PContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = P_Content ];

/// P_Type
Property PType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = P_Type ];

/// P_Provider
Property PProvider As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = P_Provider ];

/// P_TotalFee
Property PTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = P_TotalFee ];

/// P_StartDate
Property PStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = P_StartDate ];

/// P_EndDate
Property PEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = P_EndDate ];

/// P_Status
Property PStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 11, SqlFieldName = P_Status ];

/// P_Remark
Property PRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = P_Remark ];

/// P_AddUserDR
Property PAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = P_AddUserDR ];

/// P_AddDate
Property PAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = P_AddDate ];

/// P_AddTime
Property PAddTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = P_AddTime ];

/// P_SubmitUserDR
Property PSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = P_SubmitUserDR ];

/// P_SubmitDate
Property PSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = P_SubmitDate ];

/// P_SubmitTime
Property PSubmitTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = P_SubmitTime ];

/// P_AuditUserDR
Property PAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = P_AuditUserDR ];

/// P_AuditDate
Property PAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = P_AuditDate ];

/// P_AuditTime
Property PAuditTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = P_AuditTime ];

/// P_CancelUserDR
Property PCancelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = P_CancelUserDR ];

/// P_CancelDate
Property PCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = P_CancelDate ];

/// P_CancelTime
Property PCancelTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = P_CancelTime ];

/// P_InvalidFlag
Property PInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = P_InvalidFlag ];

/// P_Hold1
Property PHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = P_Hold1 ];

/// P_Hold2
Property PHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = P_Hold2 ];

/// P_Hold3
Property PHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = P_Hold3 ];

/// P_Hold4
Property PHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = P_Hold4 ];

/// P_Hold5
Property PHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = P_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQProject("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="P_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="P_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="P_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="P_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="P_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="P_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="P_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="P_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="P_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="P_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="P_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="P_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="P_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="P_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="P_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="P_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="P_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="P_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="P_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="P_Provider">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="P_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="P_ShortName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="P_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="P_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="P_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="P_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="P_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="P_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="P_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQProject</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexProviderDR">
<Global>^DHCEQProject</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{P_Provider}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartEndDate">
<Global>^DHCEQProject</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StartEndDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{P_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{P_EndDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusProvider">
<Global>^DHCEQProject</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StatusProvider"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{P_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{P_Provider}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQProject</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>P_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{P_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{P_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQProjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
