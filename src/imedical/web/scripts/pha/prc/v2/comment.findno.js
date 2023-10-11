/**
 * 名称:	 处方点评-点评处方-查单
 * 编写人:	 pushuangcai
 * 编写日期: 2020/11/06
 */
var FindNoDialog = {
	type: "",
	findFlag: "",
	loadWayCode: '',
	callback: ""
}

function InitFindNoDialog(opts){	
	FindNoDialog.type = opts.type;
	FindNoDialog.callback = opts.callback;
	if(opts.type === "OP"){
		FindNoDialog.findFlag = 1;
	}else{
		FindNoDialog.findFlag = 2;
	}
	InitFindNoDialogDict();
	InitSetFindNoDialogDefVal();
	InitGridFindNo();
	InitDialogFindNo();
}
		
function InitFindNoDialogDict() {
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay(FindNoDialog.findFlag, "CNTS").url,
		width:140
	});
	PHA.ComboBox("conResult", {
		data: [{
			RowId: "1",
			Description: $g("仅有结果")
		}, {
			RowId: "2",
			Description: $g("仅无结果")
		}, {
			RowId: "3",
			Description: $g("仅合理")
		}, {
			RowId: "4",
			Description: $g("仅不合理")
		}, {
			RowId: "5",
			Description: $g("仅医生申诉")
		}],
		panelHeight: "auto",
		width:160
	});
	PHA.ComboBox("conPharmacist", {
		url: PRC_STORE.PhaUser(),
		width:160
	});
	PHA.ComboBox("comState", {
		data: [{
			RowId: "5",
			selected: true,
			Description: $g("待点评")
		},{
			RowId: "1",
			Description: $g("未点评")
		}, {
			RowId: "2",
			Description: $g("点评中")
		}, {
			RowId: "3",
			Description: $g("点评完成")
		}, {
			RowId: "4",
			Description: $g("已提交")
		}],
		panelHeight: "auto",
		width:140
	});
}

// 界面信息初始化
function InitSetFindNoDialogDefVal() {
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.ComEndDate);
		// 二次点评启用标志
		if (jsonColData.ReCntFlag == "Y"){
			width = 0 ;
			hiddenFlag = false ;
		}
		if (jsonColData.DefaultLogonUser == "Y"){
			var phaFlag=tkMakeServerCall("PHA.PRC.Com.Util", "ChkPharmacistFlag", logonUserId)
			if (phaFlag=="Y"){	
				$("#conPharmacist").combobox("setValue", logonUserId);
			}
		}
		if (gDateRange != ""){
			var ComStartDate =tkMakeServerCall("PHA.COM.Util", "T2HtmlDate", gDateRange.split(",")[0]);
			var ComEndDate =tkMakeServerCall("PHA.COM.Util", "T2HtmlDate", gDateRange.split(",")[1]);
			$("#conStartDate").datebox("setValue", ComStartDate);
			$("#conEndDate").datebox("setValue", ComEndDate);
		}
		SearchComments();
	});	
}

function InitGridFindNo() {
	var columns = [[
        { field: "pcntId", 		title: 'rowid', 	width: 80, hidden:true},
        { field: "pcntNo", 		title: '单号',		width: 150 },
        { field: 'pcntDate', 	title: '日期', 		width: 100},
        { field: "pcntTime", 	title: '时间', 		width: 80 },
        { field: "pcntUserName", title: '制单人',	width: 80},
        { field: "typeDesc", 	title: '类型',		width: 120 },
        { field: 'wayDesc', 	title: '方式', 		width: 150},
        { field: "pcntText", 	title: '查询条件' ,	width: 400},
        { field: "pcntState", 	title: '点评状态',	width: 80 },
        { field: 'pcntWayCode',	title: '方式代码', 	width: 200, hidden: true},
		{ field: 'pcntWayId', 	title: '方式', 		width: 200, hidden: true}
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectComments',
			findFlag: FindNoDialog.findFlag,
			stDate: $("#conStartDate").datebox('getValue'),
			endDate: $("#conEndDate").datebox('getValue'),
			parStr: '',
			logonLocId: logonLocId,
			searchFlag: ''
        },      
        columns: columns,
        toolbar: "#gridFindNoBar",
        border: true ,
        isTopZindex:true ,
        bodyCls:'panel-header-gray',
        onDblClickRow:function(rowIndex,rowData){
	         SelectCommentItms() ;
		}   
    };
	PHA.Grid("gridFindNo", dataGridOption);
}

function InitDialogFindNo(){
	var title;
	if(FindNoDialog.type === "OP"){
		title = "点评处方查单";
	}else{
		title = "点评住院医嘱查单";	
	}
	$('#diagFindNo').dialog({
		title: title,
		iconCls: 'icon-w-find',
		modal: true,
		closed: true,
		isTopZindex:true ,
		width: 1200,
		height: 550,
	});
}
// 打开查单界面
function ShowDiagFindNo() {
	$('#diagFindNo').dialog('open');
}

// 查询点评单
function SearchComments(){
	var stDate = $("#conStartDate").datebox('getValue') ;
	var endDate = $("#conEndDate").datebox('getValue') ;
	var wayId = $("#conWay").combobox('getValue')||''; 
	var result = $("#conResult").combobox('getValue')||'';
	var phaUserId = $("#conPharmacist").combobox('getValue')||'';
	var state = $("#comState").combobox('getValue')||'';
	var parStr = wayId + "^" + result + "^" + phaUserId + "^" + state
	
	$("#gridFindNo").datagrid("query", {
		findFlag: FindNoDialog.findFlag,
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: ''
	});		
}

// 删除点评单
function DeleteComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		var deleteRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'DeleteComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
	
		var deleteRet = deleteRet.toString() ;
		var deleteArr = deleteRet.split('^');
		var deleteVal = deleteArr[0];
		var deleteInfo = deleteArr[1];
		
		if (deleteVal < 0) {
			PHA.Alert('提示', deleteInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '删除成功',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
}

// 提交点评单
function SubmitComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	var subInfo = "您确认提交吗?提交后不允许取消提交！"
	PHA.Confirm("提交提示", subInfo, function () {
		var submitRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SubmitComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
		
		var submitRet = submitRet.toString() ;
		var submitArr = submitRet.split('^');
		var submitVal = submitArr[0];
		var submitInfo = submitArr[1];
		
		if (submitVal < 0) {
			PHA.Alert('提示', submitInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '提交成功',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
}

// 选取点评单信息
function SelectCommentItms(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
	var loadPcntId = pcntId
	var loadWayId = gridSelect.pcntWayId ;
	var loadWayCode = gridSelect.pcntWayCode ;
	var selResult = $("#conResult").combobox('getValue')||'';
	var selPhaUserId = $("#conPharmacist").combobox('getValue')||'';
	FindNoDialog.loadWayCode = loadWayCode;
	var param = {
		pcntId: loadPcntId,	
		comResult: selResult,
		phaUserId: selPhaUserId,
		loadWayCode: loadWayCode,
		selPhaUserId: selPhaUserId
	}
	if(FindNoDialog.callback){
		FindNoDialog.callback(param);	
	}
	$('#diagFindNo').dialog('close');
}