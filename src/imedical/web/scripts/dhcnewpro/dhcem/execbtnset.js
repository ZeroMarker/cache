///CreatDate:  2017-03-10
///Author:    qiaoqingao
$(function(){ 
	$("#info").css("width",$("#toolbar").width()-48); //hxy 2018-10-25
	/*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed*/ //hxy 2020-05-26 ע��
	 
	 hospComp = GenHospComp("DHC_EmExecBtnSet");  //hxy 2020-05-26 st
     query(); //��ʼ��Ĭ�ϲ�ѯ
	 hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	 }//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-26
	commonAddRow({'datagrid':'#datagrid',value:{'EBSRowID':'','EBSNurSheetCode':'','EBSShowBtn':'','EBSActiveFlag':'Y',EBSHosp:HospDr,'EBSHospDr':HospDr}}) //hxy 2020-05-26 HospID->HospDr
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMExecBtnSet","Save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}

function delet(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$("#datagrid").datagrid('getSelected');     
			 	runClassMethod("web.DHCEMExecBtnSet","Delete",{'Id':row.EBSRowID},function(data){ 
			 	$('#datagrid').datagrid('load'); 
			})
	    }    
	}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMExecBtnSet&MethodName=GetExecBtnSetList&hospDrID='+HospDr
	})
}

