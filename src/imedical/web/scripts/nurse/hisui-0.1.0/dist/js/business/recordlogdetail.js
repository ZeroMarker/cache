/**
 * @author zw
 * @description ������¼��ϸ
 */
$(function() {
	var Global = {
	    ClassName: 'NurMp.Template.OperationLog',
	    MethodName: 'FindMultDetail'
	}
	/**
	* @description ��ʼ��UI
	*/
	function initUI() {
		initGrid();
	}
	function initGrid() {
		$HUI.datagrid('#multDetaliGrid', {
			title: '��ϸ',
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
				{field:'Oper', title:'����', width: 40, formatter: operLinkform },
				{field:'OpDate', title:'��������', width:110},
				{field:'OpTime', title:'����ʱ��', width:70},
				{field:'OpType', title:'��������', width:70},
				{field:'OpUser', title:'������', width:100},
				{field:'OpPatName', title:'��������', width:130},
				{field:'OpTemplate', title:'ģ������', width:200},
				{field:'CareDate', title:'����', width:110},
				{field:'CareTime', title:'����', width:80},
				{field:'RecUser', title:'������', width:130},
				{field:'RecCanDate', title:'��������', width:110},
				{field:'RecCanTime', title:'��������', width:80},
				{field:'RecCanUser', title:'���ϻ�ʿ', width:80},
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
