Class web.DHCEmNurCom Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod Getorddate(rowid) As %String
{
	s oeordId=$p(rowid,"||",1)
	s oeoriSub=$p(rowid,"||",2)
	q:(oeordId="")!(oeoriSub="") ""
	s orddate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
	i orddate'="" s orddate=$zd(orddate,3)
	q orddate
}

ClassMethod GetDiagnosyy(rowid) As %String
{
	s oeordId=$p(rowid,"||",1)
	q:oeordId="" ""
	s admId=$p($g(^OEORD(oeordId)),"^",1)
	s MRDiagnos=""
  	s mradmId=$P($g(^PAADM(admId)),"^",61)
  	s mrdiaSub=0
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	.s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  	..s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  	..q:dtypId=""
  	..s TypCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
  	..//q:TypCode'="OUT"
  	..s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
  	..q:MRDIAICDCodeDR=""
  	..i MRDiagnos="" d
  	...s MRDiagnos=##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2))
  	..e  d
  	...s MRDiagnos=MRDiagnos_","_##class(web.DHCEMCommonUtil).GetTransDesc("User.MRCICDDx","MRCIDDesc","",$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2))
  	
	q MRDiagnos
}

ClassMethod Getorddoc(rowid) As %String
{
	s oeordId=$p(rowid,"||",1)
	s oeoriSub=$p(rowid,"||",2)
	q:(oeordId="")!(oeoriSub="") ""
	s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    s ctcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
	q ctcpDesc
}

}
