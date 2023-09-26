Import SQLUser

Class web.DHCPE.View.ExamAppoint [ ClassType = view, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = Exam_Appoint, ViewQuery = {
	select distinct
	IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo as mzh,
	IADM_CRMADM->PIADM_PIBI_DR->PIBI_Name as XM,
			case CTSEX_RowID when 1 then '女' when 2 then '男' else '' end as xb,
			round(($H-IADM_CRMADM->PIADM_PIBI_DR->PIBI_DOB)/365,0,0) as NL ,
			'东院体检' as sjdw,
			IADM_CRMADM->PIADM_PIBI_DR->PIBI_MobilePhone as lxxx,
			
			'' as mcyj,
			'' as bszy
			
			 from Sqluser.DHC_PE_IADM,Sqluser.CT_Sex 
	       where CTSEX_RowID=IADM_CRMADM->PIADM_PIBI_DR->PIBI_Sex_DR and IADM_Status='ARRIVED'
	} ]
{

//case IADM_CRMADM->PIADM_Vip when 2 then 'V' when 3 then 'VV' else '' end||IADM_CRMADM->PIADM_PIBI_DR->PIBI_PAPMINo||'-'||TO_CHAR(IADM_AdmDate,'YYYYMMDD') As tjbh

//select * from web_DHCPE_View.Exam_Appoint where PatID='14143380'

//20131117日添加case IADM_CRMADM->PIADM_Vip when 2 then 'V' when 3 then 'VV' else '' end||

}
