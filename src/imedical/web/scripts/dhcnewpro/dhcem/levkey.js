///CreatDate:  2016-05-31
///Author:    huaxiaoying 
$(function(){ 
	/*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed *///hxy 2020-12-28注释
	 
	//同时给代码和描述绑定回车事件 //hxy 2020-12-28 st
    $('#LKCode,#LKDesc').bind('keypress',function(event){
        if(event.keyCode == "13"){
	    	query();
        }
    });
	$('#queryBTN').on('click',function(){
		query();
	}) //ed
	
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LKActiveFlag':'Y','LKHospDr':LgHospID}})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMLevKey","SaveLevKey","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
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
		 runClassMethod("web.DHCEMLevKey","RemoveLevKey",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	$("#datagrid").datagrid('reload',{hospDrID:"",LKCode:$("#LKCode").val(),LKDesc:$("#LKDesc").val()});
}

function queryReset(){
	$("#LKCode").val("");
	$("#LKDesc").val("");
	query();
}

