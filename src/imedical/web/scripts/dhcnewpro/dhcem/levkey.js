///CreatDate:  2016-05-31
///Author:    huaxiaoying 
$(function(){ 
	/*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed *///hxy 2020-12-28ע��
	 
	//ͬʱ������������󶨻س��¼� //hxy 2020-12-28 st
    $('#LKCode,#LKDesc').bind('keypress',function(event){
        if(event.keyCode == "13"){
	    	query();
        }
    });
	$('#queryBTN').on('click',function(){
		query();
	}) //ed
	
});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LKActiveFlag':'Y','LKHospDr':LgHospID}})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMLevKey","SaveLevKey","#datagrid",function(data){
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
		 runClassMethod("web.DHCEMLevKey","RemoveLevKey",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	$("#datagrid").datagrid('reload',{hospDrID:"",LKCode:$("#LKCode").val(),LKDesc:$("#LKDesc").val()});
}

function queryReset(){
	$("#LKCode").val("");
	$("#LKDesc").val("");
	query();
}

