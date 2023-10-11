/**
 * FileName: dhcbill.conf.page.opchgexcepiton.js
 * Anchor: ZhYW
 * Date: 2021-07-15
 * Description: 门诊收费异常处理页面配置
 */

$(function() {
	initUserList();
	
	var tableName = "Bill_OP_ChgException";
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
			loadUserList(newValue);
		}
	});
});

function initUserList() {	
	var toolbar = [{
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					_addClick();
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
	
	var _content = "<ul class='tip-class'><li style='font-weight:bold'>配置说明</li>" + 
		"<li>1、一般维护有收费权限的自助机、APP、科室医生</li>" +
		"<li>2、切忌维护收费员，收费员产生的异常应由其本人处理</li>" +
		"</ul>";
	$("#btn-tip").popover({
		trigger: 'hover',
		content: _content
	});
	GV.UserList = $HUI.datagrid("#userList", {
		fit: true,
		title: '收费员撤销非本人收费产生的异常人员设置',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		tools: '#dl-tools',
		toolbar: toolbar,
		columns: [[{title: 'ConfId', field: 'ConfId', hidden: true},
				   {title: '操作员', field: 'UserDesc', width: 200,
				    editor: {
							type: 'combobox',
							options: {
								panelHeight: 150,
								url: $URL + '?ClassName=web.DHCBillPageConf&QueryName=FindUserList&ResultSetType=array',
								required: true,
								method: 'get',
								valueField: 'id',
								textField: 'text',
								blurValidValue: true,
								defaultFilter: 5,
								onBeforeLoad: function (param) {
									param.hospId = getValueById("hospital");
								},
								onLoadSuccess: function() {
									$(this).next("span").find("input").focus();
								},
								onSelect: function(rec) {
									var row = GV.UserList.getRows()[GV.EditRowIndex];
									if (row) {
										row.UserId = rec.id;
									}
								},
								onChange: function(newValue, oldValue) {
									if (!newValue) {
										var row = GV.UserList.getRows()[GV.EditRowIndex];
										if (row) {
											row.UserId = "";
										}
									}
								}
							}
						}
				   },
				   {title: 'UserId', field: 'UserId', hidden: true}
			]],
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
		var ed = GV.UserList.getEditor({index: index, field: "UserDesc"});
		if (ed) {
			$(ed.target).combobox("setValue", row.UserId);
		}
	}
	
	function _onEndEditHandler(index, row) {
		var ed = GV.UserList.getEditor({index: index, field: "UserDesc"});
		if (ed) {
			row.UserDesc = $(ed.target).combobox("getText");
		}
	}
	
	/**
	* 保存
	*/
	var _saveClick = function () {
		var row = GV.UserList.getRows()[GV.EditRowIndex];
		if (!row) {
			return;
		}
		if (!_endEditing()) {
			return;
		}
		$.messager.confirm("确认", "确认保存?", function(r) {
			if (!r) {
				return;
			}
			var hospital = getValueById("hospital");
			var confAry = [];
			var myObj = {};
			myObj.PCSite = GV.Site;
			myObj.PCSiteDR = hospital;
			myObj.PCCode = GV.RolUsrCode + row.UserId;
			myObj.PCValue = 1;
			myObj.PCDesc = "撤销非本人收费产生的异常人员";
			confAry.push(JSON.stringify(myObj));
			
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "SaveConfInfo",
				pageId: GV.PageId,
				confList: confAry
			}, function(rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: "保存成功", type: "success"});
				}else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
				GV.UserList.reload();
			});
		});
	}

	/**
	* 新增
	*/
	var _addClick = function () {
		if (GV.EditRowIndex != undefined) {
			$.messager.popover({msg: "有正在编辑的行", type: "info"});
			return;
		}
		var row = {};
		$.each(GV.UserList.getColumnFields(), function (index, item) {
			row[item] = "";
		});
		GV.UserList.appendRow(row);
		GV.EditRowIndex = GV.UserList.getRows().length - 1;
		GV.UserList.beginEdit(GV.EditRowIndex);
		GV.UserList.selectRow(GV.EditRowIndex);
	}

	/**
	* 删除
	*/
	var _deleteClick = function () {
		var row = GV.UserList.getSelected();
		if (!row) {
			$.messager.popover({msg: "请选择需要删除的行", type: "info"});
			return;
		}
		if (!row.ConfId) {
			return;
		}
		$.messager.confirm("确认", "确认删除？", function(r) {
			if (!r) {
				return;
			}
			$.cm({
				ClassName: "web.DHCBillPageConf",
				MethodName: "Delete",
				idStr: row.ConfId
			}, function(rtn) {
				if (rtn.success == 0) {
					$.messager.popover({msg: rtn.msg, type: "success"});
					GV.UserList.reload();
				}else {
					$.messager.popover({msg: rtn.msg, type: "error"});
				}
			});
		});
	}

	/**
	* 取消编辑
	*/
	var _rejectClick = function () {
		GV.UserList.rejectChanges();
		GV.EditRowIndex = undefined;
	}

	var _endEditing = function () {
		if (GV.EditRowIndex == undefined) {
			return true;
		}
		if (GV.UserList.validateRow(GV.EditRowIndex)) {
			GV.UserList.endEdit(GV.EditRowIndex);
			GV.EditRowIndex = undefined;
			return true;
		}
		return false;
	}
}

function loadUserList(hospital) {
	var queryParams = {
		ClassName: "web.DHCBillPageConf",
		QueryName: "FindOPChgRolUsrCfgList",
		pageId: GV.PageId,
		site: GV.Site,
		code: GV.RolUsrCode,
		hospId: hospital
	}
	loadDataGridStore("userList", queryParams);
}