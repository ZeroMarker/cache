///CreatDate:  2016-06-07
///Author:    huaxiaoying 
var SAtypeID="";//ȫ�ֱ�������Ʒ������Ȩ��(���)������id
$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
	
	//��ʶ�󶨻س��¼�
     $('#SYGroupName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ
        }
    });
   
   
});

///csp���������ֵ����
function fillValue(rowIndex, rowData){
	$('#datagrid2').datagrid('getRows')[editIndex]['SAPointer']=rowData.id
}

///������ ��Ʒ��(����) 
function addRowSys(){
	commonAddRow({'datagrid':'#datagrid',value:{'SYActiveFlag':'Y','SYHospDr':'2'}})
}
///˫���༭ ��Ʒ��(����) 
function onClickRowSys(index,row){
	CommonRowClick(index,row,"#datagrid");
	$("#Hosp").attr("formatter",row.SYHospDr.HOSPDesc);
}
///���� ��Ʒ��(����) 
function saveSys(){
	saveByDataGrid("web.DHCEMSys","SaveSys","#datagrid",function(data){
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

///ɾ�� ��Ʒ��(����) 
function cancelSys(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSys","RemoveSys",{'Id':row.ID},function(data){ 
		 $('#datagrid').datagrid('load');
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///������ ��Ʒ���ܱ�(�ӱ�) 
function addRowSysItm(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ��');
		return;
	 }
	 var row =$("#datagrid").datagrid('getSelected');
	 SAId=row.ID; ///��id  
	 
	commonAddRow({'datagrid':'#datagrid1',value:{'SYRemark':' ','SYParRefDr':SAId}})
}
///˫���༭ ��Ʒ���ܱ�(�ӱ�)
function onClickRowSysItm(index,row){
	CommonRowClick(index,row,"#datagrid1");
}
///���� ��Ʒ���ܱ�(�ӱ�)
function saveSysItm(){
	saveByDataGrid("web.DHCEMSysItm","SaveSysItm","#datagrid1",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid1").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid1").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}

///ɾ�� ��Ʒ���ܱ�(�ӱ�)
function cancelSysItm(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItm","RemoveSysItm",{'Id':row.ID},function(data){ 
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///������ ��Ʒ������Ȩ��(���)
function addRowSysItmAut(){
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ��Ʒ���ܱ�');
		return;
	 }
	var row =$("#datagrid1").datagrid('getSelected');
	SAid=row.ID; ///�ӱ�id
	  
	commonAddRow({'datagrid':'#datagrid2',value:{'SAType':'G','SAHospDr':'2','SAParRefDr':SAid}})
	//SAtypeID="G";

}

///˫���༭ ��Ʒ������Ȩ��(���)
function onClickRowAut(index,row){
	CommonRowClick(index,row,"#datagrid2");
	$("#Hosp1").attr("formatter",row.SAHospDr.HOSPDesc);
	SAtypeID=row.SAType
	var rowIndex=$('#datagrid2').datagrid('getRowIndex',$('#datagrid2').datagrid('getSelected'))
	var varEditor = $('#datagrid2').datagrid('getEditor', { index: rowIndex, field: 'PointerDesc' });
	
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListGroup&type='+SAtypeID
	})
	
	
		
}
///���� ��Ʒ������Ȩ��(���)
function saveSysItmAut(){
	saveByDataGrid("web.DHCEMSysItmAut","SaveSysItmAut","#datagrid2",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid2").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid2").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}

///ɾ�� ��Ʒ������Ȩ��(���)
function cancelSysItmAut(){
	
	if ($("#datagrid2").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid2").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItmAut","RemoveSysItmAut",{'Id':row.ID},function(data){ $('#datagrid2').datagrid('load'); })
    }    
}); 
}
