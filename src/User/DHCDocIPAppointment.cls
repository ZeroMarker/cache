/// 住院证表，记录住院证内容
Class User.DHCDocIPAppointment Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPAppointment, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10000;

/// 住院证DHCDocIPBooking 指向DHCDocIPBooking
Property IPBookingDr As DHCDocIPBooking [ SqlColumnNumber = 2, SqlFieldName = IPBookingDr ];

/// PA_PatMas.RowID
Property PatientID As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PatientID ];

/// 住院就诊PAADM  指向PA_ADM
Property EpisodeIDTo As PAAdm [ SqlColumnNumber = 4, SqlFieldName = EpisodeIDTo ];

/// 预约生成日期
Property CreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CreateDate ];

/// 预约生成时间
Property CreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CreateTime ];

/// 预约住院操作员ID 指向SS_User
Property CreateUserID As SSUser [ SqlColumnNumber = 7, SqlFieldName = CreateUserID ];

/// 预约医师ID 指向SS_User
Property AppDocID As SSUser [ SqlColumnNumber = 8, SqlFieldName = AppDocID ];

/// 预约科室ID 指向CT_Loc
Property AppLocID As CTLoc [ SqlColumnNumber = 9, SqlFieldName = AppLocID ];

/*
/// 患者等级
Property PatientGradeDr As DHCDocIPGrade [ SqlColumnNumber = 10, SqlFieldName = PatientGradeDr ];

/// 床位意向
Property BedIntention As %String(COLLATION = "EXACT", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = BedIntention ];

/// 患者分类
Property PatientSort As %String(COLLATION = "EXACT", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PatientSort ];

/// 检验检查医嘱
Property OrderBeforeIP As %String(COLLATION = "EXACT", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = OrderBeforeIP ];
*/
/// 病床PAC_Bed.rowid
Property BedNODr As PACBed [ SqlColumnNumber = 10, SqlFieldName = BedNODr ];

/// 预约状态
Property IPStatus As %String(DISPLAYLIST = ",Book,Allocate,Arrive,Cancle,Hang", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",B,Al,Ar,C,H") [ SqlColumnNumber = 11, SqlFieldName = IPStatus ];

/// 预约住院日期
Property AppDate As %Date [ SqlColumnNumber = 12, SqlFieldName = AppDate ];

/// 预缴押金
Property AppCash As %String(COLLATION = "EXACT", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AppCash ];

/// 作废原因
Property CancleReasonDr As DHCDocIPCancleReason [ SqlColumnNumber = 14, SqlFieldName = CancleReasonDr ];

/// 分配床位日期
Property AllocateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = AllocateDate ];

/// 分配床位时间
Property AllocateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = AllocateTime ];

/// 作废日期
Property CancleDate As %Date [ SqlColumnNumber = 17, SqlFieldName = CancleDate ];

/// 作废时间
Property CancleTime As %Time [ SqlColumnNumber = 18, SqlFieldName = CancleTime ];

/// 最后更新日期
Property LastUpdateDate As %Date [ SqlColumnNumber = 19, SqlFieldName = LastUpdateDate ];

/// 最后更新时间
Property LastUpdateTime As %Time [ SqlColumnNumber = 20, SqlFieldName = LastUpdateTime ];

/// 专业
Property Specialty As DHCCTLocMedUnit [ SqlColumnNumber = 21, SqlFieldName = Specialty ];

/// 预约病区
Property AppWardID As CTLoc [ SqlColumnNumber = 22, SqlFieldName = AppWardID ];

/// 就诊级别 
Property TeartLevel As CTAcuity [ SqlColumnNumber = 23, SqlFieldName = TeartLevel ];

/// 预约院区
Property AppHospitalID As CTHospital [ SqlColumnNumber = 24, SqlFieldName = AppHospitalID ];

/// 挂起开始时间
Property HangStartDate As %Date [ SqlColumnNumber = 25, SqlFieldName = HangStartDate ];

/// 挂起结束时间
Property HangEndDate As %Date [ SqlColumnNumber = 26, SqlFieldName = HangEndDate ];

/// 是否陪床
Property IfAccompany As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = IfAccompany ];

/// 陪床人性别
Property AccompanySex As CTSex [ SqlColumnNumber = 28, SqlFieldName = AccompanySex ];

/// 页面诊断录入
Property PaDiagnos As MRCICDDx [ SqlColumnNumber = 29, SqlFieldName = PaDiagnos ];

/// 床位分配操作员ID 指向SS_User
Property BedDistributeUserID As SSUser [ SqlColumnNumber = 30, SqlFieldName = BedDistributeUserID ];

/// 信息作废操作员ID 指向SS_User
Property InfoCancelUserID As SSUser [ SqlColumnNumber = 31, SqlFieldName = InfoCancelUserID ];

/// 当前状态ID 指向DHCDocIPBDictory
Property CurrentStateID As DHCDocIPBDictory [ SqlColumnNumber = 32, SqlFieldName = CurrentStateID ];

/// 预约人电话
Property AppointPhone As %String [ SqlColumnNumber = 33, SqlFieldName = AppointPhone ];

/// 预约人姓名
Property AppointName As %String [ SqlColumnNumber = 34, SqlFieldName = AppointName ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 35, SqlFieldName = Remark ];

/// SQL存储结构
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储结构]]></Description>
<ExtentSize>10000</ExtentSize>
<SqlIdExpression>$i(^DHCDocIPApp(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AccompanySex">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AllocateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AllocateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AppCash">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AppDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AppDocID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AppHospitalID">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AppLocID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AppWardID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AppointName">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AppointPhone">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BedDistributeUserID">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BedNODr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CancleDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CancleReasonDr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CancleTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CreateUserID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CurrentStateID">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="EpisodeIDTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HangEndDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HangStartDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IPBookingDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IfAccompany">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="InfoCancelUserID">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PaDiagnos">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PatientID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Remark">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="Specialty">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TeartLevel">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^DHCDocIPApp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppDate">
<Global>^DHCDocIPApp</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AppDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBookingID">
<Global>^DHCDocIPApp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"IPBookingID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IPBookingDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPStatus">
<Global>^DHCDocIPApp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLastUpdateDate">
<Global>^DHCDocIPApp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LastUpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LastUpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientID">
<Global>^DHCDocIPApp</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PatientID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PatientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPAppointmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
