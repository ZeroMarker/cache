/// Descript: 病理检测项目字典维护
/// Creator : yuliping
/// Date    : 2017-07-07
var editRow="";
/// 页面初始化函数
function initPageDefault(){
	
	
	
	//同时给代码和描述绑定回车事件
    $('#ATICode,#ATIDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //调用查询
        }
    });
	
}
/*///病理检测项目
function initTestItem(){
	
	var Hospeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			required: true
		}
	}
	var ARCItmMast={  //设置其为可编辑
		//类别
		type:'combogrid',
		options: {
			required : true,
			//fitColumns:true,
			fit:true,//自动大小  
			pagination : true,
			panelWidth:600,
			idField: 'value',
			textField:'text',
			
			url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=getARCItmMast",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			columns:[[
				{field:'value',hidden:true},
				{field:'code',title:'代码',width:60},
				{field:'text',title:'医嘱项',width:80}
				]]	
		}
	}
	var atsflag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"Y"},{"value":"N","text":"N"}],
			
			//required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	var catEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=QueryArcCatList",
			//required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}
	/// 文本编辑格
	var textEditor={
		type: 'validatebox',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	//ATICode^ATIDesc^ArcDesc^HospDesc^ActiveFlag^CatDesc^ArcDr^HospDr^CatDr^ATIid
	var columns=[[
		{field:"ATICode",title:'项目代码',width:150,align:'center',editor:textEditor},
		{field:"ATIDesc",title:'项目描述',width:150,align:'center',editor:textEditor},
		{field:"ArcDesc",title:'关联医嘱项',width:170,align:'center',editor:{type:'combogrid',
									options: {
										required : true,
										//fitColumns:true,
										fit:true,//自动大小  
										pagination : true,
										panelWidth:600,
										idField: 'value',
										textField:'text',
										
										url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=getARCItmMast",
										//required:true,
										panelHeight:"auto",  //设置容器高度自动增长
										columns:[[
											{field:'value',hidden:true},
											{field:'code',title:'代码',width:60},
											{field:'text',title:'医嘱项',width:80}
											]]	
									}}},
		{field:"HospDesc",title:'医院标识',width:200,align:'center',editor:Hospeditor},
		{field:"ActiveFlag",title:'是否可用',width:80,align:'center',editor:atsflag},
		{field:"CatDesc",title:'检查分类',width:140,align:'center',editor:catEditor},
		{field:"ArcDr",title:'ArcDr',width:20,hidden:'true',align:'center'},
		{field:"HospDr",title:'HospDr',width:20,hidden:'true',align:'center'},
		{field:"CatDr",title:'CatDr',width:20,hidden:'true',align:'center'},
		{field:"ATIid",title:'ATIid',width:20,hidden:'true',align:'center'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            onClickRow(rowIndex,rowData) 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=ListAPPTestItem";
	new ListComponent('datagrid', columns, uniturl, option).Init(); 
}*/
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'HospDesc':'2','ActiveFlag':'Y'}})
}
function onClickRow(index,row){
	editRow = index;
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCAPPTestItem","SaveUpdTestItem","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("提示","描述已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPTestItem","RemoveTestItem",{'Id':row.ATIid},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
///调用取值函数
function fillValue(rowIndex, rowData){

	$('#datagrid').datagrid('getRows')[editIndex]['ArcDesc']=rowData.text
	$('#datagrid').datagrid('getRows')[editIndex]['ArcDr']=rowData.value
	
}

/// combogrid 组件 onChange 调用函数
function ChangeValue(newValue, oldValue){
	
	if (newValue == ""){
		$('#datagrid').datagrid('getRows')[editRow]['ArcDr']="";
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
