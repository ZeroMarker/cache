///CreatDate:  2017-03-10
///Author:    qiaoqingao
$(function(){ 
	hospComp = GenHospComp("DHC_EmDocAssessType");  //hxy 2020-05-14 st
	query();
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}//ed	
});

function addRow(){
	var HospDr=hospComp.getValue(); //
	commonAddRow({'datagrid':'#datagrid',value:{'DatActive':'Y','DatHospDr':HospDr,'DatHospDesc':HospDr,'HospDr':HospDr}}) //hxy 2019-07-25 LgHospID //hxy 2020-05-14 HospDr
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMDocAssessType","SaveDocAssessType","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-11){ //hxy 2020-05-24 st
				$.messager.alert("��ʾ","û�п���ҽԺ����Ȩ!"); 
				$("#datagrid").datagrid('reload') //ed
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
		 runClassMethod("web.DHCEMDocAssessType","RemoveDocUpdReason",{'Id':row.DatId},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocAssessType&MethodName=ListDocAssessType&HospDr='+HospDr
	})
}