// Creator: congyue
/// CreateDate: 2017-12-27
//  Descript: 不良事件升级 导出字典维护
$(function(){

	initParams();
	
	initCombobx();
	
	initBindMethod();

	initDatagrid();
	
})	

function initParams(){
	
	formNameID = "";
	
	editRow="";	
	
	inputEditor={type:'validatebox',options:{required:true}};
}

function initBindMethod(){
    $("a:contains('添加元素')").bind('click',addItm);
    $("a:contains('删除元素')").bind('click',delItm);
    $("a:contains('全部选中')").bind('click',selAllItm);
    $("a:contains('取消选中')").bind('click',unSelAllItm);
    $("a:contains('全部删除')").bind('click',delAllItm);
}
function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=";
	var option = {
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			formNameID = option.value;
			reloadAllItmTable(option.value);
			reloadSetFielTable(option.value);
	    }
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
}
function initDatagrid(){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:80,hidden:false},
		{field:'DicField',title:'DicField',width:120,hidden:false},
		{field:'DicDesc',title:'全部列',width:200}
	]];
	
	$("#allItmTable").datagrid({
		title:'报告全部列',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetAllItmByFormID",
		queryParams:{
			ForNameID:""
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
		{field:'RowID',title:'RowID',width:80,hidden:false},
		{field:'FormDicDr',title:'FormDicDr',width:120,hidden:false},
		{field:'DicField',title:'DicField',width:120,hidden:false},
		{field:'DicDesc',title:'导出列',width:200},
		{field:'num',title:'顺序号',width:80},
		{field:'pri',title:'优先级',width:200,
			formatter:function(value,rec,index){
			var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">上移</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">下移</a> ';
			return a+b;  
        }  
		,hidden:false}
	]];

	$("#setItmTable").datagrid({
		title:'报告导出列',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
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
	
	reloadAllItmTable(formNameID);
	reloadSetFielTable(formNameID);
		
}
///添加元素
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].FormDicID;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVEXPFIELD","SaveExpField",{"FormNameID":formNameID,"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("提示","新增成功！");
			reloadTopTable();
		}
	},'text');
	

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中右侧数据！");
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].RowID;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVEXPFIELD","DelExpField",{"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("提示","删除成功！");
			reloadTopTable();
		}
	},'text');
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload 左上表
function reloadAllItmTable(value){
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}
///刷新 field和fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}

//上移
function upclick(index)
{
	/* var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	if(datas.length>1){
		$.messager.alert("提示","只能选择一条左侧数据！");
		return;	    
	}
	var index=$('#setItmTable').datagrid('getRowIndex',datas[0]); */
	
	var newrow=parseInt(index)-1     
	var curr=$("#setItmTable").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.num;
	var up =$("#setItmTable").datagrid('getData').rows[newrow];
	var uprowid=up.RowID;
	var upordnum=up.num;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'setItmTable');
	
}
//下移
function downclick(index)
{
	/* var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	if(datas.length>1){
		$.messager.alert("提示","只能选择一条左侧数据！");
		return;	    
	}
	var index=$('#setItmTable').datagrid('getRowIndex',datas[0]); */
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#setItmTable").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.num;
	var down =$("#setItmTable").datagrid('getData').rows[newrow];
	var downrowid=down.RowID;
	var downordnum=down.num;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'setItmTable');
}
function SaveUp(input,datas)
{
	 /* $.post(url+'?action=UpdEventWorkFlowItmNum',{"input":input},function(data){
	}); */
	runClassMethod("web.DHCADVEXPFIELD","UpdExpFieldNum",{"input":input},
	function(ret){
		reloadTopTable();
	},'text');
	 
}
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
