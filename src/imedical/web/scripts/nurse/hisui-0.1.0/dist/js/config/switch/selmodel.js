/*
 * @author: yaojining
 * @discription: 护理病历书写权限配置-模板
 * @date: 2020-04-30
 */
var GV = {
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
	GV.ArrSelModel = !!Model ? Model.split(",") : [];
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
			if (GV.ArrSelModel.length > 0) {
				$.each(data.rows, function(index, row) {
					if ((!!row._parentId) && ($.inArray(row.Id, GV.ArrSelModel) > -1)) {
						$('#modelGrid').treegrid('checkNode', row.Id);
					}
				});
			}
		},
		onCheckNode: function(row, checked) {
			if (checked) {
				if (!!row._parentId) {
					if ($.inArray(row.Id, GV.ArrSelModel) < 0) {
						GV.ArrSelModel.push(row.Id);
					}
				} else {
					$.each(row.children, function(index, child) {
						if ($.inArray(child.Id, GV.ArrSelModel) < 0) {
							GV.ArrSelModel.push(child.Id);
						}
					});
				}
			} else {
				if (!!row._parentId) {
					if ($.inArray(row.Id, GV.ArrSelModel) > -1) {
						GV.ArrSelModel.splice(GV.ArrSelModel.indexOf(row.Id), 1);
					}
				} else {
					$.each(row.children, function(index, child) {
						if ($.inArray(child.Id, GV.ArrSelModel) > -1) {
							GV.ArrSelModel.splice(GV.ArrSelModel.indexOf(child.Id), 1);
						}
					});
				}
			}
		}
	});
}