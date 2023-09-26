/**
 * @模块:     煎药流程-状态执行
 * @编写日期: 2019-07-17
 * @编写人:   hulihua
 */

var Number = 0;
var pageTbNum = 15;
var NowTAB=""; 			//记录当前页签的tab
var ComPropData;		//公共参数
var NowRowId;			//批量执行时记录当前正在编辑的行
$(function () {
	InitDict();
	InitSetDefVal();
	InitGridScanPresc();
	InitGridBatPresc();
	InitGridExePresc();
	//登记号回车事件
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				Query();
			}
		}
	});

	$('#txtBarCode').on('keypress', function (event) {
		if (event.keyCode == "13") {
			var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
			if (tabTitle != "扫码执行") {
				$("#tabsExecute").tabs("select", 0);
			}
			var decPstId = $("#cmbDecState").combobox('getValue');
			if (decPstId == "") {
				PHA.Popover({
					msg: "请先选择煎药流程！",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			};
			if (this.value.trim() == "") {
				PHA.Popover({
					msg: "处方号为空！",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			}
			ScanExecute(this.value);
			$(this).val("");
		}
	});

	//事件
	$('#cmbDecState').combobox({
		onSelect: function () {
			Query();
		}
	});

	$('#cmbDecLoc').combobox({
		onSelect: function () {
			var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
			var type = $("input[name='busType']:checked").val() || "O";
			PHA.ComboBox("cmbDecState", {
				editable: false,
				url: PHA_DEC_STORE.DecState(decLocId, type, "Execute").url
			});

			PHA.ComboBox("cmbEquiDesc", {
				url: PHA_DEC_STORE.DecEqui(decLocId).url
			});
			$HUI.combobox("#cmbEquiDesc").disable();
		}
	});

	$HUI.radio("[name='busType']", {
		onChecked: function (e, value) {
			var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
			PHA.ComboBox("cmbDecState", {
				editable: false,
				url: PHA_DEC_STORE.DecState(decLocId, $(this).val(), "Execute").url
			});
			$('#gridScanPresc').datagrid('clear');
			$('#gridBatPresc').datagrid('clear');
			$('#gridPrescExe').datagrid('clear');
			{DEC_PRINT.VIEW(ComPropData.decInfoId, {});}
			$("#txtBarCode").val('');
			$("#txtWaterQua").val('');
			$("#cmbEquiDesc").combobox("setValue", '');
			$("#txtInput").val('');
		}
	});

	$("#tabsExecute").on("click", ChangeTabs);

});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	//公共配置
	ComPropData = $.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.COMMON",
	}, false);
	PHA.ComboBox("cmbDecLoc", {
		editable: false,
		url: PHA_DEC_STORE.DecLoc().url,
		onLoadSuccess: function () {
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		}
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url,
		onLoadSuccess: function () {
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});
	PHA.ComboBox("cmbDocLoc", {
		url: PHA_DEC_STORE.DocLoc().url
	});
	
	PHA.ComboBox("cmbDecState", {
		editable: false,
		url: PHA_DEC_STORE.DecState(ComPropData.DefaultDecLoc, "O", "Execute").url
	});
	PHA.ComboBox("cmbEquiDesc", {
		url: PHA_DEC_STORE.DecEqui(ComPropData.DefaultDecLoc).url,
		width: 155
	});
	$HUI.combobox("#cmbEquiDesc").disable();
	if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {
		//显示煎药信息panel
		var decInfoId = DEC_PRINT.DecInfo("colexecutelayout");	
		ComPropData.decInfoId = decInfoId;
		DEC_PRINT.VIEW(decInfoId, {PrescNo: ""});	
	}
}

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	if(parseInt(ComPropData.ScanPageTbNum)>0){
		pageTbNum=parseInt(ComPropData.ScanPageTbNum);
	}
	$("#tabsExecute").tabs("select", parseInt(ComPropData.OperateModel));
	if (parseInt(ComPropData.OperateModel) == "0") {
		$('#txtBarCode').focus();
	}
	$HUI.radio("input[value='O']").check();
	var tabId= $('#tabsExecute').tabs('getSelected').attr("id");
	NowTAB=tabId;
	//界面配置
	$.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.STATUSEXE"
	}, function (jsonData) {
		$("#dateStart").datebox("setValue", jsonData.ExeStartDate);
		$("#dateEnd").datebox("setValue", jsonData.ExeEndDate);
		$('#timeStart').timespinner('setValue', "00:00:00");
		$('#timeEnd').timespinner('setValue', "23:59:59");
		$('#txtWaterQua').val("").prop('disabled', true);
		$('#txtInput').val("").prop('disabled', true);
		$("#txtPatNo").val("");
		$('#txtBarCode').val("");
	});
	if (NowTAB=="tabScanPresc"){
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);
	} else {
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
	}
}

/**
 * 切换页签
 * @method ChangeTabs
 */
function ChangeTabs() {
	var tabId= $('#tabsExecute').tabs('getSelected').attr("id");
	if(NowTAB==tabId){
		return;
	}
	NowTAB=tabId;
	var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
	if (tabTitle == "扫码执行") {
		$('#txtBarCode').focus();
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);
	}
	else{
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
	}
	if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {DEC_PRINT.VIEW(ComPropData.decInfoId, {});}
	Query();
}

/**
 * 初始化扫描处方列表
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [[{
				field: 'TPstDesc',
				title: '当前流程',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TPstDesc == "收方") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TPstDesc == "浸泡") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TPstDesc == "首煎") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TPstDesc == "二煎") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TPstDesc == "制膏") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TPstDesc == "打签") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TPstDesc == "发放") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TPstDesc == "送药") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TPstCode',
				title: 'TPstCode',
				width: 60,
				hidden: 'true'
			}, {
				field: 'TPMId',
				title: 'TPMId',
				width: 60,
				hidden: 'true'
			}, {
				field: 'TPatNo',
				title: '登记号',
				align: 'left',
				width: 100
			}, {
				field: 'TPatName',
				title: '患者姓名',
				align: 'left',
				width: 100
			}, {
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 120
			}, {
				field: 'TPhaLocDesc',
				title: '调剂药房',
				align: 'left',
				width: 120
			}, {
				field: 'TDocLocDesc',
				title: '开方科室',
				align: 'left',
				width: 120
			}, {
				field: 'TDecType',
				title: '煎药类型',
				align: 'left',
				width: 80
			}, {
				field: 'TPreFacTor',
				title: '付数',
				align: 'left',
				width: 60
			}, {
				field: 'TPreCount',
				title: '味数',
				align: 'left',
				width: 60
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '是否加急',
				align: 'left',
				width: 80
			}, {
				field: 'TOperUser',
				title: '当前流程操作人',
				align: 'left',
				width: 120
			}, {
				field: 'TOperDate',
				title: '当前流程操作时间',
				align: 'left',
				width: 150
			}
		]];
	var dataGridOption = {
		url: '',
		rownumbers: true,
		columns: columns,
		pagination: false,
		singleSelect: true,
		onSelect: function (rowIndex, rowData) {
			if (rowData.TPstCode == "JP") {
				$("label[for='labelText']").html("浸泡时长(分钟)");
				$('#txtInput').prop('disabled', false);
				$("#txtInput").val(rowData.TInterval).validatebox("validate");
				$HUI.combobox("#cmbEquiDesc").disable();
				$('#txtWaterQua').prop('disabled', true);
			} else if (rowData.TPstCode == "SJ") {
				$("label[for='labelEqui']").html("首煎设备");
				$("label[for='labelWaterQua']").html("首煎水量(ml)");
				$("label[for='labelText']").html("首煎时长(分钟)");
				$HUI.combobox("#cmbEquiDesc").enable();
				$('#txtWaterQua').prop('disabled', false);
				$('#txtInput').prop('disabled', false);
				$("#txtInput").val(rowData.TInterval).validatebox("validate");
				$("#txtWaterQua").val(rowData.TWaterQua).validatebox("validate");
				$("#cmbEquiDesc").combobox("setValue", rowData.TDecEquiId);
			} else if (rowData.TPstCode == "EJ") {
				$("label[for='labelEqui']").html("二煎设备");
				$("label[for='labelWaterQua']").html("二煎水量(ml)");
				$("label[for='labelText']").html("二煎时长(分钟)");
				$HUI.combobox("#cmbEquiDesc").enable();
				$('#txtWaterQua').prop('disabled', false);
				$('#txtInput').prop('disabled', false);
				$("#txtInput").val(rowData.TInterval).validatebox("validate");
				$("#txtWaterQua").val(rowData.TWaterQua).validatebox("validate");
				$("#cmbEquiDesc").combobox("setValue", rowData.TDecEquiId);
			}else{
				$('#txtInput').prop('disabled', true);
				$('#txtWaterQua').prop('disabled', true);
				$HUI.combobox("#cmbEquiDesc").disable();
			}
			if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) { 
				var prescNo = rowData.TPrescNo;
				DEC_PRINT.VIEW(ComPropData.decInfoId, {
					PrescNo: prescNo
				});
			}
		},
		onRowContextMenu:function(){
			return false;	
		}
	};
	PHA.Grid("gridScanPresc", dataGridOption);
}

/**
 * 初始化批量执行表格
 * @method InitGridBatPresc
 */
function InitGridBatPresc() {
	var columns = [
		[{
				field: 'gridPreSelect',
				checkbox: true
			}, {
				field: 'TPstCode',
				title: '当前代码',
				width: 60,
				align: 'left',
				hidden: 'true'
			}, {
				field: 'TPstDesc',
				title: '当前流程',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TPstDesc == "收方") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TPstDesc == "浸泡") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TPstDesc == "首煎") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TPstDesc == "二煎") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TPstDesc == "制膏") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TPstDesc == "打签") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TPstDesc == "发放") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TPstDesc == "送药") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TPrescNo',
				title: '处方号',
				width: 120,
				align: 'left'
			}, {
				field: 'TSoakInterval',
				title: '浸泡时长',
				align: 'left',
				width: 80,
				hidden: true,
				editor: {
					type: 'numberbox',
					options: {
						isKeyupChange: false,
						suffix: "分钟"
					}
				},
				formatter: function (value, row, index) {
					if (value != "") {
						return value.toString()+this.editor.options.suffix;
					}
				}
			}, {
				field: 'TDecInterval',
				title: '煎药时长',
				align: 'left',
				width: 80,
				hidden: true,
				editor: {
					type: 'numberbox',
					options: {
						isKeyupChange: false,
						suffix: "分钟"
					}
				},
				formatter: function (value, row, index) {
					if (value != "") {
						return value.toString()+this.editor.options.suffix;
					}
				}
			}, {
				field: 'TWaterQua',
				title: '加水量',
				align: 'left',
				width: 80,
				hidden: true,
				editor: {
					type: 'numberbox',
					options: {
						isKeyupChange: false,
						suffix: "ml"
					}
				},
				formatter: function (value, row, index) {
					if (value != "") {
						return value.toString()+this.editor.options.suffix;
					}
				}
			}, {
				field: 'TEquiId',
				title: '煎药设备id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TDecEqui',
				title: '煎药设备',
				align: 'left',
				width: 100,
				hidden: true,
				editor: {
					type: 'combogrid',
					options: {
						url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=GetEquiMai&DecLocId=' + gLocId,
						blurValidValue: true,
						panelWidth: 180,
						idField: 'Desc',
						textField: 'Desc',
						method: 'get',
						fitColumns: true,
						columns: [[{
									field: 'id',
									title: 'id',
									hidden: true
								}, {
									field: 'Code',
									title: '设备代码',
									align: 'center'
								}, {
									field: 'Desc',
									title: '设备描述',
									align: 'center'
								}
							]],
						onSelect: function(rowIndex, rowData){
							$("#gridBatPresc").datagrid("getRows")[NowRowId].TEquiId = rowData.id;
						}
					}
				}
			}, {
				field: 'TPreFacTor',
				title: '付数',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreCount',
				title: '味数',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				width: 80,
				align: 'left'
			}, {
				field: 'TPreEmFlag',
				title: '是否加急',
				width: 80,
				align: 'left'
			}, {
				field: 'TPhaLocDesc',
				title: '调剂科室',
				width: 120,
				align: 'left'
			}, {
				field: 'TOperUser',
				title: '当前流程操作人',
				width: 120,
				align: 'left'
			}, {
				field: 'TOperDate',
				title: '当前流程操作日期',
				width: 150,
				align: 'left'
			}, {
				field: 'TPatNo',
				title: '登记号',
				width: 100,
				align: 'left'
			}, {
				field: 'TPatName',
				title: '患者姓名',
				width: 100,
				align: 'left'
			}, {
				field: 'TDocLocDesc',
				title: '开单科室',
				width: 180,
				align: 'left'
			}, {
				field: 'TCookType',
				title: '煎药方式',
				width: 80,
				align: 'left'
			}, {
				field: 'TDecType',
				title: '煎药类型',
				width: 80,
				align: 'left'
			}, {
				field: 'TPdpmId',
				title: '煎药ID',
				align: 'left',
				width: 30,
				hidden: true
			}
		]
	];

	var dataGridOption = {
		url: '',
		fit: true,
		toolbar: '#gridBatPrescBar',
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ProExe.Query",
			QueryName: "BatExePre",
		},
		onLoadSuccess: function (data) {
			console.log(data)
			$('#gridBatPresc').datagrid('uncheckAll');
			var decPstDesc = $("#cmbDecState").combobox('getText');
			if (decPstDesc == "首煎") {
				$(this).datagrid('showColumn', 'TDecInterval');
				$(this).datagrid('showColumn', 'TWaterQua');
				$(this).datagrid('showColumn', 'TDecEqui');
				$(this).datagrid('hideColumn', 'TSoakInterval');
				$(this).datagrid('setColumnTitle', {
					'TDecInterval': '首煎时长',
					'TWaterQua': '首煎加水量',
					'TDecEqui': '首煎设备'
				});
			} else if (decPstDesc == "二煎") {
				$(this).datagrid('showColumn', 'TDecInterval');
				$(this).datagrid('showColumn', 'TWaterQua');
				$(this).datagrid('showColumn', 'TDecEqui');
				$(this).datagrid('hideColumn', 'TSoakInterval');
				$(this).datagrid('setColumnTitle', {
					'TDecInterval': '二煎时长',
					'TWaterQua': '二煎加水量',
					'TDecEqui': '二煎设备'
				});
			} else if (decPstDesc == "浸泡") {
				$(this).datagrid('hideColumn', 'TDecInterval');
				$(this).datagrid('hideColumn', 'TWaterQua');
				$(this).datagrid('hideColumn', 'TDecEqui');
				$(this).datagrid('showColumn', 'TSoakInterval');
			} else {
				$(this).datagrid('hideColumn', 'TDecInterval');
				$(this).datagrid('hideColumn', 'TWaterQua');
				$(this).datagrid('hideColumn', 'TDecEqui');
				$(this).datagrid('hideColumn', 'TSoakInterval');
			}
		},
		onSelect: function (rowIndex, rowData) {
			if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {
				var prescNo = rowData.TPrescNo;
				DEC_PRINT.VIEW(ComPropData.decInfoId, {
					PrescNo: prescNo
				});
			}
		},
		onClickCell: function (rowIndex, field, value) {
			NowRowId = rowIndex;
			var decPstDesc = $("#cmbDecState").combobox('getText');
			if ((decPstDesc != "浸泡") && (decPstDesc != "首煎") && (decPstDesc != "二煎")) {
				return false;
			}
			if (field == "TSoakInterval") {
				$(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
					editField: 'TSoakInterval'
				});
			} else if ((field == "TWaterQua") || (field == "TDecEqui") || (field == "TDecInterval")) {
				$(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
					editField: 'TDecInterval'
				});
			} else {
				$(this).datagrid('endEditing');
			}
		}
	};
	PHA.Grid("gridBatPresc", dataGridOption);
}

/**
 * 初始化批量执行查询表格
 * @method InitGridExePresc
 */
function InitGridExePresc() {
	var columns = [
		[{
				field: 'TPstDesc',
				title: '煎药流程',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TPstDesc == "收方") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TPstDesc == "浸泡") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TPstDesc == "首煎") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TPstDesc == "二煎") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TPstDesc == "制膏") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TPstDesc == "打签") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TPstDesc == "发放") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TPstDesc == "送药") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TOperUser',
				title: '操作人',
				width: 100,
				align: 'left'
			}, {
				field: 'TOperDate',
				title: '操作日期',
				width: 150,
				align: 'left'
			}, {
				field: 'TAdvDictDesc',
				title: '当前流程',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TAdvDictDesc == "收方") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TAdvDictDesc == "浸泡") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TAdvDictDesc == "首煎") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TAdvDictDesc == "二煎") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TAdvDictDesc == "制膏") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TAdvDictDesc == "打签") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TAdvDictDesc == "发放") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TAdvDictDesc == "送药") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TPatNo',
				title: '登记号',
				width: 100,
				align: 'left'
			}, {
				field: 'TPatName',
				title: '患者姓名',
				width: 100,
				align: 'left'
			}, {
				field: 'TDocLocDesc',
				title: '开方科室',
				width: 180,
				align: 'left'
			}, {
				field: 'TPhaLocDesc',
				title: '调剂科室',
				width: 120,
				align: 'left'
			}, {
				field: 'TPrescNo',
				title: '处方号',
				width: 120,
				align: 'left',
			}, {
				field: 'TPreFacTor',
				title: '付数',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreCount',
				title: '味数',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				width: 80,
				align: 'left'
			}, {
				field: 'TPreEmFlag',
				title: '是否加急',
				width: 80,
				align: 'left'
			}, {
				field: 'TCookType',
				title: '煎药方式',
				width: 80,
				align: 'left'
			}, {
				field: 'TDecType',
				title: '煎药类型',
				width: 80,
				align: 'left'
			}, {
				field: 'TPdpmId:',
				title: '煎药ID',
				align: 'left',
				width: 30,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ProExe.Query",
			QueryName: "AlrExePre",
		},
		onSelect: function (rowIndex, rowData) {
			if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {
				var prescNo = rowData.TPrescNo;
				DEC_PRINT.VIEW(ComPropData.decInfoId, {
					PrescNo: prescNo
				});
			}
		}
	};
	PHA.Grid("gridPrescExe", dataGridOption);
}

/**
 * 查询数据
 * @method Query
 */
function Query() {
	var params = GetParams();
	if (params == "") {
		return;
	}
	var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
	if (tabTitle == "批量执行") {
		$('#gridBatPresc').datagrid('query', {
			ParamStr: params
		});
	} else if (tabTitle == "已执行查询") {
		var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
		if (decLocId == "") {
			PHA.Popover({
				msg: "请先选择需要查询的煎药室！",
				type: 'alert'
			});
			return;
		}

		var decPstId = $("#cmbDecState").combobox('getValue');
		if (decPstId == "") {
			PHA.Popover({
				msg: "请先选择煎药流程！",
				type: 'alert'
			});
			return;
		};
		$('#gridPrescExe').datagrid('query', {
			ParamStr: params
		});
	} else {
		return;
	}
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	InitDict();
	$('#txtPatNo').val("");
	$('#gridScanPresc').datagrid('clear');
	$('#gridBatPresc').datagrid('clear');
	$('#gridPrescExe').datagrid('clear');
	if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {DEC_PRINT.VIEW(ComPropData.decInfoId, {});}
	InitSetDefVal();
}

/**
 * 获取界面元素值
 * @method GetParams
 */
function GetParams() {
	var stDate = $("#dateStart").datebox('getValue');
	var enDate = $("#dateEnd").datebox('getValue');
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var declocid = $('#cmbDecLoc').combobox("getValue") || "";
	var phalocid = $('#cmbPhaLoc').combobox("getValue") || "";		//调剂药房
	var type = $("input[name='busType']:checked").val() || "";
	var decPstId = $("#cmbDecState").combobox('getValue');
	//alert("decPstId:"+decPstId)
	if (decPstId == "") {
		PHA.Popover({
			msg: "请先选择煎药流程！",
			type: 'alert'
		});
		return;
	};
	var patNo = $.trim($("#txtPatNo").val());
	var doclocid = $('#cmbDocLoc').combobox("getValue") || "";		//开放科室
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + declocid + "^" + type + "^" + decPstId + "^" + patNo + "^" + phalocid + "^" + doclocid;
	return params;
}

/**
 * 扫描执行
 * @method ScanExecute
 */
function ScanExecute(barCode) {
	var barCode = barCode.trim();
	var decPstId = $("#cmbDecState").combobox('getValue');
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	var type = ($("input[name='busType']:checked").val() || "O").trim();
	if((barCode.indexOf("E")<0)&&(barCode.indexOf(type)<0)){
		var busType = type=="I"?"住院":"门诊";
		PHA.Popover({
			msg: "此处方与当前选择的类型不一致！当前类型为"+busType,
			type: 'alert'
		});
		return;
	}
	var inputStr = decPstId + "^" + decLocId;
	var jsonData = $.cm({
			ClassName: "PHA.DEC.ProExe.Query",
			MethodName: "GetBarCodeInfo",
			BarCode: barCode,
			InputStr: inputStr,
			dataType: 'json'
		}, false);
	var retCode = jsonData.retCode;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert'
		});
		return;
	} else {
		$.cm({
			ClassName: "PHA.DEC.ProExe.OperTab",
			MethodName: "Execute",
			PMId: jsonData.TPMId,
			PstId: decPstId,
			UserId: gUserID
		}, function (retData) {
			var retCode = retData.retCode;
			if (retCode < 0) {
				$.messager.alert('提示', retData.retMessage, 'warning');
			} else {
				PHA.Popover({
					msg: "执行成功！",
					type: 'success'
				})
				var jsonData = $.cm({
					ClassName: "PHA.DEC.ProExe.Query",
					MethodName: "GetPrescDecInfo",
					BarCode: barCode,
					InputStr: inputStr,
					dataType: 'json'
				}, false);
				$('#gridScanPresc').datagrid('insertRow', {
					index: 0,
					row: jsonData
				});
				Number = Number + 1; //增加行id顺序号
				$('#gridScanPresc').datagrid('selectRow', 0);
				var totalRows = $('#gridScanPresc').datagrid('getRows').length;
				if (totalRows > pageTbNum) { //超过设置的行数，每增加一条，就删除一条之前的数据
					if ((Number - pageTbNum) != 0) {
						$('#gridScanPresc').datagrid('deleteRow', pageTbNum);
					}
				}
			}
			$('#txtBarCode').focus();
		});
	}

}

/**
 * 批量保存执行记录
 * @method SaveBat
 */
function SaveBat() {
	var pdpmIdStr = GetCheckedPdIdArr();
	if (pdpmIdStr == "") {
		PHA.Popover({
			msg: "请勾选需要执行的处方！",
			type: 'alert'
		});
		return;
	}

	var decPstId = $("#cmbDecState").combobox('getValue');
	if (decPstId == "") {
		PHA.Popover({
			msg: "请先选择煎药流程！",
			type: 'alert'
		});
		return;
	};

	$.cm({
		ClassName: "PHA.DEC.ProExe.OperTab",
		MethodName: "SaveBatch",
		MultiDataStr: pdpmIdStr,
		PstId: decPstId,
		UserId: gUserID
	}, function (retData) {
		var retCode = retData.retCode;
		if (retCode < 0) {
			$.messager.alert('提示', retData.retMessage, 'warning');
		} else {
			PHA.Popover({
				msg: "执行成功！",
				type: 'success'
			});
			Query();
		}
	});
}

/**
 * 获取选中记录的明细的煎药主表ID串
 * @method SaveBat
 */
function GetCheckedPdIdArr() {
	var batPdIdArr = [];
	var gridBatPrescChecked = $('#gridBatPresc').datagrid('getChecked');
	for (var i = 0; i < gridBatPrescChecked.length; i++) {
		var checkedData = gridBatPrescChecked[i];
		var pdpmId = checkedData.TPdpmId;
		var dataStr = pdpmId;
		if (batPdIdArr.indexOf(dataStr) < 0) {
			batPdIdArr.push(dataStr);
		}
	}
	return batPdIdArr.join("!!");
}

/**
 * 扫码更新执行记录
 * @method SacnUpdate
 */
function SacnUpdate() {
	var row = $('#gridScanPresc').datagrid('getSelected');
	if ((row == null) || (row == "")) {
		$.messager.alert("提示", "请先选择需要更新的煎药记录！", "warning");
		return;
	}
	var pstDesc = row.TPstDesc		//流程代码
	var pdPmId = row.TPMId;
	if ((pdPmId == null) || (pdPmId == "")) {
		$.messager.alert("提示", "选择的煎药记录还未收方！", "warning");
		return;
	}
	
	var decEquId = $("#cmbEquiDesc").combobox('getValue');
	var decDesc = $("#cmbEquiDesc").combobox('getText');
	var waterQua = $('#txtWaterQua').val().trim();
	var stateInt = $('#txtInput').val().trim();
	if ((stateInt == null) || (stateInt == "")) {
		$.messager.alert("提示", "更新数据不允许为空！", "warning");
		return;
	}
	var upDataStr = pdPmId + "^" + stateInt + "^" + waterQua + "^" + decEquId + "^" + pstDesc;
	$.cm({
		ClassName: "PHA.DEC.ProExe.OperTab",
		MethodName: "ScanUpData",
		UpDataStr: upDataStr
	}, function (retData) {
		var retCode = retData.retCode;
		if (retCode < 0) {
			$.messager.alert('提示', retData.retMessage, 'warning');
		} else {
			PHA.Popover({
				msg: "更新成功！",
				type: 'success'
			});
			$('#gridScanPresc').datagrid('updateRow',{
				index: $('#gridScanPresc').datagrid('getRowIndex',row),
				row: {
					TInterval: parseInt(stateInt)||'',
					TWaterQua: parseInt(waterQua)||'',
					TDecEqui: decDesc,
					TDecEquiId:decEquId
				}
			});
		}
	});
}

/**
 * 批量更新执行记录
 * @method UpdateBat
 */
function UpdateBat() {
	$('#gridBatPresc').datagrid('endEditing');
	var gridChanges = $('#gridBatPresc').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("提示", "没有需要保存的数据", "info");
		return "";
	}
	var decPstDesc = $("#cmbDecState").combobox('getText');
	var updatastr = ""
		for (var j = 0; j < gridChangeLen; j++) {
			var rowData = gridChanges[j];
			var pdPmId = rowData.TPdpmId || "";
			var soakint = rowData.TSoakInterval || "";
			var decint = rowData.TDecInterval || "";
			var waterqua = rowData.TWaterQua || "";
			var equiId = rowData.TEquiId || "";
			var data = pdPmId + "^" + soakint + "^" + decint + "^" + waterqua + "^" + equiId + "^" + decPstDesc;
			if (updatastr == "") {
				updatastr = data;
			} else {
				updatastr = updatastr + "!!" + data
			}
		}
		if (updatastr == "") {
			$.messager.alert("提示", "没有需要保存的数据", "info");
			return "";
		}
		$m({
			ClassName: "PHA.DEC.ProExe.OperTab",
			MethodName: "SaveUpData",
			UpDataStr: updatastr
		}, function (retData) {
			var retArr = retData.split("^");
			if (retArr[0] < 0) {
				$.messager.alert('提示', retArr[1], 'warning');
				return;
			} else {
				PHA.Popover({
					msg: "更新成功！",
					type: 'success'
				})
				$('#gridBatPresc').datagrid('reload')
			}
		});
}
