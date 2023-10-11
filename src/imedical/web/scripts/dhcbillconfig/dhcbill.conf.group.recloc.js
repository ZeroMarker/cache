/**
 * FileName: dhcbill.conf.group.recloc.js
 * Author: ZhYW
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
		url: $URL + "?ClassName=BILL.CFG.COM.GroupAuth&QueryName=ReadLoc&ResultSetType=array&hospId=" + CV.HospId,
		method: 'GET',
		valueField: 'id',
		textField: 'desc',
		disabled: true,
		selectOnNavigation: false,
		defaultFilter: 5,
		onChange: function(newValue, oldValue) {
			GV.RecLocList.load({
				ClassName: "BILL.CFG.COM.GroupAuth",
				QueryName: "ReadSelRecLocList",
				groupId: CV.GroupId,
				hospId: CV.HospId,
				logonLocId: newValue || "",
				rows: 99999999
			});
		}
	});

	//接收科室
	GV.RecLocList = $HUI.datagrid("#recLocList", {
		fit: true,
		border: false,
		rownumbers: true,
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
			groupId: CV.GroupId,
			hospId: CV.HospId,
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
	
	if (CV.GSCfgJson.ID > 0) {
		setValueById("recLocFlag", (CV.GSCfgJson.GSRecLocFlag == "Y"));
	}
});

/**
* 保存
*/
function saveClick() {
	var rlStr = GV.RecLocList.getChecked().map(function(row) {
		return row.id + "^" + row.rlRowId;
	}).join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	var logonLocId = getValueById("logonLoc");
	if (rlStr && !logonLocId) {
		$.messager.popover({msg: "请选择登录科室", type: "info"});
		return;
	}
	var recLocFlag = getValueById("recLocFlag") ? "Y" : "N";
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		var rtn = $.m({
			ClassName: "BILL.CFG.COM.GroupAuth",
			MethodName: "UpdateGSRL",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			recLocFlag: recLocFlag,
			logonLocId: logonLocId,
			gsRLStr: rlStr
		}, false);
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			$.messager.popover({msg: "保存成功", type: "success"});
			return;
		}
		$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
	});
}