/* 
 * FileName:	dhcbillmenu.taritemalias.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费项目别名
 * Description: 
*/
var TarRowid="";
var WINPUBLIC_CONSTANT={
	WINSESSION:{
		WINGROUP_ROWID : session['LOGON.GROUPID'],
        WINGROUP_DESC : session['LOGON.GROUPDESC'],
        WINGUSER_ROWID : session['LOGON.USERID'],
        WINGUSER_NAME : session['LOGON.USERNAME'],
        WINGUSER_CODE : session['LOGON.USERCODE'],
		WINHOSPID : session['LOGON.HOSPID']
	},
	WINURL:{
		WINQUERY_GRID_URL : "./dhcbill.query.grid.easyuiorder.csp",
		WINQUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp",
		WINMETHOD_URL : "./dhc.method.easyui.csp"
	},
	WINALIAS:{
		WINTARCATE : "",
		WINTARSUBCATE : "",
		WINSUBCATEINDEX : "",
		WINARCNUM : 1,	//query input num
		WINTABLE : ""
	},
	WINMETHOD:{
		WINCLS : "DHCBILLConfig.DHCBILLFIND",
		WINQUERY : "FindTarAlias",
		WININSERT : "InsertAlias",
		WINUPDATE : "UpdateAlias",
		WINDELETE : "DeleteAlias"
	}
};

$(function(){
	var selected = $('#tTarCate').datagrid('getSelected'); // 获取父窗体datagrid选择数据
	if(selected){TarRowid=selected.rowid;}
	initwinAliasGrid();
	setTimeout('initwinLoadAliasGrid('+TarRowid+')',10);
	if(BDPAutDisableFlag('winAliasAdd')){
		$('#winAliasAdd').hide();
	}
	if(BDPAutDisableFlag('winAliasUpdate')){
		$('#winAliasUpdate').hide();
	}
	if(BDPAutDisableFlag('winAliasDel')){
		$('#winAliasDel').hide();
	}
	if(BDPAutDisableFlag('winAliasSave')){
		$('#winAliasSave').hide();
	}
});

var winAliasEditIndex=-1;	//获取修改列

function initwinAliasGrid(){
	// 初始化Columns
	var winAliasColumns = [[
		{ field: 'TIAAlias', title: '别名', width: 309, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'TarRowid', title: '收费项ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'TIADESC', title: '收费项名称', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'TIARowId', title: 'TIARowId', width: 50, align: 'center', sortable: true, resizable: true, hidden: true }
	]];

	// 初始化DataGrid
	$('#wintTarAlias').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : '',
		loadMsg : '加载中,请稍后...',  
		//pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		//pageList : [15,50,100,200],
		columns : winAliasColumns,
		toolbar : '#wintAliasToolBar',
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){
			winAliasEditIndex=-1;	
		}
	});
}

function initwinLoadAliasGrid(TarRowid)
{
	var queryParams = new Object();
	queryParams.ClassName = WINPUBLIC_CONSTANT.WINMETHOD.WINCLS;
	queryParams.QueryName = WINPUBLIC_CONSTANT.WINMETHOD.WINQUERY;
	queryParams.Arg1 = TarRowid;	//项目代码
	queryParams.ArgCnt = WINPUBLIC_CONSTANT.WINALIAS.WINARCNUM;
	loadwinAliasGridStore("wintTarAlias", queryParams);
}

///加载DataGrid数据
function loadwinAliasGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = WINPUBLIC_CONSTANT.WINURL.WINQUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

$('#winAliasAdd').bind('click', function(){
	if(TarRowid==""){
		$.messager.alert('消息',"收费项目ID为空,不能添加别名,请先添加收费项目!");
		return;
	}
	lastIndex = $('#wintTarAlias').datagrid('getRows').length-1;  
	$('#wintTarAlias').datagrid('selectRow', lastIndex);
	var selected = $('#wintTarAlias').datagrid('getSelected');
	if (selected){
		if((selected.TIARowId == "")||(selected.TIARowId == "undefined")||(typeof(selected.TIARowId) == "undefined")){
			$.messager.alert('消息',"不能同时添加多条!");
			return;
		}
	}
	if((winAliasEditIndex>=0)){
		$.messager.alert('消息',"一次只能修改一条记录!");
		return;
	}
	$('#wintTarAlias').datagrid('appendRow',{
		TIAAlias : ''
	});
	lastIndex = $('#wintTarAlias').datagrid('getRows').length-1;
	$('#wintTarAlias').datagrid('selectRow', lastIndex);
	$('#wintTarAlias').datagrid('beginEdit', lastIndex);
	winAliasEditIndex = lastIndex;
});

$('#winAliasUpdate').bind('click', function(){
	var selected = $('#wintTarAlias').datagrid('getSelected');
	if (selected){
		var thisIndex = $('#wintTarAlias').datagrid('getRowIndex',selected);
		if((winAliasEditIndex!=-1) && (winAliasEditIndex!=thisIndex)){
			$.messager.alert('消息',"一次只能修改一条记录!");
			return;
		}
		$('#wintTarAlias').datagrid('beginEdit', thisIndex);
		winAliasEditIndex=thisIndex;
	}
});

$('#winAliasSave').bind('click', function(){
	$('#wintTarAlias').datagrid('acceptChanges');
	$('#wintTarAlias').datagrid('selectRow',winAliasEditIndex);
	var selected = $('#wintTarAlias').datagrid('getSelected');
	if (selected){
		// selected.rowid为undefined，说明是新建项目，调用保存接口
		if((selected.TIARowId == "")||(selected.TIARowId == "undefined")||(typeof(selected.TIARowId) == "undefined")){
			if((typeof(selected.TIAAlias) == "undefined") || (typeof(selected.TIAAlias) == "")){
				$.messager.alert('消息',"数据为空,不允许添加!");
				winAliasEditIndex=-1;
				initwinLoadAliasGrid(TarRowid);
				return;
			}
			$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WININSERT,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"保存成功!");
				}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
				}
				winAliasEditIndex=-1;
				initwinLoadAliasGrid(TarRowid);
			},"","",selected.TIAAlias,TarRowid,WINPUBLIC_CONSTANT.WINSESSION.WINGUSER_ROWID,WINPUBLIC_CONSTANT.WINSESSION.WINHOSPID);
		}else{
			if((typeof(selected.TIAAlias) == "undefined") || (typeof(selected.TIAAlias) == "")){
				$.messager.alert('消息',"数据为空,不允许修改!");
				winAliasEditIndex=-1;
				initLoadGrid("");
				return;
			}
			$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WINUPDATE,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"修改成功!");
				}else{$.messager.alert('消息',"修改失败,错误代码:"+value);
				}
				winAliasEditIndex=-1;
				initwinLoadAliasGrid(TarRowid);
			},"","",selected.TIARowId,selected.TIAAlias,WINPUBLIC_CONSTANT.WINSESSION.WINGUSER_ROWID,WINPUBLIC_CONSTANT.WINSESSION.WINHOSPID);
		}
	}
});

$('#winAliasDel').bind('click', function(){
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
		if (r){
			var selected = $('#wintTarAlias').datagrid('getSelected');
			if (selected){
				if(typeof(selected.TIARowId) != "undefined"){
					$.dhc.util.runServerMethod(WINPUBLIC_CONSTANT.WINMETHOD.WINCLS,WINPUBLIC_CONSTANT.WINMETHOD.WINDELETE,"false",function testget(value){
						if(value == "0"){$.messager.alert('消息',"删除成功!");
						}else{$.messager.alert('消息',"删除失败,错误代码:"+value);
						}
						winAliasEditIndex=-1;
						initwinLoadAliasGrid(TarRowid);
					},"","",selected.TIARowId,WINPUBLIC_CONSTANT.WINSESSION.WINGUSER_ROWID,WINPUBLIC_CONSTANT.WINSESSION.WINHOSPID);
				}
			}
		}
	});
});

$('#winAlias').bind('click', function(){
	winAliasEditIndex=-1;
	initwinLoadAliasGrid(TarRowid);
});
