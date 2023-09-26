/* 
 * FileName:	dhcbillcheck.showdata.js
 * User:		TangTao
 * Date:		2015-11-10
 * Function:	费用核查数据展示js
 * Description: 
*/

var PUBLIC_CONSTANT={
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
	}
};

function initGrid(){
	$('#tShowData').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		//loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [25,50,100,200],
		columns : Columns,
		toolbar: [{
			id:'MsgHandle',
			text:'处理',
			iconCls: 'icon-ok',
			handler: SendExec
		}],
		rowStyler : function(index,row){
			if(row.HJFlag=="1"){return 'background-color:#F2FEBF;';}
			if(row.HJFlag=="2"){return 'background-color:#E6FE80;';}
		},
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){
		},
		onSortColumn:function(sortColumn,sortOrder){
			initLoadGrid();
		}
	});
}

function initLoadGrid()
{
	var queryParams = new Object();
	if (Method[0].MenuParamNum == 0){
	}else if (Method[0].MenuParamNum == 1){
		queryParams.Arg1 = Method[0].MenuParam;
	}else if (Method[0].MenuParamNum > 1){
		for (i=1;i<=Method[0].MenuParamNum;i++){
			queryParams["Arg" + i] = Method[0].MenuParam.split(",")[i-1] ;
		}
	}
	queryParams.ClassName = Method[0].ClassName;
	queryParams.QueryName = Method[0].QueryName;
	queryParams.ArgCnt = Method[0].MenuParamNum;
	loadDataGridStore("tShowData", queryParams);
}

///加载DataGrid数据
function loadDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	opts.loadingMessage = '加载中,请稍后...';
	jQueryGridObj.datagrid('load', queryParams);
}

$(function(){
	initGrid();
	initLoadGrid();
});
