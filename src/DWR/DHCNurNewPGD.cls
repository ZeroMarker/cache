/// DWR.DHCNurNewPGD
Class DWR.DHCNurNewPGD Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "ServeComm";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://dhcc.com.cn";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

Method Save(parr, id) As %String [ WebMethod ]
{
	
	q ##class(Nur.DHCMoudData).Save2(parr,id)
}

Method getVal(id) As %String [ WebMethod ]
{
	
	q ##class(Nur.DHCMoudData).getVal(id)
	//q ..GetEmrData(mth,parr,del)
}

Method Patinfo(adm) As %String [ WebMethod ]
{
	
	q ##class(web.DHCMGNurComm).PatInfo(adm)
	//q ..GetEmrData(mth,parr,del)
}

ClassMethod GetEmrData(mth As %String, parrm As %String, del As %String) As %GlobalCharacterStream [ WebMethod ]
{
 
    s ^obj4231=mth
	s ^obj4232=parrm
	s ^obj4233=del
   s mth="s ret=##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,del)
   s x=mth_"("

  	  f i=1:1:l
		  {
		    s itm=$P(parrm,del,i)
		    s itm1=$P(parrm,del,i+1)
		    if itm="" continue
		    s itmval=""
		    if $P(itm,":")=""  s itmval=itm
		    e  s itmval=$P(itm,":",2)
		    s x=x_""""_itmval_""""
		    if itm1'=""
		    {
			    i (i'=l) s x=x_","
		    }
		  }
	 
	s x=x_")"
	x x
	i $IsObject(ret) q ret
	e  d
	.s retStream=##class(%GlobalCharacterStream).%New()
	.d retStream.Write(ret)
	q retStream
}

ClassMethod GetData(mth As %String, parrm As %String) As %String [ WebMethod ]
{
  //s a=##class(DWR.DoctorRound).GetData()
 // s mth="Nur.DHCNurCopyDiagnos:GetNurDiagnos"
  //s parrm="par:8^"
   //mth="##class(web.DHCMGNurComm).GetLoc"
  // q 1
  // s parrm=^TMP("qse")
  // s ^TMP("qse")=mth_"^"_parrm
   //s mth="web.DHCPdaComm:GetEPARCIMDetail"  ,parrm="EpisodeID:77126^InsType:^OrderDepRowid:^ArcimRowid:9746||1"
   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,"^")

   s pp=""

   if $F(parrm,"^")'=0
   {
	   f i=1:1:l
	   {
	     s itm=$P(parrm,"^",i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

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

}
