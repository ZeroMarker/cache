/// 住院证表，记录住院证内容
Class User.DHCDocIPBooking Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCDocIPBooking, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10000000;

/// PA_PatMas.RowID
Property PatientID As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = PatientID ];

/// 门诊就诊PAADM  指向PA_ADM
Property EpisodeIDFrom As PAAdm [ SqlColumnNumber = 3, SqlFieldName = EpisodeIDFrom ];

/// 住院就诊PAADM  指向PA_ADM
Property EpisodeIDTo As PAAdm [ SqlColumnNumber = 4, SqlFieldName = EpisodeIDTo ];

/// 建住院证日期
Property CreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CreateDate ];

/// 建住院证时间
Property CreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CreateTime ];

/// 建住院证操作员ID 指向SS_User
Property CreateUserID As SSUser [ SqlColumnNumber = 7, SqlFieldName = CreateUserID ];

/// 建住院证医师ID 指向SS_User
Property CreateDocID As SSUser [ SqlColumnNumber = 8, SqlFieldName = CreateDocID ];

/// 当前状态ID 指向DHCDocIPBDictory
Property CurrentStateID As DHCDocIPBDictory [ SqlColumnNumber = 9, SqlFieldName = CurrentStateID ];

/// 有效状态 Yes/No
Property IsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = IsActive ];

/// 建住院证日期
Property BookingDate As %Date [ SqlColumnNumber = 11, SqlFieldName = BookingDate ];

/// 病区ID(PAC_Ward)
Property Text1 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Text1 ];

/// 床位ID(PAC_Bed)
Property Text2 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Text2 ];

/// 科室ID(CT_Loc)
Property Text3 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Text3 ];

/// 诊断ID(MRC_ICDDx)
Property Text4 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = Text4 ];

/// 备注
Property ResumeText As %String(COLLATION = "EXACT", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ResumeText ];

/// 紧急条件,韶关增加
Property MRCCondtion As PACReferralPriority [ SqlColumnNumber = 17, SqlFieldName = MRCCondtion ];

/// 住院押金
Property IPDeposit As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IPDeposit ];

/// 备用字段4
Property Text6 As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = Text6 ];

/// 诊断注释
Property DiagnosNotes As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = DiagnosNotes ];

/// 住院证编号 IPBookNo
Property IPBookNo As %String [ SqlColumnNumber = 21, SqlFieldName = IPBookNo ];

/// 操作原因
Property InReason As DHCDocIPBDictory [ SqlColumnNumber = 22, SqlFieldName = InReason ];

/// 入院途径
Property InSorce As PACAdmSource [ SqlColumnNumber = 23, SqlFieldName = InSorce ];

/// 建议床位
Property InBedType As %String(COLLATION = "EXACT", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = InBedType ];

/// 入院诊断ICD!ICD!...
Property ICDList As %String(COLLATION = "EXACT", MAXLEN = 9999, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = ICDList ];

/// 最后更新人
Property UpdateUser As SSUser [ SqlColumnNumber = 26, SqlFieldName = UpdateUser ];

/// 最后更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 27, SqlFieldName = UpdateDate ];

/// 最后更新日期
Property UpdateTime As %Time [ SqlColumnNumber = 28, SqlFieldName = UpdateTime ];

/// 入院病情
Property AdmInitState As PACReferralPriority [ SqlColumnNumber = 29, SqlFieldName = AdmInitState ];

/// 患者等级
Property PatientLevel As DHCDocIPBDictory [ SqlColumnNumber = 30, SqlFieldName = PatientLevel ];

/// 医疗单元 
Property CTLocMedUnit As User.DHCCTLocMedUnit [ SqlColumnNumber = 31, SqlFieldName = CTLocMedUnit ];

/// 主治医师
Property PatInDoctor As CTCareProv [ SqlColumnNumber = 32, SqlFieldName = PatInDoctor ];

/// 收治原则
Property TreatedPrinciple As DHCDocIPBDictory [ SqlColumnNumber = 33, SqlFieldName = TreatedPrinciple ];

/// 是否日间 Yes/No
Property IsDayFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = IsDayFlag ];

/// 是否外院转来 Yes/No
Property IsOutTriage As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = IsOutTriage ];

/// 病区选择类型 1 本科室 2 本科室关联 3 其他病区
Property WardType As %String [ SqlColumnNumber = 36, SqlFieldName = WardType ];

/// 建住院证操作员登录科室 指向SS_User
Property CreateLogLoc As CTLoc [ SqlColumnNumber = 37, SqlFieldName = CreateLogLoc ];

/// 预约时段
Property BookingTimeRangeDR As DHCDocIPBDictory [ SqlColumnNumber = 38, SqlFieldName = BookingTimeRangeDR ];

/// 是否发送短信
Property YSsendSMS As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = YSsendSMS ];

///  接收短信手机号
Property ReceiveSMSPhone As %String [ SqlColumnNumber = 40, SqlFieldName = ReceiveSMSPhone ];

/// 短信内容 SMStext
Property SMStext As %String(MAXLEN = 32767) [ SqlColumnNumber = 41, SqlFieldName = SMStext ];

/// 基础疾病,文本记录,也可以在备注中记录
Property BasicDisease As %String(MAXLEN = 500) [ SqlColumnNumber = 42, SqlFieldName = BasicDisease ];

/// 是否陪住
Property YNAccompany As %String [ SqlColumnNumber = 43, SqlFieldName = YNAccompany ];

/// 陪伴人数
Property CompanyNum As %String [ SqlColumnNumber = 44, SqlFieldName = CompanyNum ];

/// 实际入院日期
Property InAdmDate As %Date [ SqlColumnNumber = 45, SqlFieldName = InAdmDate ];

/// 实际入院时间
Property InAdmTime As %Time [ SqlColumnNumber = 46, SqlFieldName = InAdmTime ];

/// 到院交通工具
Property InHosTransport As DHCDocIPBDictory [ SqlColumnNumber = 47, SqlFieldName = InHosTransport ];

/// 15天再入院标志
Property ReAdmission As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = ReAdmission ];

/// 入院费别
Property InAdmReason As User.PACAdmReason [ SqlColumnNumber = 49, SqlFieldName = InAdmReason ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(web.DHCDocIPBookingStateChange).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(web.DHCDocIPBookingStateChange).OnTrigger($g(%d(1)),"TAfterUpd")
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    i insert {
	    s sc=##Class(web.DHCDocIPBookingStateChange).OnTrigger(%this.%Id(),"TAfterIns")
    }else{
	    s sc=##Class(web.DHCDocIPBookingStateChange).OnTrigger(%this.%Id(),"TAfterUpd")
    }
    
    Q sc
}

/// SQL存储结构
Storage SQLStorage
{
<Description>
<![CDATA[SQL存储结构]]></Description>
<ExtentSize>10000000</ExtentSize>
<SqlIdExpression>$i(^DHCDocIPBK(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AdmInitState">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BasicDisease">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="BookingDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BookingTimeRangeDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CTLocMedUnit">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CompanyNum">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CreateDocID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CreateLogLoc">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
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
<Piece>8</Piece>
</Data>
<Data name="DiagnosNotes">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EpisodeIDFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EpisodeIDTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICDList">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IPBookNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IPDeposit">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="InAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="InAdmReason">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="InAdmTime">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="InBedType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="InHosTransport">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="InReason">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="InSorce">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IsDayFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IsOutTriage">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MRCCondtion">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PatInDoctor">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PatientID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PatientLevel">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ReAdmission">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ReceiveSMSPhone">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMStext">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="Text1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Text2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Text3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Text4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Text6">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TreatedPrinciple">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="WardType">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="YNAccompany">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="YSsendSMS">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Global>^DHCDocIPBK</Global>
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
<SQLMap name="IndexBookingDate">
<Global>^DHCDocIPBK</Global>
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
<Expression>"BookingDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{BookingDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreatDateTimeState">
<Global>^DHCDocIPBK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CreateDateTimeState"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CreateTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CurrentStateID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisodeIDFrom">
<Global>^DHCDocIPBK</Global>
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
<Expression>"EpisodeIDFrom"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{EpisodeIDFrom}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisodeIDTo">
<Global>^DHCDocIPBK</Global>
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
<Expression>"EpisodeIDTo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{EpisodeIDTo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPBookingNo">
<Global>^DHCDocIPBK</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPBookingNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPBookNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientID">
<Global>^DHCDocIPBK</Global>
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
<AccessType>Sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocIPBookingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
