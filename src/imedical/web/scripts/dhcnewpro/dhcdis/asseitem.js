///CreatDate:  2017-01-07
///Author:    yuliping
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#AICode,#AIDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
});
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'AIActiveFlag':'Y','AIHospDr':'2'}})
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCDISAsseItem","SaveUpdLevReson","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
			
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCDISAsseItem","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
