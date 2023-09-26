/// Creator:
/// Descriptions:实习历史记录档案
/// Date:
/// 
Class DHCNMG.HR.MgIntern Extends %Persistent
{

/// 人员档案id
Property IntPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Int_PerDR ];

/// 姓名
Property IntName As %String [ SqlColumnNumber = 3, SqlFieldName = Int_Name ];

/// 编号（）
Property IntNo As %String [ SqlColumnNumber = 4, SqlFieldName = Int_No ];

/// 出生日期
Property IntBirthday As %Date [ SqlColumnNumber = 5, SqlFieldName = Int_Birthday ];

/// 身份证号码
Property IntCardId As %String [ SqlColumnNumber = 6, SqlFieldName = Int_CardId ];

/// 性别
Property IntSexDR As %String [ SqlColumnNumber = 7, SqlFieldName = Int_SexDR ];

/// 当前科室
Property IntDepDR As %String [ SqlColumnNumber = 8, SqlFieldName = Int_DepDR ];

/// 进入当前科室日期
Property IntDepDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Int_DepDate ];

/// 来院日期
Property IntComeDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Int_ComeDate ];

/// 政治面貌
Property IntPolitical As %String [ SqlColumnNumber = 11, SqlFieldName = Int_Political ];

/// 籍贯
Property IntNativePlace As %String [ SqlColumnNumber = 12, SqlFieldName = Int_NativePlace ];

/// 婚姻
Property IntMarriage As %String [ SqlColumnNumber = 13, SqlFieldName = Int_Marriage ];

/// 现住址
Property IntAddress As %String [ SqlColumnNumber = 14, SqlFieldName = Int_Address ];

/// 家庭联系人
Property IntContact As %String [ SqlColumnNumber = 15, SqlFieldName = Int_Contact ];

/// 联系方式（手机号）
Property IntPhone As %String [ SqlColumnNumber = 16, SqlFieldName = Int_Phone ];

/// 实习成绩
Property IntScore As %String [ SqlColumnNumber = 17, SqlFieldName = Int_Score ];

/// 转正状态A未审核、Y已转正、N驳回
Property IntStatus As %String [ SqlColumnNumber = 18, SqlFieldName = Int_Status ];

/// 添加人
Property RecUser As %String [ SqlColumnNumber = 19, SqlFieldName = Rec_User ];

/// 更新日期
Property RecDate As %Date [ SqlColumnNumber = 20, SqlFieldName = Rec_Date ];

/// 更新时间
Property RecTime As %Time [ SqlColumnNumber = 21, SqlFieldName = Rec_Time ];

/// 照片
Property IntPic As %String [ SqlColumnNumber = 22, SqlFieldName = Per_Pic ];

Index ssid On IntPerDR;

Storage Default
{
<Data name="MgInternDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IntName</Value>
</Value>
<Value name="3">
<Value>IntID</Value>
</Value>
<Value name="4">
<Value>IntNo</Value>
</Value>
<Value name="5">
<Value>IntBirthday</Value>
</Value>
<Value name="6">
<Value>IntCardId</Value>
</Value>
<Value name="7">
<Value>IntSexDR</Value>
</Value>
<Value name="8">
<Value>IntDepDR</Value>
</Value>
<Value name="9">
<Value>IntDepDate</Value>
</Value>
<Value name="10">
<Value>IntComeDate</Value>
</Value>
<Value name="11">
<Value>IntPolitical</Value>
</Value>
<Value name="12">
<Value>IntNativePlace</Value>
</Value>
<Value name="13">
<Value>IntMarriage</Value>
</Value>
<Value name="14">
<Value>IntAddress</Value>
</Value>
<Value name="15">
<Value>IntContact</Value>
</Value>
<Value name="16">
<Value>IntPhone</Value>
</Value>
<Value name="17">
<Value>IntPerDR</Value>
</Value>
<Value name="18">
<Value>IntScore</Value>
</Value>
<Value name="19">
<Value>IntStatus</Value>
</Value>
<Value name="20">
<Value>RecUser</Value>
</Value>
<Value name="21">
<Value>RecDate</Value>
</Value>
<Value name="22">
<Value>RecTime</Value>
</Value>
<Value name="23">
<Value>IntPic</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgInternD</DataLocation>
<DefaultData>MgInternDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgInternD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgInternI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgInternS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
