///CreatDate:  2022-06-25
///Author:    ylp
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
	commonAddRow({'datagrid':'#datagrid',value:{'PPCode':'','PPName':''}})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	
	saveByDataGrid("web.DHCPRESCPremiseDic","save","#datagrid",function(data){
			if(data>0){
				$.messager.alert("��ʾ","����ɹ�!","info");
				$("#datagrid").datagrid('reload')
			}else if(data==-1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!","warning"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){ //hxy 2020-09-24 st
				$.messager.alert("��ʾ","��д�����в��ܴ��������ַ�!","warning"); //ed
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data,"warning")
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��',"warning");
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCPRESCPremiseDic","delete",{'ID':row.ID},function(data){ 
		 	if(data=="-2"){//
			 	$.messager.alert('��ʾ','��������ʹ�ã�������ɾ��',"warning");
			}
		 	$('#datagrid').datagrid('load'); 
		 })
    }    
}); 
}
