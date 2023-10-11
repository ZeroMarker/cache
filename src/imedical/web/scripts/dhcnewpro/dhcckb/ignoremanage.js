/// Creator: qunianpeng
/// CreateDate: 2020-12-28
//  Descript: ���Թ���ά���б�(�����б�)
var dataType = "";
var dataValue = "";
var flag = "";
var ItmArr =[{"value":"D","text":"Ŀ¼"},{"value":"I","text":"��Ŀ"}]
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

/// ��ť���¼�
function initBindMethod(){
	
    $("a:contains('�������')").bind('click',addItm);
    $("a:contains('ɾ������')").bind('click',delItm);
    $("a:contains('ȫ��ѡ��')").bind('click',selAllItm);
    $("a:contains('ȡ��ѡ��')").bind('click',unSelAllItm);
    $("a:contains('ȫ��ɾ��')").bind('click',delAllItm);
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

/// Combobox��ʼ��
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

/// datagrid��ʼ��
function initDatagrid(){
	var columns=[[
		{field:'id',title:'id',width:80,hidden:false},
		{field:'code',title:'����',width:120,hidden:true},
		{field:'desc',title:'����',width:260,hidden:false}
	]];
	
	$("#allItmTable").datagrid({
		title:'��������',
		url:$URL+"?ClassName=web.DHCCKBIgnoreManage&MethodName=GetAllItm",
		queryParams:{
			flag:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'rmRowID',title:'rmRowID',width:80,hidden:true},
		{field:'dataType',title:'����',width:80,hidden:false},
		{field:'dataValueDr',title:'����ֵDr',width:120,hidden:true},
		{field:'dataValue',title:'����ֵ',width:150,hidden:false},
		{field:'item',title:'��������Dr',width:100,hidden:true},
		{field:'itemDesc',title:'��������',width:200},
		{field:'flag',title:'������ʶ',width:80}
	]];

	$("#setItmTable").datagrid({
		title:'��������б�',
		url:$URL+"?ClassName=web.DHCCKBIgnoreManage&MethodName=GetReviewList",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '���ڼ�����Ϣ...',
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


///�������
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.popover({
			msg: 'δѡ��������ݣ�',
			type: 'alert',
			timeout: 2000, 		//0���Զ��رա�3000s
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
				msg: '�����ɹ���',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
				showType: 'slide'  //show,fade,slide
			});	
			reloadSetFielTable();
		}
	},"text");	
}

/// ɾ������
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){		
		$.messager.popover({
			msg: 'δѡ���Ҳ����ݣ�',
			type: 'alert',
			timeout: 2000, 		//0���Զ��رա�3000s
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
				msg: 'ɾ���ɹ���',
				type: 'success',
				timeout: 2000, 		//0���Զ��رա�3000s
				showType: 'slide'  //show,fade,slide
			});		
			reloadSetFielTable();
		}
	},'text');
}

/// ȫ��ɾ��
function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}

/// ȫѡ
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}

/// ��ѡ
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}

/// reloadȫ������
function reloadAllItmTable(value){
	var queryCode = $HUI.searchbox('#queryAllCode').getValue();
	$("#allItmTable").datagrid('load',{
		flag:value,
		queryCode:queryCode
	})
}

/// ������������ѯ
function reloadSetFielTable(){
	var queryCode = $HUI.searchbox('#querySetCode').getValue();
	$("#setItmTable").datagrid('load',{
		dataType:dataType, 
		dataValue:dataValue,
		queryCode:queryCode
	})
	
}


///ˢ�� field��fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}

/// ��ѯ��������
function SearchAllData() {
	reloadAllItmTable(flag);
}

/// ������������
function ClearAllData() {
	$HUI.searchbox('#queryAllCode').setValue("");
	reloadAllItmTable(flag);
}

/// ��ѯ��������б�
function SearchSetData() {
	reloadSetFielTable();
}

/// ������������б�
function ClearSetData() {
	$HUI.searchbox('#querySetCode').setValue("");
	reloadSetFielTable();
}


