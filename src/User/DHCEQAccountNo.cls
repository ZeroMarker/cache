Class User.DHCEQAccountNo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AN_RowID, SqlTableName = DHC_EQAccountNo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AN_AccountNo
Property ANAccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AN_AccountNo ];

/// AN_AccountDate
Property ANAccountDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = AN_AccountDate ];

/// AN_LocDR
Property ANLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AN_LocDR ];

/// AN_ProviderDR
Property ANProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = AN_ProviderDR ];

/// AN_EquipTypeDR
Property ANEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 6, SqlFieldName = AN_EquipTypeDR ];

/// AN_CheckDate
Property ANCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = AN_CheckDate ];

/// AN_CheckUser
Property ANCheckUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AN_CheckUser ];

/// AN_TotalFee
Property ANTotalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AN_TotalFee ];

/// AN_Status
Property ANStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 10, SqlFieldName = AN_Status ];

/// AN_Remark
Property ANRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AN_Remark ];

/// AN_UpdateUserDR
Property ANUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AN_UpdateUserDR ];

/// AN_UpdateDate
Property ANUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AN_UpdateDate ];

/// AN_UpdateTime
Property ANUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AN_UpdateTime ];

/// AN_SubmitUserDR
Property ANSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AN_SubmitUserDR ];

/// AN_SubmitDate
Property ANSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = AN_SubmitDate ];

/// AN_SubmitTime
Property ANSubmitTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = AN_SubmitTime ];

/// AN_AuditUserDR
Property ANAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AN_AuditUserDR ];

/// AN_AuditDate
Property ANAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = AN_AuditDate ];

/// AN_AuditTime
Property ANAuditTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = AN_AuditTime ];

/// AN_DisUseUserDR
Property ANDisUseUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AN_DisUseUserDR ];

/// AN_DisUseDate
Property ANDisUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = AN_DisUseDate ];

/// AN_DisUseTime
Property ANDisUseTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = AN_DisUseTime ];

/// AN_InvalidFlag
Property ANInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = AN_InvalidFlag ];

/// AN_Hold1
Property ANHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AN_Hold1 ];

/// AN_Hold2
Property ANHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AN_Hold2 ];

/// AN_Hold3
Property ANHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AN_Hold3 ];

/// AN_Hold4
Property ANHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AN_Hold4 ];

/// AN_Hold5
Property ANHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AN_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAccountNo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AN_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AN_AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AN_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AN_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AN_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AN_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AN_CheckUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AN_DisUseDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AN_DisUseTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AN_DisUseUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AN_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AN_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AN_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AN_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AN_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AN_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AN_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AN_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AN_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AN_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AN_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AN_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AN_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AN_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AN_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AN_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AN_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AN_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQAccountNo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AN_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccountNo">
<Global>^DHCEQAccountNo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccountNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_AccountNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQAccountNo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{AN_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQAccountNo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQAccountNo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAccountNoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
