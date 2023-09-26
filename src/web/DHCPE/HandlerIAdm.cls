/// 
/// Created by Robert 2006/3/19
/// Descrption: 对表DHCPEIAdm及相关医嘱的的一些基本处理 ，其实分为多个类更好一点。
/// Test: 
/// 
Class web.DHCPE.HandlerIAdm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod GetAdmByCrmAdm(crmAdmId As %String) As User.DHCPEIADM
{
	
	s hisAdmId=""
	&sql(select IADM_ROWID into :hisAdmId FROM SQLUSER.DHC_PE_iadm where IADM_CRMADM=:crmAdmId)
	if ($g(hisAdmId)=""){
		s objAdm=##class(User.DHCPEIADM).%New()
		s objAdm.IADMCRMADM=crmAdmId
	}else {
		s objAdm=##class(User.DHCPEIADM).%OpenId(hisAdmId)
	}
	q objAdm
}

/// test; d ##class(web.DHCPE.HandlerIAdm).updateItemMatch(12,"1||2")
ClassMethod updateItemMatch(crmOItemID, hisOItemId, IAdmId)
{
	s rowId=""
	&SQL(select crmo_rowid into :rowId FROM sqluser.dhc_pe_crmorder where crmo_crmori=:crmOItemID)
	if (rowId=""){
		&sql(insert into sqluser.dhc_pe_crmorder(crmo_crmori,crmo_oeori_dr,crmo_IADM_dr) values(:crmOItemID, :hisOItemId, :IAdmId))
	}
	else {
		 &sql(UPDATE sqluser.dhc_pe_crmorder set crmo_oeori_dr=:hisOItemId where crmo_rowid=:rowId)
	}
}

/// IdType: "CRM"--OEItemId是CRM的id, "HIS"是his中的Id
ClassMethod GetItemMatch(OEItemId As %String, IdType As %String = "CRM") As User.DHCPECRMOrder
{
	s rowId=""
	if IdType="CRM"{
		&SQL(select crmo_rowid into :rowId FROM sqluser.dhc_pe_crmorder where crmo_crmori=:OEItemId)
	}
	else{
		&SQL(select crmo_rowid into :rowId FROM sqluser.dhc_pe_crmorder where  crmo_oeori_dr=:OEItemId)
	}
	;b // GetItemMatch w rowId
	if (rowId=""){
		s objRet=##Class(User.DHCPECRMOrder).%New()
	}
	else{
		s objRet=##Class(User.DHCPECRMOrder).%OpenId(rowId)
	}
	q objRet
}

/// type:  "IADMID"-个人ID , "GADMID"-团体ID 
ClassMethod GetReport(Type As %String, ID As %String) As User.DHCPEReport
{
	s rowId=""
	if Type="IADMID"{
		&SQL(select RPT_RowId into :rowId from sqluser.dhc_pe_report  where rpt_IAdm_dr=:ID)
	}
	elseif Type="GADMID"{
		&SQL(select RPT_RowId into :rowId from sqluser.dhc_pe_report  where rpt_GAdm_dr=:ID)
	}
	else {
		s a=assertInfo("Type is wrong! in HandlerIAdmGetReport")
	}
	if (rowId=""){
		s objRet=##Class(User.DHCPEReport).%New()
	}
	else{
		s objRet=##Class(User.DHCPEReport).%OpenId(rowId)
	}
	q objRet
}

ClassMethod testArray(gAdmId As %String) As %Library.ArrayOfObjects
{
	s arrAdms=##class(%Library.ArrayOfObjects).%New()
	
	s obj=##class(User.DHCPEGBaseInfo).%New()
	s obj.GBIDesc="test"
	d arrAdms.SetAt(obj,1)
	s obj=##class(User.DHCPEGBaseInfo).%New()
	s obj.GBIDesc="tes2"
	d arrAdms.SetAt(obj,2)
	q arrAdms
}

}
