/// View Patient Merge 
Class User.VPAMergePatient [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT  DISTINCT BY (MRG_PAPMI_To_DR)
 MRG_Rowid,
 MRG_Date,
 MRG_Time, 
 MRG_PAPMI_To_DR->PAPMI_No as To_PAPMI_No, 
 MRG_PAPMI_To_DR->PAPMI_Name as To_PAPMI_Name,
 MRG_PAPMI_To_DR->PAPMI_Name2 as To_PAPMI_Name2,
 MRG_PAPMI_From_DR->PAPMI_No as From_PAPMI_No, 
 MRG_PAPMI_From_DR->PAPMI_Name as From_PAPMI_Name,
 MRG_PAPMI_From_DR->PAPMI_Name2 as From_PAPMI_Name2,
 DET_Rowid, 
 DET_Table, 
 DET_TableRowid
 FROM
 PA_MergePatient,
 PA_MergePatientDetails
 WHERE
 DET_ParRef=MRG_Rowid AND
 (DET_Table = "SURALIAS" OR DET_Table = "ALIAS")
} ]
{

}
