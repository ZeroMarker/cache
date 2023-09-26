Class User.DHCPENetPreRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_NetPreRecord ]
{

Parameter ClassName = "User.DHCPENetPreRecord";

Relationship NPRPreItemRecord As User.DHCPENetPreItemRecord [ Cardinality = children, Inverse = NPIRParRef ];

Relationship NPRPreOrdSetsRecord As User.DHCPENetPreOrdSetsRec [ Cardinality = children, Inverse = NPORParRef ];

/// His登记号
Property NPRRegNo As %String(MAXLEN = 12) [ SqlFieldName = NPR_RegNo ];

/// 姓名
Property NPRName As %String [ Required, SqlFieldName = NPR_Name ];

/// 性别
Property NPRSexDR As User.CTSex [ Required, SqlFieldName = NPR_Sex_DR ];

/// 年龄
Property NPRAge As %Integer [ SqlFieldName = NPR_Age ];

/// 身份证号
Property NPRIDCard As %String(MAXLEN = 20) [ Required, SqlFieldName = NPR_IDCard ];

/// 预约记录状态0：网上预约 1：医院已预约 2：撤销预约 3：过期未在医院预约 4:his已付费 5:his已体检  6:取消体检
Property NPRStatus As %String(MAXLEN = 1) [ Required, SqlFieldName = NPR_Status ];

/// 预约套餐ID
Property NPRSetsDR As User.ARCOrdSets [ SqlFieldName = NPR_Sets_DR ];

/// 预约检查日期
Property NPRPreDate As %Date [ Required, SqlFieldName = NPR_PreDate ];

/// 预约检查时间
Property NPRPreTime As %Time [ SqlFieldName = NPR_PreTime ];

/// 最后操作日期
Property NPRUpdateDate As %Date [ Required, SqlFieldName = NPR_UpdateDate ];

/// 最后更新时间
Property NPRUpdateTime As %Time [ Required, SqlFieldName = NPR_UpdateTime ];

/// 最后更新人
Property NPRUpdateUserDR As User.SSUser [ SqlFieldName = NPR_UpdateUser_DR ];

/// HIS中体检预约ID（User.DHCPEPreIADM）
Property NPRPreIADM As %String [ SqlFieldName = NPR_PreIADM ];

/// 调查问卷记录ID
Property NPROevaluationDR As User.DHCHMOEvaluationRecord [ SqlFieldName = NPR_Oevaluation_DR ];

/// 预约方式0：未缴费预约 1：已缴费预约 2:窗口预约
Property NPRPayFlag As %String(MAXLEN = 1) [ InitialExpression = "0", Required, SqlFieldName = NPR_PayFlag ];

/// 套餐类型描述
Property NPRLevelDesc As %String [ SqlFieldName = NPR_LevelDesc ];

/// 体检机构ID
Property NPRLocID As %String [ SqlFieldName = NPR_LocID ];

/// 电话
Property NPRTelphoneNo As %String [ SqlFieldName = NPR_TelphoneNo ];

/// 日期类型 H G I 
Property NPRDatePmType As %String [ SqlFieldName = NPR_DatePmType ];

/// User.DHCPEPreTimeManager表ID
Property NPRPreTimeMangerDR As User.DHCPEPreTimeManager [ SqlFieldName = NPR_PreTimeManger_DR ];

/// User.DHCPEPreHomeTimeInfo表ID
Property NPRPreHomeTImeDR As User.DHCPEPreHomeTimeInfo [ SqlFieldName = NPR_PreHomeTIme_DR ];

/// 证件类型
Property NPRCardType As %String(MAXLEN = 20) [ Required, SqlFieldName = NPR_CardType ];

/// 预约时间修改标志
Property NPRPreDateFlag As %String(MAXLEN = 1) [ InitialExpression = "0", Required, SqlFieldName = NPR_PreDateFlag ];

/// 预约途径   
Property NPRPreWay As %String(MAXLEN = 10, VALUELIST = ",Alipay,WeChat,APP,PC,SelfHelp,JKL,DaiShu,DHCPE,AppointCenter") [ Required, SqlFieldName = NPR_PreWay ];

/// 出生日期
Property NPRDob As %Date [ SqlFieldName = NPR_Dob ];

/// 备注  腾讯华为传 大厦、英文名
Property NPRRemark As %String [ SqlFieldName = NPR_Remark ];

/// 部门
Property NPRDepartment As %String [ SqlFieldName = NPR_Department ];

/// 工号
Property NPREmployeeNo As %String [ SqlFieldName = NPR_EmployeeNo ];

/// 体检日期索引
Index PreDateIndex On NPRPreDate;

/// 更新日期索引
Index UpdateDateIndex On NPRUpdateDate;

/// 身份证索引
Index IDCardIndex On NPRIDCard As AlphaUp;

/// 姓名索引
Index NameIndex On NPRName As AlphaUp;

/// 体检日期套餐索引
Index DateSetsIndex On (NPRPreDate, NPRSetsDR);

/// ID号索引
Index RegNoIndex On NPRRegNo As AlphaUp;

Index NPRPreIADMIndex On NPRPreIADM;

Index NPRDatePmTypeIndex On NPRDatePmType;

Index NPROevaluationIndex On NPROevaluationDR;

/// 状态索引
Index StatusIndex On NPRStatus;

Storage Default
{
<Data name="DHCPENetPreRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NPRRegNo</Value>
</Value>
<Value name="3">
<Value>NPRName</Value>
</Value>
<Value name="4">
<Value>NPRSexDR</Value>
</Value>
<Value name="5">
<Value>NPRAge</Value>
</Value>
<Value name="6">
<Value>NPRIDCard</Value>
</Value>
<Value name="7">
<Value>NPRStatus</Value>
</Value>
<Value name="8">
<Value>NPRSetsDR</Value>
</Value>
<Value name="9">
<Value>NPRPreDate</Value>
</Value>
<Value name="10">
<Value>NPRUpdateDate</Value>
</Value>
<Value name="11">
<Value>NPRUpdateTime</Value>
</Value>
<Value name="12">
<Value>NPRUpdateUserDR</Value>
</Value>
<Value name="13">
<Value>NPRPreIADM</Value>
</Value>
<Value name="14">
<Value>NPROevaluationDR</Value>
</Value>
<Value name="15">
<Value>NPRPayFlag</Value>
</Value>
<Value name="16">
<Value>NPRLevelDesc</Value>
</Value>
<Value name="17">
<Value>NPRLocID</Value>
</Value>
<Value name="18">
<Value>NPRPreTime</Value>
</Value>
<Value name="19">
<Value>NPRTelphoneNo</Value>
</Value>
<Value name="20">
<Value>NPRPreTimeMangerDR</Value>
</Value>
<Value name="21">
<Value>NPRCardType</Value>
</Value>
<Value name="22">
<Value>NPRDatePmType</Value>
</Value>
<Value name="23">
<Value>NPRPreHomeTImeDR</Value>
</Value>
<Value name="24">
<Value>NPRPreDateFlag</Value>
</Value>
<Value name="25">
<Value>NPRPreWay</Value>
</Value>
<Value name="26">
<Value>NPRDob</Value>
</Value>
<Value name="27">
<Value>NPRRemark</Value>
</Value>
<Value name="28">
<Value>NPREmployeeNo</Value>
</Value>
<Value name="29">
<Value>NPRDepartment</Value>
</Value>
</Data>
<DataLocation>^User.DHCPENetPreRecordD</DataLocation>
<DefaultData>DHCPENetPreRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetPreRecordD</IdLocation>
<IndexLocation>^User.DHCPENetPreRecordI</IndexLocation>
<StreamLocation>^User.DHCPENetPreRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
