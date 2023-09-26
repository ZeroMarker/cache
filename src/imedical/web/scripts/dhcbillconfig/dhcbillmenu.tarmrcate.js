/* 
 * FileName:	dhcbillmenu.tarmrcate.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费病案子类
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
		TARCATE : "TMC", //收费病案大类
		TARSUBCATE : "MC", //收费病案子类
		SUBCATEINDEX : "TMC", //子类中指向大类的索引
		ARCNUM : 3, //大类参数个数
		ARCSUBNUM : 6, //子类参数个数
		TABLE : "TarMRCate" //表名称后半部分
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLSysType",
		QUERY : "FindTarSubCate",	// grid查询子类时的query
		QUERYTAR : "FindTarCate",	// combobox查询大类时的query
		INSERT : "Insert",
		UPDATE : "Update",
		DELETE : "Delete"
	}
};

var lastIndex="";
var EditIndex=-1;	// 添加，修改，删除时记录修改行

function initGrid(){
	// 初始化Columns
	var CateColumns = [[
		{ field: 'code', title: '项目代码', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'desc', title: '项目名称', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'tarcatedr', title: '收费病案大类', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',  
				options:{
					url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					//valueField:'rowid',
					valueField:'desc',
					textField:'desc',
					required:true,
					onBeforeLoad:function(param){
						param.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
						param.QueryName = PUBLIC_CONSTANT.METHOD.QUERYTAR;
						param.Arg1 = "";	//项目代码
						param.Arg2 = "";	//项目名称
						param.Arg3 = PUBLIC_CONSTANT.CATE.TARCATE;	//项目大类
						param.ArgCnt = PUBLIC_CONSTANT.CATE.ARCNUM;
					}
				}
			}
		},
		{ field: 'rowid', title: '表ID', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'job', title: 'job', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'tarcatedrid', title: '收费病案大类ID', width: 200, align: 'center', sortable: true, resizable: true, hidden: true}
	]];
	
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
			Arg3 : '',	//大类ID
			Arg4 : PUBLIC_CONSTANT.CATE.TARSUBCATE,	//子类
			Arg5 : PUBLIC_CONSTANT.CATE.SUBCATEINDEX,	//子类中指向大类的索引
			Arg6 : PUBLIC_CONSTANT.CATE.TARCATE,	//大类
			ArgCnt : PUBLIC_CONSTANT.CATE.ARCSUBNUM
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
		}
	});
}

function initLoadGrid(ExpStr)
{
	var SearchCode="",SearchDesc="",SearchCateID="";
	if(ExpStr != ""){
		SearchCode = ExpStr.split("^")[0];
		SearchDesc = ExpStr.split("^")[1];
		SearchCateID = ExpStr.split("^")[2];
	}
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
	queryParams.Arg1 = SearchCode;	//项目代码
	queryParams.Arg2 = SearchDesc;	//项目名称
	queryParams.Arg3 = SearchCateID;	//大类ID
	queryParams.Arg4 = PUBLIC_CONSTANT.CATE.TARSUBCATE;	//收费项目子类
	queryParams.Arg5 = PUBLIC_CONSTANT.CATE.SUBCATEINDEX;	//子类中指向大类的索引
	queryParams.Arg6 = PUBLIC_CONSTANT.CATE.TARCATE;	//收费病案大类
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.ARCSUBNUM;
	loadDataGridStore("tTarCate", queryParams);
}

// 加载DataGrid数据
function loadDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

$(function(){
	initGrid();
	//initLoadGrid("")
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
		desc : '',
		tarcatedr : ''
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
	$('#tTarCate').datagrid('selectRow',EditIndex);
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected){
		// selected.rowid为undefined，说明是新建项目，调用保存接口
		if(typeof(selected.rowid) == "undefined"){
			var CateStr=selected.code+"^"+selected.desc+"^"+selected.tarcatedr;
			//$.messager.alert('消息',CateStr);
			//return;
			if((typeof(selected.code) == "undefined") || (typeof(selected.desc) == "undefined") || (typeof(selected.tarcatedr) == "undefined") || (typeof(selected.tarcatedr) == "")){
				$.messager.alert('消息',"数据为空,不允许添加!");
				EditIndex=-1;
				initLoadGrid("");
				return;
			}
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"保存成功!");
				}else if(value=="-1001"){$.messager.alert('消息',"项目代码已存在,保存失败!");
				}else if(value=="-1002"){$.messager.alert('消息',"项目名称已存在,保存失败!");
				}else if(value=="-1003"){$.messager.alert('消息',"项目大类不存在,保存失败!");
				}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
				}
				EditIndex=-1;
				initLoadGrid("");
			},"","",CateStr,PUBLIC_CONSTANT.CATE.TABLE,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
		}else{
			var CateStr=selected.rowid+"^"+selected.code+"^"+selected.desc+"^"+selected.tarcatedr;
			if((typeof(selected.code) == "undefined") || (typeof(selected.desc) == "undefined") || (typeof(selected.tarcatedr) == "undefined") || (typeof(selected.tarcatedr) == "")){
				$.messager.alert('消息',"数据为空,不允许修改!");
				EditIndex=-1;
				initLoadGrid("");
				return;
			}
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.UPDATE,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"修改成功!");
				}else if(value=="-1001"){$.messager.alert('消息',"项目代码重复,不能修改!");
				}else if(value=="-1002"){$.messager.alert('消息',"项目名称重复,不能修改!");
				}else if(value=="-1003"){$.messager.alert('消息',"项目大类不存在,不能修改!");
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
						EditIndex=-1;
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
	var datanum=tkMakeServerCall("DHCBILLConfig.DHCBILLSysType","GetTarSubCateNum",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,PUBLIC_CONSTANT.CATE.TARSUBCATE)
	if((datanum=="") || (datanum==0)){$.messager.alert('消息',"没有需要导出的分类!");return;}
	var datanum=eval(datanum)
	var Template=path+"ExportTarSubCate.xls"
	var xlApp = new ActiveXObject("Excel.Application");//不支持Google浏览器，只支持IE
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	xlApp.Visible=true;
	for ( i=1 ; i <= datanum ; i++){
		var value=tkMakeServerCall("DHCBILLConfig.DHCBILLSysType","GetTarSubCateData",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,PUBLIC_CONSTANT.CATE.TARSUBCATE,i)
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
	EditIndex=-1;
	var TBCode="",TBDesc="",TBCate="";
	if($("#tTBCodeText").get(0)){TBCode=$("#tTBCodeText").val();}
	if($("#tTBDescText").get(0)){TBDesc=$("#tTBDescText").val();}
	if($("#tTBCateCombo").get(0)){TBCate=$('#tTBCateCombo').combobox('getValue');}
	var Str=TBCode+"^"+TBDesc+"^"+TBCate;
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

