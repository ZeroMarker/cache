/**
 * @author zw
 * @description 操作记录明细
 */
$(function() {
	var Global = {
	    ClassName: 'NurMp.Template.OperationLog',
	    MethodName: 'FindMultDetail'
	}
	/**
	* @description 初始化UI
	*/
	function initUI() {
		initGrid();
	}
	function initGrid() {
		$HUI.datagrid('#multDetaliGrid', {
			title: '明细',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true,
			url: $URL,
			queryParams:{
				ClassName: Global.ClassName,
				QueryName: Global.MethodName,
				Parr: multDataDr,
				OpID: OpId
			},
			columns: [[
				{field:'Oper', title:'操作', width: 40, formatter: operLinkform },
				{field:'OpDate', title:'操作日期', width:110},
				{field:'OpTime', title:'操作时间', width:70},
				{field:'OpType', title:'操作类型', width:70},
				{field:'OpUser', title:'操作人', width:100},
				{field:'OpPatName', title:'患者姓名', width:130},
				{field:'OpTemplate', title:'模板名称', width:200},
				{field:'CareDate', title:'日期', width:110},
				{field:'CareTime', title:'日期', width:80},
				{field:'RecUser', title:'操作人', width:130},
				{field:'RecCanDate', title:'作废日期', width:110},
				{field:'RecCanTime', title:'作废日期', width:80},
				{field:'RecCanUser', title:'作废护士', width:80},
				{field:'RowID', title:'RowID', width:50,hidden:true}
			]],
			singleSelect: true,
			pagination: true,
			pageSize: 10,
			pageList: [10, 30, 50, 100]
		});
	}
	
	function operLinkform(val, row, index) {
		var btns = '';
		btns = '<a class="btnCls icon-template" href="#" onclick=recordDialog(\'' + index + '\')></a>'
		return btns;
	}
	
	initUI();
})

function recordDialog(index) {
	var rows=$("#multDetaliGrid").datagrid('getRows'); 
	var rowData=rows[index];
	var url = rowData.TcIndent + ".csp?EpisodeID=" + EpisodeID + "&NurMPDataID=" + rowData.RowID + "&AuthorityFlag=" + 2;
	websys_showModal({
		url: url,
		title: rowData.OpTemplate,
		iconCls: 'icon-w-find'
	});	
}
