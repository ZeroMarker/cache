Class CIS.AN.CA.UsrSignatureInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = UsrSignatureInfo ]
{

// 用户ID

Property UsrID As CF.AN.SSUser;

// 身份证

Property IdentityID As %String(TRUNCATE = 1);

// 证书

Property Certificate As %String(MAXLEN = 999999, TRUNCATE = 1);

// 证书编号

Property CertificateNo As %String(MAXLEN = 999, TRUNCATE = 1);

// 证书序列号 

Property CertificateSN As %String(MAXLEN = 99, TRUNCATE = 1);

// UKey编号（介质编号）

Property UKeyNo As %String(MAXLEN = 99, TRUNCATE = 1);

// 签名图 Base64编码的字符串

Property SignImage As %String(MAXLEN = 999999, TRUNCATE = 1);

// 用户证书唯一标识

Property UsrCertCode As %String(MAXLEN = 50, TRUNCATE = 1);

// 证书CN名称

Property CertName As %String(MAXLEN = 60, TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

// 是否启用 1/0

Property InUse As %Boolean;

Property ExternalID As %String;

// 

Index InUseID On (UsrID, InUse);

Index InUseKey On (UsrCertCode, InUse, UsrID);

Index InUsedID On (UsrCertCode, InUse);

Index IExt On ExternalID;

/// w ##Class(CIS.AN.CA.UsrSignatureInfo).GetInUseID("105")
ClassMethod GetInUseID(usrID As %String) As %String
{
	s id=""
	s id=$O(^CIS.AN.CA.UsrSignatureInfoI("InUseID", " "_usrID, 1, id))
	q id
}

ClassMethod GetInUseInfo(usrID As %String) As CIS.AN.CA.UsrSignatureInfo
{
	s id=##Class(CIS.AN.CA.UsrSignatureInfo).GetInUseID(usrID)
	q:(id="") ""
	
	q ##Class(CIS.AN.CA.UsrSignatureInfo).%OpenId(id)
}

ClassMethod GetCertName(usrID As %String) As CIS.AN.CA.UsrSignatureInfo
{
	s id=##Class(CIS.AN.CA.UsrSignatureInfo).GetInUseID(usrID)
	q:(id="") ""
	
	s obj=##Class(CIS.AN.CA.UsrSignatureInfo).%OpenId(id)
	q:(obj'="") obj.CertName
	q ""
}

/// 使用中
ClassMethod GetInUsedInfoByKey(UsrCertCode As %String) As CIS.AN.CA.UsrSignatureInfo
{
	s id=..GetInUsedIDByKey(UsrCertCode)
	q:(id="") ""
	
	q ##Class(CIS.AN.CA.UsrSignatureInfo).%OpenId(id)
}

/// 使用中
ClassMethod GetInUsedIDByKey(UsrCertCode As %String) As %String
{
	s id=""
	s tmpUsrCertCode = $zcvt(UsrCertCode,"U")	//索引中数据均为大写
	s id=$O(^CIS.AN.CA.UsrSignatureInfoI("InUsedID", " "_tmpUsrCertCode, 1, id))
	q id
}

/// 使用中
ClassMethod GetUsrIdByKey(UsrCertCode As %String) As %String
{
	s id=""
	s tmpUsrCertCode = $zcvt(UsrCertCode,"U")	//索引中数据均为大写
	s id=$O(^CIS.AN.CA.UsrSignatureInfoI("InUseKey", " "_tmpUsrCertCode, 1, id))
	q:(id="") ""
	
	q $tr(id, " ", "")
}

/// 返回错误信息
ClassMethod DisUsed(usrID As %String) As %String
{
	s obj=..GetInUseInfo(usrID)

	q:("" = obj) "该用户无关联的UKey"
	s obj.InUse=0
	d obj.%Save()
	
	q ""
}

ClassMethod NewUsrSignatureInfo(info As CIS.AN.CA.UsrSignatureInfo, certNo As %String, userCert As %String)
{
	s obj=##Class(CIS.AN.CA.UsrSignatureInfo).%New()
	s obj.UsrID=info.UsrID
	s obj.IdentityID=info.IdentityID
	s obj.Certificate=userCert
	s obj.CertificateNo=certNo
	s obj.CertificateSN=info.CertificateSN
	s obj.UKeyNo=info.UKeyNo
	s obj.SignImage=info.SignImage
	s obj.UsrCertCode=info.UsrCertCode
	s obj.CertName=info.CertName
	s obj.CreateDate=$p($h, ",", 1)
	s obj.CreateTime=$p($h, ",", 2)
	s obj.InUse=1
    d obj.%Save()
}

Storage Default
{
<Data name="UsrSignatureInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UsrID</Value>
</Value>
<Value name="3">
<Value>IdentityID</Value>
</Value>
<Value name="4">
<Value>Certificate</Value>
</Value>
<Value name="5">
<Value>CertificateNo</Value>
</Value>
<Value name="6">
<Value>CertificateSN</Value>
</Value>
<Value name="7">
<Value>UKeyNo</Value>
</Value>
<Value name="8">
<Value>SignImage</Value>
</Value>
<Value name="9">
<Value>UsrCertCode</Value>
</Value>
<Value name="10">
<Value>CertName</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>InUse</Value>
</Value>
<Value name="14">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.CA.UsrSignatureInfoD</DataLocation>
<DefaultData>UsrSignatureInfoDefaultData</DefaultData>
<IdLocation>^CIS.AN.CA.UsrSignatureInfoD</IdLocation>
<IndexLocation>^CIS.AN.CA.UsrSignatureInfoI</IndexLocation>
<StreamLocation>^CIS.AN.CA.UsrSignatureInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
