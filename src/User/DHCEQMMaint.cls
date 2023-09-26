Class User.DHCEQMMaint Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MT_RowID, SqlTableName = DHC_EQMMaint, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MT_EquipDR
Property MTEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = MT_EquipDR ];

/// MT_Type
Property MTType As %Library.String(DISPLAYLIST = ",保养,检查,维修", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 3, SqlFieldName = MT_Type ];

/// MT_SourceID
Property MTSourceID As User.DHCEQMMaintPlan [ SqlColumnNumber = 4, SqlFieldName = MT_SourceID ];

/// MT_MaintTypeDR
Property MTMaintTypeDR As User.DHCEQMCMaintType [ SqlColumnNumber = 5, SqlFieldName = MT_MaintTypeDR ];

/// MT_MaintDate
Property MTMaintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MT_MaintDate ];

/// MT_MaintLocDR
Property MTMaintLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MT_MaintLocDR ];

/// MT_MaintUserDR
Property MTMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MT_MaintUserDR ];

/// MT_MaintModeDR
Property MTMaintModeDR As User.DHCEQMCMaintMode [ SqlColumnNumber = 9, SqlFieldName = MT_MaintModeDR ];

/// MT_TotalFee
Property MTTotalFee As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = MT_TotalFee ];

/// MT_NormalFlag
Property MTNormalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MT_NormalFlag ];

/// MT_ManageLocDR
Property MTManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MT_ManageLocDR ];

/// MT_UseLocDR
Property MTUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MT_UseLocDR ];

/// MT_Status
Property MTStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 14, SqlFieldName = MT_Status ];

/// MT_Remark
Property MTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MT_Remark ];

/// MT_UpdateUserDR
Property MTUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MT_UpdateUserDR ];

/// MT_UpdateDate
Property MTUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = MT_UpdateDate ];

/// MT_UpdateTime
Property MTUpdateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = MT_UpdateTime ];

/// MT_AuditUserDR
Property MTAuditeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MT_AuditeUserDR ];

/// MT_AuditDate
Property MTAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = MT_AuditDate ];

/// MT_AuditTime
Property MTAuditTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = MT_AuditTime ];

/// MT_SubmitUserDR
Property MTSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MT_SubmitUserDR ];

/// MT_SubmitDate
Property MTSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = MT_SubmitDate ];

/// MT_SubmitTime
Property MTSubmitTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = MT_SubmitTime ];

/// MT_MaintFee
Property MTMaintFee As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = MT_MaintFee ];

/// MT_Hold1
Property MTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MT_Hold1 ];

/// MT_Hold2
Property MTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MT_Hold2 ];

/// MT_Hold3
Property MTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MT_Hold3 ];

/// MT_Hold4
Property MTHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MT_Hold4 ];

/// MT_Hold5
Property MTHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MT_Hold5 ];

/// MT_MeasureFlag
Property MTMeasureFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = MT_MeasureFlag ];

/// MT_MeasureDeptDR
Property MTMeasureDeptDR As User.DHCEQCMeasureDept [ SqlColumnNumber = 32, SqlFieldName = MT_MeasureDeptDR ];

/// MT_MeasureHandler
Property MTMeasureHandler As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MT_MeasureHandler ];

/// MT_MeasureTel
Property MTMeasureTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MT_MeasureTel ];

/// MT_MeasureUsers
Property MTMeasureUsers As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = MT_MeasureUsers ];

/// MT_ServiceDR
Property MTServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 36, SqlFieldName = MT_ServiceDR ];

/// MT_ServiceHandler
Property MTServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = MT_ServiceHandler ];

/// MT_ServiceTel
Property MTServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MT_ServiceTel ];

/// MT_ServiceUsers
Property MTServiceUsers As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = MT_ServiceUsers ];

/// MT_InvalidFlag
Property MTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = MT_InvalidFlag ];

/// MT_DelUserDR
Property MTDelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MT_DelUserDR ];

/// MT_DelDate
Property MTDelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = MT_DelDate ];

/// MT_DelTime
Property MTDelTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = MT_DelTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaint("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MT_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MT_AuditeUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MT_DelDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MT_DelTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MT_DelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MT_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MT_MaintDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MT_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MT_MaintLocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MT_MaintModeDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MT_MaintTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MT_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MT_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MT_MeasureDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MT_MeasureFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MT_MeasureHandler">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MT_MeasureTel">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MT_MeasureUsers">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MT_NormalFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MT_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MT_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MT_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MT_ServiceUsers">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MT_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MT_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MT_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MT_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MT_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MT_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MT_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MT_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MT_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQMMaint</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQMMaint</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MT_EquipDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQMMaint</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MT_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MT_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MT_EquipDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMMaintS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
