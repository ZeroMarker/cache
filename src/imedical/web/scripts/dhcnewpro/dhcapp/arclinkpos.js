/// Creator: huaxiaoying
/// CreateDate: 2016-4-19
/// Descript:���ҽ��������λ����
var ArcDr =getParam("itmmastid");  ///ҽ����ID
$(function(){ 
    
    //��λ ����ѡ��
	$('#PosDr').combobox({
		url: LINK_CSP+"?ClassName=web.DHCAppArcLinkPos&MethodName=getPos",
		valueField:'id',    
    	textField:'text'
	});
    $("#datagrid").datagrid('load',{ArcRowId:ArcDr,HospID:LgHospID});
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
	commonAddRow({'datagrid':'#datagrid',value:{'ArcDr':ArcDr}})  
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
	saveByDataGrid("web.DHCAppArcLinkPos","save","#datagrid",function(data){
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
		 runClassMethod("web.DHCAppArcLinkPos","remove",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}




