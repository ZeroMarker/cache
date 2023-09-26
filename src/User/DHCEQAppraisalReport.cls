Class User.DHCEQAppraisalReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_EQAppraisalReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AR_AuditDate
Property ARAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = AR_AuditDate ];

/// AR_AuditTime
Property ARAuditTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = AR_AuditTime ];

/// AR_AuditUserDR
Property ARAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AR_AuditUserDR ];

/// AR_CancelDate
Property ARCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = AR_CancelDate ];

/// AR_CancelTime
Property ARCancelTime As %Library.Time [ SqlColumnNumber = 35, SqlFieldName = AR_CancelTime ];

/// AR_CancelUserDR
Property ARCancelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AR_CancelUserDR ];

/// AR_CheckContent
Property ARCheckContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AR_CheckContent ];

/// AR_CheckResult
Property ARCheckResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AR_CheckResult ];

/// AR_CheckUserDR
Property ARCheckUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AR_CheckUserDR ];

/// AR_DepreMonths
Property ARDepreMonths As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AR_DepreMonths ];

/// AR_EquipDR
Property AREquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = AR_EquipDR ];

/// AR_FrequencyUnit
Property ARFrequencyUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AR_FrequencyUnit ];

/// AR_Hold1
Property ARHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = AR_Hold1 ];

/// AR_Hold2
Property ARHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = AR_Hold2 ];

/// AR_Hold3
Property ARHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = AR_Hold3 ];

/// AR_Hold4
Property ARHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = AR_Hold4 ];

/// AR_Hold5
Property ARHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = AR_Hold5 ];

/// AR_InvalidFlag
Property ARInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = AR_InvalidFlag ];

/// AR_LocationDR
Property ARLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 7, SqlFieldName = AR_LocationDR ];

/// AR_MaintCounts
Property ARMaintCounts As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AR_MaintCounts ];

/// AR_Name
Property ARName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AR_Name ];

/// AR_No
Property ARNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AR_No ];

/// AR_OriginalFee
Property AROriginalFee As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = AR_OriginalFee ];

/// AR_OtherSituation
Property AROtherSituation As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AR_OtherSituation ];

/// AR_Phone
Property ARPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AR_Phone ];

/// AR_PreviousMaintFee
Property ARPreviousMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AR_PreviousMaintFee ];

/// AR_RejectDate
Property ARRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = AR_RejectDate ];

/// AR_RejectReason
Property ARRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AR_RejectReason ];

/// AR_RejectTime
Property ARRejectTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = AR_RejectTime ];

/// AR_RejectUserDR
Property ARRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = AR_RejectUserDR ];

/// AR_Remark
Property ARRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AR_Remark ];

/// AR_ReportDate
Property ARReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = AR_ReportDate ];

/// AR_Situation
Property ARSituation As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AR_Situation ];

/// AR_StateDR
Property ARStateDR As User.DHCEQEquipStatus [ SqlColumnNumber = 9, SqlFieldName = AR_StateDR ];

/// AR_Status
Property ARStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AR_Status ];

/// AR_SubmitDate
Property ARSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = AR_SubmitDate ];

/// AR_SubmitTime
Property ARSubmitTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = AR_SubmitTime ];

/// AR_SubmitUserDR
Property ARSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AR_SubmitUserDR ];

/// AR_TotalFee
Property ARTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AR_TotalFee ];

/// AR_Type
Property ARType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AR_Type ];

/// AR_UseLocDR
Property ARUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AR_UseLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAppraisalReport("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="AR_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AR_CheckContent">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_CheckResult">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_CheckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AR_DepreMonths">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_FrequencyUnit">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="AR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="AR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="AR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="AR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="AR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="AR_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_MaintCounts">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_No">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="AR_OtherSituation">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AR_Phone">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AR_PreviousMaintFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AR_ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AR_Situation">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AR_StateDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_Status">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AR_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQAppraisalReport</Global>
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
<SQLMap name="IndexEquip">
<Global>^DHCEQAppraisalReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_EquipDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAppraisalReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
