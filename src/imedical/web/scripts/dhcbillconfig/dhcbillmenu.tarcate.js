﻿/* 
 * FileName:	dhcbillmenu.tarcate.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费项目大类
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
		TARCATE : "CC", //收费项目大类
		TARSUBCATE : "SC", //收费项目子类
		SUBCATEINDEX : "TCC", //子类中指向大类的索引
		ARCNUM : 3, //参数个数
		TABLE : "TarCate" //表名称后半部分
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLSysType",
		QUERY : "FindTarCate",
		INSERT : "Insert",
		UPDATE : "Update",
		DELETE : "Delete"
	}
};

var lastIndex="",EditIndex=-1;

function initGrid(){
	// 初始化Columns
	var CateColumns = [[
		{ field: 'code', title: '项目代码', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'desc', title: '项目名称', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'job', title: 'job', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'rowid', title: '表ID', width: 50, align: 'center', sortable: true, resizable: true }
	]];
	
	/*
	// 初始化toolbar
	var CateToolBar = [{
		id:'BtnAdd',
		text:'添加',  
		iconCls:'icon-add',  
		handler:function(){  
			//$('#tTarCate').datagrid('endEdit', lastIndex);  
			lastIndex = $('#tTarCate').datagrid('getRows').length-1;  
			$('#tTarCate').datagrid('selectRow', lastIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			if (selected){
				if(typeof(selected.rowid) == "undefined"){
					$.messager.alert('消息',"不能同时添加多条!");
					return;
				}
			}
			if((EditIndex>=0)){
				$.messager.alert('消息',"一次只能修改一条记录!");
				return;
			}
			$('#tTarCate').datagrid('appendRow',{  
				code : '',  
				desc : ''
			});
			lastIndex = $('#tTarCate').datagrid('getRows').length-1;  
			$('#tTarCate').datagrid('selectRow', lastIndex);  
			$('#tTarCate').datagrid('beginEdit', lastIndex);
			EditIndex=lastIndex;
		}  
	},'-',{  
		id:'BtnSave',
		text:'保存',  
		iconCls:'icon-save',  
		handler:function(){
			$('#tTarCate').datagrid('acceptChanges');
			var selected = $('#tTarCate').datagrid('getSelected');
			if (selected){
				// selected.rowid为undefined，说明是新建项目，调用保存接口
				if(EditIndex==-1){
					$.messager.alert('消息',"数据未修改,无需保存!");
					return;
				}
				if(typeof(selected.rowid) == "undefined"){
					var CateStr=selected.code+"^"+selected.desc+"^"+"";
					if((typeof(selected.code) == "undefined") || (typeof(selected.desc) == "undefined")){
						$.messager.alert('消息',"数据为空,不允许添加!");
						EditIndex=-1;
						initLoadGrid("");
						return;
					}
					$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
						if(value=="0"){$.messager.alert('消息',"保存成功!");
						}else if(value=="-1001"){$.messager.alert('消息',"项目代码已存在,保存失败!");
						}else if(value=="-1002"){$.messager.alert('消息',"项目名称已存在,保存失败!");
						}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
						}
						EditIndex=-1;
						initLoadGrid("");
					},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
				}else{
					$('#tTarCate').datagrid('selectRow',EditIndex);
					var selected = $('#tTarCate').datagrid('getSelected');
					var CateStr=selected.rowid+"^"+selected.code+"^"+selected.desc+"^"+"";
					if((typeof(selected.code) == "undefined") || (typeof(selected.desc) == "undefined")){
						$.messager.alert('消息',"数据为空,不允许修改!");
						EditIndex=-1;
						initLoadGrid("");
						return;
					}
					$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.UPDATE,"false",function testget(value){
						if(value=="0"){$.messager.alert('消息',"修改成功!");
						}else if(value=="-1001"){$.messager.alert('消息',"项目代码重复,不能修改!");
						}else if(value=="-1002"){$.messager.alert('消息',"项目名称重复,不能修改!");
						}else{$.messager.alert('消息',"修改失败,错误代码:"+value);
						}
						EditIndex=-1;
						initLoadGrid("");
					},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
				}
			}
		}  
	},'-',{  
		id:'BtnUpdate',
		text:'修改',  
		iconCls:'icon-edit',  
		handler:function(){
			var selected = $('#tTarCate').datagrid('getSelected');
			if (selected){
				var thisIndex = $('#tTarCate').datagrid('getRowIndex',selected);
				if((EditIndex!=-1) && (EditIndex!=thisIndex)){
					$.messager.alert('消息',"一次只能修改一条记录!");
					return;
				}
				$('#tTarCate').datagrid('beginEdit', thisIndex);
				EditIndex=thisIndex;
			}
		}  
	},'-',{  
		id:'BtnDelete',
		text:'删除',  
		iconCls:'icon-remove',  
		handler:function(){
			$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
				if (r){
					var selected = $('#tTarCate').datagrid('getSelected');
					if (selected){
						if(typeof(selected.rowid) != "undefined"){
							var CateStr=selected.rowid+"^"+selected.code+"^"+selected.desc+"^"+"";
							$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.DELETE,"false",function testget(value){
								if(value == "0"){$.messager.alert('消息',"删除成功!");
								}else{$.messager.alert('消息',"删除失败,错误代码:"+value);
								}
								initLoadGrid("");
							},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
						}
					}
				}
			});
		}  
	},'-',{  
		id:'BtnFind',
		text:'查询',
		iconCls:'icon-search',  
		handler:function(){
			lastIndex="",EditIndex=-1;
			initLoadGrid("");
		}  
	}];	*/
	
	// 初始化DataGrid
	$('#tTarCate').datagrid({  
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
			Arg1 : '',	//项目代码
			Arg2 : '',	//项目名称
			Arg3 : PUBLIC_CONSTANT.CATE.TARCATE,	//大类
			ArgCnt : PUBLIC_CONSTANT.CATE.ARCNUM
		},
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [15,50,100,200],
		columns : CateColumns,
		toolbar : '#tToolBar',
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){
			EditIndex=-1;	
		},
		onSortColumn:function(sortColumn,sortOrder){
			initLoadGrid("");
		}
	});
}

function initLoadGrid(ExpStr)
{
	var SearchCode="",SearchDesc="";
	if(ExpStr != ""){
		SearchCode = ExpStr.split("^")[0];
		SearchDesc = ExpStr.split("^")[1];
	}
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
	queryParams.Arg1 = SearchCode;	//项目代码
	queryParams.Arg2 = SearchDesc;	//项目名称
	queryParams.Arg3 = PUBLIC_CONSTANT.CATE.TARCATE;	//收费项目大类
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.ARCNUM;
	loadDataGridStore("tTarCate", queryParams);
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
	// 如果在这里调用初始化Grid数据，Grid会加载两次，原因是在申明Grid的时候Url要赋空，这样相当于空调用了一次url，这里又调用一次
	//initLoadGrid("");
	if(BDPAutDisableFlag('BtnAdd')){
		$('#BtnAdd').hide();
	}
	if(BDPAutDisableFlag('BtnSave')){
		$('#BtnSave').hide();
	}
	if(BDPAutDisableFlag('BtnUpdate')){
		$('#BtnUpdate').hide();
	}
	if(BDPAutDisableFlag('BtnDelete')){
		$('#BtnDelete').hide();
	}
	BodyKeyDownInit();
});

$('#BtnAdd').bind('click', function(){
	//$('#tTarCate').datagrid('endEdit', lastIndex);  
	lastIndex = $('#tTarCate').datagrid('getRows').length-1;  
	$('#tTarCate').datagrid('selectRow', lastIndex);
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected){
		if(typeof(selected.rowid) == "undefined"){
			$.messager.alert('消息',"不能同时添加多条!");
			return;
		}
	}
	if((EditIndex>=0)){
		$.messager.alert('消息',"一次只能修改一条记录!");
		return;
	}
	$('#tTarCate').datagrid('appendRow',{  
		code : '',  
		desc : ''
	});
	lastIndex = $('#tTarCate').datagrid('getRows').length-1;  
	$('#tTarCate').datagrid('selectRow', lastIndex);  
	$('#tTarCate').datagrid('beginEdit', lastIndex);
	EditIndex=lastIndex;
});

$('#BtnUpdate').bind('click', function(){
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected){
		var thisIndex = $('#tTarCate').datagrid('getRowIndex',selected);
		if((EditIndex!=-1) && (EditIndex!=thisIndex)){
			$.messager.alert('消息',"一次只能修改一条记录!");
			return;
		}
		$('#tTarCate').datagrid('beginEdit', thisIndex);
		EditIndex=thisIndex;
	}
});

$('#BtnSave').bind('click', function(){
	$('#tTarCate').datagrid('acceptChanges');
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected){
		// selected.rowid为undefined，说明是新建项目，调用保存接口
		if(EditIndex==-1){
			$.messager.alert('消息',"数据未修改,无需保存!");
			return;
		}
		if(typeof(selected.rowid) == "undefined"){
			var CateStr=selected.code+"^"+selected.desc+"^"+"";
			if((typeof(selected.code) == "undefined") || (typeof(selected.desc) == "undefined")){
				$.messager.alert('消息',"数据为空,不允许添加!");
				EditIndex=-1;
				initLoadGrid("");
				return;
			}
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"保存成功!");
				}else if(value=="-1001"){$.messager.alert('消息',"项目代码已存在,保存失败!");
				}else if(value=="-1002"){$.messager.alert('消息',"项目名称已存在,保存失败!");
				}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
				}
				EditIndex=-1;
				initLoadGrid("");
			},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
		}else{
			$('#tTarCate').datagrid('selectRow',EditIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			var CateStr=selected.rowid+"^"+selected.code+"^"+selected.desc+"^"+"";
			if((typeof(selected.code) == "undefined") || (typeof(selected.desc) == "undefined")){
				$.messager.alert('消息',"数据为空,不允许修改!");
				EditIndex=-1;
				initLoadGrid("");
				return;
			}
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.UPDATE,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"修改成功!");
				}else if(value=="-1001"){$.messager.alert('消息',"项目代码重复,不能修改!");
				}else if(value=="-1002"){$.messager.alert('消息',"项目名称重复,不能修改!");
				}else{$.messager.alert('消息',"修改失败,错误代码:"+value);
				}
				EditIndex=-1;
				initLoadGrid("");
			},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
		}
	}
});

$('#BtnDelete').bind('click', function(){
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
		if (r){
			var selected = $('#tTarCate').datagrid('getSelected');
			if (selected){
				if(typeof(selected.rowid) != "undefined"){
					var CateStr=selected.rowid+"^"+selected.code+"^"+selected.desc+"^"+"";
					$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.DELETE,"false",function testget(value){
						if(value == "0"){$.messager.alert('消息',"删除成功!");
						}else{
							if(value=="-1001"){
								$.messager.alert('消息',"该分类已经被使用，不能删除:"+value);
							}else{
								$.messager.alert('消息',"删除失败,错误代码:"+value);
							}
						}
						initLoadGrid("");
					},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
				}
			}
		}
	});
});

///导出分类
function EportTar(){
 	if (!!window.ActiveXObject || "ActiveXObject" in window){
	}else{
 		alert("此导出只支持IE浏览器!");
		return;
	}
 	var job="";
	var rows = $('#tTarCate').datagrid('getRows').length;
	if(rows!=""){
		$('#tTarCate').datagrid('selectRow',0);
		var selected = $('#tTarCate').datagrid('getSelected');
		job = selected.job
	}
	if(job == ""){$.messager.alert('消息',"获取导出数据失败!");return;}
	//获取模板路径
	var path=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetPath");
	if(path==""){$.messager.alert('消息',"获取模板路径失败!");return;}
	var datanum=tkMakeServerCall("DHCBILLConfig.DHCBILLSysType","GetTarCateNum",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,PUBLIC_CONSTANT.CATE.TARCATE)
	if((datanum=="") || (datanum==0)){$.messager.alert('消息',"没有需要导出的分类!");return;}
	var datanum=eval(datanum)
	var Template=path+"ExportTarCate.xls"
	var xlApp = new ActiveXObject("Excel.Application");//不支持Google浏览器，只支持IE
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	xlApp.Visible=true;
	for ( i=1 ; i <= datanum ; i++){
		var value=tkMakeServerCall("DHCBILLConfig.DHCBILLSysType","GetTarCateData",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,PUBLIC_CONSTANT.CATE.TARCATE,i)
		var ValueStr=value.split("^");
		var Vlen=ValueStr.length;
		for(j = 0; j < Vlen; j++){
			xlsheet.cells(i+1,j+1).value=ValueStr[j];
		}
	}
	Grid(xlsheet,1,1,datanum,Vlen)
	//xlsheet.PrintPreview();
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlBook=null;
	xlsheet=null;
}
$('#BtnExport').bind('click', function(){
	EportTar();
});

$('#BtnFind').bind('click', function(){
		FindClick();
});

$('#tTBCodeText').keyup(function(){
	if(event.keyCode==13){
		FindClick();
	}
});

$('#tTBDescText').keyup(function(){
	if(event.keyCode==13){
		FindClick();
	}
});

function FindClick()
{
	lastIndex="",EditIndex=-1;
	var TBCode="",TBDesc="";
	if($("#tTBCodeText").get(0)){TBCode=$("#tTBCodeText").val();}
	if($("#tTBDescText").get(0)){TBDesc=$("#tTBDescText").val();}
	var Str=TBCode+"^"+TBDesc;
	initLoadGrid(Str);
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