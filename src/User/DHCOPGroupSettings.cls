Class User.DHCOPGroupSettings Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GS_RowID, SqlTableName = DHC_OPGroupSettings, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCOPGSPayMode As User.DHCOPGSPayMode [ Cardinality = children, Inverse = GSPMParRef ];

Relationship ChildDHCOPGSRecLoc As User.DHCOPGSRecLoc [ Cardinality = children, Inverse = GSRLParRef ];

Relationship ChildDHCOPGSPrintTask As User.DHCOPGSPrintTask [ Cardinality = children, Inverse = GSPTParRef ];

/// GS_FootFlag
Property GSFootFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = GS_FootFlag ];

/// GS_RecLocFlag
Property GSRecLocFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = GS_RecLocFlag ];

/// GS_PrtINVFlag
Property GSPrtINVFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GS_PrtINVFlag ];

/// GS_DateFrom
Property GSDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = GS_DateFrom ];

/// GS_DateTo
Property GSDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = GS_DateTo ];

/// GS_AbortFlag
Property GSAbortFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = GS_AbortFlag ];

/// GS_RefundFlag
Property GSRefundFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = GS_RefundFlag ];

/// GS_SSGroup_DR
Property GSSSGroupDR As User.SSGroup [ SqlColumnNumber = 9, SqlFieldName = GS_SSGroup_DR ];

/// GS_PrtXMLName
Property GSPrtXMLName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GS_PrtXMLName ];

/// GS_ColPrtXMLName
Property GSColPrtXMLName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GS_ColPrtXMLName ];

/// GS_PRTParaFlag
Property GSPRTParaFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = GS_PRTParaFlag ];

/// GS_ItemFlag
Property GSItemFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = GS_ItemFlag ];

/// GS_RecDepFlag
Property GSRecDepFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = GS_RecDepFlag ];

/// GS_PresNoFlag
Property GSPresNoFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = GS_PresNoFlag ];

/// GS_RecInvCount
Property GSRecInvCount As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = GS_RecInvCount ];

/// GS_PrintCount
Property GSPrintCount As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = GS_PrintCount ];

/// GS_OrdSIFlag
Property GSOrdSIFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = GS_OrdSIFlag ];

/// GS_UseINVType
Property GSUseINVType As %Library.String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registeration,Login", MAXLEN = 13, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L") [ SqlColumnNumber = 19, SqlFieldName = GS_UseINVType ];

/// GS_InputOrdFlag
Property GSInputOrdFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = GS_InputOrdFlag ];

/// GS_PrtListFlag
Property GSPrtListFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = GS_PrtListFlag ];

/// GS_ColPrtListFlag
Property GSColPrtListFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = GS_ColPrtListFlag ];

/// GS_PrtEINVFlag
Property GSPrtEINVFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = GS_PrtEINVFlag ];

/// GS_ICDXFlag 按病种拆分标识
Property GSICDXFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = GS_ICDXFlag ];

/// GS_RegOrdFlag 挂号医嘱单独拆票标识
Property GSRegOrdFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = GS_RegOrdFlag ];

/// GS_Note4
Property GSNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = GS_Note4 ];

/// GS_Note5
Property GSNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = GS_Note5 ];

/// GS_OneToManyFlag
Property GSOneToManyFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = GS_OneToManyFlag ];

/// GS_RegInvFlag
Property GSRegInvFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = GS_RegInvFlag ];

/// GS_InvDateFlag
Property GSInvDateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = GS_InvDateFlag ];

/// GS_CardPayModeFlag
Property GSCardPayModeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = GS_CardPayModeFlag ];

/// GS_ReceiveFlag  日结汇总需要接收标识
Property GSReceiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = GS_ReceiveFlag ];

/// GS_RegBillFlag  挂号医嘱跟收费医嘱一起结算?
Property GSRegBillFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = GS_RegBillFlag ];

/// GS_Hosp_DR 医院
Property GSHospDR As User.CTHospital [ SqlColumnNumber = 34, SqlFieldName = GS_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPGS("GS"))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="GS_AbortFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GS_CardPayModeFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="GS_ColPrtListFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="GS_ColPrtXMLName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GS_FootFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GS_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="GS_ICDXFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="GS_InputOrdFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="GS_InvDateFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="GS_ItemFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GS_Note4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="GS_Note5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="GS_OneToManyFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="GS_OrdSIFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="GS_PRTParaFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GS_PresNoFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GS_PrintCount">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GS_PrtEINVFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="GS_PrtINVFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GS_PrtListFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="GS_PrtXMLName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GS_RecDepFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GS_RecInvCount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GS_RecLocFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GS_ReceiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="GS_RefundFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GS_RegBillFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="GS_RegInvFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="GS_RegOrdFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="GS_SSGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GS_UseINVType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCOPGS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGropuDR">
<Global>^DHCOPGSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"GSDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GS_SSGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPGroupSettingsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
