/* 
 * FileName:	dhcbillmenu.changepricegroup.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	调价安全组设置
 * Description: 
*/

var PUBLIC_CONSTANT={
	SESSION:{
		GROUP_ROWID : session['LOGON.GROUPID'],
        GROUP_DESC : session['LOGON.GROUPDESC'],
        GUSER_ROWID : session['LOGON.USERID'],
        GUSER_NAME : session['LOGON.USERNAME'],
        GUSER_CODE : session['LOGON.USERCODE'],
		HOSPID : session['LOGON.HOSPID']
	},
	URL:{
		QUERY_GRID_URL : "./dhcbill.query.grid.easyuiorder.csp",
		QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp",
		METHOD_URL : "./dhc.method.easyui.csp"
	},
	CATE:{
		TARCATE : "",
		TARSUBCATE : "",
		SUBCATEINDEX : "",
		ARCNUM : 0,
		TABLE : ""
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLOthConfig",
		QUERY : "FindChangGroup",
		INSERT : "InsertComGrp",
		UPDATE : "",
		DELETE : ""
	}
};

$(function(){
	initGrid();
	if(BDPAutDisableFlag('BtnAdd')){
		$('#BtnAdd').hide();
	}
	if(BDPAutDisableFlag('BtnDelete')){
		$('#BtnDelete').hide();
	}
});

var lastIndex="",EditIndex=-1;

function initGrid(){
	// 初始化Columns
	var CateColumns = [[
		{ field: 'TGrpDesc', title: '安全组', width: 300, align: 'center', editor : 'text', sortable: true, resizable: true},
		{ field: 'TGrpRowid', title: 'TGrpRowid', width: 100, align: 'center', sortable: true, resizable: true, hidden: true }
	]];

	// 初始化DataGrid
	$('#tChangeGroup').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		queryParams : {
			ClassName : PUBLIC_CONSTANT.METHOD.CLS,
			QueryName : PUBLIC_CONSTANT.METHOD.QUERY,
			ArgCnt : PUBLIC_CONSTANT.CATE.ARCNUM
		},
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns : CateColumns,
		toolbar : '#tToolBar',
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){
			EditIndex=-1;	
		}
	});
}

function initLoadGrid()
{
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.ARCNUM;
	loadDataGridStore("tChangeGroup", queryParams);
}

///加载DataGrid数据
function loadDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

$('#BtnAdd').bind('click', function(){
	var GrpStr = $('#tGroup').combobox('getValues');
	if(GrpStr==""){
		$.messager.alert('消息',"安全组为空,不能添加!");
		return;
	}
	var GrpStr="\""+GrpStr+"\"";
	$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
		if(value=="0"){$.messager.alert('消息',"保存成功!");
		}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
		}
		initLoadGrid();
		$('#tGroup').combobox('clear');
	},"","",GrpStr,PUBLIC_CONSTANT.SESSION.GUSER_ROWID,PUBLIC_CONSTANT.SESSION.HOSPID,"Insert");
});

$('#BtnDelete').bind('click', function(){
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
		if (r){
			var selected = $('#tChangeGroup').datagrid('getSelected');
			var GrpStr=selected.TGrpRowid;
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"删除成功!");
				}else{$.messager.alert('消息',"删除失败,错误代码:"+value);
				}
				initLoadGrid();
				$('#tGroup').combobox('clear');
			},"","",GrpStr,PUBLIC_CONSTANT.SESSION.GUSER_ROWID,PUBLIC_CONSTANT.SESSION.HOSPID,"Delete");
		}
	});
});

$('#BtnFind').bind('click', function(){
	EditIndex=-1;
	initLoadGrid();
});

function Test(){
	//$("<div id='tCateToolBar' style='margin-top:6px'><span >安全组：</span><input id='tGroup' class='easyui-combobox' style='width:200px' /></div>").appendTo('.datagrid-toolbar table tbody tr');
	//$('#tCateToolBar').appendTo('.datagrid-toolbar table tbody tr');
	//$('.datagrid-toolbar table tbody tr').append(tCateToolBar);
	//var oldHtml=$('.datagrid-toolbar table tbody tr').html();
	//var oldHtml=oldHtml+"<td><div id='tCateToolBar'><span >安全组：</span><input id='tGroup' class='easyui-combobox' style='width:200px' /></div></td>"
	//$('.datagrid-toolbar table tbody tr').html(oldHtml);
}