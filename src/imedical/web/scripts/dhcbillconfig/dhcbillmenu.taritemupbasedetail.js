/* 
 * FileName:	dhcbillmenu.taritemupbasedetail.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费项目基础信息修改日志明细
 * Description: 
*/

var UBIRowid="";
var PUBLIC_CONSTANTUBD={
	SESSION:{
		GROUP_ROWID : session['LOGON.GROUPID'],
        GROUP_DESC : session['LOGON.GROUPDESC'],
        GUSER_ROWID : session['LOGON.USERID'],
        GUSER_NAME : session['LOGON.USERNAME'],
        GUSER_CODE : session['LOGON.USERCODE']
	},
	URL:{
		QUERY_GRID_URL : "./dhcbill.query.grid.easyuiorder.csp",
		QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp",
		METHOD_URL : "./dhc.method.easyui.csp"
	},
	CATE:{
		UBDNUM : 1
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLFIND",
		QUERY : "FindUpBaseDetail"
	}
};

var lastIndex="";
var EditIndex=-1;	// 添加，修改，删除时记录修改行

function initGrid(){
	// 初始化Columns 
	var CateColumns = [[
		{ field: 'TUBDRowid', title: '表ID', width: 50, align: 'center', sortable: true,  hidden: true },
		{ field: 'TUBDItemDesc', title: '名称', width: 100, align: 'center', sortable: true },
		{ field: 'TUBDOldInfo', title: '原信息', width: 200, align: 'center', sortable: true },
		{ field: 'TUBDNewInfo', title: '新信息', width: 200, align: 'center', sortable: true },
		{ field: 'TFlag', title: 'TFlag', width: 100, align: 'center', sortable: true, hidden: true }	
	]];

	// 初始化DataGrid
	$('#tTarUBDDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : PUBLIC_CONSTANTUBD.URL.QUERY_GRID_URL,
		queryParams : {
			ClassName : PUBLIC_CONSTANTUBD.METHOD.CLS,
			QueryName : PUBLIC_CONSTANTUBD.METHOD.QUERY,
			Arg1 : UBIRowid,
			ArgCnt : PUBLIC_CONSTANTUBD.CATE.UBDNUM
		},
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [50,100,200],
		columns : CateColumns,
		rowStyler : function(index,row){
			if(row.TFlag=="1"){
				//return 'background-color:#6293BB;color:#fff;';
				return 'background-color:#FF6666;';
			}
		},
		onRowContextMenu : function(e, rowIndex, rowData){
		},
		onSelect : function(rowIndex, rowData){
		},
		onLoadSuccess:function(data){
			EditIndex=-1;
		}
	});
}

function initLoadGrid(UBIRowid)
{
	var ubdqueryParams = new Object();
	ubdqueryParams.ClassName = PUBLIC_CONSTANTUBD.METHOD.CLS;
	ubdqueryParams.QueryName = PUBLIC_CONSTANTUBD.METHOD.QUERY;
	ubdqueryParams.Arg1 = UBIRowid;
	ubdqueryParams.ArgCnt = PUBLIC_CONSTANTUBD.CATE.UBDNUM;
	loadDataGridStore("tTarUBDDetail", ubdqueryParams);
}

// 加载DataGrid数据
function loadDataGridStore(DataGridID, ubdqueryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANTUBD.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', ubdqueryParams);
}

$(function(){
	var selected = $('#tTarUBIDetail').datagrid('getSelected'); // 获取父窗体datagrid选择数据
	if(selected){UBIRowid=selected.TUBIRowid;}
	initGrid();
	setTimeout('initLoadGrid('+UBIRowid+')',10);
});

