Class User.DHCEQAReduce Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_EQAReduce, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AR_AccessoryTypeDR
Property ARAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 3, SqlFieldName = AR_AccessoryTypeDR ];

/// AR_AuditDate
Property ARAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = AR_AuditDate ];

/// AR_AuditTime
Property ARAuditTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = AR_AuditTime ];

/// AR_AuditUserDR
Property ARAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AR_AuditUserDR ];

/// AR_Hold1
Property ARHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AR_Hold1 ];

/// AR_Hold2
Property ARHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AR_Hold2 ];

/// AR_Hold3
Property ARHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AR_Hold3 ];

/// AR_Hold4
Property ARHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AR_Hold4 ];

/// AR_Hold5
Property ARHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AR_Hold5 ];

/// AR_LocDR
Property ARLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AR_LocDR ];

/// AR_MakeDate
Property ARMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AR_MakeDate ];

/// AR_MakeTime
Property ARMakeTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AR_MakeTime ];

/// AR_MakerDR
Property ARMakerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AR_MakerDR ];

/// AR_ProviderDR
Property ARProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = AR_ProviderDR ];

/// AR_ReduceNo
Property ARReduceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AR_ReduceNo ];

/// AR_ReduceType
Property ARReduceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AR_ReduceType ];

/// AR_RejectDate
Property ARRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = AR_RejectDate ];

/// AR_RejectReason
Property ARRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AR_RejectReason ];

/// AR_RejectTime
Property ARRejectTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = AR_RejectTime ];

/// AR_RejectUserDR
Property ARRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AR_RejectUserDR ];

/// AR_Remark
Property ARRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AR_Remark ];

/// AR_Status
Property ARStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 24, SqlFieldName = AR_Status ];

/// AR_SubmitDate
Property ARSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = AR_SubmitDate ];

/// AR_SubmitTime
Property ARSubmitTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = AR_SubmitTime ];

/// AR_SubmitUserDR
Property ARSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AR_SubmitUserDR ];

/// AR_ToLocDR
Property ARToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AR_ToLocDR ];

/// AR_ToSourceID
Property ARToSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AR_ToSourceID ];

/// AR_ToType
Property ARToType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AR_ToType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAReduce("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AR_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_MakeTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_MakerDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_ReduceNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_ReduceType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AR_Status">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AR_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AR_ToSourceID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_ToType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQAReduce</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatusLoc">
<Global>^DHCEQAReduce</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StatusReturnloc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AR_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQAReduce</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AR_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AR_ReduceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AR_AuditDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAReduceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
