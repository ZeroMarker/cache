/*
 * FileName:	dhcbillmenu.admreason.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	病人收费类别
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
		TARCATE : "", //
		TARSUBCATE : "", //
		SUBCATEINDEX : "", //
		ARCNUM : 2, //参数个数
		TABLE : "" //
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLSysType",
		QUERY : "FindAdmReason",
		INSERT : "InsertAdmReason",
		UPDATE : "UpdateAdmReason",
		DELETE : "DeleteAdmReason"
	}
};

var lastIndex="",EditIndex=-1;

function initGrid(){
	var CateColumns = [[
		{ field: 'RowID', title: '表ID', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'REACode', title: '项目代码', width: 100, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'READesc', title: '项目名称', width: 200, align: 'center', sortable: true, resizable: true,
			editor:{type:'validatebox',options:{required:true}}
		},
		{ field: 'READateFrom', title: '开始日期', width: 100, align: 'center', editor : 'datebox', sortable: true, resizable: true },
		{ field: 'READateTo', title: '结束日期', width: 150, align: 'center', editor : 'datebox', sortable: true, resizable: true },
		{ field: 'REANationalCode', title: '住院NationalCode', width: 150, align: 'center', editor : 'text', sortable: true, resizable: true },
		{ field: 'REAAdmSource', title: '门诊AdmSource', width: 100, align: 'center', editor : 'text', sortable: true, resizable: true}
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
});

$('#BtnAdd').bind('click', function(){
	//$('#tTarCate').datagrid('endEdit', lastIndex);  
	lastIndex = $('#tTarCate').datagrid('getRows').length-1;  
	$('#tTarCate').datagrid('selectRow', lastIndex);
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected){
		if(selected.RowID == ""){
			$.messager.alert('消息',"不能同时添加多条!");
			return;
		}
	}
	if((EditIndex>=0)){
		$.messager.alert('消息',"一次只能修改一条记录!");
		return;
	}
	$('#tTarCate').datagrid('appendRow',{  
		RowID : '',
		REACode : '',
		READesc : '',
		READateFrom : '',
		READateTo : '',
		REANationalCode : '',
		REAAdmSource : ''
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
		// selected.RowID为undefined，说明是新建项目，调用保存接口
		if(selected.RowID == ""){
			if((selected.REACode == "undefined") || (selected.READesc == "undefined") || (selected.REACode == "") || (selected.READesc == "")){
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
			},"","",selected.REACode,selected.READesc,selected.READateFrom,selected.READateTo,selected.REANationalCode,selected.REAAdmSource,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
		}else{
			$('#tTarCate').datagrid('selectRow',EditIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			if((selected.REACode == "undefined") || (selected.READesc == "undefined") || (selected.REACode == "") || (selected.READesc == "")){
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
			},"","",selected.RowID,selected.REACode,selected.READesc,selected.READateFrom,selected.READateTo,selected.REANationalCode,selected.REAAdmSource,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
		}
	}
});

$('#BtnDelete').bind('click', function(){
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
		if (r){
			var selected = $('#tTarCate').datagrid('getSelected');
			if (selected){
				if(selected.RowID != ""){
					$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.DELETE,"false",function testget(value){
						if(value == "0"){$.messager.alert('消息',"删除成功!");
						}else{$.messager.alert('消息',"删除失败,错误代码:"+value);
						}
						initLoadGrid("");
					},"","",selected.RowID,PUBLIC_CONSTANT.SESSION.GUSER_ROWID);
				}
			}
		}
	});
});

$('#BtnFind').bind('click', function(){
	EditIndex=-1;
	initLoadGrid("");
});

