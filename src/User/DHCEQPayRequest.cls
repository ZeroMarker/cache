Class User.DHCEQPayRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PR_RowID, SqlTableName = DHC_EQPayRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PR_AccountDate
Property PRAccountDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PR_AccountDate ];

/// PR_Agent
Property PRAgent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PR_Agent ];

/// PR_AuditDate
Property PRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = PR_AuditDate ];

/// PR_AuditTime
Property PRAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = PR_AuditTime ];

/// PR_AuditUserDR
Property PRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PR_AuditUserDR ];

/// PR_Bank
Property PRBank As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PR_Bank ];

/// PR_BankAccount
Property PRBankAccount As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PR_BankAccount ];

/// PR_DisUseDate
Property PRDisUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = PR_DisUseDate ];

/// PR_DisUseTime
Property PRDisUseTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = PR_DisUseTime ];

/// PR_DisUseUserDR
Property PRDisUseUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PR_DisUseUserDR ];

/// PR_Hold1
Property PRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PR_Hold1 ];

/// PR_Hold2
Property PRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PR_Hold2 ];

/// PR_Hold3
Property PRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PR_Hold3 ];

/// PR_Hold4
Property PRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PR_Hold4 ];

/// PR_Hold5
Property PRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = PR_Hold5 ];

/// PR_InvalidFlag
Property PRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PR_InvalidFlag ];

/// PR_LocDR
Property PRLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PR_LocDR ];

/// PR_MakeDate
Property PRMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PR_MakeDate ];

/// PR_PayFromType
Property PRPayFromType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PR_PayFromType ];

/// PR_PayMode
Property PRPayMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PR_PayMode ];

/// PR_ProviderDR
Property PRProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = PR_ProviderDR ];

/// PR_PurposeTypeDR
Property PRPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 10, SqlFieldName = PR_PurposeTypeDR ];

/// PR_Remark
Property PRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PR_Remark ];

/// PR_RequestNo
Property PRRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PR_RequestNo ];

/// PR_SourceType
Property PRSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PR_SourceType ];

/// PR_Status
Property PRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 13, SqlFieldName = PR_Status ];

/// PR_SubmitDate
Property PRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = PR_SubmitDate ];

/// PR_SubmitTime
Property PRSubmitTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = PR_SubmitTime ];

/// PR_SubmitUserDR
Property PRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PR_SubmitUserDR ];

/// PR_TotalFee
Property PRTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PR_TotalFee ];

/// PR_UpdateDate
Property PRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PR_UpdateDate ];

/// PR_UpdateTime
Property PRUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = PR_UpdateTime ];

/// PR_UpdateUserDR
Property PRUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PR_UpdateUserDR ];

/// PR_GetPayFlag
Property PRGetPayFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = PR_GetPayFlag ];

/// PR_HospBank
Property PRHospBank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PR_HospBank ];

/// PR_HospBankNo
Property PRHospBankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PR_HospBankNo ];

/// PR_CheckNo
Property PRCheckNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PR_CheckNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPayRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PR_Agent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PR_Bank">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_BankAccount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PR_CheckNo">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PR_DisUseDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PR_DisUseTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PR_DisUseUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PR_GetPayFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PR_HospBank">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PR_HospBankNo">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PR_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PR_PayFromType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PR_PayMode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PR_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PR_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PR_Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PR_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQPayRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQPayRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PR_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQPayRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PR_RowID</Field>
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
<Expression>{PR_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQPayRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ReqesutNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PR_RequestNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQPayRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPayRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
