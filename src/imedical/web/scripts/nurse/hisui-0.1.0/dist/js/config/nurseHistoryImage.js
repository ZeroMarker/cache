/*
 * @author: yaojining
 * @discription: 护理病历历史图片生成
 * @date: 2021-7-29
 */
$(function () {
	initUI();
});

var GLOBAL = {
	HospEnvironment: false,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_HistoryImage',
};

/**
* @description: 初始化界面
*/
function initUI() {
	initHosp(function(){
		LoadTemplate();
		loadHistory();
	});
	initCondition();
	listenEvent();
}

/**
* @description: 初始化查询条件
*/
function initCondition() {
	$HUI.combobox("#taskStatus", {
		valueField: 'id',
		textField: 'text',
		data:[
			{id:"A", text:"全部"},
			{id:"H", text:"未进行"},
			{id:"R", text:"正在进行"},
			{id:"P", text:"暂停"},
			{id:"S", text:"成功"},
			{id:"F", text:"失败"},
		], 
		value: 'A',
		onSelect: function(record) {
			loadHistory();
		},
		defaultFilter:4
	});
	$HUI.combobox("#taskType", {
		valueField: 'id',
		textField: 'text',
		data:[
			{id:"H", text:"网页"},
			{id:"P", text:"图片"},
			{id:"A", text:"全部"}
		], 
		value: 'H',
		onSelect: function(record) {
			loadHistory();
		},
		defaultFilter:4
	});
	$HUI.combobox("#TaskType", {
		valueField: 'id',
		textField: 'text',
		data:[
			{id:"H", text:"网页"},
			{id:"P", text:"图片"},
			{id:"A", text:"全部"}
		], 
		value: 'H',
		defaultFilter:4
	});
	$HUI.combobox("#printModel", {
		valueField: 'Indentity',
		textField: 'Name',
		url: $URL + "?ClassName=NurMp.Service.Image.History&MethodName=getAllPrintModel&HospitalID=" + GLOBAL.HospitalID,
		defaultFilter:4
	});
}
/**
 * @description 加载模板表格
 */
function LoadTemplate(){
	var param = {
		HospitalID: GLOBAL.HospitalID,
		SearchContent: $HUI.searchbox('#searchDesc').getValue()	
	};
	$HUI.datagrid('#TemplateGrid', {
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Image.History",
			QueryName: "findInusedTemplates",
			Param: JSON.stringify(param)
		},
		toolbar:"#toolbar",
		singleSelect:false,
		nowrap:false,
		pagination: true,
		pageSize: 14,
		pageList: [14, 30, 50]
	});
}
/**
 * @description 加载历史记录表格
 */
function loadHistory(Guid){
	var param = {
		Status: $('#taskStatus').combobox('getValue'),
		Type: $('#taskType').combobox('getValue')
	};
	$HUI.datagrid('#HistoryGrid', {
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Image.History",
			QueryName: "findImageHistory",
			Param: JSON.stringify(param)
		},
		singleSelect:true,
		nowrap:false,
		pagination: true,
		pageSize: 10,
		pageList: [10, 20, 30],
		rowStyler: function (rowIndex, rowData) {
			if (rowData.HCreateStatus == '正在进行') {
				return 'background-color:lightblue;';
			}else if (rowData.HCreateStatus == '暂停') {
				return 'background-color:lightgray;';
			}else if (rowData.HCreateStatus == '成功') {
				return 'background-color:lightgreen;';
			}
		},
		onDblClickRow: function(rowIndex, rowData){
			if ((rowData.HCreateStatus == "正在进行") || (rowData.HCreateStatus == "暂停") || (rowData.HCreateStatus == "成功")) {
				$.messager.alert("简单提示", "正在进行或完成状态不允许修改日期！", "info");
				return;
			}
			$("#dialog-model").dialog("open");
		 		$('#form-model').form("clear");
			 	$('#form-model').form("load", {
			 		Guids: rowData.HGuid
		 		});
		 		$('#printModel').combobox('enable');
		 		$('#printModel').combobox('setValue', rowData.HPrintGuid)
		 		$('#StartDate').datebox('setValue', rowData.HDateFrom);
		 		$('#EndDate').datebox('setValue', rowData.HDateTo);	
			}
	});
}
/**
 * @description 查询模板
 */
function findTemplates(){
	var param = {
		HospitalID: GLOBAL.HospitalID,
		SearchContent: $HUI.searchbox('#searchDesc').getValue()	
	};
	$('#TemplateGrid').datagrid('reload', {
		ClassName: "NurMp.Service.Image.History",
		QueryName: "findInusedTemplates",
		Param: JSON.stringify(param)
	});
}
/**
 * @description 编辑任务
 */
function updateModel() {
	var rows = $('#TemplateGrid').datagrid("getSelections");
	if (rows.length == 0) {
    	$.messager.alert("简单提示", "请选择模板", "info");
 	}else{
     	var guidArr = [];
     	$.each(rows, function(index, row) {
	    	guidArr.push(row.TGuid);
	    });
   		$("#dialog-model").dialog("open");
 		$('#form-model').form("clear");
	 	$('#form-model').form("load", {
	 		Guids: guidArr.join('^')
 		});
 		$('#printModel').combobox('clear');
 		if (guidArr.length > 1) {
			$('#printModel').combobox('disable');
 		}else{
	 		$('#printModel').combobox('enable');
	 	}
		// $HUI.combobox("#TaskType", {
		// 	valueField: 'id',
		// 	textField: 'text',
		// 	data:[
		// 		{id:"H", text:"网页"},
		// 		{id:"P", text:"图片"},
		// 		{id:"A", text:"全部"}
		// 	], 
		// 	value: 'H',
		// 	defaultFilter:4
		// });
		$("#TaskType").combobox("setValue","H");
 		$('#StartDate').datebox('setValue', 'Today');
 		$('#EndDate').datebox('setValue', 'Today');		
 	}
}
/**
 * @description 保存任务
 */
function saveModel() {
	var guids = $("#Guids").val();
	var startDate = $("#StartDate").datebox('getValue');
	var endDate = $("#EndDate").datebox('getValue');
	if(!startDate){
		$.messager.popover({ msg: '起始日期不能为空！', type:'error', timeout: 1000 });
    	return false;
	}
	if(!endDate){
		$.messager.popover({ msg: '终止日期不能为空！', type:'error', timeout: 1000 });
    	return false;
	}
	var param = {
		HospitalID: GLOBAL.HospitalID,
		Guids: guids,
		PrintGuid: $('#printModel').combobox('getValue'),
		DateFrom: startDate,
		DateTo: endDate,
		CreateStatus: 'H',
		TaskType: $('#TaskType').combobox('getValue'),
		RecordStatus: 'A',
		UpdateUser: session['LOGON.USERID']
	};
	$m({
		ClassName: 'NurMp.Service.Image.History',
		MethodName: 'saveModel',
		Param: JSON.stringify(param)
	},function(result){
		if(!result){
			$.messager.popover({ msg: '保存成功!', type: 'success', timeout: 1000});
			$("#dialog-model").dialog( "close" );
			$('#HistoryGrid').datagrid('reload');			
		}else{
			$.messager.popover({ msg: result, type: 'error', timeout: 1000});
		}
	});
}
function formatOper(value, row, index){
	var result;
	if (row.HCreateStatus == "未进行") {
    	result = "<a onclick='createPic(" + index + ")' class='icon-run' href='#'>&nbsp&nbsp&nbsp&nbsp</a>&nbsp&nbsp";
	    result += "<a onclick='deleteRow(" + index + ")' class='icon-cancel' href='#'>&nbsp&nbsp&nbsp&nbsp</a>";		
	}else if (row.HCreateStatus == "正在进行") {
    	result = "<a onclick='pause(" + index + ")' class='icon-pause' href='#'>&nbsp&nbsp&nbsp&nbsp</a>&nbsp&nbsp";
	}else if (row.HCreateStatus == "暂停") {
    	result = "<a onclick='createPic(" + index + ")' class='icon-run' href='#'>&nbsp&nbsp&nbsp&nbsp</a>&nbsp&nbsp";
	}else if (row.HCreateStatus == "成功") {
    	result = "<a onclick='createPic(" + index + ")' class='icon-run' href='#'>&nbsp&nbsp&nbsp&nbsp</a>&nbsp&nbsp";
	}else if (row.HCreateStatus == "失败") {
    	result = "<a onclick='createPic(" + index + ")' class='icon-run' href='#'>&nbsp&nbsp&nbsp&nbsp</a>&nbsp&nbsp";
	    result += "<a onclick='deleteRow(" + index + ")' class='icon-cancel' href='#'>&nbsp&nbsp&nbsp&nbsp</a>";
    }
    return result;
}
function formatLog(value, row, index){
	var formatClass = "icon-paper";
    return  "<a onclick='showLog(" + index + ")' class='" + formatClass + "' href='#'>&nbsp&nbsp&nbsp&nbsp</a>"
}
/**
 * @description 删除记录
 */
function deleteRow(index){
	var record = $("#HistoryGrid").datagrid("getData").rows[index];
	$m({
		ClassName: 'NurMp.Service.Image.History',
		MethodName: 'deleteModel',
		ID: record.HID
	}, function(result){
		if (result == 0) {
			$.messager.popover({msg: "删除成功!", type: 'success', timeout: 1000 });
			loadHistory();
		}else{
			$.messager.popover({msg: '删除失败!', type: 'error', timeout: 1000 });
		}
	});
}
/**
 * @description 生成图片
 */
function createPic(index){
	var record = $("#HistoryGrid").datagrid("getData").rows[index];
	if (!record.HPrintGuid) {
		$.messager.alert("简单提示", "请配置打印模板！", "info");
		return;
	}
	var param = {
		Guids: record.HGuid,
		CreateStatus: 'R',
		TaskType: record.HTaskType == "网页" ? "H" : "P",
		UpdateUser: session['LOGON.USERID']
	};
	$m({
		ClassName: 'NurMp.Service.Image.History',
		MethodName: 'saveModel',
		Param: JSON.stringify(param)
	}, function(result){
		if (!result) {
			loadHistory();
			$m({
				ClassName: 'NurMp.Print.NurseHistoryImage',
				MethodName: 'getDischAdm',
				StDate: record.HDateFrom, 
				EdDate: record.HDateTo, 
				HospitalId: GLOBAL.HospitalID, 
				PrnCode: record.HPrintGuid, 
				Code: record.HGuid,
				TaskType: record.HTaskType == "网页" ? "H" : "P"
			}, function(flag){
				if (flag == 0) {
					loadHistory();
				}else{
					console.log(flag);
				}
			});
		}else{
			console.log(result);
		}
	});
}
/**
 * @description 暂停
 */
function pause(index){
	var record = $("#HistoryGrid").datagrid("getData").rows[index];
	var param = { 
		Guids: record.HGuid,
		CreateStatus: 'P',
		UpdateUser: session['LOGON.USERID']
	};
	$m({
		ClassName: 'NurMp.Service.Image.History',
		MethodName: 'saveModel',
		Param: JSON.stringify(param)
	}, function(result){
		if (!result) {
			loadHistory();
		}else{
			
		}
	});
}
/**
 * @description 显示日志
 */
function showLog(index){
	var record = $("#HistoryGrid").datagrid("getData").rows[index];
	var url = 'nur.hisui.nursehistoryimagelog.csp?HospitalID=' + GLOBAL.HospitalID + '&Code=' + record.HGuid;
    $('#dialog-log').dialog({  
        title: '日志',
        width: 600,  
        height: 400,  
        content:"<iframe id='iframeImageLog' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
    });
    $("#dialog-log").dialog("open");
}
/**
 * @description 监听事件
 */
function listenEvent(){
	setInterval(function(){
		loadHistory();
	}, 20000)
	$('#searchDesc').searchbox({
		searcher: function(value) {
			findTemplates();
		}
	});
	$('#addToTask').bind('click', updateModel);
	$('#btn-dialog-save').bind('click', saveModel);
}