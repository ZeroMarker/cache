/// 签名接口类
Class CIS.AN.CA.ISignService [ Abstract ]
{

ClassMethod GetServerCert() As %String
{
}

ClassMethod Login(userCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String) As %String
{
}

ClassMethod Sign(recordSheetId As %String, userCertCode As %String, signCode As %String, contentHash As %String, signValue As %String, CareProvType As %String = "", certNo As %String = "") As %String
{
}

ClassMethod GetLoginQR(token) As %String
{
}

}
