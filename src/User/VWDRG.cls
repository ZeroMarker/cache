Class User.VWDRG [ ClassType = view, CompileAfter = (User.MRCDRGCodes, User.MRAdm, User.PAAdm, User.PAAdmLeave), DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = VW_DRG, ViewQuery = { SELECT MRC_DRGCodes.DRG_Code,  MRC_DRGCodes.DRG_Desc, pa_adm.paadm_rowid ,datediff(dd,pa_adm.paadm_admdate,paadm_dischgdate)  FROM    SQLUser.PA_Adm PA_Adm,    SQLUser.MR_Adm MR_Adm,    SQLUser.PA_AdmLeave PA_AdmLeave,    SQLUser.MRC_DRGCodes MRC_DRGCodes                     WHERE    pa_adm.paadm_mainmradm_dr=mr_adm.mradm_rowid   and pa_adm.paadm_dischgdate !='' and mrc_drgcodes.drg_rowid=mr_adm.mradm_drg_dr} ]
{

}
