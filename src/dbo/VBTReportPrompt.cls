Class dbo.VBTReportPrompt [ ClassType = view, CompileAfter = (dbo.BTHospital, dbo.BTReportPrompt), DdlAllowed, Owner = {UnknownUser}, Not ProcedureBlock, SqlTableName = V_BT_ReportPrompt, ViewQuery = { SELECT     dbo.BT_ReportPrompt.RowID, dbo.BT_ReportPrompt.Code, dbo.BT_ReportPrompt.CName, dbo.BT_ReportPrompt.HospitalDR, dbo.BT_ReportPrompt.PmtDT, 
 dbo.BT_ReportPrompt.Place, dbo.BT_ReportPrompt.Remark, dbo.BT_ReportPrompt.Sequence, dbo.BT_ReportPrompt.Active, dbo.BT_Hospital.Code AS HospitalCode, 
 dbo.BT_Hospital.CName AS HospitalName
 FROM         dbo.BT_ReportPrompt LEFT OUTER JOIN
 dbo.BT_Hospital ON dbo.BT_ReportPrompt.HospitalDR = dbo.BT_Hospital.RowID} ]
{

}
