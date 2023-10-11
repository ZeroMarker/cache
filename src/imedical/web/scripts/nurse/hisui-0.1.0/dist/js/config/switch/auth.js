/*
 * @Descripttion: 页面介绍
 * @Author: yaojining
 */
/*
 * @Descripttion: 配置授权明细查询
 * @Author: yaojining
 */
var GLOBAL = {
	ClassName: 'NurMp.Service.Switch.Config'
};

function initUI() {
	loadAuthGrid();
}
$(initUI);

/**
 * @description 加载授权列表
 */
function loadAuthGrid() {
	$('#gridAuth').datagrid({
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: 'FindAuthList',
			HospitalID: HospitalID,
			CurrentInfo: GroupID + '^' + LocID + '^' + ModelID,
			Page: Page
		},
		columns: [[
			{ field: 'Desc', title: '名称', width: 600 },
			{ field: 'UpdateDateTime', title: '更新时间', width: 200 },
			{ field: 'Id', title: 'ID', width: 70, hidden:true },
			{ field: 'IsCurrent', title: '当前配置', width: 120, align: 'center', hidden:true },
			{ field: 'Opration', title: '操作', width: 50, align: 'center', formatter: formatOp },
		]],
		idField: 'Id',
		rownumbers: true,
		singleSelect: true,
		rowStyler: function (rowIndex, rowData) {
			if (rowData.IsCurrent == 'Y') {
				$('#gridAuth').datagrid('selectRow', rowIndex);
				return false;
			}
			if (rowData.Group == '0') {
				return 'color:gray';
			}
		},
		onLoadSuccess: function(data) {
			
		},
		onDblClickRow: onGridDbClick
	});
}
/**
 * @description: 点击事件
 */
function onGridDbClick(rowIndex, rowData) {
	parent.comboSetValue(rowData);
	parent.closeWin();
}
/**
* @description: 格式化
*/
function formatOp(value, row, index) {
    var iconCls = 'grid-cell-icon icon-cancel';
    return '<span href="#" class="' + iconCls + '" onclick="removeAuth(\'' + row.Id + '\')">&nbsp&nbsp&nbsp&nbsp</span>'
}
/**
* @description: 移除权限
*/
function removeAuth(id) {
	if (!id) {
		return;
	}
	$.messager.confirm('提示', '确定要移除该权限吗？', function(r){
		if (r) {
			$cm({
				ClassName: 'NurMp.Service.Switch.Config',
				MethodName: 'RemoveOneAuth',
				ID: id,
				Page: Page
			},function(result){
				if (result.status >= 0) {
					$('#gridAuth').datagrid('reload');
					parent.findCommon();  // 刷新后显示通用
                    $.messager.popover({ msg: result.msg, type: "success" });
                    
                } else {
                    $.messager.popover({ msg: result.msg, type: "error" });
                    return;
                }
			});
		} else {
			return;
		}
	});
}
