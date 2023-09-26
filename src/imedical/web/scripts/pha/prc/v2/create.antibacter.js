/**
 * 名称:	 处方点评-抗菌药专项点评
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-10
 */
PHA_COM.App.Csp = "pha.prc.v2.create.antibacter";
PHA_COM.App.Name = "PRC.Create.Antibacter";
PHA_COM.App.Load = "";
var logonLocId = session['LOGON.CTLOCID'];
var logonUserId = session['LOGON.USERID'];
$(function () {
	InitDict();
	InitEvents();
	InitSetDefVal();
});

// 字典
function InitDict() {
	// 初始化-日期
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	// 初始化-多选下拉框
	PHA.ComboBox("conMultiAntDrugLevel", {
		multiple: true,
		rowStyle: 'checkbox', //显示成勾选行形式,不要勾选框就注释
		width:156,
		url: PRC_STORE.PCNTSAntiLevel()
	});
	ImportHandler();
}

// 事件
function InitEvents() {
	$("#btnQuery").on("click", ComfirmQuery);
	$("#btnClean").on("click", ComfirmClear);
	$("#btnImport").on("click", ImportHandler);
	$("#btnSave").on("click", ComfirmSave);
	$("#btnDownLoad").on("click", DownLoadModel);
}

/// 界面信息初始化
function InitSetDefVal() {
	//界面配置
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.CreateStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.CreateEndDate);
	});

}


function ImportHandler() {
	$("#conFileBox").filebox({
		prompt: '请选择文件...',
		buttonText: '选择',
		width: 250,
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	})
	$("#btnFileBox").on("click", function(){
		var filelist = $('#conFileBox').filebox("files");
		if (filelist.length == 0) {
			//alert("请先选择文件")
			PHA.Alert('提示', "请先选择文件！", 'warning');
			return
		}
		var file = filelist[0];
		var importData="";
		PHA_COM.ReadExcel(file,function(xlsData){
			var dataLen = xlsData.length ;
			//alert(JSON.stringify(xlsData))
			//var JSONData = JSON.stringify(xlsData) ;
			for (var num=0;num<dataLen;num++){
				var sData = xlsData[num] ;
				var prescno = sData['prescno'] ;
				if ((prescno !="")&&(prescno!=null)&&(prescno!=undefined)){
					importData=(importData=="")?prescno:importData+"^"+prescno ;
				}
			}
			if ((importData=="")||(importData==null)||(importData==undefined)){
				PHA.Alert('提示', "没有获取到需要导入的处方信息，请注意Excel模板格式是否正确！", 'warning');
				return ;
			}
			var importRet = tkMakeServerCall("PHA.PRC.Create.Antibacter","ImportCommentData",importData,logonLocId,logonUserId)
			var RetArr = importRet.split("^");
			var RetSucc = RetArr[0];
			var RetVal = RetArr[1];
			if (RetSucc < 0) {
				PHA.Alert('提示', "保存失败，错误信息："+RetVal, 'warning');
			} else {				
				var msgInfo = "抽取成功!";
				PHA.Alert('提示', msgInfo, 'success');
				$('#importConComNo').val(RetVal);
				
			}
		})
		
	});
}

function ComfirmQuery(){
	var comInfo = "您确认统计处方吗?"
	PHA.Confirm("查询提示", comInfo, function () {
		Query();
	})
}

function Query(){
	if (CheckBeforeQuery() < 0) {
            return;
        }
	$('#conPresNum').val('');
	var queryParStr = GetQueryParStr() ;
	var saveParStr = GetSaveParStr() ;
	PHA.Loading("Show") 
	var pid = tkMakeServerCall("PHA.PRC.Create.Antibacter", "JobGetAntiPrescDataNum", queryParStr, saveParStr, logonLocId);
	// 调后台,5s一次
	var jobInterval = setInterval(function() {
		var jobRet = tkMakeServerCall("PHA.PRC.Com.Util", "JobRecieve", pid);
		if (jobRet != "") {
			clearInterval(jobInterval);
			PHA.Loading("Hide")
			var jobRetArr = jobRet.split("^");
			var jobRetSucc = jobRetArr[0];
			var jobRetVal = jobRetArr[1];
			if (jobRetSucc < 0) {
				PHA.Alert('提示', "查询失败，错误代码："+jobRetVal, 'warning');
			} else {
				if (jobRetVal == 0) {
					var msgInfo = "没有符合条件的处方,请更换查询条件后再试!";
					PHA.Alert('提示', msgInfo, 'warning');
				} else {
					$('#conPresNum').val(jobRetVal);
				}
			}
		}
	},5000);
	
}

function ComfirmClear(){
	var comInfo = "您确认要清除吗?"
	PHA.Confirm("清除提示", comInfo, function () {
		Clear();
	})
}

function Clear(){
	$('#conPresNum').val('');
	$("#conMultiAntDrugLevel").combobox("setValue",'');	
	$('#conDocCent').val('');
	$('#conPresCent').val('');
	$('#chkAllFlag').checkbox("uncheck",true) ;		
	$('#conComNo').val('');
	
	$('#conFileBox').filebox('clear');
	$('#importConComNo').val('');
	InitSetDefVal();
	return ;	
}


function ComfirmSave(){
	var comInfo = "确认要生成抗菌药处方点评单吗 ?"
	PHA.Confirm("确认提示", comInfo, function () {
		Save();
	})
	
}

function Save(){
	if (CheckBeforeSave() < 0) {
            return;
        }
	var queryParStr = GetQueryParStr() ;
	var saveParStr = GetSaveParStr() ;
	$('#conComNo').val('');
	PHA.Loading("Show") 
	var pid = tkMakeServerCall("PHA.PRC.Create.Antibacter", "JobSaveAntiCommentData", queryParStr, saveParStr, logonLocId, logonUserId);
	// 调后台,5s一次
	var jobInterval = setInterval(function() {
		var jobRet = tkMakeServerCall("PHA.PRC.Com.Util", "JobRecieve", pid);
		if (jobRet != "") {
			clearInterval(jobInterval);
			PHA.Loading("Hide")
			var jobRetArr = jobRet.split("^");
			var jobRetSucc = jobRetArr[0];
			var jobRetVal = jobRetArr[1];
			if (jobRetSucc < 0) {
				PHA.Alert('提示', "查询失败，错误代码："+jobRetVal, 'warning');
			} else {
				if (jobRetVal == 0) {
					var msgInfo = "没有符合条件的处方,请更换查询条件后再试!";
					PHA.Alert('提示', msgInfo, 'warning');
				} else {
					var msgInfo = "抽取成功!";
					PHA.Alert('提示', msgInfo, 'success');
					$('#conComNo').val(jobRetVal);
				}
			}
		}
	},5000);
	
	
}

//下载导入模板
function DownLoadModel(){
	window.open("../scripts/pha/prc/v2/门诊处方点评导入模板.xlsx", "_blank");	
}

function GetQueryParStr(){
	var startDate = $("#conStartDate").datebox('getValue')||'';
	var endDate = $("#conEndDate").datebox('getValue')||'';	
	var antiLevelStr = $("#conMultiAntDrugLevel").combobox('getValues')||'';		//抗菌药物级别
	var docCent = $.trim($("#conDocCent").val())||''; 
	var prescNum = $.trim($("#conPresCent").val())||''; 
	var allFlag = ""			//基本药物标志
	if ($("#chkAllFlag").is(':checked')){
		allFlag = "Y"	
	}
	else{
		allFlag = "N"		
	}
	
	var parstr = startDate +"^"+ endDate +"^"+ docCent +"^"+ prescNum +"^"+ antiLevelStr 
	var parstr = parstr +"^"+ allFlag
	
	return parstr
	
}

function GetSaveParStr(){
	var wayCode = "K"		//点评方式代码	
	var saveparstr = wayCode
	
	return saveparstr

}

function CheckBeforeQuery() {
	var docCent = $.trim($("#conDocCent").val())||'';
	if (docCent == "") {
		PHA.Alert('提示', "医生比例为必填项，不能为空!", 'warning');
		return -1;
	}
	if (!(docCent > 0) && (docCent !== "")) {
		PHA.Alert('提示', "医生比例填写不正确!", 'warning');
		return -1;
	}
	var prescNum = $.trim($("#conPresCent").val())||''; 
	if (prescNum == "") {
		PHA.Alert('提示', "处方张数为必填项，不能为空!", 'warning');
		return -1;
	}	
	if ((!(prescNum > 0)) && (prescNum !== "")) {
		PHA.Alert('提示', "处方张数填写不正确!", 'warning');
		return -1;
	}
	return 0 ;
}

function CheckBeforeSave() {
	if (CheckBeforeQuery() < 0) {
		return -99;
    }
	var maxnum = $.trim($("#conPresNum").val())||'';
	if (maxnum == "") {
		PHA.Alert('提示', "请先统计处方总数!", 'warning');
		return -11;
	}
	if (maxnum == 0) {
		PHA.Alert('提示', "处方总数为0,没有可抽取的处方,请先统计处方总数!", 'warning');
		return -12;
	}
	return 0;
	
}

