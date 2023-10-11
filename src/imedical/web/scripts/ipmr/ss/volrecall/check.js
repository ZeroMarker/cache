/**
 * check 审核
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2021-05-24
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	InitgridApply();
	loadgridApply();
	InitgridExpand();
	InitgridCheckExpand();
}

function InitEvent(){
}

/**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 待审核申请记录模块
 * DATE: 2021-05-11
 * NOTE: 包括方法：
 * TABLE: 
 */
 // 初始化待审核申请记录表格
function InitgridApply(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'VolStausDesc',title:'病案状态',width:100,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'ApplyUser',title:'申请人',width:80,align:'left'},
		{field:'ApplyDate',title:'申请时间',width:160,align:'left',
			formatter: function(value,row,index){
				return row.ApplyDate+ ' ' + row.ApplyTime;
			}
		},
		{field:'StatusDesc',title:'状态',width:100,align:'left'},
		{field:'ReCallReasonDesc',title:'召回原因',width:150,align:'left'},
		{field:'IsReCallAll',title:'全部召回',width:80,align:'left',
			formatter:function(value,row,index){
				var IsReCallAll	= row.IsReCallAll;
				var ReCallID	= row.ReCallID;
				if (IsReCallAll == '1'){
					return $g("是");
				} else {
					return "<a href='#' onclick='openExpandDialog(\"" + ReCallID +"\""+");'>"+$g('否')+"</a>";
				}
			}
		},
		{field:'Resume',title:'备注',width:100,align:'left'}
	]];
	var gridApply =$HUI.datagrid("#gridApply",{
		fit: true,
		title: "病案召回申请记录",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallSrv",
			QueryName:"QryReCallToCheck",
			aHospID: Logon.HospID,
			aMrTypeID:Logon.MrTypeID,
			aDiscLocID:Logon.LocID,
			aStatusCode:ServerObj.ApplyStatus
	    },
		columns:columns
	});
	return gridApply;
}

// 刷新申请记录数据
function loadgridApply() {
	$("#gridApply").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallSrv",
		QueryName:"QryReCallToCheck",
		aHospID: Logon.HospID,
		aMrTypeID:Logon.MrTypeID,
		aDiscLocID:Logon.LocID,
		aStatusCode:ServerObj.ApplyStatus
	})
	$('#gridApply').datagrid('unselectAll');
}


function checkPass(type){
	var selectData	= $('#gridApply').datagrid('getSelections');
	if (selectData.length==0){
		$.messager.popover({msg: '请选择需操作的申请记录！',type: 'alert',timeout: 1000});
		return false;
	}
	var ReCallIDs = '';
	var selectFlag=1; // 勾选的数据中是否都是整体召回
	for (var i = 0; i <  selectData.length; i++) {
		var selRowArray = selectData[i];
		ReCallIDs += ',' + selRowArray.ReCallID;
		if (selRowArray.IsReCallAll==0) selectFlag=0;
	}
	if (ReCallIDs != '') ReCallIDs = ReCallIDs.substr(1,ReCallIDs.length-1);
	if ((ServerObj.PassCode=='MP')&&(selectFlag==0)&&(type==0)){	// 病案科审核
		// 弹出明细编辑框
		openExpandCheckDialog(ReCallIDs);
	}else{
		if (type==1) {	// 验证是否有没有授权时长的
			var data = $('#gridCheckExpand').datagrid('getData');
			var checkflg=0;
			for (var i=0;i<data.total;i++) {
				if ((data.rows[i].DurationTimeID=='')&&(data.rows[i].IsRefuse==0)) checkflg=1;
			}
			if (checkflg==1){
				$.messager.popover({msg: '存在未授权时长的病历文书！',type: 'alert',timeout: 1000});
				return false;
			}
		}
		$.messager.confirm('确认', '确认审核通过勾选的记录？', function(r){
	    	if (r) {
				var flg = $m({
					ClassName:"MA.IPMR.SSService.VolReCallSrv",
					MethodName:"CheckReCall",
					aReCallIDs:ReCallIDs,
					aStatusCode:ServerObj.PassCode,
					aUserID:Logon.UserID,
					aResume:'',
					aIPAddress:ServerObj.IpAdress
				},false);
				if (parseInt(flg) <= 0) {
					if (parseInt(flg)==0){
						$.messager.alert("提示", "召回状态维护错误!" + '<br>' + flg, 'info');
					}
					if (parseInt(flg)==-1){
						$.messager.alert("错误", "病案卷信息错误!" + '<br>' + flg, 'error');
					}
					if (parseInt(flg)==-2){
						$.messager.alert("错误", "审核信息保存失败!" + '<br>' + flg, 'error');
					}
					if (parseInt(flg)==-3){
						$.messager.alert("错误", "病案卷状态错误!" + '<br>' + flg, 'error');
					}
					if (parseInt(flg)==-4){
						$.messager.alert("错误", "撤销回收状态失败!" + '<br>' + flg, 'error');
					}
					if (parseInt(flg)==-5){
						$.messager.alert("错误", "撤销病历提交失败!" + '<br>' + flg, 'error');
					}
				} else {
					if (type==1) {
						$('#ExpandCheckDialog').window("close");
					}
					loadgridApply();
				}
			} 
	    });
	}
}

// 审核通过
$('#btnPass').click(function(){
	checkPass(0)
});

// 审核不通过
$('#btnUnPass').click(function(){
	var selectData	= $('#gridApply').datagrid('getSelections');
	if (selectData.length==0){
		$.messager.popover({msg: '请选择需操作的申请记录！',type: 'alert',timeout: 1000});
		return false;
	}
	var ReCallIDs = '';
	for (var i = 0; i <  selectData.length; i++) {
		var selRowArray = selectData[i];
		ReCallIDs += ',' + selRowArray.ReCallID;
	}
	if (ReCallIDs != '') ReCallIDs = ReCallIDs.substr(1,ReCallIDs.length-1);
	$.messager.prompt("提示", "输入审核不通过原因:", function (r) {
		if (r) {
			var flg = $m({
				ClassName:"MA.IPMR.SSService.VolReCallSrv",
				MethodName:"CheckReCall",
				aReCallIDs:ReCallIDs,
				aStatusCode:ServerObj.UnPassCode,
				aUserID:Logon.UserID,
				aResume:r,
				aIPAddress:ServerObj.IpAdress
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "审核不通过失败!" + '<br>' + flg, 'error');
			} else {
				loadgridApply();
			}
		} else {
			if (r=='') {
				$.messager.popover({msg: '输入信息为空，未做任何操作！',type: 'alert',timeout: 1000});
			}
		}
	});
});

// 初始化召回文书表格
function InitgridExpand(){
	var columns = [[
		{field:'Title',title:'标题',width:120,align:'left'},
		{field:'CreateDate',title:'创建日期',width:100,align:'left'},
		{field:'CreateTime',title:'创建时间',width:100,align:'left'},
		{field:'CreateUser',title:'病历创建人',width:100,align:'left'},
		{field:'Status',title:'状态',width:80,align:'left'}
	]];
	var gridExpand =$HUI.datagrid("#gridExpand",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    url:$URL,
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryVolReCallExpand",
			aReCallIDs:''
	    },
		columns:columns
	});
	return gridExpand;
}

// 刷新历文书表格数据
function loadgridExpand(ReCallID) {
	$("#gridExpand").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
		QueryName:"QryVolReCallExpand",
		aReCallIDs:ReCallID
	})
	$('#gridExpand').datagrid('unselectAll');
}

// 单项召回明细
function openExpandDialog(ReCallID){
	loadgridExpand(ReCallID);
	var ExpandDialog =$HUI.dialog('#ExpandDialog',{
		title:'召回文书',
		iconCls:'icon-w-edit',
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
	    buttons:[{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#ExpandDialog').window("close");
			}	
		}]
	});
	$('#ExpandDialog').window('open');
}


// 初始化审核召回文书表格
function InitgridCheckExpand(){
	var columns = [[
		{field:'ApplyUser',title:'申请人',width:120,align:'left'},
		{field:'ApplyDate',title:'申请日期',width:120,align:'left'},
		{field:'ApplyTime',title:'申请时间',width:120,align:'left'},
		{field:'MrNo',title:'病案号',width:120,align:'left'},
		{field:'PatName',title:'患者姓名',width:120,align:'left'},
		{field:'DischDate',title:'出院日期',width:120,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:120,align:'left'},
		{field:'CreateUser',title:'病历创建人',width:100,align:'left'},
		{field:'CreateDate',title:'创建日期',width:100,align:'left'},
		{field:'CreateTime',title:'创建时间',width:100,align:'left'},
		{field:'Status',title:'状态',width:80,align:'left'},
		{field:'DurationTimeDesc',title:'授权时长',width:120,align:'left',
			editor:{
				type: 'combobox',
				options: ComboDurationTime()
			}
		},
		{field:'IsRefuse',title:'操作',width:120,align:'left',
			formatter:function(value,row,index){
				var IsRefuse	= row.IsRefuse;
				var ExpandID	= row.ExpandID;
				if (IsRefuse == '1'){
					return "<a href='#' onclick='operIsRefuse(\"" + ExpandID +"\""+",\"" +0 + "\");'>"+$g("取消拒绝")+"</a>";
				} else {
					return "<a href='#' onclick='operIsRefuse(\"" + ExpandID +"\""+",\"" +1 + "\");'>"+$g("拒绝")+"</a>";
				}
			}
		}
	]];
	var gridCheckExpand =$HUI.datagrid("#gridCheckExpand",{
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    url:$URL,
	    /*groupField:'ReCallID',
		view: groupview,
		groupFormatter: function (value, rows) {
			var tip = '申请人：'+rows[0].ApplyUser + ' 病案号：'+rows[0].MrNo+ ' 姓名：'+rows[0].PatName+ ' '+rows[0].DischLocDesc+ ' '+rows[0].DischDate
		    return tip;
		},*/
	    queryParams:{
		    ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
			QueryName:"QryVolReCallExpand",
			aReCallIDs:''
	    },
		columns:columns,
		onDblClickRow: function(index,row) {
			var eIndex = $(this).datagrid('getEditingRowIndexs')[0];
			if (typeof(eIndex)=='undefined') {
				$(this).datagrid('beginEdit', index);
			}else{
				if (eIndex!=index){
					$(this).datagrid('endEdit', eIndex);
					$(this).datagrid('beginEdit', index);
				}
			}
		}
	});
	return gridCheckExpand;
}

// 刷新历文书表格数据
function loadgridCheckExpand(ReCallIDs) {
	$("#gridCheckExpand").datagrid("reload", {
		ClassName:"MA.IPMR.SSService.VolReCallExpandSrv",
		QueryName:"QryVolReCallExpand",
		aReCallIDs:ReCallIDs
	})
	$('#gridCheckExpand').datagrid('unselectAll');
}

// 单项召回明细
function openExpandCheckDialog(ReCallIDs){
	loadgridCheckExpand(ReCallIDs);
	var ExpandCheckDialog =$HUI.dialog('#ExpandCheckDialog',{
		title:'授权召回文书',
		iconCls:'icon-w-edit',
		modal:true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
	    buttons:[{
			text:'确定',
			iconCls:'icon-w-add',
			handler:function(){
				checkPass(1);
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				$('#ExpandCheckDialog').window("close");
			}	
		}]
	});
	$('#ExpandCheckDialog').window('open');
}
/**
 * 授权时长下拉框
 * @return {cmp}下拉组件
 */
function ComboDurationTime() {
	var cbo = {
		url: $URL,
		editable: false,
		defaultFilter:4,
		valueField: 'Desc',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.aDicType = 'ReCallDurationTime';
			param.aIsActive = 1;
			param.aHospID = '';
			param.aAlias = '';
			param.ResultSetType = 'array';
		},onSelect:function(record){
			var eIndex = $('#gridCheckExpand').datagrid('getEditingRowIndexs')[0];
			var expandID = $('#gridCheckExpand').datagrid('getData').rows[eIndex].ExpandID;
			var DurationTimeID = record['ID'];
			$m({
				ClassName:"MA.IPMR.SS.VolReCallExpand",
				MethodName:"UpdateDurationTime",
				aInputStr:expandID+'^'+DurationTimeID
			},function(txtData){
				$('#gridCheckExpand').datagrid('reload');
			});
		}
	}
	return cbo;
}

// 取消拒绝/拒绝单项
function operIsRefuse(ExpandID,RefuseFlg) {
	$m({
		ClassName:"MA.IPMR.SS.VolReCallExpand",
		MethodName:"UpdateRefuse",
		aExpandID:ExpandID,
		aIsRefuse:RefuseFlg
	},function(txtData){
		$('#gridCheckExpand').datagrid('reload');
	});
}