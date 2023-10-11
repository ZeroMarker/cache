/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:11
 * @version v1.0
 */
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function InitReportWin()
{
	var obj = new Object();
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
	
	// 初始化模块
	obj.AdminPower  = AdminPower;
	obj.RepStatusCode = '';
	obj.Bacterias =Bacterias;
	obj.DiagList = ServerObj.DiagList;
	obj.LabIsNeed=ServerObj.LabIsNeed;
	obj.AntIsNeed=ServerObj.AntIsNeed;
	obj.OprIsNeed=ServerObj.OprIsNeed;
	obj.OpIsShow =ServerObj.OpIsShow;
	if ((ServerObj.DiagList)&&(!DiagnosID)) {   //存在未报时每次取一条
		DiagnosID = ServerObj.DiagList.split(",")[0];
	}
	if ((!ReportID)&&(DiagnosID)) {
		$.messager.popover({msg: '当前正在报告确诊后的诊断！',type:'info',timeout: 2000});
	}

	InitBase(obj);
	InitRep(obj);
	InitDiag(obj);
	InitOper(obj);
	InitLab(obj);
	InitAnt(obj);
	if (ServerObj.BasisNeed!=1) {
		$("#LabDiagBasis").empty();
	}
	InitReportWinEvent(obj);
	return obj;
}