var PageLogicObj={
	m_PrefTabListDataGrid:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function PageHandle(){
	//类型
	LoadObjectType(); 
}
function Init(){
	PageLogicObj.m_PrefTabListDataGrid=InitPrefTabListDataGrid();
}
function InitEvent(){
	$("#BFind").click(FindClickHandle);
	$(document.body).bind("keydown",BodykeydownHandler)
}
function InitPrefTabListDataGrid(){
	var Columns=[[ 
		{field:'Index',title:'序号',hidden:true},
		{field:'valueDesc',title:'类型描述',width:100},
		{field:'valueCode',title:'类型代码',width:100},
		{field:'Type',title:'类型',width:100},
		{field:'AppKey',title:'应用代码',width:200},
		{field:'Tab',title:'表名',width:100},
		{field:'Col',title:'列名',width:100},
		{field:'ARCIMorARCOS',title:'医嘱或医嘱套',width:100},
		{field:'Desc',title:'药品描述',width:300},
		{field:'Code',title:'药品代码',width:120},
		{field:'itemrowid',title:'医嘱或医嘱套Code',width:150},
		{field:'websysPrefId',title:'模板表ID',width:100}
    ]]
	var PrefTabListDataGrid=$("#PrefTabList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Index',
		columns :Columns
	});
	PrefTabListDataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return PrefTabListDataGrid;
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}
function FindClickHandle(){
	var objvalue=$("#objvalue").combobox('getValue');
	if (objvalue==""){
		$.messager.alert("提示","请选择值!","info",function(){
			$("#objvalue").next('span').find('input').focus();
		});
		return false;
	}
	PrefTabListDataGridLoad();
}
function PrefTabListDataGridLoad(){
	$.cm({
	    ClassName : "web.DHCDocPrefTabs",
	    QueryName : "FindPrefTabs",
	    objtype:$("#objtype").combobox('getValue'),
	    objvalue:$("#objvalue").combobox('getValue'),
	    Pagerows:PageLogicObj.m_PrefTabListDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_PrefTabListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function LoadObjectType(){
	$HUI.combobox("#objtype", {
			valueField: 'id', 
			textField: 'text', 
			editable:false,
			data: [{"id":"User.SSUser","text":"个人",'selected':true},
				   {"id":"User.CTLoc","text":"科室"},
				   {"id":"User.SSGroup","text":"安全组"},
				   {"id":"User.PACTrust","text":"区域"},
				   {"id":"User.CTHospital","text":"医院"},
				   {"id":"SITE","text":"站点"}
		    ],
			onSelect: function(rec){  
				LoadObjectValue();
			},
			onLoadSuccess:function(){
				LoadObjectValue();
			}
	 });
}
function LoadObjectValue(){
	var Type=$("#objtype").combobox('getValue');
	$("#objvalue").combobox({
		url:$URL+"?ClassName=web.DHCDocPrefTabs&QueryName=FindObjValue",
        mode:'remote',
        method:"Get",
		valueField: 'objId', 
		textField: 'objValue', 
		editable:true,
		onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{Type:Type,value:desc});
	    },
	    loadFilter:function(data){
		    return data['rows'];
		}
	 });
}