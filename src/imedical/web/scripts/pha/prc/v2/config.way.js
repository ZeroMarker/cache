/**
 * 名称:	 处方点评-点评方式维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.way.csp";
PHA_COM.App.Name = "PRC.ConFig.Way";
PHA_COM.App.Load = "";
$(function () {
	InitGridWay();
	InitEvents();
});

// 事件
function InitEvents() {
	$("#btnAdd").on("click", SaveWay);
	$("#btnEdit").on("click", EditWay);
}


// 表格-点评方式维护
function InitGridWay() {
    var columns = [
        [
            { field: "wayId", title: 'rowId',width: 100,hidden: true },
            { field: "wayCode", title: '代码',width: 120, },
            { field: 'wayDesc', title: '方式', width: 300},
            { field: "wayActive", title: '激活' ,width: 120},
            { field: 'wayReSave', title: '重复抽取', width: 120}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Way',
            QueryName: 'SelectWay'
        },
        columns: columns,
        toolbar: "#gridWayBar",
        onClickRow:function(rowIndex,rowData){
			var rowId=rowData.wayId;
			var wayCode=rowData.wayCode;
			var wayDesc=rowData.wayDesc;
			var activeFlag=rowData.wayActive;
			var repeatFlag=rowData.wayReSave;
			$("#conCode").val(wayCode);
			$("#conDesc").val(wayDesc);
			$HUI.checkbox("#chkActive", { "checked": activeFlag == "是" ? true : false });
			$HUI.checkbox("#chkRepeat", { "checked": repeatFlag == "是" ? true : false });
		}   
    };
	PHA.Grid("gridWay", dataGridOption);
}

function SaveWay(){
	var wayCode = $("#conCode").val();
	var wayCode = wayCode.replace(/\s+/g,"");
	if (wayCode == "") {
		PHA.Popover({
			msg: "请先填写点评代码后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var wayDesc = $("#conDesc").val();
	var wayDesc = wayDesc.replace(/\s+/g,""); 
	if (wayDesc == "") {
		PHA.Popover({
			msg: "请先填写点评方式描述后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	if ($("#chkActive").is(':checked')){
		activeFlag = "Y"	
	}
	else{
		activeFlag = "N"		
	}
	if ($("#chkRepeat").is(':checked')){
		reSaveFlag = "Y"	
	}
	else{
		reSaveFlag = "N"		
	}
	var Params = wayCode + "^" + wayDesc + "^" + activeFlag + "^" + reSaveFlag ;
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveWay',
		wayId: '',
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
		ClearWay();
	}
	
}
function EditWay(){
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
	var wayCode = $("#conCode").val();
	var wayCode = wayCode.replace(/\s+/g,"");
	if (wayCode == "") {
		PHA.Popover({
			msg: "请先填写点评方式代码后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var wayDesc = $("#conDesc").val();
	var wayDesc = wayDesc.replace(/\s+/g,"");
	if (wayDesc == "") {
		PHA.Popover({
			msg: "请先填写点评方式描述后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	if ($("#chkActive").is(':checked')){
		activeFlag = "Y"	
	}
	else{
		activeFlag = "N"		
	}
	if ($("#chkRepeat").is(':checked')){
		reSaveFlag = "Y"	
	}
	else{
		reSaveFlag = "N"		
	}
	var Params = wayCode + "^" + wayDesc + "^" + activeFlag + "^" + reSaveFlag ;
	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Way',
		MethodName: 'SaveWay',
		wayId: wayId,
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
		ClearWay();
	}
}

function ClearWay(){
	$("#conCode").val('');
	$("#conDesc").val('');
	$HUI.checkbox("#chkActive", { "checked": false });
	$HUI.checkbox("#chkRepeat", { "checked": false });
	$("#gridWay").datagrid("reload");
	
	
}





