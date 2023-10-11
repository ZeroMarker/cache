/**
 * 名称:	 处方点评-点评权限维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.secgrp.csp";
PHA_COM.App.Name = "PRC.ConFig.SecGrp";
PHA_COM.App.Load = "";
$(function () {
	InitDict();
	InitGridWay();
	InitGridSecGrp();
	InitEvents();
});

// 事件
function InitEvents() {
	$("#btnAdd").on("click", SaveScgGrp);
	$("#btnEdit").on("click", UpdateScgGrp);
	$("#btnDel").on("click", DeleteScgGrp);
}

// 字典
function InitDict() {
	// 初始化安全组
	PHA.ComboBox("conSecGrp", {
		url: PHA_STORE.SSGroup().url 		
	});
	
}

// 表格-点评方式维护
function InitGridWay() {
    var columns = [
        [
            { field: "wayId", title: 'rowId', width: 100, hidden: true },
            { field: "wayCode", title: '代码',width: 120, },
            { field: 'wayDesc', title: '方式', width: 200},
            { field: "wayActive", title: '激活' ,width: 120}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Way',
            QueryName: 'SelectWay',
            queryMenu: "secgrp"
        },
        columns: columns,
        onClickRow:function(rowIndex,rowData){
	         QueryGridSecGrp();
		}   
    };
	PHA.Grid("gridWay", dataGridOption);
}

// 表格-点评安全组维护
function InitGridSecGrp() {
    var columns = [
        [
            { field: "wayItmId", title: 'wayItmId', width: 100, hidden: true },
            { field: "groupId", title: '安全组Id',width: 120, hidden: true },
            { field: "groupDesc", title: '安全组',width: 200, },
            { field: 'updateFlag', title: '修改权限', width: 200}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Way',
            QueryName: 'SelectWayItm'
        },
        columns: columns,
        toolbar: "#gridSecGrpBar",
        onClickRow:function(rowIndex,rowData){		
			//var wayItmId = rowData.wayItmId ;
			var updateFlag = rowData.updateFlag ;
			var groupId = rowData.groupId ;
			var groupDesc = rowData.groupDesc ;
			$("#conSecGrp").combobox('setValue', groupId); 				
			$("#conSecGrp").combobox('setText', groupDesc);
			if (updateFlag=="是"){
				//$('#chkUpdate').iCheck('check')
				$('#chkUpdate').checkbox("check",true) ;
			}
			else{
				//$('#chkUpdate').iCheck('uncheck')
				$('#chkUpdate').checkbox("uncheck",true) ;
			}
		}   
    };
    PHA.Grid("gridSecGrp", dataGridOption);
}

///查询安全组配置
function QueryGridSecGrp() {
	$("#conSecGrp").combobox("setValue",'') ;
	$("#conSecGrp").combobox("setText", '') ;
	$('#chkUpdate').checkbox("uncheck",true) ;
	var gridSelect = $("#gridWay").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要维护的数据!","info");
		return;
	}
	var wayId=gridSelect.wayId;
    $('#gridSecGrp').datagrid('query', {
        wayId: wayId
    });
}

function SaveScgGrp(){
	var gridSelect = $("#gridWay").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评方式!","info");
		return;
	}
	var wayId=gridSelect.wayId;
	if (wayId==''){
		$.messager.alert('提示',"没有获取到点评方式id，请重新选择后重试!","info");
		return;
	}
	
	var SecGrpId = $("#conSecGrp").combobox('getValue');
	if (SecGrpId == "") {
		PHA.Popover({
			msg: "请先选择安全组后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var checkFlag = ""
	if ($("#chkUpdate").is(':checked')){
		checkFlag = "Y"	
	}
	else{
		checkFlag = "N"		
	}
	var Params = wayId + "^" + SecGrpId + "^" + checkFlag
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveScgGrp',
		wayItmId: '',
		Params: Params,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		ClearwayItm();
	}
	
}
function UpdateScgGrp(){
	var gridSelect = $("#gridWay").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评方式!","info");
		return;
	}
	var wayId=gridSelect.wayId;
	if (wayId==''){
		$.messager.alert('提示',"没有获取到点评方式id，请重新选择后重试!","info");
		return;
	}
	var gridSelectItm = $("#gridSecGrp").datagrid("getSelected");
	if (gridSelectItm==null){
		$.messager.alert('提示',"请先选中安全组授权信息!","info");
		return;
	}
	var wayItmId=gridSelectItm.wayItmId;
	if (wayItmId==''){
		$.messager.alert('提示',"没有获取到授权安全组id，请重新选择后重试!","info");
		return;
	}
	
	var SecGrpId = $("#conSecGrp").combobox('getValue');
	if (SecGrpId == "") {
		PHA.Popover({
			msg: "请先选择安全组后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var checkFlag = ""
	if ($("#chkUpdate").is(':checked')){
		checkFlag = "Y"	
	}
	else{
		checkFlag = "N"		
	}
	var Params = wayId + "^" + SecGrpId + "^" + checkFlag
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveScgGrp',
		wayItmId: wayItmId,
		Params: Params,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '修改成功',
			type: 'success'
		});
		ClearwayItm();
	}
}
function DeleteScgGrp(){
	var delInfo = "您确认删除吗?"
	var gridSelectItm = $('#gridSecGrp').datagrid('getSelected');
	PHA.Confirm("删除提示", delInfo, function () {
		if ((gridSelectItm == "")||(gridSelectItm == null)) {
			PHA.Popover({
				msg: "请先选中需要删除的授权信息",
				type: "alert",
				timeout: 1000
			});
			return;
		}
		var wayItmId = gridSelectItm.wayItmId ;
		var saveRet = $.cm({
			ClassName: 'PHA.PRC.ConFig.Way',
			MethodName: 'DelScgGrp',
			wayItmId: wayItmId,			
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('提示', saveInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '删除成功',
				type: 'success'
			});
			ClearwayItm();
		}
	})
}

function ClearwayItm(){
	$("#conSecGrp").combobox("setValue",'') ;
	$("#conSecGrp").combobox("setText", '') ;
	//$('#chkUpdate').iCheck('uncheck') ;
	$('#chkUpdate').checkbox("uncheck",true) ;
	$("#gridSecGrp").datagrid("reload") ;
	
	
}





