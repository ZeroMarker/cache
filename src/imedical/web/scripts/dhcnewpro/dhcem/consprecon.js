///CreatDate:  2016-05-25
///Author:    huaxiaoying 
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#PACode,#PADesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'ECActiveFlag':'Y','ECHospDr':LgHospID}})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	
	saveByDataGrid("web.DHCEMConsFunction","SaveConData","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){ //hxy 2020-09-24 st
				$.messager.alert("提示","填写内容中不能存在特殊字符!"); //ed
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
		 runClassMethod("web.DHCEMConsFunction","RemovePatAware",{'Id':row.ID},function(data){ 
		 	if(data=="-2"){//hxy 2020-08-10
			 	$.messager.alert('提示','会诊工作流配置-会诊工作流前置条件处已使用，不允许删除');
			}
		 	$('#datagrid').datagrid('load'); 
		 })
    }    
}); 
}

