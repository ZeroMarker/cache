/**
 * INSUMsgInfo.js
 * 医保日志查询
 * tangzf 20190709
 */
 var HospDr=session['LOGON.HOSPID'];
//界面入口
$(function(){
	//回车事件    
	key_enter();
		
	//业务类型box
	ini_YWLX();
	
	// 产品线
	ini_ProductLine();
	
	//默认时间
	setDateBox();
	
	// grid
	init_dg();
});
//数据面板
function init_dg(){
	var dgobj = $HUI.datagrid("#dg", {
		fit: true,
		border:false,
		nowrap: true,
		striped: true,
		pagination: true,
		singleSelect: true,
		collapsible: true,
		onSelect: function (rowIndex, rowData) { rowindex = rowIndex; },
		onClickCell: function (rowIndex, field, value) { FormDialog(field, value, rowIndex); },
		onDblClickCell: function (rowIndex, field, value) { doubleCell("Edit", rowIndex, field); },
		columns: [[
			{ title: '导航号', field: 'MsgInfoDr', width: 70, hidden: true },
			{ title: '工号', field: 'OutUserCode', width: 70 },
			{ title: '登记号', field: 'OutRegNo', width: 90 },
			{ title: '姓名', field: 'OutPaName', width: 70 },
			{ title: '医保号', field: 'OutInsuNo', width: 80 },
			{ title: '就诊号', field: 'OutAdmDr', width: 70 },
			{ title: '发票Dr', field: 'OutInvPrtDr', width: 60 },
			{ title: '账单', field: 'OutPBDr', width: 70 },
			{ title: '业务类型代码', field: 'OutYWLX', width: 100 },
			
			{ title: '错误信息', field: 'OutMsg', width: 400, },
			{ title: '解决标记', field: 'OutSolveFlag', width: 80 },
			{ title: '解决方法', field: 'OutResolvent', width: 400, },
			/* 					{title:'错误信息',field:'OutMsg',width:400,halign:'center', formatter: function (value) {
						//return ; //Ding
								return "<span title='" + value + "'>" + value + "</span>";}},	
					  {title:'解决方法',field:'OutResolvent',width:400,halign:'center', formatter: function (value) {
						//return ; //Ding
								return "<span title='" + value + "'>" + value + "</span>"}, editor:{type:'text'}}, */
			{ title: '插入日期', field: 'OutDate', width: 90 },
			{ title: '插入时间', field: 'OutTime', width: 90 },
			{ title: '解决人', field: 'OutSolveUser', width: 80 },
			{ title: '解决日期', field: 'OutSolveDate', width: 90 },
			{ title: '解决时间', field: 'OutSolveTime', width: 90 },
			{ title: '客户端IP', field: 'OutIPAdress', width: 70 },
			{ title: 'MAC', field: 'OutIPMAC', width: 85 },
			{ title: '客户端日期', field: 'OutCliDate', width: 90 },
			{ title: '客户端时间', field: 'OutCliTime', width: 90 },
			{ title: '产品线', field: 'ProductLine', width: 100 },
			{ title: '客户端名称', field: 'OutCliName', width: 80 }
		]],
		data:[]
	});
	
}
function deleteMsg() {
	var dgobj = $HUI.datagrid("#dg")
	if (dgobj) {
		$.m({
			ClassName: "web.INSUMsgInfo",
			MethodName: "delete",
			MsgInfoDr: dgobj.MsgInfoDr
		}, function (txtData) {
			if(txtData=='0'){
				$.messager.alert('提示','删除成功','info');
			}else{
				$.messager.alert('提示','删除失败','info');		
			}
		});
	}
}

//查询
function RunQuery() {
	var YWLXobj = $HUI.combogrid("#YWLX")
	var tmpurl = "&UserCode=" + $('#UserCode').val() + "&StrIp=" + $('#StrIp').val() + "&IPMAC=" + $('#IPMAC').val() + "&RegNo=" + $('#RegNo').val() + "&InsuNo=" + $('#InsuNo').val();
	tmpurl = tmpurl + "&AdmDr=" + $('#AdmDr').val() + "&InvPrtDr=" + $('#InvPrtDr').val() + "&PBDr=" + $('#PBDr').val() + "&StartDate=" + getValueById('StartDate') + "&EndDate=" + getValueById('EndDate') + "&DateFlag=" + $('#DateFlag').checkbox('getValue') + "&SolveFlag=" + $('#SolveFlag').checkbox('getValue') + "&YWLX=" + YWLXobj.getValue();
	tmpurl = tmpurl + "&HospId=" + HospDr + "&ParamProductLine=" + $HUI.combogrid("#ProductLine").getValue();
	$HUI.datagrid("#dg", {
		url: $URL + "?ClassName=web.INSUMsgInfo&QueryName=GetINMSGInfo" + tmpurl,
		pageSize: 20
	})
}
//单击单元格 生成模态窗  w ##class(web.INSUMsgInfo).GetMsgAllInfoByRowId("202486")
function FormDialog(field, value, rowIndex) {
	switch (field) {
		case "OutMsg":
			var dgobj = $HUI.datagrid("#dg")
			dgobj.selectRow(rowIndex)
			var val = ""
			$.m({
				// get err detailinfo from global
				ClassName: "web.INSUMsgInfo",
				MethodName: "GetMsgAllInfoByRowId",
				RowId: dgobj.getSelected().MsgInfoDr,
			},function (textdata) {
					if (textdata != "") {
						openCellWindow(textdata,"disable",'错误信息')
					}else{
						$.messager.alert('提示','Global信息不存在','error')
					}
				}
			)
			break;
		case "OutResolvent":
			if (value == "") { value = " "; }
			openCellWindow(value,"enable",'解决方法')
			break;
		case "Edit":
			openCellWindow(value,"enable",'解决方法')
			break;
		default:
			break;
	}
}
// 修改解决方法
function saveSolveInfo() {
	var selectRowObj = $('#dg').datagrid('getSelected');
	var editInfo = $('#editCode').val();
	var rtn = tkMakeServerCall("web.INSUMsgInfo", "update", selectRowObj.MsgInfoDr, editInfo);
	if (rtn > 0) {
		$.messager.alert('提示', '修改成功,RowId:' + rtn, 'info', function () {
			RunQuery();
			$('#Modifydl').window('close');
		});
	} else {
		$.messager.alert('提示', '修改失败,err:' + rtn, 'info', function () {
			$('#Modifydl').window('close');
		});
	}
}
//默认时间
function setDateBox() {
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
///回车
function key_enter() {
	$('#UserCode').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#InsuNo').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#RegNo').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#AdmDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
}
// 双击单元格
function doubleCell(Flag, rowindex, field) {
	switch (field) {
		case "OutSolveFlag":
			var dgobj = $HUI.datagrid("#dg")
			dgobj.selectRow(rowindex)
			var msgobj = $.messager
			msgobj.defaults.ok = "是";
			msgobj.defaults.cancel = "否";
			msgobj.confirm('修改', '该错误是否解决？', function (r) {
				if (r) { dgobj.getSelected().OutSolveFlag = "Y"; }
				else { dgobj.getSelected().OutSolveFlag = "N"; }
				$.m(
					{
						ClassName: "web.INSUMsgInfo",
						MethodName: "update",
						MsgInfoDr: dgobj.getSelected().MsgInfoDr,
						InString: "^" + dgobj.getSelected().OutSolveFlag //解决方法^解决标记
					},
					function (textData) {
						if (textData != "") $.messager.alert('提示', "修改成功,RowId:" + textData, 'info');
						RunQuery();
					}
				)
			});
			break;
		default:
			break;
	}
}
//清屏
function clear_click() {
	$('.search-table').form('clear');
}
//业务类型
function ini_YWLX() {
	$HUI.combogrid("#YWLX", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=INSUMsgYWLX"+'&HospDr='+HospDr,
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '代码', field: 'cCode', width: 200 },
			{ title: '描述', field: 'cDesc', width: 200 },
		]]
	})
}
// 产品线
function ini_ProductLine() {
	$HUI.combogrid("#ProductLine", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=INSUMsgProductLine"+'&HospDr='+HospDr,
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '代码', field: 'cCode', width: 200 },
			{ title: '描述', field: 'cDesc', width: 200 },
		]]
	})
}
/**
 * Creator: tangzf
 * CreatDate: 2019-7-10
 * Description: 生成次级弹窗Modifydl
 * input:	msg : 提示内容
 * 			buttonType : 是否显示按钮 "Y" 显示
 * 			title : 弹窗标题
 */
function openCellWindow(msg,buttonType,title){
	$('#editCode').val(msg);
	$('#Modifydl').panel({
    	title:title,
 	});
	$("#saveBtn").linkbutton(buttonType);
	$('#Modifydl').window('open');	
}
