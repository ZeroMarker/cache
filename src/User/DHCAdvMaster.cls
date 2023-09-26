Class User.DHCAdvMaster Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADV_RowID, SqlTableName = DHC_AdvMaster, StorageStrategy = SQLStorage ]
{

/// 	表单填写id		
Property ADVFormRecDr As User.DHCAdvFormRecord [ SqlColumnNumber = 2, SqlFieldName = ADV_FormRec_Dr ];

/// 	报告类型id		
Property ADVRepTypeDr As %String [ SqlColumnNumber = 3, SqlFieldName = ADV_RepType_Dr ];

/// 	报告状态ID			
Property ADVRepStausDr As User.DHCAdrEvtWorkFlowItm [ SqlColumnNumber = 4, SqlFieldName = ADV_RepStaus_Dr ];

/// 	报告日期
Property ADVRepDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ADV_RepDate ];

/// 	报告时间
Property ADVRepTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ADV_RepTime ];

/// 	上报人
Property ADVRepUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = ADV_RepUser_Dr ];

/// 	上报科室
Property ADVRepLocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = ADV_RepLoc_Dr ];

/// 	报告类型子类描述
Property ADVRepSubType As %String [ SqlColumnNumber = 9, SqlFieldName = ADV_RepSubType ];

/// 	重点标记
Property ADVRepImpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ADV_RepImpFlag ];

/// 	审批日期
Property ADVAuditDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ADV_AuditDate ];

/// 	审批时间
Property ADVAuditTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ADV_AuditTime ];

/// 	不良事件级别
Property ADVRepLevel As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ADV_RepLevel ];

/// 	伤害严重度
Property ADVRepInjSev As %String [ SqlColumnNumber = 14, SqlFieldName = ADV_RepInjSev ];

/// 	患者ID(登记号)
Property ADVPatID As %String [ SqlColumnNumber = 15, SqlFieldName = ADV_PatID ];

/// 	就诊形式
Property ADVAdmType As %String [ SqlColumnNumber = 16, SqlFieldName = ADV_AdmType ];

/// 	就诊id
Property ADVAdm As %String [ SqlColumnNumber = 17, SqlFieldName = ADV_Adm ];

/// 	患者姓名
Property ADVPatName As %String [ SqlColumnNumber = 18, SqlFieldName = ADV_PatName ];

/// 	患者性别
Property ADVPatSex As %String [ SqlColumnNumber = 19, SqlFieldName = ADV_PatSex ];

/// 	患者年龄
Property ADVPatAge As %String [ SqlColumnNumber = 20, SqlFieldName = ADV_PatAge ];

/// 	病案号
Property ADVAdmNo As %String [ SqlColumnNumber = 21, SqlFieldName = ADV_AdmNo ];

/// 	病人诊断
Property ADVPatDiag As %String [ SqlColumnNumber = 22, SqlFieldName = ADV_PatDiag ];

/// 	床号
Property ADVPatBedNo As %String [ SqlColumnNumber = 23, SqlFieldName = ADV_PatBedNo ];

/// 	入院日期
Property ADVHospAdmDate As %Date [ SqlColumnNumber = 24, SqlFieldName = ADV_HospAdmDate ];

/// 	入院时间
Property ADVHospAdmTime As %Time [ SqlColumnNumber = 25, SqlFieldName = ADV_HospAdmTime ];

/// 	发生日期
Property ADVOccurDate As %Date [ SqlColumnNumber = 26, SqlFieldName = ADV_OccurDate ];

/// 	发生时间
Property ADVOccurTime As %Time [ SqlColumnNumber = 27, SqlFieldName = ADV_OccurTime ];

/// 	发生科室
Property ADVOccurLoc As %String [ SqlColumnNumber = 28, SqlFieldName = ADV_OccurLoc ];

/// 	填报人职称
Property ADVRepUserTitle As %String [ SqlColumnNumber = 29, SqlFieldName = ADV_RepUserTitle ];

/// 	填报人工作年限
Property ADVRepUseWorYears As %String [ SqlColumnNumber = 30, SqlFieldName = ADV_RepUseWorYears ];

///   护理级别
Property ADVPatNurLev As %String [ SqlColumnNumber = 31, SqlFieldName = ADV_PatNurLev ];

/// 	报告状态 
Property ADVRepStaus As %String [ SqlColumnNumber = 32, SqlFieldName = ADV_RepStaus ];

/// Braden压疮高风险评分 
Property ADVBradenSca As %String [ SqlColumnNumber = 33, SqlFieldName = ADV_BradenSca ];

/// 压疮高风险评估日期
Property ADVEvalDate As %Date [ SqlColumnNumber = 34, SqlFieldName = ADV_EvalDate ];

/// 压疮高风险评估
Property ADVEvalTime As %Time [ SqlColumnNumber = 35, SqlFieldName = ADV_EvalTime ];

/// 护理填单日期
Property ADVFiDate As %Date [ SqlColumnNumber = 36, SqlFieldName = ADV_FiDate ];

/// 护理填单时间
Property ADVFiTime As %Time [ SqlColumnNumber = 37, SqlFieldName = ADV_FiTime ];

/// 报告编号
Property ADVRepNo As %String [ SqlColumnNumber = 38, SqlFieldName = ADV_RepNo ];

/// 病区ID 
Property ADVRepWardDr As User.PACWard [ SqlColumnNumber = 39, SqlFieldName = ADV_RepWard_Dr ];

/// 患者所属科室
Property ADVSubLoc As User.CTLoc [ SqlColumnNumber = 40, SqlFieldName = ADV_SubLoc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVMASTER)</SqlIdExpression>
<SQLMap name="AdmIndex">
<Global>^DHCADVMASTER</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADV_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="AuditDateIndex">
<Global>^DHCADVMASTER</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADV_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="FormRecIndex">
<Global>^DHCADVMASTER</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FormRec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADV_FormRec_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADV_Adm">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADV_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ADV_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADV_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADV_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADV_BradenSca">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ADV_EvalDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ADV_EvalTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ADV_FiDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ADV_FiTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ADV_FormRec_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADV_HospAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ADV_HospAdmTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ADV_OccurDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ADV_OccurLoc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ADV_OccurTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ADV_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADV_PatBedNo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ADV_PatDiag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ADV_PatID">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADV_PatName">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADV_PatNurLev">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ADV_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADV_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADV_RepImpFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADV_RepInjSev">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADV_RepLevel">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADV_RepLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADV_RepNo">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ADV_RepStaus">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ADV_RepStaus_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADV_RepSubType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADV_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADV_RepType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADV_RepUseWorYears">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ADV_RepUserTitle">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ADV_RepUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADV_RepWard_Dr">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ADV_SubLoc">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Global>^DHCADVMASTER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADV_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="OccurDateIndex">
<Global>^DHCADVMASTER</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OccurDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADV_OccurDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="RepDateIndex">
<Global>^DHCADVMASTER</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADV_RepDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvMasterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
