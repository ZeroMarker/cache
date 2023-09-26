///CreatDate:  2017-01-18
///Author:    yuliping
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#PHGSCode,#PHGSDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
});
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'PHGSModType':'EDU','PHGSSubModType':'N'}})
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCPHGuiScope","SaveUpdGuiScope","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","模块已存在,不能重复保存!"); 
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
		 runClassMethod("web.DHCPHGuiScope","RemoveGuiScope",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

