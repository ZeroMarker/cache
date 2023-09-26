Import SQLUser

Class web.DHCPE.View.PATINFO [ ClassType = view, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_PACS_PATINFO, ViewQuery = {
	select IADM_CRMADM->PIADM_PIBI_DR->PIBI_Name as Name,IADM_CRMADM As OutPatNo,
			CTSEX_Desc as Sex,TO_CHAR(IADM_CRMADM->PIADM_PIBI_DR->PIBI_DOB,'YYYY-MM-DD') as Birthdate,
			IADM_CRMADM->PIADM_PIBI_DR->PIBI_Address as Address,IADM_CRMADM->PIADM_PIBI_DR->PIBI_MobilePhone as PhoneNO,
	       '体检中心' as Dept,'医生' as Doctor,IADM_CRMADM->PIADM_HPNo as InPatNo,'' as Ward,'' as BedNo,
	       IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo As PatID 
	       from Sqluser.Sqluser.DHC_PE_IADM,Sqluser.CT_Sex 
	       where CTSEX_RowID=IADM_CRMADM->PIADM_PIBI_DR->PIBI_Sex_DR and IADM_CRMADM->PIADM_Status='ARRIVED' and IADM_CRMADM->PIADM_DepCode_DR='53'
	} ]
{

//case IADM_CRMADM->PIADM_Vip when 2 then 'V' when 3 then 'VV' else '' end||IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo||'-'||TO_CHAR(IADM_AdmDate,'YYYYMMDD')

//select * from web_DHCPE_View.V_PACS_PATINFO where PatID='14143380'

}
