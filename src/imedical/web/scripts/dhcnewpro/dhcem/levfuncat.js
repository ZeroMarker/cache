/// huaxiaoying
/// 2016-04-26
/// ҽ���������ά��
var HospDrID=""//ȫ�ֱ��� �������ҽԺid
$(function(){
   //��������ʼ��ʾ
	$('#CatLib').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevFunCat&MethodName=ListCatLibTree', 
		//checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			//alert(node.id);
			if(node.id==1){
				$('#tabs').tabs('select', 0);
				//$('#tabs').tabs('enableTab', 0);          // ���õڶ���ѡ����
                //$('#tabs').tabs('enableTab', 'Tab2');     // ���ñ���ΪTab2��ѡ����
            }else{
              
                $('#tabs').tabs('select', 1);
	            }
			 }
	});
	
	/*$('#hospDrID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //���ò�ѯ
	 }) //hxy ed 
	 
	 $('#hospDr').combobox({ //hxy 2019-07-21 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryButton').on('click',function(){
		 commonQuery({'datagrid':'#datagrid1','formid':'#toolbar1'}); //���ò�ѯ
	 }) //hxy ed *///hxy 2020-12-25 ע��

   
})


///LevFunCat_TAB
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LFCActiveFlag':'Y','LFCHospDr':'2','LFCRemark':''}})
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMLevFunCat","SaveLevFunCat","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
				$("#datagrid1").datagrid('reload')
				$('#CatLib').tree('reload')   
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
		 runClassMethod("web.DHCEMLevFunCat","RemoveLevFunCat",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
		 $('#CatLib').tree('reload')  
    }    
    }); 
}

///LevFunLib_TAB
function addRowLib(){
	commonAddRow({'datagrid':'#datagrid1',value:{'LFLActiveFlag':'Y','LFLHospDr':'2','LFLRemark':''}})
}
//˫���༭
function onClickRowLib(index,row){
	CommonRowClick(index,row,"#datagrid1");
	
	/*if(row.LFLHospDrID!=2){
		HospDrID=row.LFLHospDrID
		var rowIndex=$('#datagrid1').datagrid('getRowIndex',$('#datagrid1').datagrid('getSelected'))
    	rowIndex=rowIndex==-1?0:rowIndex
    	var varEditor = $('#datagrid1').datagrid('getEditor', { index: rowIndex, field: 'LFLCatDr' });
    	//$(varEditor.target).combobox('clear');//�������ֵ
    	$(varEditor.target).combobox( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMLevFunLib&MethodName=GetLFLCatDr&type='+HospDrID
    	 })
    	 
    	$(varEditor.target).combobox('select', row.LFLCatDr);
	}*///hxy 2020-12-25 ע��
	
}

function saveLib(){
	saveByDataGrid("web.DHCEMLevFunLib","SaveLevFunLib","#datagrid1",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
				$("#datagrid1").datagrid('reload')
				$('#CatLib').tree('reload')  
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid1").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}

function cancelLib(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMLevFunLib","RemoveLevFunLib",{'Id':row.ID},function(data){ $('#datagrid1').datagrid('load'); })
         $('#CatLib').tree('reload')  
    }    
    }); 
}