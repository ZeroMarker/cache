/**
* author :    QuNianpeng
* date:       2017-7-8
* descript:   病理病人病历分类字典操作
*/


/// 页面初始化函数
function initPageDefault(){
	initDgList();  		// 初始页面DataGrid病历分类表
	initButton();		// 初始化按钮
}

/// 病历病人
function initDgList(){
	
	var hospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto"  //设置容器高度自动增长			
		}
	}
	
	var accFlag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"Y"},{"value":"N","text":"N"}],			
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
		{field:"accRowId",title:'ID',width:20,hidden:'true',align:'center'},
		{field:"accCode",title:'分类代码',width:150,align:'center',editor:textEditor},
		{field:"accDesc",title:'分类描述',width:170,align:'center',editor:textEditor},
		{field:"accHospDesc",title:'医院',width:200,align:'center',editor:hospEditor},
		{field:"accHospDr",title:'医院ID',width:40,align:'center',hidden:'true'},
		{field:"accActiveFlag",title:'是否可用',width:60,align:'center',editor:accFlag}		
	]];
	
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            onClickRow(rowIndex,rowData) 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCaseClass&MethodName=QueryCaseClass";
	new ListComponent('caseclassdg', columns, uniturl, option).Init(); 	
	
	
}

//增加一行
function addRow(){
	commonAddRow({'datagrid':'#caseclassdg',value:{'accHospDesc':'2','accActiveFlag':'Y'}})
}

//修改行
function onClickRow(index,row){
	CommonRowClick(index,row,"#caseclassdg");
}
//保存
function save(){
	saveByDataGrid("web.DHCAPPCaseClass","SaveCaseClass","#caseclassdg",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#caseclassdg").datagrid('reload');
			}else if(data==-1){
				$.messager.alert('提示','保存失败:'+data)
			}else{	
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#caseclassdg").datagrid('reload');				
			}
		});	
}


//删除一行
function deleteRow(){
	
	if ($("#caseclassdg").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$("#caseclassdg").datagrid('getSelected');     
			 runClassMethod("web.DHCAPPCaseClass","DeleteCaseClass",{'accRowId':row.accRowId},function(data){ $('#caseclassdg').datagrid('load'); })
	    }    
	}); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	// 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findCaseList(); //调用查询
    });
    
    //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findCaseList(); //调用查询
    });   
     
     
   	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
	    findCaseList();
    });	 
    
}

// 查询
function findCaseList()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#caseclassdg').datagrid('load',{params:params}); 
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })