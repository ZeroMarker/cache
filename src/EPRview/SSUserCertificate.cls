Class EPRview.SSUserCertificate [ ClassType = view, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = SSUserCertificate, ViewQuery = { SELECT DISTINCT CTCP.CTPCP_Unit AS CTPCP_Unit, SSU.SSUSR_Name AS SSUSR_Name, SSU.SSUSR_EMailName AS SSUSR_EMailName FROM SQLUser.SS_User SSU, SQLUser.CT_CareProv CTCP WHERE SSU.SSUSR_CareProv_DR = CTCP.CTPCP_RowId1 AND CTCP.CTPCP_Unit IS NOT NULL AND ( CTCP.CTPCP_DateActiveTo > {fn CURDATE()} OR CTCP.CTPCP_DateActiveTo IS NULL)  } ]
{

}
