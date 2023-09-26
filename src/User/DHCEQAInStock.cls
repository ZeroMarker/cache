Class User.DHCEQAInStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AIS_RowID, SqlTableName = DHC_EQAInStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index AISInStockNoUnqIdx1 On AISInStockNo [ Unique ];

/// AIS_AccessoryTypeDR
Property AISAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 3, SqlFieldName = AIS_AccessoryTypeDR ];

/// AIS_AddDate
Property AISAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = AIS_AddDate ];

/// AIS_AddTime
Property AISAddTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = AIS_AddTime ];

/// AIS_AddUserDR
Property AISAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AIS_AddUserDR ];

/// AIS_AuditDate
Property AISAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = AIS_AuditDate ];

/// AIS_AuditTime
Property AISAuditTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = AIS_AuditTime ];

/// AIS_AuditUserDR
Property AISAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AIS_AuditUserDR ];

/// AIS_BuyLocDR
Property AISBuyLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AIS_BuyLocDR ];

/// AIS_BuyUserDR
Property AISBuyUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AIS_BuyUserDR ];

/// AIS_Hold1
Property AISHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AIS_Hold1 ];

/// AIS_Hold10
Property AISHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = AIS_Hold10 ];

/// AIS_Hold11
Property AISHold11 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = AIS_Hold11 ];

/// AIS_Hold2
Property AISHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AIS_Hold2 ];

/// AIS_Hold3
Property AISHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = AIS_Hold3 ];

/// AIS_Hold4
Property AISHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = AIS_Hold4 ];

/// AIS_Hold5
Property AISHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = AIS_Hold5 ];

/// AIS_Hold6
Property AISHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AIS_Hold6 ];

/// AIS_Hold7
Property AISHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = AIS_Hold7 ];

/// AIS_Hold8
Property AISHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = AIS_Hold8 ];

/// AIS_Hold9
Property AISHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = AIS_Hold9 ];

/// AIS_InDate
Property AISInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = AIS_InDate ];

/// AIS_InStockNo
Property AISInStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 45, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AIS_InStockNo ];

/// AIS_InType
Property AISInType As %Library.String(DISPLAYLIST = ",采购,盘盈,捐赠,分解,其他", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,9") [ SqlColumnNumber = 8, SqlFieldName = AIS_InType ];

/// AIS_LocDR
Property AISLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AIS_LocDR ];

/// AIS_ProviderDR
Property AISProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 9, SqlFieldName = AIS_ProviderDR ];

/// AIS_RejectDate
Property AISRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = AIS_RejectDate ];

/// AIS_RejectReason
Property AISRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AIS_RejectReason ];

/// AIS_RejectTime
Property AISRejectTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = AIS_RejectTime ];

/// AIS_RejectUserDR
Property AISRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AIS_RejectUserDR ];

/// AIS_Remark
Property AISRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AIS_Remark ];

/// AIS_RequestDate
Property AISRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = AIS_RequestDate ];

/// AIS_RequestUserDR
Property AISRequestUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AIS_RequestUserDR ];

/// AIS_SourceID
Property AISSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AIS_SourceID ];

/// AIS_Status
Property AISStatus As %Library.String(DISPLAYLIST = ",新增,提交,记账,作废", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 17, SqlFieldName = AIS_Status ];

/// AIS_SubmitDate
Property AISSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = AIS_SubmitDate ];

/// AIS_SubmitTime
Property AISSubmitTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = AIS_SubmitTime ];

/// AIS_SubmitUserDR
Property AISSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AIS_SubmitUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAInStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AIS_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIS_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AIS_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AIS_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AIS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AIS_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AIS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AIS_BuyLocDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AIS_BuyUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AIS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AIS_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="AIS_Hold11">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="AIS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AIS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AIS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AIS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AIS_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AIS_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AIS_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="AIS_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="AIS_InDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AIS_InStockNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AIS_InType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AIS_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AIS_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AIS_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AIS_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AIS_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AIS_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AIS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AIS_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AIS_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AIS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AIS_Status">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AIS_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AIS_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AIS_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCEQAInStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AIS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInStockNo">
<Global>^DHCEQAInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIS_InStockNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQAInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIS_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQAInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIS_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQAInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AIS_RowID</Field>
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
<Expression>{AIS_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AIS_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAInStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
