///CreatDate:  2016-05-25
///Author:    huaxiaoying 
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#PACode,#PADesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'ECActiveFlag':'Y','ECHospDr':LgHospID}})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	
	saveByDataGrid("web.DHCEMConsFunction","SaveConData","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){ //hxy 2020-09-24 st
				$.messager.alert("��ʾ","��д�����в��ܴ��������ַ�!"); //ed
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
		 runClassMethod("web.DHCEMConsFunction","RemovePatAware",{'Id':row.ID},function(data){ 
		 	if(data=="-2"){//hxy 2020-08-10
			 	$.messager.alert('��ʾ','���﹤��������-���﹤����ǰ����������ʹ�ã�������ɾ��');
			}
		 	$('#datagrid').datagrid('load'); 
		 })
    }    
}); 
}

