///CreatDate:  2017-01-05
///Author:    lvpeng 
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#DTCode,#DTDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
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
	commonAddRow({'datagrid':'#datagrid',value:{'DTActiveFlag':'Y','DTHospDr':LgHospID}}) //hxy 2019-07-22 LgHospID
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCDISTool","SaveDisTool","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){
				$.messager.alert("��ʾ","��༭��������!"); 
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
		 runClassMethod("web.DHCDISTool","RemoveDisTool",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

