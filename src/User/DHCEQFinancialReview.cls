Class User.DHCEQFinancialReview Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQFinancialReview, StorageStrategy = SQLStorage ]
{

/// FR_BussinessType
Property FRBussinessType As %String(DISPLAYLIST = ",入库,转移,退货,减少,报废,台帐,折旧,调账", MAXLEN = 2, VALUELIST = ",RK,ZY,TH,JS,BF,TZ,ZJ,CA") [ SqlColumnNumber = 2, SqlFieldName = FR_BussinessType ];

/// FR_BussinessNo
Property FRBussinessNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FR_BussinessNo ];

/// FR_EquipTypeIDs
Property FREquipTypeIDs As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = FR_EquipTypeIDs ];

/// FR_PDFName
Property FRPDFName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FR_PDFName ];

/// FR_BussinessSDate
Property FRBussinessSDate As %Date [ SqlColumnNumber = 6, SqlFieldName = FR_BussinessSDate ];

/// FR_BussinessEDate
Property FRBussinessEDate As %Date [ SqlColumnNumber = 7, SqlFieldName = FR_BussinessEDate ];

/// FR_CreateType
Property FRCreateType As %String(DISPLAYLIST = ",自动任务,接口调用,手动生成", MAXLEN = 2, VALUELIST = ",1,2,3") [ SqlColumnNumber = 8, SqlFieldName = FR_CreateType ];

/// FR_CreateUserDR
Property FRCreateUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = FR_CreateUserDR ];

/// FR_CreateDate
Property FRCreateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = FR_CreateDate ];

/// FR_CreateTime
Property FRCreateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = FR_CreateTime ];

/// FR_SubmitUserDR
Property FRSubmitUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FR_SubmitUserDR ];

/// FR_SubmitDate
Property FRSubmitDate As %Date [ SqlColumnNumber = 13, SqlFieldName = FR_SubmitDate ];

/// FR_SubmitTime
Property FRSubmitTime As %Time [ SqlColumnNumber = 14, SqlFieldName = FR_SubmitTime ];

/// FR_AuditUserDR
Property FRAuditUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = FR_AuditUserDR ];

/// FR_AuditDate
Property FRAuditDate As %Date [ SqlColumnNumber = 16, SqlFieldName = FR_AuditDate ];

/// FR_AuditTime
Property FRAuditTime As %Time [ SqlColumnNumber = 17, SqlFieldName = FR_AuditTime ];

/// FR_CancelUserDR
Property FRCancelUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = FR_CancelUserDR ];

/// FR_CancelDate
Property FRCancelDate As %Date [ SqlColumnNumber = 19, SqlFieldName = FR_CancelDate ];

/// FR_CancelTime
Property FRCancelTime As %Time [ SqlColumnNumber = 20, SqlFieldName = FR_CancelTime ];

/// FR_CancelReason
Property FRCancelReason As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = FR_CancelReason ];

/// FR_Status
Property FRStatus As %String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 22, SqlFieldName = FR_Status ];

/// FR_InvalidFlag
Property FRInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = FR_InvalidFlag ];

/// FR_Remark
Property FRRemark As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = FR_Remark ];

/// FR_AccountFlag
Property FRAccountFlag As %String(DISPLAYLIST = ",未传输,未做账,已做账", MAXLEN = 2, VALUELIST = ",0,1,2") [ SqlColumnNumber = 25, SqlFieldName = FR_AccountFlag ];

/// FR_AccountDate
Property FRAccountDate As %Date [ SqlColumnNumber = 26, SqlFieldName = FR_AccountDate ];

/// FR_AccountTime
Property FRAccountTime As %Time [ SqlColumnNumber = 27, SqlFieldName = FR_AccountTime ];

/// FR_Voucher
Property FRVoucher As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = FR_Voucher ];

/// FR_Month
Property FRMonth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = FR_Month ];

/// FR_HospitalDR
Property FRHospitalDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = FR_HosptialDR ];

/// FR_Hold1
Property FRHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = FR_Hold1 ];

/// FR_Hold2
Property FRHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = FR_Hold2 ];

/// FR_Hold3
Property FRHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = FR_Hold3 ];

/// FR_Hold4
Property FRHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = FR_Hold4 ];

/// FR_Hold5
Property FRHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = FR_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQFinancialReview("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FR_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="FR_AccountFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="FR_AccountTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="FR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="FR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="FR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="FR_BussinessEDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FR_BussinessNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FR_BussinessSDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FR_BussinessType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="FR_CancelReason">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="FR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="FR_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="FR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FR_CreateType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FR_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FR_EquipTypeIDs">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="FR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="FR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="FR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="FR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="FR_HosptialDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="FR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="FR_Month">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="FR_PDFName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="FR_Status">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="FR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="FR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="FR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FR_Voucher">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCEQFinancialReview</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBussinessNo">
<Global>^DHCEQFinancialReview</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BussinessNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FR_BussinessNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusType">
<Global>^DHCEQFinancialReview</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FR_RowID</Field>
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
<Expression>{FR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FR_BussinessType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQFinancialReviewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
