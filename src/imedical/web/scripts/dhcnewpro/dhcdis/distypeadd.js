///CreatDate:  2017-03-28
///Author:    wangxuejian
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#DTCode,#DTDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'TAActiveFlag':'Y','TAHospDr':'2'}})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCDISTypeAdd","SaveDisTypeAdd","#datagrid",function(data){
			if(data==0){
			
				$.messager.alert("��ʾ","����ɹ�!");
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
		 runClassMethod("web.DHCDISTypeAdd","RemoveDisTypeAdd",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

