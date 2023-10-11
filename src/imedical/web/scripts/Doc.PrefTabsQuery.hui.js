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
		{field:'HospDesc',title:'院区',width:200},
		{field:'FavCatType',title:'分类代码',width:250},
		{field:'TypeValueDesc',title:'分类值描述',width:100},
		{field:'TypeValueCode',title:'分类值代码',width:90},
		{field:'Cat',title:'大类',width:100},
		{field:'SubCat',title:'子分类',width:100},
		{field:'ItemType',title:'医嘱或医嘱套',width:100},
		{field:'ItemDesc',title:'项目描述',width:300},
		{field:'itemNotes',title:'备注',width:100},
		{field:'PartCodeInfo',title:'部位代码列表',width:150},
		{field:'TypeValue',title:'分类值',width:60},
		{field:'ItemID',title:'项目ID',width:100}
    ]]
	var PrefTabListDataGrid=$("#PrefTabList").datagrid({
		fit : true,
		border : false,
		striped : false,
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
	/*if (objvalue==""){
		$.messager.alert("提示","请选择值!","info",function(){
			$("#objvalue").next('span').find('input').focus();
		});
		return false;
	}*/
	PrefTabListDataGridLoad();
}
function PrefTabListDataGridLoad(){
	$.cm({
	    ClassName : "web.DHCDocPrefTabs",
	    QueryName : "FindPrefTabs",
	    objtype:$("#objtype").combobox('getValue'),
	    objvalue:$("#objvalue").combobox('getValue'),
	    HospRowId:session['LOGON.HOSPID'],
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
			data: [{"id":"User.SSUser","text":$g("个人"),'selected':true},
				   {"id":"User.CTLoc","text":$g("科室")},
				   //{"id":"User.SSGroup","text":"安全组"},
				   //{"id":"User.PACTrust","text":"区域"},
				   {"id":"User.CTHospital","text":$g("医院")},
				   //{"id":"SITE","text":"站点"}
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
		url:"DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo&ClassName=web.DHCDocPrefTabs&QueryName=FindObjValue&Type="+Type,
        mode:'local',
        method:"Get",
		valueField: 'objId', 
		textField: 'objValue', 
		editable:true,
		filter: function(q, row){
	        return (row['objValue'].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row['objCode'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
	    }
	 });
}