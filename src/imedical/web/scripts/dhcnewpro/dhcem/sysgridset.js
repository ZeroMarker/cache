// ����:Grid���ù���
// ��д����:2016-11-14
///CreatDate:  2016-09-08
///Author:    zhanghailong 
var SAId=""//ȫ�ֱ���:���id
var editRow=""//ȫ�ֱ������ӱ�˫���༭index 
$(function(){
	$("#date").datagrid({
		onSelect:function (rowIndex,rowDate){
			$("#datagrid1").datagrid("reload",{
				"SGSGridID":rowDate.SGSGridID,
				"SGSCspName":rowDate.SGSCspName,
				"SGSSaveFor":rowDate.SGSSaveFor,
				"SGSReference":rowDate.SGSReference	
				})
			}
		})
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
});	

///������ (���) 
function addRowSys(){
	commonAddRow({'datagrid':'#date'})
}

///���� (���) 
function saveSys(){
	saveByDataGrid("web.DHCEmSysGridSet","SaveSys","#date",function(data){
			if(data==0){
				$.messager.alert("��ʾ","����ɹ�!");
				$("#date").datagrid('load');
				$("#datagrid1").datagrid('load');
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#date").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});		
}

///ɾ�� (���) 
function cancelSys(){
	if ($("#date").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	     var rowDate =$("#date").datagrid('getSelected');   //��ȡѡ���е�����
		 runClassMethod("web.DHCEmSysGridSet","Delete",{
			    "SGSGridID":rowDate.SGSGridID,
				"SGSCspName":rowDate.SGSCspName,
				"SGSSaveFor":rowDate.SGSSaveFor,
				"SGSReference":rowDate.SGSReference	},function(data){ 
				if(data==0){
				     $.messager.alert("��ʾ","ɾ���ɹ�!");
			      }else {	
				     $.messager.alert('��ʾ','ɾ��ʧ��:'+data)
			      }	
		 $('#date').datagrid('load');
		 $('#datagrid1').datagrid('load');
		  })
    }    
}); 
}

///˫���༭ (�ұ�)
function onClickRowSysItm(index,row){
    editRow=index //add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid1");
}

///������ (�ұ�) 
function addRowSysItm(){
	 if ($("#date").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�����');
		return;
	 }
	var row =$("#date").datagrid('getSelected');
	commonAddRow({'datagrid':'#datagrid1'})
	var SGSGridID = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSGridID'});
	var SGSCspName = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSCspName'});
	var SGSSaveFor = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSSaveFor'});
	var SGSReference = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSReference'});
	$(SGSGridID.target).val(row.SGSGridID); 
	$(SGSCspName.target).val(row.SGSCspName); 
	$(SGSSaveFor.target).val(row.SGSSaveFor); 
	$(SGSReference.target).val(row.SGSReference); 
}

///���� (�ұ�)
function save(){
	saveByDataGrid("web.DHCEmSysGridSet","SaveSys","#datagrid1",function(data){
			if(data==0){
				$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("��ʾ","�����ظ�����!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
		});			
}
