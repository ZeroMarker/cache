Class User.DHCDocPilotProECRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPE_RowId, SqlTableName = DHC_DocPilotProECRecord, StorageStrategy = SQLStorage ]
{

//伦理审查结果

Property PPEResultDr As User.DHCDocCTDefineData [ SqlColumnNumber = 2, SqlFieldName = PPE_Result_Dr ];

//跟踪审查频率

Property CheckFreqDr As User.DHCDocCTDefineData [ SqlColumnNumber = 3, SqlFieldName = PPE_CheckFreq_Dr ];

Property ProjectDr As User.DHCDocPilotProject [ SqlColumnNumber = 4, SqlFieldName = PPE_PProject_Dr ];

//主要研究者资格评价

Property MainAppraisal As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPE_MainAppraisal ];

//设计方案评价

Property DesignAppraisal As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPE_DesignAppraisal ];

//知情同意书评价

Property FormAppraisal As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPE_FormAppraisal ];

//受试者补偿措施评价

Property ComPenAppraisal As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PPE_ComPenAppraisal ];

//其他

Property OtherRemark As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPE_OtherRemark ];

//会议日期

Property EthicsMeetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PPE_EthicsMeetDate ];

//出席人数

Property Attendance As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPE_Attendance ];

//弃权人数

Property UndecideNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PPE_UndecideNum ];

//生成批件日期

Property CreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = PPE_CreateDate ];

//批件号（自动生成）

Property InstrucNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PPE_InstrucNo ];

//批件类型

Property PPEType As %Library.String(DISPLAYLIST = ",Common,Fast,Addition", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",C,F,A") [ SqlColumnNumber = 15, SqlFieldName = PPE_Type ];

//审批医院（主要针对快审批件）

Property Hospital As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PPE_Hospital ];

//审批意见

Property Opinion As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PPE_Opinion ];

//附件 

Property Attachment As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PPE_Attachment ];

//审批日期

Property CheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = PPE_CheckDate ];

//批件号（主要针对快审以及补充批件，手动写入）

Property PJNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PPE_PJNo ];

//资料文件（主要针对补充批件）

Property FileData As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PPE_FileData ];

//审核意见（是否通过，主要针对补充批件）

Property Pass As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = PPE_Pass ];

//回避人数

Property AvoidNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PPE_AvoidNum ];

//任务来源

Property TaskFrom As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PPE_TaskFrom ];

//药检/检验报告批号

Property DrugPJNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PPE_DrugPJNo ];

//研究方案版本号

Property PlanVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PPE_PlanVersion ];

//研究方案版本日期

Property PlanVersionDate As %Library.Date [ SqlColumnNumber = 27, SqlFieldName = PPE_PlanVersionDate ];

//知情同意书版本号

Property FormVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PPE_FormVersion ];

//知情同意书版本日期

Property FormVersionDate As %Library.Date [ SqlColumnNumber = 29, SqlFieldName = PPE_FormVersionDate ];

//同意

Property AgreeNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PPE_AgreeNum ];

//做必要修正后同意

Property ZBYXZHTY As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PPE_ZBYXZHTY ];

//作必要修正后重审

Property BBYXZHCS As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PPE_BBYXZHCS ];

//不同意

Property UAgreeNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PPE_UAgreeNum ];

//终止或暂停已经批准的临床试验

Property ZZHZT As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PPE_ZZHZT ];

//记录人

Property RecordName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PPE_RecordName ];

//主任委员/副主任委员

Property WyName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PPE_WyName ];

//SFDA批件提交日期

Property SFDADate As %Library.Date [ SqlColumnNumber = 37, SqlFieldName = PPE_SFDADate ];

//SFDA批件号

Property SFDANo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = PPE_SFDANo ];

//批准日期

Property ApproveDate As %Library.Date [ SqlColumnNumber = 39, SqlFieldName = PPE_ApproveDate ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPE)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPE_AgreeNum">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PPE_ApproveDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PPE_Attachment">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPE_Attendance">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPE_AvoidNum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PPE_BBYXZHCS">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PPE_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPE_CheckFreq_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPE_ComPenAppraisal">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPE_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPE_DesignAppraisal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPE_DrugPJNo">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PPE_EthicsMeetDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPE_FileData">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PPE_FormAppraisal">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPE_FormVersion">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PPE_FormVersionDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PPE_Hospital">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPE_InstrucNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPE_MainAppraisal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPE_Opinion">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPE_OtherRemark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPE_PJNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PPE_PProject_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPE_Pass">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PPE_PlanVersion">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PPE_PlanVersionDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PPE_RecordName">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PPE_Result_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPE_SFDADate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PPE_SFDANo">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PPE_TaskFrom">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PPE_Type">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPE_UAgreeNum">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PPE_UndecideNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPE_WyName">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PPE_ZBYXZHTY">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PPE_ZZHZT">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^DHCDocPPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PPE_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexProjectDr">
<Global>^DHCDocPPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ProjectDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPE_PProject_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProECRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
