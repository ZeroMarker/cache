var cat =getParam("cat");  ///ҽ����ID
window.onload=function(){
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
		if(cat==""||cat==null){		//lvpeng 2016-07-15
			//alert("����");
			$('#datagrid').datagrid({
				url:''
			});
		}else{
			//alert("����");
			$('#datagrid').datagrid({
				url:'dhcapp.broker.csp?ClassName=web.DHCAPPCatLinkOpt&MethodName=list',
				queryParams:{ALOOptParRef:cat}
			});
		}   //lvpeng 2016-07-15
}


//��������
function addRow(){
	if(cat==""){
		$.messager.alert('��ʾ','��ѡ�������')
		return;	
	}
	commonAddRow({'datagrid':'#datagrid',value:{'ALOOptParRef':cat}})
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

//��������
function save(){
	saveByDataGrid("web.DHCAPPCatLinkOpt","save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==1){	
			    $.messager.alert('��ʾ','��¼����Ч��������ѡ��!')
			    $("#datagrid").datagrid('reload')
			}else if(data==2){    ///sufan  2017-02-24
				$.messager.alert('��ʾ','�����ظ�:'+data);
				$("#datagrid").datagrid('reload');
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
		 runClassMethod("web.DHCAPPCatLinkOpt","remove",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
	});	
}
function fillValue(rowIndex, rowData){
	$('#datagrid').datagrid('getRows')[editIndex]['ALOOptDr']=rowData.ID
}