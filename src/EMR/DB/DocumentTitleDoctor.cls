/// 名称:	EMR.DB.DoctorSignStream
/// 描述:	记录病程记录中选择的医师信息
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB.DocumentTitleDoctor Extends %Persistent
{

Index IdxDocumentID On DocumentID [ Unique ];

Index IdxDocumentIDUserID On (DocumentID, UserID) [ Unique ];

/// 用户ID(=TrakID)
Property UserID As %String(TRUNCATE = 1);

/// 医生级别 Resident, Attending, Chief
Property UserLevel As %String(TRUNCATE = 1);

/// 医生级别描述
Property UserLevelDesc As %String(TRUNCATE = 1);

/// 医生姓名
Property UserName As %String(TRUNCATE = 1);

/// 病历ID
Property DocumentID As %String [ Required ];

Storage Default
{
<Data name="DocumentTitleDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserLevel</Value>
</Value>
<Value name="4">
<Value>UserLevelDesc</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
<Value name="6">
<Value>DocumentID</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.DocumentTitleDoctorD</DataLocation>
<DefaultData>DocumentTitleDoctorDefaultData</DefaultData>
<IdLocation>^EMR.DB.DocumentTitleDoctorD</IdLocation>
<IndexLocation>^EMR.DB.DocumentTitleDoctorI</IndexLocation>
<StreamLocation>^EMR.DB.DocumentTitleDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
