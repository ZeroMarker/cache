Import SQLUser

Class web.DHCPE.View.BaseInfoWest [ ClassType = view, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BaseInfoWest, ViewQuery = {
	select IADM_CRMADM->PIADM_PIBI_DR->PIBI_Name as name,IADM_CRMADM->PIADM_HPNo As exam_no,
			case CTSEX_RowID when 1 then 2 when 2 then 1 else 1 end as sex,
			TO_CHAR(IADM_CRMADM->PIADM_PIBI_DR->PIBI_DOB,'YYYY-MM-DD') as dob,
			IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo As patid,round(($H-IADM_CRMADM->PIADM_PIBI_DR->PIBI_DOB)/365,0,0) as age,
			IADM_RowId as admid
			 from Sqluser.DHC_PE_IADM,Sqluser.CT_Sex 
	       where CTSEX_RowID=IADM_CRMADM->PIADM_PIBI_DR->PIBI_Sex_DR and IADM_Status='ARRIVED' and IADM_CRMADM->PIADM_DepCode_DR='572'
	} ]
{

}
