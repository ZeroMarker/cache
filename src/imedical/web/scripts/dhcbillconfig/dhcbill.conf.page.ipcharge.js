/**
 * FileName: dhcbill.conf.page.ipcharge.js
 * Anchor: ZhYW
 * Date: 2020-04-08
 * Description: 住院收费页面配置
 */﻿

$(function() {
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	$("#btn-TransPMList").popover({
		width: 410,
		height: 360,
		cache: false,
		arrow: false,
		placement: 'bottom',
		content: loadPopContent(),
		onShow: function() {
			initPopContent();
		}
	});
	
	var tableName = "Bill_IP_Charge";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 350,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.DelPayCode,
				siteId: newValue
			}, function (rtn) {
				setValueById("delPayMode", rtn);
			});
		}
	});
	
	$("#delPayMode").combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: '0', text: '押金回冲'},
			  {id: '1', text: '押金不回冲'}],
		onChange: function(newValue, oldValue) {
			if (newValue == "1") {
				$("#btn-TransPMList").removeClass("disabled").popover();
			}else {
				$("#btn-TransPMList").addClass("disabled").popover('destroy');
			}
		}
	});
});

function loadPopContent() {
	return "<div id=\"card-panel\" style=\"margin-bottom:10px;\">" +
			"	<table class=\"search-table\">" +
			"		<tr>" +
			"			<td class=\"r-label\"><label>不能回冲押金的支付方式</label></td>" +
			"			<td><input id=\"noTransPM\" class=\"textbox\"/></td>" +
			"		</tr>" +
			"	</table>" +
			"</div>" +
			"<table id=\"transPMList\"></table>";
}

function initPopContent() {
	$("#card-panel").panel({
		height: 52,
		bodyCls: 'panel-body-gray',
		onBeforeOpen: function () {
			//不能回冲押金的支付方式
			$("#noTransPM").combobox({
				panelHeight: 160,
				url: $URL + "?ClassName=web.DHCBillPageConf&QueryName=FindPayMode&ResultSetType=array",
				method: 'get',
				multiple: true,
				editable: false,
				rowStyle: 'checkbox',
				valueField: 'id',
				textField: 'desc',
				onLoadSuccess: function(data) {
					$.m({
						ClassName: "web.DHCBillPageConf",
						MethodName: "GetConfValue",
						pageId: GV.PageId,
						site: GV.Site,
						code: GV.NoTransPMCode,
						siteId: getValueById("hospital")
					}, function(rtn) {
						$("#noTransPM").combobox("setValues", (rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2) || []));
					});
				},
				onHidePanel: function() {
					//保存选择的支付方式
					var confAry = [];
					var myObj = {};
					myObj.PCSite = GV.Site;
					myObj.PCSiteDR = getValueById("hospital");
					myObj.PCCode = GV.NoTransPMCode;
					myObj.PCValue = $(this).combobox("getValues").join(PUBLIC_CONSTANT.SEPARATOR.CH2);
					myObj.PCDesc = "取消结算时不能回冲押金的支付方式";
					confAry.push(JSON.stringify(myObj));

					$.cm({
						ClassName: "web.DHCBillPageConf",
						MethodName: "SaveConfInfo",
						pageId: GV.PageId,
						confList: confAry
					}, function (rtn) {
						if (rtn != "0") {
							$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
						}
					});
				}
			});
		}
	});
	
	initTransPMList();
}

function initTransPMList() {
	var toolbar = [{
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					_addClick();
				}
			}, {
				text: '修改',
				iconCls: 'icon-write-order',
				handler: function() {
					_updateClick();
				}
			}, {
				text: '删除',
				iconCls: 'icon-cancel',
				handler: function() {
					_deleteClick();
				}
			}, {
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					_saveClick();
				}
			}, {
				text: '取消编辑',
				iconCls: 'icon-redo',
				handler: function() {
					_rejectClick();
				}
			}
		];
	GV.TransPMList = $HUI.datagrid("#transPMList", {
			height: $("#btn-TransPMList").popover("options").height - $("#card-panel").panel("options").height - 10,
			title: '支付方式与回冲支付方式对照',
			headerCls: 'panel-header-gray',
			iconCls: 'icon-compare',
			singleSelect: true,
			rownumbers: true,
			pageSize: 999999999,
			toolbar: toolbar,
			columns: [[{title: 'ConfId', field: 'ConfId', hidden: true},
			           {title: 'FrmPMID', field: 'FrmPMID', hidden: true},
					   {title: '支付方式', field: 'FrmPMDesc', width: 170,
						editor: {
							type: 'combobox',
							options: {
								panelHeight: 150,
								url: $URL + "?ClassName=web.DHCBillPageConf&QueryName=FindPayMode&ResultSetType=array",
								required: true,
								method: 'get',
								valueField: 'id',
								textField: 'desc',
								blurValidValue: true,
								onSelect: function(rec) {
									var row = GV.TransPMList.getRows()[GV.EditRowIndex];
									if (row) {
										row.FrmPMID = rec.id;
									}
								},
								onChange: function(newValue, oldValue) {
									if (!newValue) {
										var row = GV.TransPMList.getRows()[GV.EditRowIndex];
										if (row) {
											row.FrmPMID = "";
										}
									}
								}
							}
						}
					   },
					   {title: 'ToPMID', field: 'ToPMID', hidden: true},
					   {title: '回冲支付方式', field: 'ToPMPMDesc', width: 170,
					    editor: {
							type: 'combobox',
							options: {
								panelHeight: 150,
								url: $URL + "?ClassName=web.DHCBillPageConf&QueryName=FindPayMode&ResultSetType=array",
								required: true,
								method: 'get',
								valueField: 'id',
								textField: 'desc',
								blurValidValue: true,
								onSelect: function(rec) {
									var row = GV.TransPMList.getRows()[GV.EditRowIndex];
									if (row) {
										row.ToPMID = rec.id;
									}
								},
								onChange: function(newValue, oldValue) {
									if (!newValue) {
										var row = GV.TransPMList.getRows()[GV.EditRowIndex];
										if (row) {
											row.ToPMID = "";
										}
									}
								}
							}
						}
					}
				]],
			url: $URL,
			queryParams: {
				ClassName: "web.DHCBillPageConf",
				QueryName: "FindPMCfgList",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.TransPMCode,
				hospId: getValueById("hospital")
			},
			onLoadSuccess: function(data) {
				GV.EditRowIndex = undefined;
			},
			onBeginEdit: function(index, row) {
				_onBeginEditHandler(index, row);
	    	},
			onEndEdit: function(index, row, changes) {
				_onEndEditHandler(index, row);
			}
		});
		
	function _onBeginEditHandler(index, row) {
		var ed = GV.TransPMList.getEditor({index: index, field: "FrmPMDesc"});
		if (ed) {
			$(ed.target).combobox("setValue", row.FrmPMID);
		}
		var ed = GV.TransPMList.getEditor({index: index, field: "ToPMPMDesc"});
		if (ed) {
			$(ed.target).combobox("setValue", row.ToPMID);
		}
	}

	function _onEndEditHandler(index, row) {
		var ed = GV.TransPMList.getEditor({index: index, field: "FrmPMDesc"});
		if (ed) {
			row.FrmPMDesc = $(ed.target).combobox("getText");
		}
		var ed = GV.TransPMList.getEditor({index: index, field: "ToPMPMDesc"});
		if (ed) {
			row.ToPMPMDesc = $(ed.target).combobox("getText");
		}
	}
	
	/**
	* 保存
	*/
	function _saveClick() {
		if (!_checkData()) {
			return;
		}
		var row = GV.TransPMList.getRows()[GV.EditRowIndex];
		if (!row) {
			return;
		}
		if (!_endEditing()) {
			return;
		}
		var hospital = getValueById("hospital");
		
		$.messager.confirm("确认", "确认保存?", function(r) {
			if (r) {
				var confAry = [];
				var myObj = {};
				myObj.PCSite = GV.Site;
				myObj.PCSiteDR = hospital;
				myObj.PCCode = GV.TransPMCode + row.FrmPMID;
				myObj.PCValue = row.ToPMID;
				myObj.PCDesc = "取消结算时" + row.FrmPMDesc + "回冲" + row.ToPMPMDesc;
				confAry.push(JSON.stringify(myObj));
				
				$.cm({
					ClassName: "web.DHCBillPageConf",
					MethodName: "SaveConfInfo",
					pageId: GV.PageId,
					confList: confAry
				}, function (rtn) {
					if (rtn == "0") {
						$.messager.popover({msg: "保存成功", type: "success"});
					}else {
						$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
					}
					GV.TransPMList.reload();
				});
			}
		});
	}
	
	function _checkData() {
		var bool = true;
		$(".validatebox-text").each(function() {
			if (!$(this).validatebox("isValid")) {
				bool = false;
				return false;
			}
		});
		if (!bool) {
			return bool;
		}
		
		//重复性校验
		var hash = {};
		$.each(GV.TransPMList.getRows(), function(index, row) {
			if(hash[row.FrmPMID]) {
				$.messager.popover({msg: "支付方式重复", type: "info"});
				bool = false;
				return false;
			}
			hash[row.FrmPMID] = true;
		});
		
		return bool;
	}
	
	/**
	* 新增
	*/
	function _addClick() {
		if (GV.EditRowIndex != undefined) {
			$.messager.popover({msg: "有正在编辑的行", type: "info"});
			return;
		}
		var row = {};
		$.each(GV.TransPMList.getColumnFields(), function (index, item) {
			row[item] = "";
		});
		GV.TransPMList.appendRow(row);
		GV.EditRowIndex = GV.TransPMList.getRows().length - 1;
		GV.TransPMList.beginEdit(GV.EditRowIndex);
		GV.TransPMList.selectRow(GV.EditRowIndex);
	}

	/**
	* 删除
	*/
	function _deleteClick() {
		var row = GV.TransPMList.getSelected();
		if (!row) {
			$.messager.popover({msg: "请选择需要删除的行", type: "info"});
			return;
		}
		if (!row.ConfId) {
			return;
		}
		$.messager.confirm("确认", "确认删除？", function(r) {
			if (r) {
				$.cm({
					ClassName: "web.DHCBillPageConf",
					MethodName: "Delete",
					idStr: row.ConfId
				}, function(rtn) {
					$.messager.popover({msg: rtn.msg, type: ((rtn.success == "0") ? "success" : "error")});
					GV.TransPMList.reload();
				});
			}
		});
	}
	
	/**
	* 修改
	*/
	function _updateClick() {
		if (GV.EditRowIndex != undefined) {
			$.messager.popover({msg: "有正在编辑的行", type: "info"});
			return;
		}
		var row = GV.TransPMList.getSelected();
		if (!row) {
			$.messager.popover({msg: "请选择需要编辑的行", type: "info"});
			return;
		}
		
		GV.EditRowIndex = GV.TransPMList.getRowIndex(row);
		GV.TransPMList.beginEdit(GV.EditRowIndex);
	}
	
	/**
	* 取消编辑
	*/
	function _rejectClick() {
		GV.TransPMList.rejectChanges();
		GV.EditRowIndex = undefined;
	}

	function _endEditing() {
		if (GV.EditRowIndex == undefined) {
			return true;
		}
		if (GV.TransPMList.validateRow(GV.EditRowIndex)) {
			GV.TransPMList.endEdit(GV.EditRowIndex);
			GV.EditRowIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
}

/**
* 保存
*/
function saveClick() {
	if (!checkData()) {
		return;
	}
	var hospital = getValueById("hospital");
	$.messager.confirm("确认", "确认保存?", function(r) {
		if (r) {
			var confObj = {};
			confObj[GV.DelPayCode + "VAL"] = getValueById("delPayMode");
			confObj[GV.DelPayCode + "DESC"] = "取消结算原押金是否冲回";
			
			var confAry = [];
			$.each(GV.CodeStr.split("^"), function(index, item) {
				var myObj = {};
				myObj.PCSite = GV.Site;
				myObj.PCSiteDR = hospital;
				myObj.PCCode = item;
				myObj.PCValue = confObj[item + "VAL"];
				myObj.PCDesc = confObj[item + "DESC"];
				confAry.push(JSON.stringify(myObj));
			});
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "SaveConfInfo",
				pageId: GV.PageId,
				confList: confAry
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
				}else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}
