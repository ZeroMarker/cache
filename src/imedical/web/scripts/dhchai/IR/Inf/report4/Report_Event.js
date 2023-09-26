/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:35
 * @version v1.0
 */
function InitReportWinEvent(obj){
	CheckSpecificKey();
	$('#btnUpdate').click(function (e) {
    	var InputRep = obj.Rep_SaveBase();
    	var InputPreFactors = "";  //obj.PreFactor_SaveData();
    	var InputInvasOpers = "";  //obj.InvasOper_SaveData();
    	var InputDiag = ""; //obj.DIAG_SaveData();
    	var InputOPS = obj.OPR_SaveData();
    	var InputLab = "";  //obj.LAB_SaveData();
    	var InputAnti = obj.ANT_SaveData();
		if(InputOPS=="")
			return;
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.INFReportSrv','SaveINFReport',InputRep,InputPreFactors,InputInvasOpers,InputDiag,InputOPS,InputLab,InputAnti)
    	alert(ret)
	});
	obj.checkDate = function(d){
		d = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",d);
		var cDateFrom = obj.AdmInfo.record[0].AdmDate;
		var cDateTo = obj.AdmInfo.record[0].DischDate;
		if (cDateTo==''){
			cDateTo = $.form.GetCurrDate('-');
		}
		var flg1 = $.form.CompareDate(d,cDateFrom);
		var flg2 = $.form.CompareDate(cDateTo,d);
		if (flg1&&flg2){
			return true;
		}else{
			return false;
		}
	}
}

