Class User.DHCEQPreMonthDepre Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_EQPreMonthDepre, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MD_AddDate
Property MDAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = MD_AddDate ];

/// MD_AddTime
Property MDAddTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = MD_AddTime ];

/// MD_AddUserDR
Property MDAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MD_AddUserDR ];

/// MD_AffixDR
Property MDAffixDR As User.DHCEQAffix [ SqlColumnNumber = 33, SqlFieldName = MD_AffixDR ];

/// MD_AllotFlag
Property MDAllotFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = MD_AllotFlag ];

/// MD_Hold2
Property MDAllotType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = MD_AllotType ];

/// MD_AuditDate
Property MDAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = MD_AuditDate ];

/// MD_AuditTime
Property MDAuditTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = MD_AuditTime ];

/// MD_AuditUserDR
Property MDAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MD_AuditUserDR ];

/// MD_Hold1
Property MDCommonFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = MD_CommonFlag ];

/// MD_CostAllotDR
Property MDCostAllotDR As User.DHCEQCostAllot [ SqlColumnNumber = 17, SqlFieldName = MD_CostAllotDR ];

/// MD_CostAllotType
Property MDCostAllotType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MD_CostAllotType ];

/// MD_DepreFee
Property MDDepreFee As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = MD_DepreFee ];

/// MD_DepreMethodDR
Property MDDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 5, SqlFieldName = MD_DepreMethodDR ];

/// MD_DepreMonth
Property MDDepreMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MD_DepreMonth ];

/// MD_DepreMonthsNum
Property MDDepreMonthsNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = MD_DepreMonthsNum ];

/// MD_Hold4
Property MDDepreRate As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = MD_DepreRate ];

/// MD_DepreSetDR
Property MDDepreSetDR As User.DHCEQDepreSet [ SqlColumnNumber = 3, SqlFieldName = MD_DepreSetDR ];

/// MD_DepreType
Property MDDepreType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = MD_DepreType ];

/// MD_Hold3
Property MDDepreTypeDR As User.DHCEQCDepreType [ SqlColumnNumber = 37, SqlFieldName = MD_DepreTypeDR ];

/// MD_DesignWorkLoadNum
Property MDDesignWorkLoadNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = MD_DesignWorkLoadNum ];

/// MD_EquipDR
Property MDEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = MD_EquipDR ];

/// MD_Hold1
Property MDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = MD_Hold1 ];

/// MD_Hold2
Property MDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MD_Hold2 ];

/// MD_Hold3
Property MDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = MD_Hold3 ];

/// MD_Hold4
Property MDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MD_Hold4 ];

/// MD_Hold5
Property MDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MD_Hold5 ];

/// MD_LimitYearsNum
Property MDLimitYearsNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = MD_LimitYearsNum ];

/// MD_LocDR
Property MDLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MD_LocDR ];

/// MD_MainFlag
Property MDMainFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MD_MainFlag ];

/// MD_Hold5
Property MDManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = MD_ManageLocDR ];

/// MD_NetFee
Property MDNetFee As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = MD_NetFee ];

/// MD_NetRemainFee
Property MDNetRemainFee As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = MD_NetRemainFee ];

/// MD_OriginalFee
Property MDOriginalFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = MD_OriginalFee ];

/// MD_PreTotalDepreFee
Property MDPreTotalDepreFee As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = MD_PreTotalDepreFee ];

/// MD_PreTotalWorkloadFee
Property MDPreTotalWorkloadFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = MD_PreTotalWorkloadFee ];

/// MD_Remark
Property MDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MD_Remark ];

/// MD_Status
Property MDStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 21, SqlFieldName = MD_Status ];

/// MD_UpdateDate
Property MDUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = MD_UpdateDate ];

/// MD_UpdateTime
Property MDUpdateTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = MD_UpdateTime ];

/// MD_UpdateUserDR
Property MDUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MD_UpdateUserDR ];

/// MD_WorkLoadNum
Property MDWorkLoadNum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = MD_WorkLoadNum ];

/// MD_WorkLoadUnitDR
Property MDWorkLoadUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MD_WorkLoadUnitDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPreMonthDepre("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MD_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MD_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MD_AffixDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MD_AllotFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MD_AllotType">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MD_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MD_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MD_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MD_CommonFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MD_CostAllotDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MD_CostAllotType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MD_DepreFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MD_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MD_DepreMonth">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MD_DepreMonthsNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MD_DepreRate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MD_DepreSetDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_DepreType">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MD_DepreTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MD_DesignWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MD_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MD_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MD_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MD_MainFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MD_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MD_NetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MD_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MD_PreTotalDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MD_PreTotalWorkloadFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MD_Status">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MD_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MD_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MD_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQPreMonthDepre</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MD_MainFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MD_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepreSet">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepreSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_DepreType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_DepreSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipMonth">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipMonth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_DepreMonth}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonth">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Month"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_DepreMonth}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSetMonth">
<Global>^DHCEQPreMonthDepre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SetMonth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_DepreSetDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_DepreMonth}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPreMonthDepreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
