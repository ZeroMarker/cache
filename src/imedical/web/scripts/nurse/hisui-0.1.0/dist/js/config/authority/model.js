/*
 * @author: yaojining
 * @discription: 护理病历书写权限配置-模板
 * @date: 2020-04-30
 */
var GLOBAL = {
	ClassName: "NurMp.Service.Template.List",
	QueryName: "FindHospModels",
	ArrSelModel: []
};
var init = function () {
	initData();
}
$(init);

/**
 * 初始化数据
 */
function initData() {
	GLOBAL.ArrSelModel = !!Model ? Model.split("^") : [];
	$HUI.treegrid('#modelGrid',{
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Template.List",
			QueryName: "FindHospModels",
			HospitalID: HospitalID,
			LocID: Loc,
			page: 1,
			rows: 1000
		},
		columns: [[
			{field:'Name',title:'名称',width:480},
			{field:'Guid',title:'GUID',width:280,hidden:true},
			{field:'Id',title:'ID',width:70},
		]],
		idField:'Id',
		treeField:'Name',
		checkbox: true,
//		pagination: true,
//		pageSize: 12,
//		pageList: [12, 30, 50],
		onLoadSuccess: function(row, data) {
			if (GLOBAL.ArrSelModel.length > 0) {
				$.each(data.rows, function(index, row) {
					if ((!!row._parentId) && ($.inArray(row.Id, GLOBAL.ArrSelModel) > -1)) {
						$('#modelGrid').treegrid('checkNode', row.Id);
					}
				});
			}
		},
		onCheckNode: function(row, checked) {
			if (checked) {
				if (!!row._parentId) {
					if ($.inArray(row.Id, GLOBAL.ArrSelModel) < 0) {
						GLOBAL.ArrSelModel.push(row.Id);
					}
				} else {
					$.each(row.children, function(index, child) {
						if ($.inArray(child.Id, GLOBAL.ArrSelModel) < 0) {
							GLOBAL.ArrSelModel.push(child.Id);
						}
					});
				}
			} else {
				if (!!row._parentId) {
					if ($.inArray(row.Id, GLOBAL.ArrSelModel) > -1) {
						GLOBAL.ArrSelModel.splice(GLOBAL.ArrSelModel.indexOf(row.Id), 1);
					}
				} else {
					$.each(row.children, function(index, child) {
						if ($.inArray(child.Id, GLOBAL.ArrSelModel) > -1) {
							GLOBAL.ArrSelModel.splice(GLOBAL.ArrSelModel.indexOf(child.Id), 1);
						}
					});
				}
			}
		}
	});
}