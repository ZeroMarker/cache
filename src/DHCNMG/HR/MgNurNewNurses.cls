/// Creator:
/// Descriptions:新人档案
/// Date:2017-11-28
/// 
Class DHCNMG.HR.MgNurNewNurses Extends %Persistent
{

/// 人员表记录ID
Property NewNurseDR As %String [ SqlColumnNumber = 2, SqlFieldName = New_NurseDR ];

/// 姓名
Property NewNurseName As %String [ SqlColumnNumber = 3, SqlFieldName = New_NurseName ];

/// 工号
Property NewNurseID As %String [ SqlColumnNumber = 4, SqlFieldName = New_NurseID ];

/// 出生日期
Property NewBirthday As %Date [ SqlColumnNumber = 5, SqlFieldName = New_Birthday ];

/// 身份证号码
Property NewCardId As %String [ SqlColumnNumber = 6, SqlFieldName = New_CardId ];

/// 性别
Property NewSexDR As %String [ SqlColumnNumber = 7, SqlFieldName = New_SexDR ];

/// 当前病区
Property NewDepDR As %String [ SqlColumnNumber = 8, SqlFieldName = New_DepDR ];

/// 进病区日期
Property NewDepDate As %Date [ SqlColumnNumber = 9, SqlFieldName = New_DepDate ];

/// 来院日期
Property NewComeDate As %Date [ SqlColumnNumber = 10, SqlFieldName = New_ComeDate ];

/// 参加工作日期
Property NewWorkDate As %Date [ SqlColumnNumber = 11, SqlFieldName = New_WorkDate ];

/// 婚姻
Property NewMarriage As %String [ SqlColumnNumber = 12, SqlFieldName = New_Marriage ];

/// 籍贯
Property NewNativePlace As %String [ SqlColumnNumber = 13, SqlFieldName = New_NativePlace ];

/// 政治面貌
Property NewPolitical As %String [ SqlColumnNumber = 14, SqlFieldName = New_Political ];

/// 家庭地址
Property NewAddress As %String [ SqlColumnNumber = 15, SqlFieldName = New_Address ];

/// 家庭联系人
Property NewContact As %String [ SqlColumnNumber = 16, SqlFieldName = New_Contact ];

/// 联系方式（手机号）
Property NewPhone As %String [ SqlColumnNumber = 17, SqlFieldName = New_Phone ];

/// 同步日期
Property NewSyncDate As %Date [ SqlColumnNumber = 18, SqlFieldName = New_SyncDate ];

/// 同步状态
Property NewSyncState As %String [ SqlColumnNumber = 19, SqlFieldName = New_SyncState ];

/// 同步人
Property NewSyncUser As %String [ SqlColumnNumber = 20, SqlFieldName = New_SyncUser ];

/// 创建人
Property NewCreateUser As %String [ SqlColumnNumber = 21, SqlFieldName = New_CreateUser ];

/// 科室
Property NewLocDR As %String [ SqlColumnNumber = 22, SqlFieldName = New_LocDR ];

/// 证书图片
Property CertPic As list Of %String [ SqlColumnNumber = 23, SqlFieldName = CertPic ];

Index card On NewCardId;

Index nurno On NewNurseID;

Storage Default
{
<Data name="MgNurNewNursesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NewName</Value>
</Value>
<Value name="3">
<Value>NewID</Value>
</Value>
<Value name="4">
<Value>NewBirthday</Value>
</Value>
<Value name="5">
<Value>NewCardId</Value>
</Value>
<Value name="6">
<Value>NewSexDR</Value>
</Value>
<Value name="7">
<Value>NewDepDR</Value>
</Value>
<Value name="8">
<Value>NewDepDate</Value>
</Value>
<Value name="9">
<Value>NewComeDate</Value>
</Value>
<Value name="10">
<Value>NewWorkDate</Value>
</Value>
<Value name="11">
<Value>NewMarriage</Value>
</Value>
<Value name="12">
<Value>NewNativePlace</Value>
</Value>
<Value name="13">
<Value>NewPolitical</Value>
</Value>
<Value name="14">
<Value>NewAddress</Value>
</Value>
<Value name="15">
<Value>NewContact</Value>
</Value>
<Value name="16">
<Value>NewPhone</Value>
</Value>
<Value name="17">
<Value>NewSyncDate</Value>
</Value>
<Value name="18">
<Value>NewSyncState</Value>
</Value>
<Value name="19">
<Value>NewSyncUser</Value>
</Value>
<Value name="20">
<Value>NewNurseName</Value>
</Value>
<Value name="21">
<Value>NewNurseID</Value>
</Value>
<Value name="22">
<Value>NewNurseDR</Value>
</Value>
<Value name="23">
<Value>NewCreateUser</Value>
</Value>
<Value name="24">
<Value>NewLocDR</Value>
</Value>
<Value name="25">
<Value>CertPic</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurNewNursesD</DataLocation>
<DefaultData>MgNurNewNursesDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgNurNewNursesD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurNewNursesI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurNewNursesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
