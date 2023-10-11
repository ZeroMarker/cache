/**
 * FileName: dhcbill.conf.group.ipbillmenu.js
 * Author: ZhYW
 * Date: 2019-03-18
 * Description: 住院收费菜单配置
 */

GV.ColumnAry = [{field: 'ck', title: 'ck', checkbox: true},
		 		{field: 'JBMCode', title: '代码', width: 120},
	     		{field: 'JBMDesc', title: '描述', width: 120},
		 		{field: 'JBMIconCls', title: '图标', width: 100},
		 		{field: 'JBMHandler', title: '关联事件', width: 100},
	     		{field: 'JBMActiveFlag', title: '是否启用',width: 80,
		 		 formatter: function (value, row, index) {
					return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
				 }
		 		},
			    {field: 'JBMSequence', title: '顺序号', width: 70},
			    {field: 'rowId', title: 'ID', hidden: true},
			    {field: 'Select', title: 'Select', hidden: true},
			    {field: 'JBMParrefDr', title: 'Parref', hidden: true},
			    {field: 'JBMNodeLevel', title: 'Level', hidden: true}];

$(function () {
	$("#btn-save").linkbutton({
		onClick: function () {
			saveClick();
		}
	});
	
	//工具菜单
	GV.ToolMenuList = $HUI.datagrid("#toolMenuList", {
		fit: true,
		border: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		singleSelect: true,
		fitColumns: true,
		loadMsg: '',
		toolbar: [{
					iconCls: 'icon-add',
					text: '新增',
					handler: function () {
						saveHandler("IPBILLTool", "");
					}
				}, {
					iconCls: 'icon-write-order',
					text: '修改',
					disabled: true,
					id: 'editToolMenu',
					handler: function () {
						var row = GV.ToolMenuList.getSelected();
						if (row) {
							saveHandler("IPBILLTool", row);
						}
					}
				}
			],
		pageSize: 999999999,
		columns: [GV.ColumnAry],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "GetMenuList",
			code: "IPBILLTool",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			rows: 99999999
		},
		onLoadSuccess: function (data) {
			$.each(data.rows, function (index, row) {
				if (row.Select == 1) {
					GV.ToolMenuList.checkRow(index);
				}
			});
		},
		onSelect: function (rowIndex, rowData) {
			GV.ToolMenuList.getPanel().find("#editToolMenu").linkbutton("enable");
		},
		onDblClickRow: function (rowIndex, rowData) {
			saveHandler("IPBILLTool", rowData);
		}
	});
	
	//右键菜单
	GV.RightMenuList = $HUI.datagrid("#rightMenuList", {
		fit: true,
		border: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		singleSelect: true,
		fitColumns: true,
		loadMsg: '',
		toolbar: [{
					iconCls: 'icon-add',
					text: '新增',
					handler: function () {
						saveHandler("IPBILLRighty", "");
					}
				}, {
					iconCls: 'icon-write-order',
					text: '修改',
					disabled: true,
					id: 'editRightMenu',
					handler: function () {
						var row = GV.RightMenuList.getSelected();
						if (row) {
							saveHandler("IPBILLRighty", row);
						}
					}
				}
			],
		pageSize: 999999999,
		columns: [GV.ColumnAry],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "GetMenuList",
			code: "IPBILLRighty",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			rows: 99999999
		},
		onLoadSuccess: function (data) {
			$.each(data.rows, function (index, row) {
				if(row.Select == 1) {
					GV.RightMenuList.checkRow(index);
				}
			});
		},
		onSelect: function (rowIndex, rowData) {
			GV.RightMenuList.getPanel().find("#editRightMenu").linkbutton("enable");
		},
		onDblClickRow: function (rowIndex, rowData) {
			saveHandler("IPBILLRighty", rowData);
		}
	});
});

/**
* 保存
*/
function saveHandler(code, row) {
	var rowId = "";
	var menuCode = "";
	var menuDesc = "";
	var menuIcon = "";
	var menuHandler = "";
	var menuActive = "";
	var parrefInfo = tkMakeServerCall("BILL.CFG.COM.GroupAuth", "GetMenuInfo", "", code);
	var parrefAry = parrefInfo.split("^");
	var parref = parrefAry[1];
	var page = parrefAry[4];
	var target = parrefAry[5];
	var nodeLevel = 1 + parseInt(parrefAry[8]);
	var sequence = "";
	var dlgIconCls = "icon-w-add";
	var dlgTitle = "新增" + ((code == "IPBILLTool") ? "<span style='margin-left:10px;'>工具菜单</span>" : "<span style='margin-left:10px;'>右键菜单</span>");
	if (row) {
		parref = row.JBMParrefDr;
		rowId = row.rowId;
		menuCode = row.JBMCode;
		menuDesc = row.JBMDesc;
		menuIcon = row.JBMIconCls;
		menuHandler = row.JBMHandler;
		menuActive = row.JBMActiveFlag;
		nodeLevel = row.JBMNodeLevel;
		page = row.JBMPage;
		target = row.JBMTarget;
		sequence = row.JBMSequence;
		dlgIconCls = "icon-w-edit";
		dlgTitle = "修改" + ((code == "IPBILLTool") ? "<span style='margin-left:10px;'>工具菜单</span>" : "<span style='margin-left:10px;'>右键菜单</span>");
	}

	$("#menuDlg").show();
	var menuDlgObj = $HUI.dialog("#menuDlg", {
			iconCls: dlgIconCls,
			title: dlgTitle,
			draggable: false,
			resizable: true,
			modal: true,
			buttons: [{
					text: "保存",
					handler: function () {
						var bool = true;
						$(".validatebox-text").each(function(index, item) {
							if (!$(this).validatebox("isValid")) {
								$.messager.popover({msg: "<font color='red'>" + $(this).parent().prev().text() + "</font>" + "验证不通过", type: "info"});
								bool = false;
								return false;
							}
						});
						if (!bool) {
							return;
						}
						$.messager.confirm("确认", "确认保存？", function(r) {
							if (!r) {
								return;
							}
							var menuInfo = rowId + "^" + getValueById("menuCode") + "^" + getValueById("menuDesc") + "^" + ($("#menuActive").switchbox("getValue") ? "Y" : "N");
							menuInfo += "^" + parref + "^" + nodeLevel + "^" + page + "^" + target + "^" + getValueById("menuSequenceNo");
							menuInfo += "^" + getValueById("menuIcon") + "^" + getValueById("menuHandler");
							$.m({
								ClassName: "BILL.CFG.COM.GroupAuth",
								MethodName: "SaveMenu",
								menuInfo: menuInfo
							}, function (rtn) {
								var myAry = rtn.split("^");
								if (myAry[0] == 0) {
									$.messager.popover({msg: "保存成功", type: "success"});
									menuDlgObj.close();
									if (code == "IPBILLTool") {
										GV.ToolMenuList.reload();
									}else {
										GV.RightMenuList.reload();
									}
									return;
								}
								$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
							});
						});
					}
				}, {
					text: '关闭',
					handler: function () {
						menuDlgObj.close();
					}
				}
			],
			onBeforeOpen: function() {
				setValueById("menuCode", menuCode);
				setValueById("menuDesc", menuDesc);
				setValueById("menuIcon", menuIcon);
				setValueById("menuHandler", menuHandler);
				setValueById("menuSequenceNo", sequence);
				$("#menuActive").switchbox("setValue", ((!menuActive) || (menuActive == "Y")));

				$.extend($.fn.validatebox.defaults.rules, {
					checkCodeExist: {    //校验代码是否存在
					    validator: function(value) {
						    return $.m({ClassName: "BILL.CFG.COM.GroupAuth", MethodName: "CheckCodeExist", id: rowId, code: $.trim(value)}, false) == 0;
						},
						message: "菜单代码已存在"
					},
					checkSequenceNoExist: {    //校验顺序号是否存在
					    validator: function(value) {
						    if (sequence == value) {
							    return true;
							}
							var bool = true;
						    var gridObj = (code == "IPBILLTool") ? GV.ToolMenuList : GV.RightMenuList;
						    $.each(gridObj.getRows(), function (index, row) {
							    if (row.JBMSequence && (row.JBMSequence == value)) {
								    bool = false;
								    return false;
								}
							});
							return bool;
						},
						message: "顺序号已存在"
					}
				});
			}
		});
}

/**
* 授权
*/
function saveClick() {
	var menuAry = [];
	//工具菜单
	$.each(GV.ToolMenuList.getChecked(), function (index, row) {
		menuAry.push(row.rowId);
	});
	
	//右键菜单
	$.each(GV.RightMenuList.getChecked(), function (index, row) {
		menuAry.push(row.rowId);
	});
	if (menuAry.length == 0) {
		$.messager.popover({msg: "请选择需授权菜单", type: "info"});
		return;
	}
	var menuStr = menuAry.join("^");
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "BILL.CFG.COM.GroupAuth",
			MethodName: "GrantMenu",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			menuStr: menuStr
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				GV.ToolMenuList.reload();
				GV.RightMenuList.reload();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}