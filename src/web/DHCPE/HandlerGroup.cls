/// 
/// Created by Robert 2006/3/19
/// Descrption: 对表DHCPEGBaseInfo及相关表的一些基本处理
/// Test: d ##class(web.DHCPE.HandlerGBaseInfo).Test()
Class web.DHCPE.HandlerGroup Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod getAGrpByCRMId(grpCrmId As %String) As User.DHCPEGBaseInfo
{
	
	s grpHisId=""
	s ^lisatest("0828getAGrpByCRMId")=grpCrmId
	&sql(select gbi_rowid into :grpHisId 
		FROM SQLUSER.DHc_pe_gbaseinfo where gbi_crmno=:grpCrmId)
	if ($g(grpHisId)=""){
		s objGrp=##class(User.DHCPEGBaseInfo).%New()
		s objGrp.GBICRM=grpCrmId
		//d objGrp.%Save()
	}else {
		s objGrp=##class(User.DHCPEGBaseInfo).%OpenId(grpHisId)
	}
	q objGrp
}

ClassMethod getGRegByCRMId(crmRegId As %String) As User.DHCPEGADM
{
	s hisRegId="", myCount=0
	&sql(select max(gadm_rowid), count(*) into :hisRegId, :myCount FROM SQLUSER.DHC_PE_GADM where gadm_crmgadm=:crmRegId)
	if (myCount=0){
		s objReg=##class(User.DHCPEGADM).%New()
		s objReg.GADMCRMGADM=crmRegId

		//d objReg.%Save()
	}else {
		s objReg=##class(User.DHCPEGADM).%OpenId(hisRegId)
	}
	q objReg
}

ClassMethod getGTeamByCrmTeamId(crmTeamId As %String) As User.DHCPEGTeam
{
	s hisGTeamId=""
	&sql(SELECT GT_RowId into :hisGTeamId FROM SQLUSER.DHC_PE_GTEAM WHERE GT_CRMTeam=:crmTeamId)
	if (hisGTeamId=""){
		s objTeam=##class(User.DHCPEGTeam).%New()
	}
	else{
		s objTeam=##class(User.DHCPEGTeam).%Open(hisGTeamId)
	}
	q objTeam
}

ClassMethod test()
{
	s obj=..getAGrpByCRMId("123")
	s obj=..getAGrpByCRMId("456")
	q "OK"
}

}
