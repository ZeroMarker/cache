Class DWR.NurseEmrComm Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.		"parr:"+ItmName + "^" + ID + "^" + MultID + "^" + MthArr+"!"	"parr:DHCNURMGCHECKSUMPRN^^^!"	string
Parameter SERVICENAME = "DocServComm";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://dhcc.com.cn";

Parameter USECLASSNAMESPACES = 1;

//w ##class(DWR.NurseEmrComm).GetData("web.DHCNurEmrMainComm:SaveMBStream","parr:4558^")

ClassMethod Excute(clsName, methodName, parameters) As %GlobalCharacterStream [ WebMethod ]
{
	//w ##class(DWR.NurseEmrComm).Excute("web.DHCNUREMR","generatorJs",^objcyf329)
	//s ^objcyf329=parameters
	s ret=##class(Nur.QueryBrokerEmr).ExcuteWebService(clsName, methodName,parameters)
	q ret
}

ClassMethod ImportBarCodeTemplate(code, TemplateContent) As %GlobalCharacterStream [ WebMethod ]
{
	s ret=##class(web.DHCNUREMR).ImportBarCodeTemplate(code, TemplateContent)
	q ret
}

ClassMethod ExportBarCodeTemplate(code) As %GlobalCharacterStream [ WebMethod ]
{
	s ret=##class(web.DHCNUREMR).ExportBarCodeTemplate( code)
	q ret
}

ClassMethod GetData22(mth As %String, parrm As %String) As %String [ WebMethod ]
{
   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,"^")

   s pp=""
   //s ^oiiiecyf=mth_"  ***"_parrm
   if $F(parrm,"^")'=0
   {
	   f i=1:1:l
	   {
	     s itm=$P(parrm,"^",i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"
         b ;44
	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s @p=v
	     if pp'="" s pp=pp_","_p
	     e  s pp=p 
	     b //
	   }
   }
   	s mth=mth_"("_pp_")"
   	b
   	s c="a="_mth
   	set @c
   	s b="a"
   	s aa=@b
   	
	s a=$TR(aa,$C(1),"@")
	s a=$TR(a,$C(2),"!")
	s a=$TR(a,$C(3),"$")
	q a
}

ClassMethod GetQueryDataX(QueryName, parrm, del) As %XML.DataSet [ WebMethod ]
{
	
  s a= ##class(Nur.QueryBrokerEmr).GetQueryDataX(QueryName, parrm, del)
  q a
}

ClassMethod GetData(mth, parrm, del) As %String [ WebMethod ]
{
 s a=##class(Nur.QueryBrokerEmr).GetData(mth, parrm, del)
 q a
}

ClassMethod GetLoc() As %String [ WebMethod ]
{
 s a=##class(web.DHCNurEmrMainComm).GetLoc()
 q a
}

ClassMethod generatorJs(parr) As %String [ WebMethod ]
{
 s a=##class(web.DHCNUREMR).generatorJs(parr)
 q a
}

ClassMethod GetQueryHead(parr) As %String [ WebMethod ]
{
 s a=##class(web.DHCNurEmrMainComm).GetQueryHead(parr)
 q 0
}

ClassMethod GetEmrData(mth, parrm, del) As DWR.DHCTranStream [ WebMethod ]
{
 s a=##class(Nur.QueryBrokerEmr).GetEmrData(mth, parrm, del)
 q a
}

//保存模板信息

Method SaveMBData(parr, data As %GlobalCharacterStream) As %String [ WebMethod ]
{
	d data.Rewind()
	q ##class(web.DHCNurEmrMainComm).SaveMBStream(parr,data)
}

//保存维护程序目录信息

Method SaveEmrMian(code, data As %GlobalCharacterStream) As %String [ WebMethod ]
{
	d data.Rewind()
	q ##class(web.DHCNurEmrMainComm).SaveEmrMian(code,data)
}

//保存维护程序目录fold名字

Method SaveMainName(code, type, data As %GlobalCharacterStream) As %String [ WebMethod ]
{
	d data.Rewind()
	q ##class(NurEmr.MainNameBack).SaveMainName(code,type,data)
}

//保存知识库信息

Method SaveEmrItm(code, desc, data As %GlobalCharacterStream) As %String [ WebMethod ]
{
	d data.Rewind()
	q ##class(web.DHCNurEmrMainComm).SaveEmrItm(code,desc,data)
}

}
