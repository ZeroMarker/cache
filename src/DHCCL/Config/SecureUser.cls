/// 用户
Class DHCCL.Config.SecureUser Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SecureUser ]
{

/// 用户账号
Property Account As %String [ SqlColumnNumber = 2 ];

/// 用户密码
Property Password As %String [ SqlColumnNumber = 3 ];

/// 用户全名
Property FullName As %String [ SqlColumnNumber = 4 ];

/// 用户激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

/// 用户失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 用户默认登录科室
Property DefLoc As DHCCL.Config.Location [ SqlColumnNumber = 7 ];

/// 用户关联的医护人员
Property CareProv As %String [ SqlColumnNumber = 8 ];

/// 用户所在的医院
Property Hospital As DHCCL.Config.Hospital [ SqlColumnNumber = 9 ];

/// 用户默认安全组
Property DefGroup As DHCCL.Code.SecureGroup [ SqlColumnNumber = 10 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 11 ];

/// 签名证书用户唯一识别符
Property SignCertID As %String [ SqlColumnNumber = 12 ];

/// 签名图片(base64字符串或签名图片文件所在的路径)
Property SignImage As %GlobalCharacterStream(LOCATION = "^DHCCL.Config.SecureUserS") [ SqlColumnNumber = 13 ];

/// 是否CA签名
Property CASign As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 14 ];

/// 工号密码签名开始日期
Property AccountSignStartDate As %Date [ SqlColumnNumber = 15 ];

/// 工号密码签名结束日期
Property AccountSignEndDate As %Date [ SqlColumnNumber = 16 ];

Index Account On Account [ Unique ];

Index Group On DefGroup;

Index Hosp On Hospital;

Index Ext On ExternalID;

Index SignCert On SignCertID;

Storage Default
{
<Data name="SecureUserDefaultData">
<Value name="1">
<Value>Account</Value>
</Value>
<Value name="2">
<Value>Password</Value>
</Value>
<Value name="3">
<Value>FullName</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>DefLoc</Value>
</Value>
<Value name="7">
<Value>CareProv</Value>
</Value>
<Value name="8">
<Value>Hospital</Value>
</Value>
<Value name="9">
<Value>DefGroup</Value>
</Value>
<Value name="10">
<Value>ExternalID</Value>
</Value>
<Value name="11">
<Value>SignCertID</Value>
</Value>
<Value name="12">
<Value>SignImage</Value>
</Value>
<Value name="13">
<Value>CASign</Value>
</Value>
<Value name="14">
<Value>AccountSignStartDate</Value>
</Value>
<Value name="15">
<Value>AccountSignEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.SecureUserD</DataLocation>
<DefaultData>SecureUserDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.SecureUserD</IdLocation>
<IndexLocation>^DHCCL.Config.SecureUserI</IndexLocation>
<StreamLocation>^DHCCL.Config.SecureUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
