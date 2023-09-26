/**
 * FileName: dhcbill.conf.hosp.kpi.js
 * Anchor: ZhYW
 * Date: 2019-10-23
 * Description: 指标授权
 */

var GV = {};

$(function () {
	initMenu();
	initTreegrid();
});

function initMenu() {
	var tableName = "Bill_Com_KPI";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$('#hospital').combobox({
		panelHeight: 150,
		width: 300,
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
			loadTreegrid();
		}
	});
}

function initTreegrid() {
	var toolbar = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				saveClick();
			}
		}
	];
    GV.Treegrid = $HUI.treegrid("#treegrid", {
        fit: true,
        bodyCls: 'panel-body-gray',
        idField: 'id',
        treeField: 'title',
        checkbox: true,
        pageSize: 999999999,
        loadMsg: '',
        toolbar: toolbar,
        columns: [[{title: 'id', field: 'id', hidden: true},
        		   {title: '指标名称', field: 'title', width: 360},
        		   {title: 'kpiId', field: 'kpiId', hidden: true}
            ]]
    });
}

function loadTreegrid() {
	var queryParams = {
        ClassName: "BILL.CFG.COM.HospAuth",
        QueryName: "FindHospKPI",
        hospId: getValueById("hospital"),
        rows: 99999999
    }
    loadTreeGridStore("treegrid", queryParams);
}

function saveClick() {
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (r) {
			var myAry = [];
			$.each(GV.Treegrid.getCheckedNodes("checked"), function (index, row) {
				if (row.kpiId) {
					var myKPIId = row.kpiId;
					myAry.push(myKPIId);
				}
			});
			var kpiIdStr = myAry.join("^");
			$.m({
				ClassName: "BILL.CFG.COM.HospAuth",
				MethodName: "SaveHospKPI",
				hospId: getValueById("hospital"),
				kpiIdStr: kpiIdStr
			}, function (rtn) {
				if (rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
				}else {
					$.messager.popover({msg: "保存失败", type: "error"});
				}
			});
		}
	});
}
