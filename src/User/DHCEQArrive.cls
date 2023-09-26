Class User.DHCEQArrive Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = A_RowID, SqlTableName = DHC_EQArrive, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// A_ArriveNo
Property AArriveNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = A_ArriveNo ];

/// A_VendorDR
Property AVendorDR As User.DHCEQCVendor [ SqlColumnNumber = 3, SqlFieldName = A_VendorDR ];

/// A_ArriveDate
Property AArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = A_ArriveDate ];

/// A_SendUser
Property ASendUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = A_SendUser ];

/// A_SendHandler
Property ASendHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = A_SendHandler ];

/// A_SendTel
Property ASendTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = A_SendTel ];

/// A_ReceiveDR
Property AReceiveDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = A_ReceiveDR ];

/// A_LocationDR
Property ALocationDR As User.DHCEQCLocation [ SqlColumnNumber = 9, SqlFieldName = A_LocationDR ];

/// A_PackageNum
Property APackageNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = A_PackageNum ];

/// A_QuantityNum
Property AQuantityNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = A_QuantityNum ];

/// A_Status
Property AStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 1, SELECTIVITY = "20.0000%", VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 12, SqlFieldName = A_Status ];

/// A_Remark
Property ARemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = A_Remark ];

/// A_InvalidFlag
Property AInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = A_InvalidFlag ];

/// A_UpdateUserDR
Property AUpdateUserDR As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = A_UpdateUserDR ];

/// A_UpdateDate
Property AUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = A_UpdateDate ];

/// A_UpdateTime
Property AUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = A_UpdateTime ];

/// A_SubmitUserDR
Property ASubmitUserDR As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = A_SubmitUserDR ];

/// A_SubmitDate
Property ASubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = A_SubmitDate ];

/// A_SubmitTime
Property ASubmitTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = A_SubmitTime ];

/// A_AuditUserDR
Property AAuditUserDR As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = A_AuditUserDR ];

/// A_AuditDate
Property AAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = A_AuditDate ];

/// A_AuditTime
Property AAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = A_AuditTime ];

/// A_Hold1
Property AHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = A_Hold1 ];

/// A_Hold2
Property AHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = A_Hold2 ];

/// A_Hold3
Property AHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = A_Hold3 ];

/// A_Hold4
Property AHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = A_Hold4 ];

/// A_Hold5
Property AHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = A_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQArrive("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="A_ArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="A_ArriveNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="A_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="A_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="A_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="A_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="A_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="A_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="A_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="A_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="A_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="A_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="A_PackageNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="A_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="A_ReceiveDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="A_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="A_SendHandler">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="A_SendTel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="A_SendUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="A_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="A_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="A_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="A_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="A_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="A_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="A_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="A_VendorDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQArrive</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{A_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArriveDate">
<Global>^DHCEQArrive</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArriveDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{A_ArriveDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendorDR">
<Global>^DHCEQArrive</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VendorDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{A_VendorDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQArriveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
