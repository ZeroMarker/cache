/// Creator: huaxiaoying
/// CreateDate: 2016-4-19
/// Descript:���ҽ������������
var ArcDr =getParam("itmmastid");  ///ҽ����ID
$(function(){ 
    
     //���� ����ѡ��
	$('#DispDr').combobox({
		url: LINK_CSP+"?ClassName=web.DHCAPPArcLinkDisp&MethodName=getDisp",
		valueField:'id',    
    	textField:'text'
	});
   
   //$("#datagrid").datagrid('load',{ArcRowId:ArcDr});
  
   $('#datagrid').datagrid({
		url:LINK_CSP+'?ClassName=web.DHCAPPArcLinkDisp&MethodName=list&ArcRowId='+ArcDr+'&HospID='+LgHospID
	});

});

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'ArcDr':ArcDr}}) 
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCAPPArcLinkDisp","save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert('��ʾ','�����ظ�����:'+data)
				$("#datagrid").datagrid('reload')
			}else{
				$.messager.alert('��ʾ','����ʧ�ܣ�'+data)
				}
		});	
		
}

///ɾ�� 
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPArcLinkDisp","remove",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}


