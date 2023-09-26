///CreatDate:  2017-01-07
///Author:    yuliping
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#LICode,#LIDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
    $('#HospDrID').combobox({ //hxy 2019-07-22 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) //hxy ed
});
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LIType':'0','LIActiveFlag':'Y','LIHospDr':LgHospID,'LITypeAddDr':'','RecActiveFlag':'Y'}})
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	
	saveByDataGrid("web.DHCDISLocItem","SaveUpdLevReson","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
			
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){
				$.messager.alert("提示","请编辑必填数据!"); 
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
		 runClassMethod("web.DHCDISLocItem","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
