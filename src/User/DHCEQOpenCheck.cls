Class User.DHCEQOpenCheck Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OC_RowID, SqlTableName = DHC_EQOpenCheck, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OC_EquipDR
Property OCEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = OC_EquipDR ];

/// OC_GroupDR
Property OCGroupDR As User.DHCEQGroup [ SqlColumnNumber = 3, SqlFieldName = OC_GroupDR ];

/// OC_ManageLocDR
Property OCManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OC_ManageLocDR ];

/// OC_UseLocDR
Property OCUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OC_UseLocDR ];

/// OC_OpenState
Property OCOpenState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OC_OpenState ];

/// OC_CheckResultDR
Property OCCheckResultDR As User.DHCEQCCheckResult [ SqlColumnNumber = 7, SqlFieldName = OC_CheckResultDR ];

/// OC_CheckResultRemark
Property OCCheckResultRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OC_CheckResultRemark ];

/// OC_CheckUser
Property OCCheckUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OC_CheckUser ];

/// OC_Status
Property OCStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 10, SqlFieldName = OC_Status ];

/// OC_Remark
Property OCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OC_Remark ];

/// OC_AddUserDR
Property OCAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OC_AddUserDR ];

/// OC_AddDate
Property OCAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = OC_AddDate ];

/// OC_AddTime
Property OCAddTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = OC_AddTime ];

/// OC_UpdateUserDR
Property OCUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = OC_UpdateUserDR ];

/// OC_UpdateDate
Property OCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = OC_UpdateDate ];

/// OC_UpdateTime
Property OCUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = OC_UpdateTime ];

/// OC_AuditUserDR
Property OCAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = OC_AuditUserDR ];

/// OC_AuditDate
Property OCAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = OC_AuditDate ];

/// OC_AuditTime
Property OCAuditTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = OC_AuditTime ];

/// OC_PackTypeDR
Property OCPackTypeDR As User.DHCEQCPackType [ SqlColumnNumber = 21, SqlFieldName = OC_PackTypeDR ];

/// OC_PackNum
Property OCPackNum As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = OC_PackNum ];

/// OC_RejectReason
Property OCRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OC_RejectReason ];

/// OC_RejectUserDR
Property OCRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = OC_RejectUserDR ];

/// OC_RejectDate
Property OCRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = OC_RejectDate ];

/// OC_RejectTime
Property OCRejectTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = OC_RejectTime ];

/// OC_ApproveSetDR
Property OCApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 27, SqlFieldName = OC_ApproveSetDR ];

/// OC_NextRoleDR
Property OCNextRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 28, SqlFieldName = OC_NextRoleDR ];

/// OC_NextFlowStep
Property OCNextFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = OC_NextFlowStep ];

/// OC_ApproveStatu
Property OCApproveStatu As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OC_ApproveStatu ];

/// OC_ApproveRoleDR
Property OCApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 31, SqlFieldName = OC_ApproveRoleDR ];

/// OC_Name
Property OCName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = OC_Name ];

/// OC_ModelDR
Property OCModelDR As User.DHCEQCModel [ SqlColumnNumber = 33, SqlFieldName = OC_ModelDR ];

/// OC_EquiCatDR
Property OCEquiCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 34, SqlFieldName = OC_EquiCatDR ];

/// OC_UnitDR
Property OCUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = OC_UnitDR ];

/// OC_Code
Property OCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = OC_Code ];

/// OC_ItemDR
Property OCItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 37, SqlFieldName = OC_ItemDR ];

/// OC_LeaveFactoryNo
Property OCLeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = OC_LeaveFactoryNo ];

/// OC_LeaveFactoryDate
Property OCLeaveFactoryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = OC_LeaveFactoryDate ];

/// OC_OpenCheckDate
Property OCOpenCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 40, SqlFieldName = OC_OpenCheckDate ];

/// OC_CountryDR
Property OCCountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = OC_CountryDR ];

/// OC_OriginDR
Property OCOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 42, SqlFieldName = OC_OriginDR ];

/// OC_FromDeptDR
Property OCFromDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 43, SqlFieldName = OC_FromDeptDR ];

/// OC_ProviderDR
Property OCProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = OC_ProviderDR ];

/// OC_ManuFactoryDR
Property OCManuFactoryDR As User.DHCEQCManufacturer [ SqlColumnNumber = 45, SqlFieldName = OC_ManuFactoryDR ];

/// OC_OriginalFee
Property OCOriginalFee As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = OC_OriginalFee ];

/// OC_NetFee
Property OCNetFee As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = OC_NetFee ];

/// OC_EquipTypeDR
Property OCEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 48, SqlFieldName = OC_EquipTypeDR ];

/// OC_PurchaseTypeDR
Property OCPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 49, SqlFieldName = OC_PurchaseTypeDR ];

/// OC_StatCatDR
Property OCStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 50, SqlFieldName = OC_StatCatDR ];

/// OC_Hold1
Property OCHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = OC_Hold1 ];

/// OC_Hold2
Property OCHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = OC_Hold2 ];

/// OC_Hold3
Property OCHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = OC_Hold3 ];

/// OC_Hold4
Property OCHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = OC_Hold4 ];

/// OC_Hold5
Property OCHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = OC_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOpenCheck("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OC_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OC_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OC_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OC_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OC_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OC_ApproveStatu">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OC_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OC_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OC_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OC_CheckResultDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OC_CheckResultRemark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OC_CheckUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OC_Code">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OC_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OC_EquiCatDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OC_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OC_FromDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OC_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="OC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="OC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="OC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="OC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="OC_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OC_LeaveFactoryDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OC_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OC_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OC_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OC_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OC_Name">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OC_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="OC_NextFlowStep">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OC_NextRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OC_OpenCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OC_OpenState">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OC_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OC_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OC_PackNum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OC_PackTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OC_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OC_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OC_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OC_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OC_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OC_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OC_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="OC_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OC_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OC_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OC_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQOpenCheck</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQOpenCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OC_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OC_NextRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQOpenCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OC_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OC_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OC_NextFlowStep}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQOpenCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQOpenCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OC_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOpenCheckS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
