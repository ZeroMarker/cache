/// @author wanghc
/// @date 20220210
/// @other dhc.logon.ca.csp登录时日志
Class User.DHCClientCALogin Extends %Persistent [ SqlTableName = DHC_ClientCALogin ]
{

/// 当前HIS用户ID
Property SessionUserDr As %String [ SqlColumnNumber = 2 ];

/// 当前HIS科室ID
Property SessionLocDr As %String [ SqlColumnNumber = 3 ];

/// IP地址
Property IPAddr As %String [ SqlColumnNumber = 4 ];

/// CA用户唯一标识
Property CAUserCertCode As %String [ SqlColumnNumber = 5 ];

/// CA证书唯一标识
Property CACertNo As %String [ SqlColumnNumber = 6 ];

/// PHONE登录时票据
Property CAToken As %String [ SqlColumnNumber = 7 ];

/// 登录类型 UKEY, PHONE, PINPHONE, PAGEPHONE, FACE ,SOUND
Property CALoginType As %String [ SqlColumnNumber = 8 ];

/// CA登录日期
Property CALoginDate As %Date [ SqlColumnNumber = 9 ];

/// CA登录时间
Property CALoginTime As %Time [ SqlColumnNumber = 10 ];

/// CA登录厂商
Property CAVenderCode As %String [ SqlColumnNumber = 11 ];

ClassMethod Insert(CAUserCertCode, CACertNo, CALoginType, CAToken, CAVenderCode, IPAddr = "", SessUserId = "", SessLocId = "")
{
	Set Obj = ##class(User.DHCClientCALogin).%New()
	Set Obj.CAUserCertCode = CAUserCertCode
	Set Obj.CACertNo = CACertNo
	Set Obj.CALoginType = CALoginType
	Set Obj.CAToken = CAToken
	Set Obj.CAVenderCode = CAVenderCode
	Set Obj.IPAddr = IPAddr
	Set Obj.SessionUserDr = SessUserId
	Set Obj.SessionLocDr = SessLocId
	Set Obj.CALoginDate = +$h
	Set Obj.CALoginTime = $p($h,",",2)
	Set sc = Obj.%Save()
	if (sc){
		quit "-1^"_$system.Status.GetErrorText(sc)
	}
	Set ID = Obj.%Id()
	Set Obj = ""
	Quit ID
}

Storage Default
{
<Data name="DHCClientCALoginDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SessionUserDr</Value>
</Value>
<Value name="3">
<Value>SessionLocDr</Value>
</Value>
<Value name="4">
<Value>IPAddr</Value>
</Value>
<Value name="5">
<Value>CAUserCertCode</Value>
</Value>
<Value name="6">
<Value>CACertNo</Value>
</Value>
<Value name="7">
<Value>CAToken</Value>
</Value>
<Value name="8">
<Value>CALoginType</Value>
</Value>
<Value name="9">
<Value>CALoginDate</Value>
</Value>
<Value name="10">
<Value>CALoginTime</Value>
</Value>
<Value name="11">
<Value>CAVenderCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCClientCALoginD</DataLocation>
<DefaultData>DHCClientCALoginDefaultData</DefaultData>
<IdLocation>^User.DHCClientCALoginD</IdLocation>
<IndexLocation>^User.DHCClientCALoginI</IndexLocation>
<StreamLocation>^User.DHCClientCALoginS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
