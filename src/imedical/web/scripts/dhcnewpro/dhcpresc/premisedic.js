///CreatDate:  2022-06-25
///Author:    ylp
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
	commonAddRow({'datagrid':'#datagrid',value:{'PPCode':'','PPName':''}})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	
	saveByDataGrid("web.DHCPRESCPremiseDic","save","#datagrid",function(data){
			if(data>0){
				$.messager.alert("提示","保存成功!","info");
				$("#datagrid").datagrid('reload')
			}else if(data==-1){
				$.messager.alert("提示","代码已存在,不能重复保存!","warning"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){ //hxy 2020-09-24 st
				$.messager.alert("提示","填写内容中不能存在特殊字符!","warning"); //ed
			}else{	
				$.messager.alert('提示','保存失败:'+data,"warning")
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除',"warning");
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCPRESCPremiseDic","delete",{'ID':row.ID},function(data){ 
		 	if(data=="-2"){//
			 	$.messager.alert('提示','该数据已使用，不允许删除',"warning");
			}
		 	$('#datagrid').datagrid('load'); 
		 })
    }    
}); 
}
