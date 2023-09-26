Class User.DHCEmConsult Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsult, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEMCONSULTITM As User.DHCEmConsultItm [ Cardinality = children, Inverse = ECParRefDr ];

/// 病人Adm   EC_Adm_Dr
Property ECAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EC_Adm_Dr ];

/// 申请科室  EC_RLoc_Dr
Property ECRLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = EC_RLoc_Dr ];

/// 申请日期  EC_RDate
Property ECRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = EC_RDate ];

/// 申请时间  EC_RTime
Property ECRTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = EC_RTime ];

/// 申请医生  EC_RUser_Dr
Property ECRUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = EC_RUser_Dr ];

/// 病情及诊疗经过  EC_TrePro
Property ECTrePro As %Library.Text(MAXLEN = 5000) [ SqlColumnNumber = 7, SqlFieldName = EC_TrePro ];

/// 会诊的理由和目的  EC_Purpose
Property ECPurpose As %Library.Text(MAXLEN = 5000) [ SqlColumnNumber = 8, SqlFieldName = EC_Purpose ];

/// 会诊类别  EC_Category
Property ECCategory As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EC_Category ];

/// 医生级别  EC_DocLev
Property ECDocLev As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EC_DocLev ];

/// 会诊日期  EC_NDate
Property ECNDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = EC_NDate ];

/// 会诊时间  EC_NTime
Property ECNTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = EC_NTime ];

/// 会诊地点  EC_NPlace
Property ECNPlace As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EC_NPlace ];

/// 审核科室  EC_ALoc_Dr
Property ECALocDr As User.CTLoc [ SqlColumnNumber = 14, SqlFieldName = EC_ALoc_Dr ];

/// 审核人  EC_AUser_Dr
Property ECAUserDr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = EC_AUser_Dr ];

/// 审核日期  EC_ADate
Property ECADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = EC_ADate ];

/// 审核时间  EC_ATime
Property ECATime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = EC_ATime ];

/// 最终治疗措施  EC_TreMeasures
Property ECTreMeasures As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = EC_TreMeasures ];

/// 申请状态  EC_RStatus
Property ECRStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EC_RStatus ];

/// 会诊类型  EC_Type
Property ECType As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EC_Type ];

/// 完成日期  EC_CDate
Property ECCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = EC_CDate ];

/// 完成时间  EC_CTime
Property ECCTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = EC_CTime ];

/// 完成人  EC_CUser_Dr
Property ECCUserDr As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = EC_CUser_Dr ];

/// 是否加急  EC_EmFlag
Property ECEmFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = EC_EmFlag ];

/// 是否院外  EC_OutFlag
Property ECOutFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = EC_OutFlag ];

/// 外院名称  EC_Unit
Property ECUnit As %Library.String [ SqlColumnNumber = 26, SqlFieldName = EC_Unit ];

/// 外院医师  EC_DocName
Property ECDocName As %Library.String [ SqlColumnNumber = 27, SqlFieldName = EC_DocName ];

/// 备注  EC_Remark
Property ECRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = EC_Remark ];

/// 联系人  EC_ConsUser
Property ECConsUser As %Library.String [ SqlColumnNumber = 29, SqlFieldName = EC_ConsUser ];

/// 联系电话  EC_ConsPhone
Property ECConsPhone As %Library.String [ SqlColumnNumber = 30, SqlFieldName = EC_ConsPhone ];

/// 是否共享  EC_ShareFlag
Property ECShareFlag As %Library.String [ SqlColumnNumber = 31, SqlFieldName = EC_ShareFlag ];

/// 是否多科  EC_MoreDepFlag
Property ECMoreDepFlag As %Library.String [ SqlColumnNumber = 32, SqlFieldName = EC_MoreDepFlag ];

/// 是否有医疗纠纷  EC_MedcalTangle
Property ECMedcalTangle As %Library.String [ SqlColumnNumber = 33, SqlFieldName = EC_MedcalTangle ];

/// 目前存在问题 EC_CurQuestion
Property ECCurQuestion As %Library.Text(MAXLEN = 5000) [ SqlColumnNumber = 34, SqlFieldName = EC_CurQuestion ];

/// 会诊意见 EC_Opintion
Property ECOpintion As %Library.Text(MAXLEN = 5000) [ SqlColumnNumber = 35, SqlFieldName = EC_Opintion ];

/// 是否同意使用抗生素 EC_ConsentAnti 
Property ECConsentAnti As %Library.String [ SqlColumnNumber = 36, SqlFieldName = EC_ConsentAnti ];

/// 是否开启医嘱录入 EC_OrdWriteFlag
Property ECOrdWriteFlag As %Library.String [ SqlColumnNumber = 37, SqlFieldName = EC_OrdWriteFlag ];

/// 打印标志  EC_PrintFlag
Property ECPrintFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = EC_PrintFlag ];

/// 外院科室 EC_UnitDept
Property ECUnitDept As %Library.String [ SqlColumnNumber = 39, SqlFieldName = EC_UnitDept ];

/// 评价标志  EC_EvaFlag
Property ECEvaFlag As %Library.String [ SqlColumnNumber = 40, SqlFieldName = EC_EvaFlag ];

/// 评价内容 EC_EvaDesc
Property ECEvaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = EC_EvaDesc ];

/// 讨论内容 EC_Discuss
Property ECDiscuss As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = EC_Discuss ];

/// 讨论日期  EC_DiscDate
Property ECDiscDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 43, SqlFieldName = EC_DiscDate ];

/// 讨论时间  EC_DiscTime
Property ECDiscTime As %Library.Time [ SqlColumnNumber = 44, SqlFieldName = EC_DiscTime ];

/// 执行主治医师 EC_AttendDoc
Property ECAttendDoc As User.DHCEmConsDicItem [ SqlColumnNumber = 45, SqlFieldName = EC_AttendDoc ];

/// 会诊性质 EC_Nat_Dr
Property ECNatDr As User.DHCEmConsDicItem [ SqlColumnNumber = 46, SqlFieldName = EC_Nat_Dr ];

/// 病种类型 EC_DisType_Dr
Property ECDisTypeDr As User.DHCEmConsDicItem [ SqlColumnNumber = 47, SqlFieldName = EC_DisType_Dr ];

/// 会诊印象 EC_Impression
Property ECImpression As %Library.String [ SqlColumnNumber = 48, SqlFieldName = EC_Impression ];

/// 会诊处理 EC_Processing
Property ECProcessing As %Library.String [ SqlColumnNumber = 49, SqlFieldName = EC_Processing ];

/// 申请理由及要求 EC_ReqReason
Property ECReqReason As %Library.String(MAXLEN = 5000) [ SqlColumnNumber = 50, SqlFieldName = EC_ReqReason ];

/// 会诊主持人 EC_Moderator
Property ECModerator As %Library.String [ SqlColumnNumber = 51, SqlFieldName = EC_Moderator ];

/// 病历Id  EC_Instance_Dr
Property ECInstanceDr As %Library.String [ SqlColumnNumber = 52, SqlFieldName = EC_Instance_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_ADate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EC_ALoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EC_ATime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EC_AUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_AttendDoc">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="EC_CDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EC_CTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EC_CUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="EC_Category">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_ConsPhone">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="EC_ConsUser">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="EC_ConsentAnti">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="EC_CurQuestion">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="EC_DisType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="EC_DiscDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="EC_DiscTime">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="EC_Discuss">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="EC_DocLev">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EC_DocName">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="EC_EmFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EC_EvaDesc">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="EC_EvaFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="EC_Impression">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="EC_Instance_Dr">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="EC_MedcalTangle">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="EC_Moderator">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="EC_MoreDepFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="EC_NDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EC_NPlace">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EC_NTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EC_Nat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="EC_Opintion">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="EC_OrdWriteFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="EC_OutFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="EC_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="EC_Processing">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="EC_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_RDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_RLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_RStatus">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EC_RTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_RUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="EC_ReqReason">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="EC_ShareFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="EC_TreMeasures">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EC_TrePro">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_Type">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EC_Unit">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="EC_UnitDept">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConDate">
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_NDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReqData">
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReqDateIndex"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_RDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
