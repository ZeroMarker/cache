/* 
 * FileName:	dhcbillcheck.menuservice.js
 * User:		TangTao
 * Date:		2015-11-10
 * Function:	费用核查菜单维护
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
	},
	CATE:{
		EPARCNUM : 1
	},
	METHOD:{
		CLS : "web.DHCBillMenu",
		QUERY : "FindCheckMenu",
		INSERT : "InsertMenu",
		UPDATE : "UpdateMenu",
		DELETE : "DeleteMenu"
	}
};

var lastIndex="",EditIndex=-1;

function initGrid(){
	// 初始化Columns
	var MenuType = [  
		{id:'foldermenu',name:'父菜单'},
		{id:'childmenu',name:'子菜单'}
	]; 

	var CateColumns = [[
		{ field: 'DHCBTText', title: '菜单名称', align: 'left', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'DHCBTHref', title: '菜单CSP', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'DHCBTMenuTypeDesc', title: '菜单类型', width: 60, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',
				options:{
					valueField:'id',
					textField:'name',
					data:MenuType,
					required:true,
					onSelect:function(rec){
						if(rec.id == "foldermenu"){
							rec
						}
					}
				}
			}
		},
		{ field: 'DHCBTParentText', title: '从属菜单', width: 60, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',  
				options:{
					url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'Rowid',
					textField:'DHCBTText',
					required:true,
					onBeforeLoad:function(param){
						param.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
						param.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
						param.Arg1 = "main^foldermenu";
						param.ArgCnt = PUBLIC_CONSTANT.CATE.EPARCNUM;
					}
				}
			}
		},
		{ field: 'DHCBTClassName', title: '类名称', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox'}
		},
		{ field: 'DHCBTMethodName', title: '方法名称', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox'}
		},
		{ field: 'DHCBTParam', title: '固定入参(多个逗号分隔,参数为空也需要用逗号分隔)', width: 100, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox'}
		},
		{ field: 'DHCBTParamNum', title: '入参个数', width: 100, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox'}
		},
		{ field: 'Rowid', title: '表ID', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'DHCBTParentNode', title: 'DHCBTParentNode', width: 100, align: 'center', sortable: true, resizable: true,hidden: true},
		{ field: 'DHCBTMenuType', title: 'DHCBTMenuType', width: 100, align: 'center', sortable: true, resizable: true,hidden: true}
	]];
	
	// 初始化DataGrid
	$('#tMenuService').datagrid({  
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
			Arg1 : "",
			ArgCnt : PUBLIC_CONSTANT.CATE.EPARCNUM
		},
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [50,100,200],
		columns : CateColumns,
		toolbar : '#tToolBar',
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
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
	queryParams.Arg1 = "";
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.EPARCNUM;
	loadDataGridStore("tMenuService", queryParams);
}

///加载DataGrid数据
function loadDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

$(function(){
	initGrid();
	BodyKeyDownInit();
});

$('#BtnAdd').bind('click', function(){
	//$('#tMenuService').datagrid('endEdit', lastIndex);  
	lastIndex = $('#tMenuService').datagrid('getRows').length-1;  
	$('#tMenuService').datagrid('selectRow', lastIndex);
	var selected = $('#tMenuService').datagrid('getSelected');
	if (selected){
		if(typeof(selected.Rowid) == "undefined"){
			$.messager.alert('消息',"不能同时添加多条!");
			return;
		}
	}
	if((EditIndex>=0)){
		$.messager.alert('消息',"一次只能修改一条记录!");
		return;
	}

	$('#tMenuService').datagrid('appendRow',{  
		DHCBTText : '',  
		DHCBTHref : '',  
		DHCBTMenuTypeDesc : '',  
		DHCBTParentText : '',  
		DHCBTClassName : '',  
		DHCBTMethodName : '',
		DHCBTParam : '',  
		DHCBTParamNum : ''
	});
	lastIndex = $('#tMenuService').datagrid('getRows').length-1;  
	$('#tMenuService').datagrid('selectRow', lastIndex);  
	$('#tMenuService').datagrid('beginEdit', lastIndex);
	EditIndex=lastIndex;
});

$('#BtnUpdate').bind('click', function(){
	var selected = $('#tMenuService').datagrid('getSelected');
	if (selected){
		var thisIndex = $('#tMenuService').datagrid('getRowIndex',selected);
		if(selected.DHCBTParentNode=="0"){
			$.messager.alert('消息',"主菜单不允许修改!");
			return;
		}
		if(selected.DHCBTText=="菜单维护"){
			$.messager.alert('消息',"菜单维护不允许修改!");
			return;
		}
		if(selected.DHCBTMenuType=="foldermenu"){
			$.messager.alert('消息',"父菜单请谨慎修改!");
		}
		if((EditIndex!=-1) && (EditIndex!=thisIndex)){
			$.messager.alert('消息',"一次只能修改一条记录!");
			return;
		}
		$('#tMenuService').datagrid('beginEdit', thisIndex);
		EditIndex=thisIndex;
		var selected = $('#tMenuService').datagrid('getSelected');
		var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParentText'});
		$(thisEd.target).combobox('select',selected.DHCBTParentNode);
		var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTMenuTypeDesc'});
		$(thisEd.target).combobox('select',selected.DHCBTMenuType);
	}
});

$('#BtnSave').bind('click', function(){
	//$('#tMenuService').datagrid('acceptChanges');
	$('#tMenuService').datagrid('selectRow', EditIndex);
	var selected = $('#tMenuService').datagrid('getSelected');
	if (selected){
		// selected.Rowid为undefined，说明是新建项目，调用保存接口
		if(EditIndex==-1){
			$.messager.alert('消息',"数据未修改,无需保存!");
			return;
		}
		if(typeof(selected.Rowid) == "undefined"){
			var selected = $('#tMenuService').datagrid('getSelected');
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTMenuTypeDesc'});
			var menuDHCBTMenuTypeDesc = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParentText'});
			var menuDHCBTParentText = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTText'});
			var menuDHCBTText = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTHref'});
			var menuDHCBTHref = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTClassName'});
			var menuDHCBTClassName = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTMethodName'});
			var menuDHCBTMethodName = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParam'});
			var menuDHCBTParam = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParamNum'});
			var menuDHCBTParamNum = $(thisEd.target).val();
			var CateStr=""+"^"+menuDHCBTText+"^"+menuDHCBTHref+"^"+menuDHCBTMenuTypeDesc+"^"+menuDHCBTParentText;
			CateStr=CateStr+"^"+menuDHCBTClassName+"^"+menuDHCBTMethodName+"^"+menuDHCBTParam+"^"+menuDHCBTParamNum;
			if((menuDHCBTText == "") || (menuDHCBTHref == "")){
				$.messager.alert('消息',"数据为空,不允许添加!");
				EditIndex=-1;
				initLoadGrid();
				return;
			}
			if((menuDHCBTParentText == "") || (menuDHCBTMenuTypeDesc == "")){
				$.messager.alert('消息',"数据为空,不允许添加!");
				EditIndex=-1;
				initLoadGrid();
				return;
			}
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"保存成功!");
				}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
				}
				EditIndex=-1;
				initLoadGrid();
			},"","",CateStr);
		}else{
			$('#tMenuService').datagrid('selectRow',EditIndex);
			var selected = $('#tMenuService').datagrid('getSelected');
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTMenuTypeDesc'});
			var menuDHCBTMenuTypeDesc = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParentText'});
			var menuDHCBTParentText = $(thisEd.target).combobox('getValue');
			var menuRowid = selected.Rowid;
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTText'});
			var menuDHCBTText = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTHref'});
			var menuDHCBTHref = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTClassName'});
			var menuDHCBTClassName = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTMethodName'});
			var menuDHCBTMethodName = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParam'});
			var menuDHCBTParam = $(thisEd.target).val();
			var thisEd = $('#tMenuService').datagrid('getEditor', {index:EditIndex,field:'DHCBTParamNum'});
			var menuDHCBTParamNum = $(thisEd.target).val();
			var CateStr=menuRowid+"^"+menuDHCBTText+"^"+menuDHCBTHref+"^"+menuDHCBTMenuTypeDesc+"^"+menuDHCBTParentText;
			CateStr=CateStr+"^"+menuDHCBTClassName+"^"+menuDHCBTMethodName+"^"+menuDHCBTParam+"^"+menuDHCBTParamNum;
			if((menuDHCBTText == "") || (menuDHCBTHref == "")){
				$.messager.alert('消息',"数据为空,不允许修改!");
				EditIndex=-1;
				initLoadGrid();
				return;
			}
			if((menuDHCBTParentText == "") || (menuDHCBTMenuTypeDesc == "")){
				$.messager.alert('消息',"数据为空,不允许修改!");
				EditIndex=-1;
				initLoadGrid();
				return;
			}
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.UPDATE,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"修改成功!");
				}else if(value=="-1001"){$.messager.alert('消息',"没有修改内容,无需修改!");
				}else{$.messager.alert('消息',"修改失败,错误代码:"+value);
				}
				EditIndex=-1;
				initLoadGrid();
			},"","",CateStr);
		}
	}
});

$('#BtnDelete').bind('click', function(){
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
		if (r){
			var selected = $('#tMenuService').datagrid('getSelected');
			if (selected){
				if(typeof(selected.Rowid) != "undefined"){
					var CateStr=selected.Rowid;
					$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.DELETE,"false",function testget(value){
						if(value == "0"){$.messager.alert('消息',"删除成功!");
						}else{$.messager.alert('消息',"删除失败,错误代码:"+value);
						}
						initLoadGrid();
					},"","",CateStr);
				}
			}
		}
	});
});

$('#BtnFind').bind('click', function(){
		FindClick();
});

function FindClick()
{
	EditIndex=-1;
	initLoadGrid();
}

function BodyKeyDownInit()
{
	$(document).keydown(function(e){
		if(e.which == 113) {
			if(EditIndex>=0){return;}
			if(!BDPAutDisableFlag('BtnAdd')){
				$('#BtnAdd').trigger("click");
			}
		}
		if(e.which == 115) {
			if(EditIndex>=0){return;}
			if(!BDPAutDisableFlag('BtnUpdate')){
				$('#BtnUpdate').trigger("click");
			}
		}
		if(e.which == 117) {
			if(!BDPAutDisableFlag('BtnSave')){
				$('#BtnSave').trigger("click");
			}
		}
		if(e.which == 118) {
			if(!BDPAutDisableFlag('BtnDelete')){
				$('#BtnDelete').trigger("click");
			}
		}
		if(e.which == 119) {
			$('#BtnFind').trigger("click");
		}
	});
}