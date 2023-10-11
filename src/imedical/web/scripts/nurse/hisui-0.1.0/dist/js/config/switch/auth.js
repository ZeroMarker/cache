/*
 * @Descripttion: ҳ�����
 * @Author: yaojining
 */
/*
 * @Descripttion: ������Ȩ��ϸ��ѯ
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
 * @description ������Ȩ�б�
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
			{ field: 'Desc', title: '����', width: 600 },
			{ field: 'UpdateDateTime', title: '����ʱ��', width: 200 },
			{ field: 'Id', title: 'ID', width: 70, hidden:true },
			{ field: 'IsCurrent', title: '��ǰ����', width: 120, align: 'center', hidden:true },
			{ field: 'Opration', title: '����', width: 50, align: 'center', formatter: formatOp },
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
 * @description: ����¼�
 */
function onGridDbClick(rowIndex, rowData) {
	parent.comboSetValue(rowData);
	parent.closeWin();
}
/**
* @description: ��ʽ��
*/
function formatOp(value, row, index) {
    var iconCls = 'grid-cell-icon icon-cancel';
    return '<span href="#" class="' + iconCls + '" onclick="removeAuth(\'' + row.Id + '\')">&nbsp&nbsp&nbsp&nbsp</span>'
}
/**
* @description: �Ƴ�Ȩ��
*/
function removeAuth(id) {
	if (!id) {
		return;
	}
	$.messager.confirm('��ʾ', 'ȷ��Ҫ�Ƴ���Ȩ����', function(r){
		if (r) {
			$cm({
				ClassName: 'NurMp.Service.Switch.Config',
				MethodName: 'RemoveOneAuth',
				ID: id,
				Page: Page
			},function(result){
				if (result.status >= 0) {
					$('#gridAuth').datagrid('reload');
					parent.findCommon();  // ˢ�º���ʾͨ��
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
