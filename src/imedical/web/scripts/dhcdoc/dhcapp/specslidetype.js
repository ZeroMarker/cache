/**
* author :    QuNianpeng
* date:       2017-7-8
* descript:   病理标本玻片类型字典操作
*/

var editRow = "";
/// 页面初始化函数
function initPageDefault(){
	initDgList();  		// 初始页面DataGrid标本玻片类型表
	initButton();		// 初始化按钮
}

/// 初始页面DataGrid
function initDgList(){
	
	var hospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto", //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'astHospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'astHospDr'});
				$(ed.target).val(option.value); 
			} 			
		}
	}
	
	var astFlag={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"是"},{"value":"N","text":"否"}],			
			panelHeight:"auto" , //设置容器高度自动增长	
			onSelect:function(option){
				///设置类型值
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'astActiveFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'ActiveFlagCode'});
				$(ed.target).val(option.value); 
			} 		
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
		{field:"astRowId",title:'ID',width:20,hidden:'true',align:'center'},
		{field:"astCode",title:'分类代码',width:150,editor:textEditor},
		{field:"astDesc",title:'分类描述',width:170,editor:textEditor},
		{field:"astHospDesc",title:'医院',width:200,editor:hospEditor},
		{field:"astHospDr",title:'医院ID',width:40,align:'center',editor:textEditor,hidden:'true'},
		{field:"astActiveFlag",title:'是否可用',width:80,align:'center',editor:astFlag},
		{field:"ActiveFlagCode",title:'ActiveFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'}
		
	]];
	
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	     onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            onClickRow(rowIndex,rowData);
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPSpecSlideType&MethodName=QuerySpecSlideType";
	new ListComponent('specslidetypedg', columns, uniturl, option).Init(); 	
	
	
}

//增加一行
function addRow(){
	commonAddRow({'datagrid':'#specslidetypedg',value:{'astRowId':"",'astCode':"",'astDesc':"",'astHospDr':2,'astHospDesc':'2','astActiveFlag':'Y','ActiveFlagCode':"Y"}})
}
//修改行
function onClickRow(index,row){
	CommonRowClick(index,row,"#specslidetypedg");
}
//保存
function save(){
	saveByDataGrid("web.DHCAPPSpecSlideType","SaveSpecSlideType","#specslidetypedg",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#specslidetypedg").datagrid('reload');
			}else if(data==-1){
				$.messager.alert('提示','保存失败:'+data);
			}else{	
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#specslidetypedg").datagrid('reload');
				
			}
		});	
}


//删除一行
function deleteRow(){
	
	if ($("#specslidetypedg").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$("#specslidetypedg").datagrid('getSelected');     
			 runClassMethod("web.DHCAPPSpecSlideType","DeleteSpecSlideType",{'astRowId':row.astRowId},function(data){ $('#specslidetypedg').datagrid('load'); })
	    }    
	}); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	// 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findSlideTypeList(); //调用查询
    });
    
    //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findSlideTypeList(); //调用查询
    });   
         
   	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
	    findSlideTypeList();
    });	 
}

// 查询
function findSlideTypeList()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#specslidetypedg').datagrid('load',{params:params}); 
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })