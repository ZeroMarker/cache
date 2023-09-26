/// View Next of Kin
Class User.VPNextofKin [ ClassType = view, Not ProcedureBlock, ViewQuery = { SELECT
 NOK_PAPMI_ParRef->PAPMI_RowId,
 NOK_ContactType_DR->CONTTP_Code,
 NOK_ContactType_DR->CONTTP_Desc,
 NOK_PAPER_DR,
 NOK_PAPER_DR->PAPER_Name,
 NOK_PAPER_DR->PAPER_Name2,
 NOK_PAPER_DR->PAPER_TelH,
 NOK_PAPER_DR->PAPER_StName,
 NOK_PAPER_DR->PAPER_CityCode_DR->CTCIT_Desc,
 NOK_PAPER_DR->PAPER_Zip_DR->CTZIP_Code,
 NOK_Relation_DR->CTRLT_Desc		
 FROM	PA_NOK
} ]
{

}
