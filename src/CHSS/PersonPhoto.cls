Class CHSS.PersonPhoto Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PhotoRowId, SqlTableName = PersonPhoto ]
{

/// 个人档案主键	
Property PersonRowId As CHSS.PersonHealthRecordMain;

/// 照片
Property Photo As %GlobalBinaryStream;

/// 照片路径
Property PhotoUrl As %String(MAXLEN = 100, TRUNCATE = 1);

/// 照片名称
Property PhotoName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 上传日期
Property DateOfUpload As %Date;

/// 照相日期
Property DateOfPhoto As %Date;

/// 上传人员
Property StaffOfUpload As %String(MAXLEN = 50, TRUNCATE = 1);

/// 默认照片
Property bCurrentPhoto As %String(MAXLEN = 5, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PersonPhotoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonRowId</Value>
</Value>
<Value name="3">
<Value>Photo</Value>
</Value>
<Value name="4">
<Value>PhotoName</Value>
</Value>
<Value name="5">
<Value>DateOfPhoto</Value>
</Value>
<Value name="6">
<Value>DateOfUpload</Value>
</Value>
<Value name="7">
<Value>StaffOfUpload</Value>
</Value>
<Value name="8">
<Value>bCurrentPhoto</Value>
</Value>
<Value name="9">
<Value>PhotoUrl</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonPhotoD</DataLocation>
<DefaultData>PersonPhotoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonPhotoD</IdLocation>
<IndexLocation>^CHSS.PersonPhotoI</IndexLocation>
<StreamLocation>^CHSS.PersonPhotoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
