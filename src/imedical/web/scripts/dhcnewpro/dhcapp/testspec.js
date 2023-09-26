/// Descript: 病理标本字典维护
/// Creator : yuliping
/// Date    : 2017-07-08
var editRow="";
/// 页面初始化函数
function initPageDefault(){
	
	initTestItem();       	/// 初始页面DataGrid病理检测项目
	
	//同时给代码和描述绑定回车事件
    $('#ATSCode,#ATSDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //调用查询
        }
    });
	
}
///病理检测项目
function initTestItem(){
	
	var Hospeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto" , //设置容器高度自动增长,
			required: true
		}
	}
	
	var atsflag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"是"},{"value":"N","text":"否"}],
			
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var mulflag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"是"},{"value":"N","text":"否"}],
			
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
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
	
	var columns=[[
		{field:"ATSCode",title:'项目代码',width:150,editor:textEditor},
		{field:"ATSDesc",title:'项目描述',width:150,editor:textEditor},
		{field:"CatDesc",title:'标本所属分类',width:140,editor:catEditor},
		{field:"HospDesc",title:'医院标识',width:200,editor:Hospeditor},
		{field:"ActiveFlag",title:'是否可用',width:80,align:'center',editor:atsflag},
		{field:"ActiveFlagCode",title:'ActiveFlagCode',width:80,align:'center',editor:textEditor},
		{field:"CatDr",title:'CatDr',width:20,hidden:'true',align:'center'},
		{field:"HospDr",title:'HospDr',width:20,hidden:'true',align:'center'},
		{field:"ATSid",title:'ATSid',width:20,hidden:'true',align:'center'},
		{field:"MulFlag",title:'多选',width:80,align:'center',editor:mulflag},
		{field:"MulFlagCode",title:'MulFlagCode',width:80,align:'center',editor:textEditor}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            onClickRow(rowIndex,rowData) 
            editRow=rowIndex;
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestSpec&MethodName=ListAPPTestSpec";
	new ListComponent('datagrid', columns, uniturl, option).Init(); 
}
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'HospDesc':'2','ActiveFlag':'Y','ActiveFlagCode':'Y','MulFlag':'Y','MulFlagCode':'Y'}})
	editRow=0;
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCAPPTestSpec","SaveUpdTestSpec","#datagrid",function(data){
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
		 runClassMethod("web.DHCAPPTestSpec","RemoveTestSpec",{'Id':row.ATSid},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
