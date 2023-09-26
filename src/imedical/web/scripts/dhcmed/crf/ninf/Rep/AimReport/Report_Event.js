
function InitReportEvent(obj)
{
	obj.ClsCommonClsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonCls");
	obj.ClsAimReport = ExtTool.StaticServerObject("DHCMed.NINF.Rep.AimReport");
	obj.ClsAimReportSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReport");
	obj.ClsAimReportUCSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportUC");
	obj.ClsAimReportPICCSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportPICC");
	obj.ClsAimReportVAPSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportVAP");
	obj.ClsAimReportOPRSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportOPR");
	obj.ClsAimReportMDRSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportMDR");
	obj.ClsAimReportNUCSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportNUC");
	obj.ClsAimReportNPICCSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportNPICC");
	obj.ClsAimReportNVNTSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportNVNT");
	obj.ClsBasePatientAdm = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
	obj.ClsBasePatient = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsMapRepMdlSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.MapRepMdl");
	
	//获取界面模块列表
	obj.GetModuleList = function(EpisodeID){
		return obj.ClsMapRepMdlSrv.GetAimModules(EpisodeID);
	}
	
	return obj;
}