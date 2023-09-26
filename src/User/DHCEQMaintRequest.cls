Class User.DHCEQMaintRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MR_RowID, SqlTableName = DHC_EQMaintRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index MRRequestNOUnqIdx1 On MRRequestNO [ Unique ];

/// MR_AcceptDate
Property MRAcceptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = MR_AcceptDate ];

/// MR_AcceptTime
Property MRAcceptTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = MR_AcceptTime ];

/// MR_AcceptUserDR
Property MRAcceptUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MR_AcceptUserDR ];

/// MR_AddDate
Property MRAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = MR_AddDate ];

/// MR_AddTime
Property MRAddTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = MR_AddTime ];

/// MR_AddUserDR
Property MRAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MR_AddUserDR ];

/// MR_AssignDR
Property MRAssignDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MR_AssignDR ];

/// MR_CancelDate
Property MRCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = MR_CancelDate ];

/// MR_CancelTime
Property MRCancelTime As %Library.Time [ SqlColumnNumber = 47, SqlFieldName = MR_CancelTime ];

/// MR_CancelUser
Property MRCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = MR_CancelUser ];

/// MR_DealMethodDR
Property MRDealMethodDR As User.DHCEQCDealMethod [ SqlColumnNumber = 8, SqlFieldName = MR_DealMethodDR ];

/// MR_DealMethodRemark
Property MRDealMethodRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MR_DealMethodRemark ];

/// MR_EndDate
Property MREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = MR_EndDate ];

/// MR_EndTime
Property MREndTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = MR_EndTime ];

/// MR_EquipDR
Property MREquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = MR_EquipDR ];

/// MR_FaultCaseDR
Property MRFaultCaseDR As User.DHCEQCFaultCase [ SqlColumnNumber = 4, SqlFieldName = MR_FaultCaseDR ];

/// MR_FaultCaseRemark
Property MRFaultCaseRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MR_FaultCaseRemark ];

/// MR_FaultReasonDR
Property MRFaultReasonDR As User.DHCEQCFaultReason [ SqlColumnNumber = 6, SqlFieldName = MR_FaultReasonDR ];

/// MR_FaultReasonRemark
Property MRFaultReasonRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MR_FaultReasonRemark ];

/// MR_FaultTypeDR
Property MRFaultTypeDR As User.DHCEQCFaultType [ SqlColumnNumber = 16, SqlFieldName = MR_FaultTypeDR ];

/// MR_InvalidFlag
Property MRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = MR_InvalidFlag ];

/// MR_IsInputFlag
Property MRIsInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = MR_IsInputFlag ];

/// MR_MaintDept
Property MRMaintDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = MR_MaintDept ];

/// MR_MaintFee
Property MRMaintFee As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = MR_MaintFee ];

/// MR_MaintLocDR
Property MRMaintLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = MR_MaintLocDR ];

/// MR_MaintModeDR
Property MRMaintModeDR As User.DHCEQCMaintMode [ SqlColumnNumber = 21, SqlFieldName = MR_MaintModeDR ];

/// MR_MaintRemark
Property MRMaintRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MR_MaintRemark ];

/// MR_ManageLocDR
Property MRManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MR_ManageLocDR ];

/// MR_OtherFee
Property MROtherFee As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = MR_OtherFee ];

/// MR_PayedMaintFlag
Property MRPayedMaintFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = MR_PayedMaintFlag ];

/// MR_Remark
Property MRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MR_Remark ];

/// MR_RequestDate
Property MRRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = MR_RequestDate ];

/// MR_RequestLocDR
Property MRRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MR_RequestLocDR ];

/// MR_RequestNO
Property MRRequestNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MR_RequestNO ];

/// MR_RequestTime
Property MRRequestTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = MR_RequestTime ];

/// MR_StartDate
Property MRStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = MR_StartDate ];

/// MR_StartTime
Property MRStartTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = MR_StartTime ];

/// MR_Status
Property MRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 30, SqlFieldName = MR_Status ];

/// MR_SubmitDate
Property MRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 38, SqlFieldName = MR_SubmitDate ];

/// MR_SubmitTime
Property MRSubmitTime As %Library.Time [ SqlColumnNumber = 39, SqlFieldName = MR_SubmitTime ];

/// MR_SubmitUserDR
Property MRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = MR_SubmitUserDR ];

/// MR_UpdateDate
Property MRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = MR_UpdateDate ];

/// MR_UpdateTime
Property MRUpdateTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = MR_UpdateTime ];

/// MR_UpdateUserDR
Property MRUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MR_UpdateUserDR ];

/// MR_UseLocDR
Property MRUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MR_UseLocDR ];

/// MR_UserOpinion
Property MRUserOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MR_UserOpinion ];

/// MR_UserSignDR
Property MRUserSignDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MR_UserSignDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMaintRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MR_AcceptDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MR_AcceptTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MR_AcceptUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MR_AssignDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MR_DealMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MR_DealMethodRemark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MR_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MR_FaultCaseDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_FaultCaseRemark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_FaultReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MR_FaultReasonRemark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MR_FaultTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MR_IsInputFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MR_MaintDept">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MR_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MR_MaintLocDR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MR_MaintModeDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MR_MaintRemark">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MR_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MR_OtherFee">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MR_PayedMaintFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MR_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MR_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_RequestNO">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MR_RequestTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MR_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MR_Status">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MR_UserOpinion">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MR_UserSignDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCEQMaintRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RequestNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>" "_{MR_RequestNO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMaintRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
