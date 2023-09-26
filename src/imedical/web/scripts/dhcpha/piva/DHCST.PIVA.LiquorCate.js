/*
模块:		静脉配液中心
子模块:		静脉配液中心-配药类别维护
Creator:	hulihua
CreateDate:	2016-12-16
*/
var PolIdDr=""
var editRow="";			 //当前编辑行号
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
/// 定义界面tab列表
var tabsObjArr = [
	{"tabTitle":"药品配液分类","tabCsp":"dhcst.piva.drugcat.csp"},
	{"tabTitle":"关联用法","tabCsp":"dhcst.piva.catlinkuse.csp"},
	{"tabTitle":"液体量","tabCsp":"dhcst.piva.liquid.csp"}
	];

$(function(){
	///初始化页签
	InitDefault()		
	///初始化配液类别列表
	InitPIVAcatList();
	///初始化界面按钮事件
	InitWidListener();
})

/// 初始化界面默认信息
function InitDefault(){	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

/// 界面元素监听事件
function InitWidListener(){
    $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,PolIdDr)}});
		}
	});
}

///初始化配液类别列表
function InitPIVAcatList(){
	// 定义columns
	var columns=[[
		{field:"PolId",title:'ID',width:20,align:'center',hidden:true},
		{field:"PolDesc",title:'配液分类描述',width:360,align:'center',editor:texteditor}
	]];
	// 定义datagrid
	$('#phcpivacatlist').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaCatList',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#phcpivacatlist").datagrid('endEdit', editRow); 
            } 
            $("#phcpivacatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        PolIdDr=rowData.PolId;
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,PolIdDr)}});
			
	    }
	});
}

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#phcpivacatlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#phcpivacatlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {PolId: '',PolDesc: ''}
	});
            
	$("#phcpivacatlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 保存编辑行
function saveRow(){
	if(editRow>="0"){
		$("#phcpivacatlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#phcpivacatlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PolDesc==null)||(rowsData[i].PolDesc=="")){
			$.messager.alert("提示","配液分类描述不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].PolId +"^"+ rowsData[i].PolDesc;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//保存数据
	var savetype="1";
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVAOrderLink",params,savetype)
	if(data!=""){
		if(data==-1){
			$.messager.alert("提示","配液分类描述为空,不能保存!"); 
		}else if(data==-2){	
			$.messager.alert('提示','更新失败!');		
		}else{	
			$.messager.alert('提示','更新成功!');		
		}
		$("#phcpivacatlist").datagrid('reload');
	}
}
/// 删除
function deleteRow(){
	if ($("#phcpivacatlist").datagrid('getSelections').length != 1) {		
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm("提示", "配液分类为基础数据,您确认删除吗?", function (res) {//提示是否删除
		if (res) {
			var rowsData = $("#phcpivacatlist").datagrid('getSelected'); //选中要删除的行
			if (rowsData != null) {
				if (rowsData.PolId!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVAOrderLink",rowsData.PolId)
					if(data!=""){
						if(data==-1){
							$.messager.alert("提示","没有选中需要删除的记录!"); 
						}else if(data==-2){	
							$.messager.alert('提示','删除失败!');		
						}else{	
							$.messager.alert('提示','删除成功!');		
						}
						$("#phcpivacatlist").datagrid('reload');
					}
				}else{
				        var rowIndex = $('#phcpivacatlist').datagrid('getRowIndex', rowsData);
         				$('#phcpivacatlist').datagrid('deleteRow', rowIndex);  
				}				
			}
		}
	})
}
/// 添加选项卡
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// 创建框架
function createFrame(tabUrl, PolIdDr){
	tabUrl = tabUrl.split("?")[0];
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?polid='+ PolIdDr +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}