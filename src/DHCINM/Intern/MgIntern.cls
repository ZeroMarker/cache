/// Creator:
/// Descriptions:实习历史记录档案
/// Date:
Class DHCINM.Intern.MgIntern Extends %Persistent
{

/// 人员档案id
Property IntPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Int_PerDR ];

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

/// 籍贯所在省
Property NativeProvince As %String [ SqlColumnNumber = 23, SqlFieldName = Per_NativeProvince ];

/// 籍贯所在市
Property NativeCity As %String [ SqlColumnNumber = 24, SqlFieldName = Per_NativeCity ];

/// 籍贯详细地址              
Property NativeAddress As %String [ SqlColumnNumber = 25, SqlFieldName = Per_NativeAddress ];

/// 现住址所在省               
Property CurrentProvince As %String [ SqlColumnNumber = 26, SqlFieldName = Per_CurrentProvince ];

/// 现住址所在市              
Property CurrentCity As %String [ SqlColumnNumber = 27, SqlFieldName = Per_CurrentCity ];

/// 现住址                     
Property CurrentAddress As %String [ SqlColumnNumber = 28, SqlFieldName = Per_CurrentAddress ];

/// 应往届【实习生的应往届】
Property PerCategroy As %String [ SqlColumnNumber = 29, SqlFieldName = Per_Categroy ];

/// 籍贯所在区(县)
Property NativeArea As %String [ SqlColumnNumber = 31, SqlFieldName = Per_NativeArea ];

/// 现住址所在市区(县)            
Property CurrentArea As %String [ SqlColumnNumber = 32, SqlFieldName = Per_CurrentArea ];

/// 实习生院校
Property PerInternSchool As %String [ SqlColumnNumber = 30, SqlFieldName = Per_InternSchool ];

/// 实习开始日期
Property PerInternStDate As %Date [ SqlColumnNumber = 33, SqlFieldName = Per_InternStDate ];

/// 实习结束日期
Property PerInternEndDate As %Date [ SqlColumnNumber = 34, SqlFieldName = Per_InternEndDate ];

Index ssid On IntPerDR;

Storage Default
{
<Data name="MgInternDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IntPerDR</Value>
</Value>
<Value name="3">
<Value>IntName</Value>
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
<Value>IntScore</Value>
</Value>
<Value name="18">
<Value>IntStatus</Value>
</Value>
<Value name="19">
<Value>RecUser</Value>
</Value>
<Value name="20">
<Value>RecDate</Value>
</Value>
<Value name="21">
<Value>RecTime</Value>
</Value>
<Value name="22">
<Value>IntPic</Value>
</Value>
<Value name="23">
<Value>NativeProvince</Value>
</Value>
<Value name="24">
<Value>NativeCity</Value>
</Value>
<Value name="25">
<Value>NativeAddress</Value>
</Value>
<Value name="26">
<Value>CurrentProvince</Value>
</Value>
<Value name="27">
<Value>CurrentCity</Value>
</Value>
<Value name="28">
<Value>CurrentAddress</Value>
</Value>
<Value name="29">
<Value>PerCategroy</Value>
</Value>
<Value name="30">
<Value>PerInternSchool</Value>
</Value>
<Value name="31">
<Value>NativeArea</Value>
</Value>
<Value name="32">
<Value>CurrentArea</Value>
</Value>
<Value name="33">
<Value>PerInternStDate</Value>
</Value>
<Value name="34">
<Value>PerInternEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgInternD</DataLocation>
<DefaultData>MgInternDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgInternD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgInternI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgInternS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
