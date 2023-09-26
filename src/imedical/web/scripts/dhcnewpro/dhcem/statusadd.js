///CreatDate:  2017-01-18
///Author:    yuliping
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#SACode,#SADesc').bind('keypress',function(event){
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
	commonAddRow({'datagrid':'#datagrid',value:{'SAActiveFlag':'Y','SAMustFlag':'Y','SAType':'','SAHospDr':LgHospID}}) //hxy 2019-07-01 SAHospDr
}
function onClickRow(index,row){
	
	CommonRowClicks(index,row,"#datagrid");
	getCheckStatus(index,row)
}
function save(){
	saveByDataGrid("web.DHCDISStatusAdd","SaveUpdStatusAdd","#datagrid",function(data){
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
		 runClassMethod("web.DHCDISStatusAdd","RemoveStatusAdd",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
function CommonRowClicks(index,row,datagridid){
	//if (editIndex != index){  //hxy
		if (endEditing(datagridid)){
			$(datagridid).datagrid('selectRow', index).datagrid('beginEdit', index)
			
			editIndex = index;
		} else {
			$(datagridid).datagrid('selectRow', editIndex);
		}
	//}   //hxy
}
function getCheckStatus(index,row){
	
	var id="#selectRadio"+index
	if($(id).attr('value')=="Y"){
		
		$(id).attr("checked","checked")
		
		}
	}
