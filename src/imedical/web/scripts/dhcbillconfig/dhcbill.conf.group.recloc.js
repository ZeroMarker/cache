/**
 * FileName: dhcbill.conf.group.recloc.js
 * Anchor: ZhYW
 * Date: 2019-10-24
 * Description: 接收科室设置
 */

$(function() {
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	$HUI.checkbox("#recLocFlag", {
		onCheckChange: function(e, value) {
			if (value) {
				$("#logonLoc").combobox("enable");
			}else {
				$("#logonLoc").combobox("clear").combobox("disable");
			}
		}
	});
	
	//登录科室
	$HUI.combobox("#logonLoc", {
		panelHeight: 150,
		url: $URL + "?ClassName=BILL.CFG.COM.GroupAuth&QueryName=ReadLoc&ResultSetType=array&hospId=" + GV.HospId,
		method: 'GET',
		valueField: 'id',
		textField: 'desc',
		disabled: true,
		selectOnNavigation: false,
		defaultFilter: 4,
		onChange: function(newValue, oldValue) {
			GV.RecLocList.load({
				ClassName: "BILL.CFG.COM.GroupAuth",
				QueryName: "ReadSelRecLocList",
				groupId: GV.GroupId,
				hospId: GV.HospId,
				logonLocId: newValue || "",
				rows: 99999999
			});
		}
	});

	//接收科室
	GV.RecLocList = $HUI.datagrid("#recLocList", {
		fit: true,
		border: false,
		rownumbers: false,
		pageSize: 999999999,
		loadMsg: '',
		columns: [[{field: 'ck', checkbox: true},
				   {title: 'id', field: 'id', hidden: true},
		           {title: 'code', field: 'code', hidden: true},
				   {title: '接收科室', field: 'desc', width: 280},
				   {title: 'rlRowId', field: 'rlRowId', hidden: true},
				   {title: 'selected', field: 'selected', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "ReadSelRecLocList",
			groupId: GV.GroupId,
			hospId: GV.HospId,
			logonLocId: getValueById("logonLoc"),
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				if (row.selected) {
					GV.RecLocList.checkRow(index);
				}
			});
		}
	});
	
	if (+GV.GSCfgJson.ID > 0) {
		setValueById("recLocFlag", (GV.GSCfgJson.GSRecLocFlag == "Y"));
	}
});

/**
* 保存
*/
function saveClick() {
	var recLocFlag = getValueById("recLocFlag") ? "Y" : "N";
	
	var rlAry = [];
	var str = "";
	$.each(GV.RecLocList.getChecked(), function(index, row) {
		str = row.id + "^" + row.rlRowId;
		rlAry.push(str);
	});
	var rlStr = rlAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	var logonLocId = getValueById("logonLoc");
	if (rlStr && !logonLocId) {
		$.messager.popover({msg: "请选择登录科室", type: "info"});
		return;
	}
	$.m({
		ClassName: "BILL.CFG.COM.GroupAuth",
		MethodName: "UpdateGSRL",
		groupId: GV.GroupId,
		hospId: GV.HospId,
		recLocFlag: recLocFlag,
		logonLocId: logonLocId,
		gsRLStr: rlStr
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.popover({msg: "保存成功", type: "success"});
		}else {
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
		}
	});
}