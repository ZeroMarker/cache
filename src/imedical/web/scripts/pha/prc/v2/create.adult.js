/**
 * 名称:	 处方点评-成人专项点评
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-13
 */
PHA_COM.App.Csp = "pha.prc.v2.create.adult.csp";
PHA_COM.App.Name = "PRC.Create.Adult";
PHA_COM.App.Load = "";
var logonLocId = session['LOGON.CTLOCID'];
var logonUserId = session['LOGON.USERID'];
var maxcentnum = 0.8; 	//最大抽取百分比数
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
	PHA.ComboBox("conMultiDocLoc", {
		multiple: true,
		rowStyle: 'checkbox', 	//显示成勾选行形式,不要勾选框就注释
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("conMultiAntDrugLevel", {
		multiple: true,
		rowStyle: 'checkbox', //显示成勾选行形式,不要勾选框就注释
		width:156,
		url: PRC_STORE.PCNTSAntiLevel()
	});
	PHA.ComboBox("conAdmType", {
		data: [{
			RowId: "1",
			Description: "门诊"
		}, {
			RowId: "2",
			Description: "急诊"
		}, {
			RowId: "3",
			Description: "全部"
		}],
		panelHeight: "auto"
	});
	
	PHA.ComboBox("conSaveType", {
		data: [{
			RowId: "Random",
			Description: "随机数"
		}, {
			RowId: "Percent",
			Description: "百分比"
		}],
		panelHeight: "auto",
		width:85
	});
	ImportHandler();
}

// 事件
function InitEvents() {
	$("#btnQuery").on("click", ComfirmQuery);
	$("#btnClean").on("click", ComfirmClear);
	$("#btnImport").on("click", Import);
	$("#btnSave").on("click", ComfirmSave);
	$("#btnDownLoad").on("click", DownLoadModel);
	
	$("#conAge").val('>15岁');	
	$HUI.radio("#chkRandomNum").setValue(true);
	/*
	$("#conSavePercent").on("click",function(){
		$("#conSaveRandomNum").val('')				//	文本框清空
		$HUI.radio("#chkPercent").setValue(true);		// 单选框选中
		$HUI.radio("#chkRandomNum").setValue(false);	// 单选框不可用
	})
		
	$("#conSaveRandomNum").on("click",function(){
		$("#conSavePercent").val('')						//	文本框清空
		$HUI.radio("#chkRandomNum").setValue(true);		// 单选框选中
		$HUI.radio("#chkPercent").setValue(false);		// 单选框不可用
	})
	*/
	$("#conSpaceQty").on('keypress', function (event){
		if (event.keyCode == "13") {
			CheckTheoryQty() ;
			GetSpaceQty() ;			
		}
	})
	$("#conSpaceQty").on('focus', function (){
		GetSpaceQty();
	})
	$("#conSpaceQty").on('blur', function (){
		GetSpaceQty();
	})
	
	$("#conSaveTxt").on('keypress', function (event){
		if (event.keyCode == "13") {
			GetSpaceQty() ;			
		}
	})
	$("#conSaveTxt").on('blur', function (){
		GetSpaceQty();
	})
	
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
	$("#conSaveType").combobox("setValue", "Random");
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
			var importRet = tkMakeServerCall("PHA.PRC.Create.Adult","ImportCommentData",importData,logonLocId,logonUserId)
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
	var pid = tkMakeServerCall("PHA.PRC.Create.Adult", "JobGetAdultPrescDataNum", queryParStr, saveParStr, logonLocId);
	// 调后台,3s一次
	setTimeout('JobRecieve('+pid+')', 3000);
}

function JobRecieve(pid) {
	$cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "JobRecieve",
		pid: pid,
		dataType: 'text'
	}, function(jobRet){
		if (jobRet == "-1"){
			setTimeout(function(){
				JobRecieve(pid);
			}, 2000);
		} else {
			PHA.Loading("Hide")
			var jobRetArr = jobRet.split("^");
			var jobRetSucc = jobRetArr[0];
			var jobRetVal = jobRetArr[1];
			if (jobRetSucc < 0) {
				PHA.Alert('提示', "查询失败，错误代码："+ jobRetVal, 'warning');
			} else {
				if (jobRetVal == 0) {
					var msgInfo = "没有符合条件的处方,请更换查询条件后再试!";
					PHA.Alert('提示', msgInfo, 'warning');
				} else {
					$('#conPresNum').val(jobRetVal);
				}
			}
		}
	})
}

function ComfirmClear(){
	var comInfo = "您确认要清除吗?"
	PHA.Confirm("清除提示", comInfo, function () {
		Clear();
	})
}

function Clear(){
	$('#conPresNum').val('');
	$("#conMultiDocLoc").combobox("setValue",'');
	$("#conAdmType").combobox("setValue",'');
	$("#conMultiAntDrugLevel").combobox("setValue",'');	
	
	$('#conComNo').val('');
	$("#conSaveTxt").val('');
	$("#conSpaceQty").val('');
	$("#conWriteQty").val('');
	$("#conASpaceQty").val('');
	$("#conTheoryQty").val('');
	
	
	$('#conFileBox').filebox('clear');
	$('#importConComNo').val('');
	InitSetDefVal();
	return ;	
}

function Import(){
	
	
}

function ComfirmSave(){
	var comInfo = "您确认要生成成人专项点评单吗 ?"
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
	var pid = tkMakeServerCall("PHA.PRC.Create.Adult", "JobSaveAdultCommentData", queryParStr, saveParStr, logonLocId, logonUserId);
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
	var modelA = document.getElementById('downloadModel');
	if(!modelA){
		modelA = document.createElement('a');
		modelA.id = "downloadModel";
	}
	modelA.href = "../scripts/pha/prc/v2/门诊处方点评导入模板.xlsx";
	modelA.click();
}

function GetQueryParStr(){
	var startDate = $("#conStartDate").datebox('getValue')||'';
	var endDate = $("#conEndDate").datebox('getValue')||'';
	var docLocStr = $("#conMultiDocLoc").combobox('getValues')||'';		//医生科室
	var admType = $("#conAdmType").combobox('getValue')||'';			//就诊类型
	var antiLevelStr = $("#conMultiAntDrugLevel").combobox('getValues')||'';		//抗菌药物级别
	var ageMin = $("#conAge").val()||''; 						//年龄下限
	
	var parstr = startDate +"^"+ endDate +"^"+ docLocStr +"^"+ antiLevelStr +"^"+ admType
	var parstr = parstr +"^"+ ageMin
	
	return parstr
	
}

function GetSaveParStr(){
	var wayCode = "C"		//点评方式代码
	var rnum="",pcent=""
	var savetype = $("#conSaveType").combobox('getValue')||'';
	var conTxt = $.trim($("#conSaveTxt").val())||'';	
    if (savetype=="Random"){
		var rnum = conTxt;	
	}
	else{
		var pcent = conTxt;	
	}
	var spaceqty =  $.trim($("#conSpaceQty").val())||'';		//间隔数
	
	var saveparstr = wayCode +"^"+ rnum +"^"+ pcent +"^"+ spaceqty	
	
	return saveparstr
	
}

function CheckBeforeQuery() {
	return 0
}

function CheckBeforeSave() {
	if (CheckBeforeQuery() < 0) {
		return;
    }
	var maxnum = $.trim($("#conPresNum").val())||'';
	if (maxnum == "") {
		PHA.Alert('提示', "请先统计处方总数!", 'warning');
		return -1;
	}
	if (maxnum == 0) {
		PHA.Alert('提示', "处方总数为0,没有可抽取的处方,请先统计处方总数!", 'warning');
		return -1;
	}
	var rnum="",pcent=""
	var savetype = $("#conSaveType").combobox('getValue')||'';
	var conTxt = $.trim($("#conSaveTxt").val())||'';	
    if (savetype=="Random"){
		var rnum = conTxt;	
	}
	else{
		var pcent = conTxt;	
	}
	if ((rnum=="")&&(pcent=="")){
		PHA.Alert('提示', "请先填写随机数或者百分比!", 'warning');
		return -1;		
	}
	if ((!(rnum>0))&&(!(pcent>0))){
		PHA.Alert('提示', "填写的随机数或者百分比格式不正确，请修改后重试!", 'warning');
		return -1;		
	}
	var rnumstr = rnum.split(".")
	if (rnumstr[0] !== rnum){
		PHA.Alert('提示', "填写的随机数不能为小数，请修改后重试!", 'warning');
		return -1;		
	}
	if (parseFloat(rnum) > parseFloat((maxnum * maxcentnum))) {
		PHA.Alert('提示', "随机数超过总处方数的"+ maxcentnum * 100 + '%,建议调整随机数!', 'warning');
		return -1;
	}
	if (!(pcent > 0)&&(pcent!=="")) {
		PHA.Alert('提示', "百分比格式不正确!", 'warning');
        return -1;
    }
	if (parseFloat(pcent) > (maxcentnum * 100)) {
		PHA.Alert('提示', "百分比不能大于"+ maxcentnum * 100 + '%,建议调整百分比!', 'warning');
		return -1;
	}
	if (((parseFloat(pcent) * parseFloat(maxnum) / 100) < 1)&&(pcent!=="")) {
		PHA.Alert('提示', '按百分比抽取随机数小于1,不能抽取!', 'warning');
        return -1;
    }
    //间隔数
	var spaceqtynum = $.trim($("#conSpaceQty").val())||'';
	//建议间隔数
	var spaceAqtynum = $.trim($("#conASpaceQty").val())||'';
	if ((!(spaceqtynum > 0)) && (spaceqtynum != 0) && (spaceqtynum != "")) {
		PHA.Alert('提示', '间隔数填写不正确!', 'warning');
		return -1;
	}
	if ((parseInt(spaceqtynum) != spaceqtynum) && (spaceqtynum != "")) {
		PHA.Alert('提示', '间隔数只能填整数!', 'warning');
		return -1;
	}
	var spaceqtynum=parseInt(spaceqtynum)
	var spaceAqtynum=parseInt(spaceAqtynum)
	if((spaceqtynum>0)&&(spaceqtynum>spaceAqtynum)){
		PHA.Alert('提示', '间隔数大于建议间隔数,不能抽取!请参考建议间隔数,重新更改录入间隔数！', 'warning');
		return -1;
	}
	return 0;
	
}

function CheckTheoryQty()
{
	if (CheckBeforeSave() < 0) {
        return false;
    }
}

function GetSpaceQty()
{
	var spaceQty = $.trim($("#conSpaceQty").val())||'';
	var maxnum = $.trim($("#conPresNum").val())||'';		//统计处方总数
	var rnum="",pcent=""
	var savetype = $("#conSaveType").combobox('getValue')||'';
	var conTxt = $.trim($("#conSaveTxt").val())||'';	
    if (savetype=="Random"){
		var rnum = conTxt;	
	}
	else{
		var pcent = conTxt;	
	}
	if (rnum != "") {
		var writeqty = rnum;
	} else {
		var rnum = parseInt(maxnum * pcent / 100);
		var writeqty = rnum;
	}
	if (writeqty==0){
		$("#conWriteQty").val('') ;
	}
	else{
		$("#conWriteQty").val(writeqty) ;
	}
	if ((rnum != 0)&&(rnum != "")) {
		$("#conASpaceQty").val(Math.floor(maxnum / rnum));
	} else {
		$("#conASpaceQty").val('');
	}
	if ((spaceQty == 0)||(spaceQty == "")) {
		$("#conTheoryQty").val('');
	} else {
		$("#conTheoryQty").val(parseInt(writeqty * spaceQty));
	}

}