/// DHCMA.VTE.PointCaseService
Class DHCMA.VTE.PointCaseService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "PointCaseService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

// "EpisodeDr1^RiskLevel1^BloodLevel1^VteType1#EpisodeDr2^RiskLevel2^BloodLevel2^VteType2"

Method StorePointCase(PonitCases As %String) As %String [ WebMethod ]
{
	set result = ""
	//截取字符串
	For index=1:1:$l(PonitCases,"#") {
		Set ponitcase=$p(PonitCases,"#",index) ;获取第index个病例
		//保存数据
		Set flg=##Class(DHCMA.VTE.VtePointCase).Update(ponitcase,"^")
		if flg<0 {
			set result = result+$p(ponitcase,"^",1) ;记录保存失败的就诊号
		}	
	}
	if result="" {
		set result="success"
	} 
	Quit result
}

/// TODO: add arguments and implementation.
/// StorePointCase
/// 通过ss_user表中的id获取数字签名图片 w ##Class(DHCMA.VTE.PointCaseService).GetInUseInfoImage("2718")
Method GetInUseInfoImage(DocID As %String) As %String [ WebMethod ]
{
	//s usrID=$o(^SSU("SSUSR",0,"CTPCP",DocID,""))
	s id=##Class(CA.UsrSignatureInfo).GetInUseID(DocID)
	q:(id="") ""
	s obj=##Class(CA.UsrSignatureInfo).%OpenId(id)
	q obj.SignImage
}

}
