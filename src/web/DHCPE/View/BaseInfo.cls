Import SQLUser

Class web.DHCPE.View.BaseInfo [ ClassType = view, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BaseInfo, ViewQuery = {
	select IADM_CRMADM->PIADM_PIBI_DR->PIBI_Name as xm,IADM_CRMADM->PIADM_HPNo As tjbh,
			case CTSEX_RowID when 1 then 2 when 2 then 1 else 1 end as xb,
			TO_CHAR(IADM_CRMADM->PIADM_PIBI_DR->PIBI_DOB,'YYYY-MM-DD') as csny,'团体名称' as mc,
			IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo As PatID,round(($H-IADM_CRMADM->PIADM_PIBI_DR->PIBI_DOB)/365,0,0) as nl 
			 from Sqluser.DHC_PE_IADM,Sqluser.CT_Sex 
	       where CTSEX_RowID=IADM_CRMADM->PIADM_PIBI_DR->PIBI_Sex_DR and IADM_Status='ARRIVED'
	} ]
{

//case IADM_CRMADM->PIADM_Vip when 2 then 'V' when 3 then 'VV' else '' end||IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo||'-'||TO_CHAR(IADM_AdmDate,'YYYYMMDD')

//select * from web_DHCPE_View.V_BaseInfo where PatID='14143380'

//20131117日添加case IADM_CRMADM->PIADM_Vip when 2 then 'V' when 3 then 'VV' else '' end||

}
