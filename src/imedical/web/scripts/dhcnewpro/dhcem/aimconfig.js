///CreatDate:  2016-09-08
///Author:    zhanghailong 
var HospDr="";//ȫ�ֱ�����(����)��ҽԺid
var SAId=""//ȫ�ֱ���:����id
var editRowF=0//ȫ�ֱ���������˫���༭index 
var editRow=0//ȫ�ֱ������ӱ�˫���༭index 
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
});

///������ (����) 
function addRowSys(){
	commonAddRow({'datagrid':'#datagrid',value:{'AISActiveFlag':'Y','AISHospDr':LgHospID}}) //hxy 2019-07-26 LgHospID
}

///˫���༭ (����) 
function onClickRowSys(index,row){
	editRowF=index //add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid");
	AISHospDr=row.AISHospDrID
	$("#Hosp").attr("formatter",row.AISHospDr.HOSPDesc);
}
///�����༭ (����) 
function ClickRowSys(){
	var row =$("#datagrid").datagrid('getSelected');
	SAId=row.ID; ///��id
	$('#datagrid1').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEmAISItem&MethodName=ListSysItm&SAId='+SAId
	});
	}
	
///���� (����) 
function saveSys(){
	saveByDataGrid("web.DHCEmAIS","SaveSys","#datagrid",function(data){
			if(data==0){				
				$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('load')
				$("#datagrid2").datagrid('load')
			}else if(data==10){
				$.messager.alert("��ʾ","��Ŀ�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				$("#datagrid").datagrid('load')
				
			}
		});		
}

///ɾ�� (����) 
function cancelSys(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEmAIS","RemoveSys",{'Id':row.ID},function(data){ 
		 $('#datagrid').datagrid('load');
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///������ (�ӱ�) 
function addRowSysItm(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','����ѡ�� ����');
		return;
	 }
	 $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
	 var row =$("#datagrid").datagrid('getSelected');
	 SAId=row.ID; ///��id  
	commonAddRow({'datagrid':'#datagrid1',value:{'AISActiveFlag':'Y','AISParRefDr':SAId}})
}

///˫���༭ (�ӱ�)
function onClickRowSysItm(index,row){
    editRow=index //add hxy 2016-08-06
    $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid1");
}

///�����༭ (�ӱ�)
function ClickRowSysItm(){
	var row =$("#datagrid1").datagrid('getSelected');
	SAItmId=row.ID; ///�ӱ�id
	$('#datagrid2').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAut&SAItmId='+SAItmId
	});
	}

///���� (�ӱ�)
function saveSysItm(){
	saveByDataGrid("web.DHCEmAISItem","SaveSysItm","#datagrid1",function(data){
			if(data==0){
				$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("��ʾ","��Ŀ�����Ѵ���,�����ظ�����!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
		});		
}

///ɾ�� (�ӱ�)
function cancelSysItm(){
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEmAISItem","RemoveSysItm",{'Id':row.ID},function(data){ 
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}