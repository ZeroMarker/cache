/// View Theatre Bookings 
Class User.VTheatreBookings [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 PA_AdmTransaction.TRANS_RowId,
 RB_OperatingRoom.RBOP_DateOper, 
 RB_OperatingRoom.RBOP_TimeOper, 
 RB_OperatingRoom.RBOP_Remarks, 
 RB_OperatingRoom.RBOP_Status,
 RB_Resource.RES_Code, RB_Resource.RES_Desc,
 PA_Adm.PAADM_AdmDate, PA_Adm.PAADM_AdmTime,
 CT_CareProv.CTPCP_Desc,
 Anaesthetist.CTPCP_Desc ANCTPCP_Desc,
 PA_PatMas.PAPMI_Name, PA_PatMas.PAPMI_Name2, PA_PatMas.PAPMI_Name3,
 PAC_Bed.BED_Code,
 PA_Person.PAPER_Dob,
 PAC_Ward.WARD_Code,
 CT_Title.TTL_Code,
 TRANS_Ward_DR->WARD_Code pre_WARD_Code, 
 TRANS_Bed_DR->BED_Code pre_BED_Code
 FROM
 SQLUser.PA_AdmTransaction PA_AdmTransaction,
 SQLUser.RB_OperatingRoom RB_OperatingRoom,
 SQLUser.RB_Resource RB_Resource,
 SQLUser.CT_CareProv CT_CareProv,
 SQLUser.CT_CareProv Anaesthetist,
 SQLUser.PA_PatMas PA_PatMas,
 SQLUser.PAC_Bed PAC_Bed,
 SQLUser.PA_Person PA_Person,
 SQLUser.PAC_Ward PAC_Ward,
 SQLUser.CT_Title CT_Title,
 { oj SQLUser.PA_Adm PA_Adm LEFT OUTER JOIN SQLUser.PAC_BedAdm PAC_BedAdm ON
 PA_Adm.PAADM_RowID = PAC_BedAdm.ADM_PAADM_DR}
 WHERE
 PA_AdmTransaction.TRANS_ParRef = RB_OperatingRoom.RBOP_PAADM_DR AND
 RB_OperatingRoom.RBOP_Resource_DR = RB_Resource.RES_RowId AND
 RB_OperatingRoom.RBOP_PAADM_DR = PA_Adm.PAADM_RowID AND
 RB_OperatingRoom.RBOP_Surgeon_DR = CT_CareProv.CTPCP_RowId AND
 RB_OperatingRoom.RBOP_Anaesthetist_DR = Anaesthetist.CTPCP_RowId1 AND
 PA_Adm.PAADM_PAPMI_DR = PA_PatMas.PAPMI_RowId AND
 PAC_BedAdm.ADM_ParRef =* PAC_Bed.BED_RowID AND
 PA_PatMas.PAPMI_PAPER_DR = PA_Person.PAPER_RowId AND
 PAC_Bed.BED_WARD_ParRef =* PAC_Ward.WARD_RowID AND
 PA_Person.PAPER_Title_DR = CT_Title.TTL_RowId AND
 RB_OperatingRoom.RBOP_Status = 'B'
} ]
{

}
