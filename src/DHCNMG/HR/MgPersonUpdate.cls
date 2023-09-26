/// Creator:guozj
/// Descriptions:护士专业档案修改记录
/// Date:2017-11-30
/// 
Class DHCNMG.HR.MgPersonUpdate Extends %Persistent
{

/// 姓名
Property PerName As %String [ SqlColumnNumber = 2, SqlFieldName = Per_Name ];

/// 工号
Property PerID As %String [ SqlColumnNumber = 3, SqlFieldName = Per_ID ];

/// 编号（实习类人员）
Property PerNo As %String [ SqlColumnNumber = 4, SqlFieldName = Per_No ];

/// ssuserid
Property PerUserDR As %String [ SqlColumnNumber = 5, SqlFieldName = Per_UserDR ];

/// 出生日期
Property PerBirthday As %Date [ SqlColumnNumber = 6, SqlFieldName = Per_Birthday ];

/// 身份证号码
Property PerCardId As %String [ SqlColumnNumber = 7, SqlFieldName = Per_CardId ];

/// 医护类型(医生(D)、护士(N))
Property PerCareType As %String [ SqlColumnNumber = 8, SqlFieldName = Per_CareType ];

/// 性别
Property PerSexDR As %String [ SqlColumnNumber = 9, SqlFieldName = Per_SexDR ];

/// 当前病区
Property PerDepDR As %String [ SqlColumnNumber = 10, SqlFieldName = Per_DepDR ];

/// 进入病区日期
Property PerDepDate As %Date [ SqlColumnNumber = 11, SqlFieldName = Per_DepDate ];

/// 来院日期
Property PerComeDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Per_ComeDate ];

/// 护士年届
Property PerYear As %String [ SqlColumnNumber = 13, SqlFieldName = Per_Year ];

/// 参加工作日期
Property PerWorkDate As %Date [ SqlColumnNumber = 14, SqlFieldName = Per_WorkDate ];

/// 注册证书号
Property PerRegNo As %String [ SqlColumnNumber = 15, SqlFieldName = Per_RegNo ];

/// 婚姻
Property PerMarriage As %String [ SqlColumnNumber = 16, SqlFieldName = Per_Marriage ];

/// 籍贯
Property PerNativePlace As %String [ SqlColumnNumber = 17, SqlFieldName = Per_NativePlace ];

/// 职工性质
Property PerSource As %String [ SqlColumnNumber = 18, SqlFieldName = Per_Source ];

/// 现住址
Property PerAddress As %String [ SqlColumnNumber = 19, SqlFieldName = Per_Address ];

/// 政治面貌
Property PerPolitical As %String [ SqlColumnNumber = 20, SqlFieldName = Per_Political ];

/// 民族
Property PerNation As %String [ SqlColumnNumber = 21, SqlFieldName = Per_Nation ];

/// 上衣号
Property PerClothesNo As %String [ SqlColumnNumber = 22, SqlFieldName = Per_ClothesNo ];

/// 裤号
Property PerTrouserNo As %String [ SqlColumnNumber = 23, SqlFieldName = Per_TrouserNo ];

/// 鞋号
Property PerShoesNo As %String [ SqlColumnNumber = 24, SqlFieldName = Per_ShoesNo ];

/// 人员类型（正式（N）、进修（S）、实习（P）、护理员（W））
Property PerTypeDR As %String [ SqlColumnNumber = 25, SqlFieldName = Per_TypeDR ];

/// 是否轮转护士
Property PerTransFlag As %String [ SqlColumnNumber = 26, SqlFieldName = Per_TransFlag ];

/// 工作科室
Property PerWordType As %String [ SqlColumnNumber = 27, SqlFieldName = Per_WordType ];

/// 护士种类
Property PerNurType As %String [ SqlColumnNumber = 28, SqlFieldName = Per_NurType ];

/// 家庭联系人
Property PerContact As %String [ SqlColumnNumber = 29, SqlFieldName = Per_Contact ];

/// 联系方式（手机号）
Property PerPhone As %String [ SqlColumnNumber = 30, SqlFieldName = Per_Phone ];

/// 身高
Property PerHeight As %String [ SqlColumnNumber = 31, SqlFieldName = Per_Height ];

/// 扩展字段{日期}
Property PerRetireDate As %Date [ SqlColumnNumber = 32, SqlFieldName = Per_RetireDate ];

/// 扩展字段{日期}
Property PerResignDate As %Date [ SqlColumnNumber = 33, SqlFieldName = Per_ResignDate ];

/// 照片
Property PerPic As %String [ SqlColumnNumber = 34, SqlFieldName = Per_Pic ];

/// 审核状态（Y、N）
Property PerAuditFlag As %String [ SqlColumnNumber = 35, SqlFieldName = Per_AuditFlag ];

/// 审核人
Property PerAuditor As %String [ SqlColumnNumber = 36, SqlFieldName = Per_Auditor ];

/// 审核日期
Property PerAuditDate As %Date [ SqlColumnNumber = 37, SqlFieldName = Per_AuditDate ];

/// 添加人
Property RecUser As %String [ SqlColumnNumber = 38, SqlFieldName = Rec_User ];

/// 更新日期
Property RecDate As %Date [ SqlColumnNumber = 39, SqlFieldName = Rec_Date ];

/// 更新时间
Property RecTime As %Time [ SqlColumnNumber = 40, SqlFieldName = Rec_Time ];

/// 院内短号
Property PerHosShortNo As %String [ SqlColumnNumber = 41, SqlFieldName = Per_HosShortNo ];

/// 在院状态 在职 离职 退休
Property PerStatus As %String [ SqlColumnNumber = 42, SqlFieldName = Per_Status ];

/// 状态日期 
Property PerStateDate As %Date [ SqlColumnNumber = 43, SqlFieldName = PerStateDate ];

/// 状态原因
Property PerStatuReason As %String(MAXLEN = 2000) [ SqlColumnNumber = 44, SqlFieldName = Per_StatuReason ];

/// 提干日期
Property PerCadreDate As %Date [ SqlColumnNumber = 45, SqlFieldName = Per_CadreDate ];

/// 创建记录日期
Property CreateRecDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 46, SqlFieldName = Create_RecDate ];

/// 创建记录时间
Property CreateRecTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 47, SqlFieldName = Create_RecTime ];

Index date On CreateRecDate;

Storage Default
{
<Data name="MgPersonUpdateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerName</Value>
</Value>
<Value name="3">
<Value>PerID</Value>
</Value>
<Value name="4">
<Value>PerNo</Value>
</Value>
<Value name="5">
<Value>PerUserDR</Value>
</Value>
<Value name="6">
<Value>PerBirthday</Value>
</Value>
<Value name="7">
<Value>PerCardId</Value>
</Value>
<Value name="8">
<Value>PerCareType</Value>
</Value>
<Value name="9">
<Value>PerSexDR</Value>
</Value>
<Value name="10">
<Value>PerDepDR</Value>
</Value>
<Value name="11">
<Value>PerDepDate</Value>
</Value>
<Value name="12">
<Value>PerComeDate</Value>
</Value>
<Value name="13">
<Value>PerYear</Value>
</Value>
<Value name="14">
<Value>PerWorkDate</Value>
</Value>
<Value name="15">
<Value>PerRegNo</Value>
</Value>
<Value name="16">
<Value>PerMarriage</Value>
</Value>
<Value name="17">
<Value>PerNativePlace</Value>
</Value>
<Value name="18">
<Value>PerSource</Value>
</Value>
<Value name="19">
<Value>PerAddress</Value>
</Value>
<Value name="20">
<Value>PerPolitical</Value>
</Value>
<Value name="21">
<Value>PerNation</Value>
</Value>
<Value name="22">
<Value>PerClothesNo</Value>
</Value>
<Value name="23">
<Value>PerTrouserNo</Value>
</Value>
<Value name="24">
<Value>PerShoesNo</Value>
</Value>
<Value name="25">
<Value>PerTypeDR</Value>
</Value>
<Value name="26">
<Value>PerTransFlag</Value>
</Value>
<Value name="27">
<Value>PerWordType</Value>
</Value>
<Value name="28">
<Value>PerNurType</Value>
</Value>
<Value name="29">
<Value>PerContact</Value>
</Value>
<Value name="30">
<Value>PerPhone</Value>
</Value>
<Value name="31">
<Value>PerHeight</Value>
</Value>
<Value name="32">
<Value>PerRetireDate</Value>
</Value>
<Value name="33">
<Value>PerResignDate</Value>
</Value>
<Value name="34">
<Value>PerPic</Value>
</Value>
<Value name="35">
<Value>PerAuditFlag</Value>
</Value>
<Value name="36">
<Value>PerAuditor</Value>
</Value>
<Value name="37">
<Value>PerAuditDate</Value>
</Value>
<Value name="38">
<Value>RecUser</Value>
</Value>
<Value name="39">
<Value>RecDate</Value>
</Value>
<Value name="40">
<Value>RecTime</Value>
</Value>
<Value name="41">
<Value>PerHosShortNo</Value>
</Value>
<Value name="42">
<Value>PerStatus</Value>
</Value>
<Value name="43">
<Value>PerStateDate</Value>
</Value>
<Value name="44">
<Value>PerStatuReason</Value>
</Value>
<Value name="45">
<Value>PerCadreDate</Value>
</Value>
<Value name="46">
<Value>CreateRecDate</Value>
</Value>
<Value name="47">
<Value>CreateRecTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgPersonUpdateD</DataLocation>
<DefaultData>MgPersonUpdateDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgPersonUpdateD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgPersonUpdateI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgPersonUpdateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
