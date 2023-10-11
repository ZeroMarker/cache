/// Creator: qunianpeng
/// CreateDate: 2020-12-28
//  Descript: 忽略规则维护列表(忽略列表)
var dataType = "";
var dataValue = "";
var flag = "";
var ItmArr =[{"value":"D","text":"目录"},{"value":"I","text":"项目"}]
$(function(){

	initParams();
	
	initCombobx();
	
	initBindMethod();

	initDatagrid();
	
})	

function initParams(){
	
	dataType =  getParam("dataType");
	dataValue = getParam("dataValue");
	inputEditor={type:'validatebox',options:{required:true}};
}

/// 按钮绑定事件
function initBindMethod(){
	
    $("a:contains('添加条件')").bind('click',addItm);
    $("a:contains('删除条件')").bind('click',delItm);
    $("a:contains('全部选中')").bind('click',selAllItm);
    $("a:contains('取消选中')").bind('click',unSelAllItm);
    $("a:contains('全部删除')").bind('click',delAllItm);
    $('#queryAllCode').searchbox({
	    searcher:function(value,name){
	   		SearchAllData();
	    }	   
	});
	$('#querySetCode').searchbox({
	    searcher:function(value,name){
	   		SearchSetData();
	    }	   
	});
}

/// Combobox初始化
function initCombobx(){

	var option = {
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		data:ItmArr,
		onSelect:function(option){
			flag = option.value;
			reloadAllItmTable(option.value);
			reloadSetFielTable();
	    }
	};
	var url = "";
	new ListCombobox("reviewmanage",url,'',option).init();	
}

/// datagrid初始化
function initDatagrid(){
	var columns=[[
		{field:'id',title:'id',width:80,hidden:false},
		{field:'code',title:'代码',width:120,hidden:true},
		{field:'desc',title:'条件',width:260,hidden:false}
	]];
	
	$("#allItmTable").datagrid({
		title:'忽略条件',
		url:$URL+"?ClassName=web.DHCCKBIgnoreManage&MethodName=GetAllItm",
		queryParams:{
			flag:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'rmRowID',title:'rmRowID',width:80,hidden:true},
		{field:'dataType',title:'类型',width:80,hidden:false},
		{field:'dataValueDr',title:'类型值Dr',width:120,hidden:true},
		{field:'dataValue',title:'类型值',width:150,hidden:false},
		{field:'item',title:'忽略条件Dr',width:100,hidden:true},
		{field:'itemDesc',title:'忽略条件',width:200},
		{field:'flag',title:'条件标识',width:80}
	]];

	$("#setItmTable").datagrid({
		title:'忽略审查列表',
		url:$URL+"?ClassName=web.DHCCKBIgnoreManage&MethodName=GetReviewList",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
	
	reloadAllItmTable(flag);
	reloadSetFielTable();
		
}


///添加条件
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.popover({
			msg: '未选中左侧数据！',
			type: 'alert',
			timeout: 2000, 		//0不自动关闭。3000s
			showType: 'slide'  //show,fade,slide
		});		
		return;	    
	}
	var itemArr = $("#setItmTable").datagrid("getData").rows;
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].id;
		var existFlag = 0;
		for(i=0;i<itemArr.length;i++){
			if (param ==itemArr[i].item ){
				existFlag = 1;
				break;
			}
		}
		if (existFlag == 0){		
			dataArray.push(param);
		}
	}
	if(dataArray.length == 0 ){
		return;
	}
	var params = dataArray.join("&&");
	runClassMethod("web.DHCCKBIgnoreManage","SaveReview",{"dataTypeStr":dataType,"dataValueStr":dataValue,"flag":flag,"params":params},function(ret){
		if(ret=="0"){		
			$.messager.popover({
				msg: '新增成功！',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});	
			reloadSetFielTable();
		}
	},"text");	
}

/// 删除条件
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){		
		$.messager.popover({
			msg: '未选中右侧数据！',
			type: 'alert',
			timeout: 2000, 		//0不自动关闭。3000s
			showType: 'slide'  //show,fade,slide
		});		
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].rmRowID;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCCKBIgnoreManage","DelReview",{"params":params},
	function(ret){
		if(ret=="0"){
			$.messager.popover({
				msg: '删除成功！',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});		
			reloadSetFielTable();
		}
	},'text');
}

/// 全部删除
function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}

/// 全选
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}

/// 反选
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}

/// reload全部条件
function reloadAllItmTable(value){
	var queryCode = $HUI.searchbox('#queryAllCode').getValue();
	$("#allItmTable").datagrid('load',{
		flag:value,
		queryCode:queryCode
	})
}

/// 已设置条件查询
function reloadSetFielTable(){
	var queryCode = $HUI.searchbox('#querySetCode').getValue();
	$("#setItmTable").datagrid('load',{
		dataType:dataType, 
		dataValue:dataValue,
		queryCode:queryCode
	})
	
}


///刷新 field和fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}

/// 查询忽略条件
function SearchAllData() {
	reloadAllItmTable(flag);
}

/// 清屏忽略条件
function ClearAllData() {
	$HUI.searchbox('#queryAllCode').setValue("");
	reloadAllItmTable(flag);
}

/// 查询忽略审查列表
function SearchSetData() {
	reloadSetFielTable();
}

/// 清屏忽略审查列表
function ClearSetData() {
	$HUI.searchbox('#querySetCode').setValue("");
	reloadSetFielTable();
}


