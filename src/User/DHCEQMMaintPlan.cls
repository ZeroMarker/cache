Class User.DHCEQMMaintPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MP_RowID, SqlTableName = DHC_EQMMaintPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MP_Name
Property MPName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MP_Name ];

/// MP_Type
Property MPType As %Library.String(DISPLAYLIST = ",保养,检查", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 3, SqlFieldName = MP_Type ];

/// MP_SourceType
Property MPSourceType As %Library.String(DISPLAYLIST = ",设备分类,设备项,设备", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 4, SqlFieldName = MP_SourceType ];

/// MP_SourceID
Property MPSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MP_SourceID ];

/// MP_ModelDR
Property MPModelDR As User.DHCEQCModel [ SqlColumnNumber = 6, SqlFieldName = MP_ModelDR ];

/// MP_Content
Property MPContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MP_Content ];

/// MP_CycleNum
Property MPCycleNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MP_CycleNum ];

/// MP_CycleUnit
Property MPCycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 9, SqlFieldName = MP_CycleUnitDR ];

/// MP_MaintTypeDR
Property MPMaintTypeDR As User.DHCEQMCMaintType [ SqlColumnNumber = 10, SqlFieldName = MP_MaintTypeDR ];

/// MP_FromDate
Property MPFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = MP_FromDate ];

/// MP_EndDate
Property MPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = MP_EndDate ];

/// MP_PreWarnDaysNum
Property MPPreWarnDaysNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MP_PreWarnDaysNum ];

/// MP_MaintFee
Property MPMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MP_MaintFee ];

/// MP_MaintLocDR
Property MPMaintLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MP_MaintLocDR ];

/// MP_MaintUserDR
Property MPMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MP_MaintUserDR ];

/// MP_MaintModeDR
Property MPMaintModeDR As User.DHCEQMCMaintMode [ SqlColumnNumber = 17, SqlFieldName = MP_MaintModeDR ];

/// MP_ContractDR
Property MPContractDR As User.DHCEQContract [ SqlColumnNumber = 18, SqlFieldName = MP_ContractDR ];

/// MP_MeasureFlag
Property MPMeasureFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = MP_MeasureFlag ];

/// MP_MeasureDeptDR
Property MPMeasureDeptDR As User.DHCEQCMeasureDept [ SqlColumnNumber = 20, SqlFieldName = MP_MeasureDeptDR ];

/// MP_MeasureHandler
Property MPMeasureHandler As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MP_MeasureHandler ];

/// MP_MeasureTel
Property MPMeasureTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MP_MeasureTel ];

/// MP_ServiceDR
Property MPServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 23, SqlFieldName = MP_ServiceDR ];

/// MP_ServiceHandler
Property MPServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MP_ServiceHandler ];

/// MP_ServiceTel
Property MPServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MP_ServiceTel ];

/// MP_Remark
Property MPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MP_Remark ];

/// MP_Status
Property MPStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 27, SqlFieldName = MP_Status ];

/// MP_UpdateUserDR
Property MPUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MP_UpdateUserDR ];

/// MP_UpdateDate
Property MPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = MP_UpdateDate ];

/// MP_UpdateTime
Property MPUpdateTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = MP_UpdateTime ];

/// MP_SubmitUserDR
Property MPSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MP_SubmitUserDR ];

/// MP_SUbmitDate
Property MPSUbmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = MP_SUbmitDate ];

/// MP_SubmitTime
Property MPSubmitTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = MP_SubmitTime ];

/// MP_AuditUserDR
Property MPAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MP_AuditUserDR ];

/// MP_AuditDate
Property MPAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = MP_AuditDate ];

/// MP_AuditTime
Property MPAuditTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = MP_AuditTime ];

/// MP_InvalidFlag
Property MPInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = MP_InvalidFlag ];

/// MP_DelUserDR
Property MPDelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MP_DelUserDR ];

/// MP_DelDate
Property MPDelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = MP_DelDate ];

/// MP_DelTime
Property MPDelTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = MP_DelTime ];

/// MP_Hold1
Property MPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MP_Hold1 ];

/// MP_Hold2
Property MPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = MP_Hold2 ];

/// MP_Hold3
Property MPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MP_Hold3 ];

/// MP_Hold4
Property MPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MP_Hold4 ];

/// MP_Hold5
Property MPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = MP_Hold5 ];

/// MP_TotalFee
Property MPTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = MP_TotalFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaintPlan("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MP_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MP_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MP_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MP_Content">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MP_ContractDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MP_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MP_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MP_DelDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MP_DelTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MP_DelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MP_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MP_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MP_MaintLocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MP_MaintModeDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MP_MaintTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MP_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MP_MeasureDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MP_MeasureFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MP_MeasureHandler">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MP_MeasureTel">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MP_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MP_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MP_PreWarnDaysNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MP_SUbmitDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MP_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MP_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MP_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MP_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MP_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MP_Status">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MP_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MP_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MP_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCEQMMaintPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQMMaintPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MP_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MP_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQMMaintPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MP_RowID</Field>
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
<Expression>{MP_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMMaintPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
