//zhouxin 2016-04-19
$(function(){ 
	//ѡ���ϼ���λ
	$('#datagrid').datagrid({    
		 onClickRow:function(rowIndex, rowData){
	            $("#AOIOptParRef").val(rowData.ID);
	            $('#subdatagrid').datagrid('load', {    
				    AOIOptParRef: rowData.ID  
				}); 
         }
	});
});

//����commonQuery �� commonReload ˵��
//<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="javascript:commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})">��ѯ</a> 

//������ʾ��csp�и���ťע�� �����¼�
//commonQuery �� commonReload ����ζ��� json�ַ���,��ʽΪ {'datagrid':'#datagrid','formid':'#queryForm'}
// ����datagrid ��datagrid��id
 // formid ��<form>��id �����form�����������в�ѯ�����ĸ����������в�ѯ�����������������������
 // <input type="text" name="AOCode" class="textParent"></input>
 //���в�ѯ������Ӧ����name���ԣ���������Ժͺ�̨����������ͬ
 // ���������������������commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})
 // ���#queryForm ��������б�Ԫ���ύ��datagrid ����ĺ�̨�෽���������෽����������ͱ�Ԫ�ص�nameһֱ
 //  commonReload ����ͬ commonQuery ,ֻ��������ղ�ѯ��������

//������λ�ֵ�����һ��
//commonAddRow ����˵��
//��һ������ datagrid ����Ҫ����һ�е�datagrid��id
//�ڶ������� value �������и���ʼֵ
//���û����Ҫ��ʼ��ֵ���Բ����ڶ�������
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'AORequired':'Y','AOType':'Input'}})
}
//������λ�ֵ�˫���༭
//������������˫����datagrid��id����
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
//������λ����
//"web.DHCAPPOtherOpt" ����
//"save"   			  ������
//"#datagrid"          Ҫ�����datagrid��id
// �˷����Զ���datagrid�еı༭�Ĵ���������ݴ����̨
// һ������֮���� "^" �ָ�
// ��������֮���� "$$" �ָ�
// �ύ ����̨�Ĳ������� params
// ���ĸ������Ǻ�ִ̨����Ļص�����

function save(){
	saveByDataGrid("web.DHCAPPOtherOpt","save","#datagrid",function(data){
			if(data==0){
				$.messager.alert('��ʾ','����ɹ�')			
			}else if(data==-10){
				$.messager.alert('��ʾ','�����ظ�')	
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
			$("#datagrid").datagrid('reload')
		});	
}

function addRowSub(){
	if($("#AOIOptParRef").val() == ""){
		$.messager.alert('��ʾ','����ѡ��������Ŀ�ֵ�')
		return;
	}
	commonAddRow({'datagrid':'#subdatagrid',value:{AOIOptParRef:$("#AOIOptParRef").val()}})
}
function onClickRowSub(index,row){
	CommonRowClick(index,row,"#subdatagrid");
}
function saveSub(){
	saveByDataGrid("web.DHCAPPOtherOpt","saveSub","#subdatagrid",function(data){
		if(data == 0){     //qunianpeng 2016-07-15
			$.messager.alert('��ʾ','��ӳɹ�');
		}else if(data == -10){
			$.messager.alert('��ʾ','���벻���ظ�');
		}else{
			$.messager.alert('��ʾ','���ʧ��:'+data);
		}		
		$("#subdatagrid").datagrid('reload');
	});	

}





function cancelSub(){
	
	if ($("#subdatagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#subdatagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPOtherOpt","removeSub",{'Id':row.ID},function(data){ $('#subdatagrid').datagrid('load'); })
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
		 runClassMethod("web.DHCAPPOtherOpt","remove",{'Id':row.ID},function(data){
			  if(data==1){     //lvpeng  2016/7/13
				$.messager.alert("��ʾ��","�����ѱ����ã��޷�ɾ��");	 
			 }else{
				$.messager.alert("��ʾ��","ɾ���ɹ�");	 
		     }
			  $('#datagrid').datagrid('load'); })
    }    
}); 
}

///sufan ������commonQuery,commonReload����
function commonQuery()
{
	var code=$("#code").val();
	var desc=$("#desc").val();
	$('#datagrid').datagrid('load',{AOCode:code,AODesc:desc}); 
}

function commonReload()
{
	$("#code").val("");
	$("#desc").val("");
	commonQuery();
}

/// ����ѡ���������á��Ƿ��������б�
function reLoadReq(){
	
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AOType'});
	if ($(ed.target).combobox("getValue")== "Check"){
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("clear");
		$(ed.target).combobox("loadData",[{"value":"N","text":'��'}]);
		$(ed.target).combobox('setValue',"N");
	}else{
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("loadData",[{"value":"N","text":'��'},{"value":"Y","text":'��'}]);
	}
	
}
