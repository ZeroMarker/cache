/// Descript: �������뵥״̬����ά��
/// Creator : qunianpeng
/// Date    : 2017-11-16
var currEditRow="";

/// JQuery ��ʼ��ҳ��
$(function(){ 

	initPageDefault(); 
})

/// ҳ���ʼ������
function initPageDefault(){		
	
	//ͬʱ������������󶨻س��¼�
    $('#pisStatCode,#pisStatDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //���ò�ѯ
        }
    });
	
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid'})
}

function onClickRow(index,row){
	currEditRow=row;
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCAPPStatContrast","SaveUpdStatus","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","PIS�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("��ʾ","PIS�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==3){
				$.messager.alert("��ʾ","HIS����,�Ѿ������գ������ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data);				
			}
			$("#datagrid").datagrid('reload')
		});	
}

//ɾ��
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$("#datagrid").datagrid('getSelected');     
			 runClassMethod("web.DHCAPPStatContrast","RemoveStat",{'id':row.contrastId},function(data){ $('#datagrid').datagrid('load'); })
	    }    
	}); 
}

///����ȡֵ����
function fillValue(rowIndex, rowData){
			
/*  ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'StatCode'});
	$(ed.target).val(rowData.statusDesc)
	ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'StatusId'});
	$(ed.target).val(rowData.statusId) */
	
}

