///CreatDate:  2017-01-18
///Author:    yuliping
var url="dhcpha.clinical.action.csp";
$(function(){ 
    //lbb   2020.2.26 增加模块、子模块取值
    var phgsmodtypeCombobox = new ListCombobox("PHGSModType",url+'?action=ListIsActive','',{panelHeight:"auto"});
	phgsmodtypeCombobox.init();
	var phgssubmodtypeCombobox = new ListCombobox("PHGSSubModType",url+'?action=ListIsActiveSub','',{panelHeight:"auto"});
	phgssubmodtypeCombobox.init();
	//同时给代码和描述绑定回车事件
     $('#PHGSCode,#PHGSDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
     });
     //lbb   2020.2.26  增加模块、子模块过滤
     $('a:contains("查询")').bind('click', function(){
	     var PHGSCode=$('#PHGSCode').val()
	     var PHGSDesc=$('#PHGSDesc').val()
	     var PHGSModType=$('#PHGSModType').combobox('getValue');   
	     var PHGSSubModType=$('#PHGSSubModType').combobox('getValue'); 
		 if($('#PHGSModType').combobox('getText')=="") 
		 {
			PHGSModType=""
		 }
		 if( $('#PHGSSubModType').combobox('getText')=="")
		 {
			PHGSSubModType=""
		 }
		 $('#datagrid').datagrid('load',{PHGSCode:PHGSCode,PHGSDesc:PHGSDesc, PHGSModType:PHGSModType, PHGSSubModType:PHGSSubModType});
		 })
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

