function refreshData() {
	queryData();
}

// 查询
function queryData() {
	$('#oeordData').datagrid('loading');
	$('#checkPnl').html('');

	var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getOeordForGrd', episodeID, ssgroupID);
	ajaxGET(data, function (ret) {
		$('#oeordData').datagrid('loadData', $.parseJSON(ret).rows);
		$('#oeordData').datagrid('loaded');
	}, function (ret) {
		alert('getOeordForGrd error:' + ret);
	});
}

//设置数据
function setDataGrid() {
	$('#oeordData').datagrid({
		pageSize : 10,
		pageList : [10, 20, 30],
		loadMsg : '数据装载中......',
		autoRowHeight : true,
		rownumbers : true,
		pagination : false,
		//singleSelect : true,
		checkOnSelect : true,
		//selectOnCheck: true,
		fitColumns : true,
		fit : true,
		columns : [
			[{
					field : 'ck',
					checkbox : true
				}, {
					field : 'oeord',
					title : '医嘱内容',
					halign : 'center',
					width : 350
				}, {
					field : 'oeordType',
					title : '医嘱类型',
					halign : 'center',
					align : 'center',
					width : 0,
					hidden : true
				}
			]
		],
		view : groupview,
		groupField : 'oeordType',
		groupFormatter : function (value, rows) {
			var groupText = value + ' - ' + rows.length;
			var htmlStr = '<input id="' + value + '" type="checkbox">&nbsp' + groupText + '&nbsp&nbsp';
			$('#checkPnl').append(htmlStr);
			return groupText;
		}
	});

}

//引用数据
function getData() {

	var result = "";
	separate = "\n";
	var checkedItems = $('#oeordData').datagrid('getChecked');
	$.each(checkedItems, function (index, item) {
		result = result + item.oeord + separate;
	});

	var param = {
		"action" : "insertText",
		"text" : result
	};
	parent.eventDispatch(param);
	UnCheckAll();
}

//去掉选择
function UnCheckAll() {
	$("#oeordData").datagrid("uncheckAll");
}

function ReLoadLabInfo() {
	refreshData();
}

$(function () {
	$(':checkbox').live('change', function () {
		$('#oeordData').datagrid('loading');
		var stopFlag = false;
		var oeordType = $(this).attr('id');
		var checkFlag = $(this).is(':checked') ? 'checkRow' : 'uncheckRow';
		var rows = $('#oeordData').datagrid('getRows');

		for (var idx = 0; idx < rows.length; idx++) {
			if (rows[idx].oeordType === oeordType) {
				if (!stopFlag) {
					stopFlag = true;
				}
				$('#oeordData').datagrid(checkFlag, idx);
			} else if (stopFlag) {
				$('#oeordData').datagrid('loaded');
				return;
			}
		}
		$('#oeordData').datagrid('loaded');
	});
	setDataGrid();
	queryData();
	parent.HisTools.refreshOeOrdGrd = function () {
		refreshData();
	};
});
