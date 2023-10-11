/*
 * @author: yaojining
 * @discription: 护理病历书写权限配置-科室
 * @date: 2020-04-30
 */
var GLOBAL = {
	ClassName: "NurMp.Service.Template.Authority",
	QueryName: "FindAuthLoc",
	ArrSelLoc: [],
	ArrRecLoc: []
};
var init = function () {
	initData();
	listenEvent();
}
$(init);

/**
 * 初始化数据
 */
function initData() {
	GLOBAL.ArrSelLoc = !!Loc ? Loc.split("^") : [];
	GLOBAL.ArrRecLoc = [].concat(GLOBAL.ArrSelLoc);
	$HUI.combobox('#statecombo', {
		valueField: 'id',
		textField: 'text',
		value: "A",
		data:[
			{id:"A", text:"全部"},
			{id:"L", text:"已限制"},
			{id:"U", text:"未限制"}
		], 
		defaultFilter:4,
		onSelect: function(record){
			$("#btnSearch").click();
		}
	});
	$HUI.datagrid('#locGrid', {
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: GLOBAL.QueryName,
			HospitalID: HospitalID,
			ConfigTableName: ConfigTableName,
			Status: $("#statecombo").combobox("getValue"),
			SearchDesc: $('#searchbox').searchbox('getValue'),
			SearchIds: "^" + Loc + "^"
		},
		columns: [[
			{field:'Checkbox',title:'sel',checkbox:true},
			{field:'LocDesc',title:'名称',width:250},
			{field:'HospDesc',title:'院区',width:240},
		]],
		idField: "LocId",
		pagination: true,
		pageSize: 10,
		pageList: [10, 30, 50],
		onLoadSuccess: function(data) {
			// $('#locGrid').datagrid('clearChecked');
			if (GLOBAL.ArrRecLoc.length > 0) {
				$.each(data.rows, function(index, row) {
					if ($.inArray(row.LocId, GLOBAL.ArrRecLoc) > -1) {
						$('#locGrid').datagrid('selectRow', index);
					}
				});
			}
		},
		onSelect: function(rowIndex, rowData) {
			if ($.inArray(rowData.LocId, GLOBAL.ArrSelLoc) < 0) {
				GLOBAL.ArrSelLoc.push(rowData.LocId);
				GLOBAL.ArrSelLoc.sort(function(a, b){
					return a-b;
				});
			}
		},
		onUnselect: function(rowIndex, rowData) {
			GLOBAL.ArrSelLoc.splice(GLOBAL.ArrSelLoc.indexOf(rowData.LocId), 1)
		},
		onSelectAll: function(rows) {
			$.each(rows, function(index, row) {
				if ($.inArray(row.LocId, GLOBAL.ArrSelLoc) < 0) {
					GLOBAL.ArrSelLoc.push(row.LocId);
				}
			});
			GLOBAL.ArrSelLoc.sort(function(a, b){
				return a-b;
			});
		},
		onUnselectAll: function(rows) {
			$.each(rows, function(index, row) {
				GLOBAL.ArrSelLoc.splice(GLOBAL.ArrSelLoc.indexOf(row.LocId), 1);
			});
		}
	});
}
/**
 * 监听
 */
function listenEvent() {
	$('#searchbox').searchbox("textbox").keydown(function(e) {
		if (e.keyCode == 13) {
			$("#btnSearch").click();
		}
	});
	$('.searchbox-button').bind('click', function(){
		$('#btnSearch').click();
	});
	$('#btnSearch').click(function(e) {
		$('#locGrid').datagrid('reload',{
			ClassName: GLOBAL.ClassName,
			QueryName: GLOBAL.QueryName,
			HospitalID: HospitalID,
			ConfigTableName: ConfigTableName,
			Status: $("#statecombo").combobox("getValue"),
			SearchDesc: $('#searchbox').searchbox('getValue'),
			SearchIds: "^" + Loc + "^"
		});	
	});
}