/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-��ҳ-��˵�-�ܾ���ҩԭ��ά��
createdate:2016-06-29
creator:dinghongying
*/
var url = "dhcpha.inpha.drugrefusereason.action.csp";
var HospId = session['LOGON.HOSPID'];
$(function(){
	InitHospCombo(); //����ҽԺ
	InitDrugRefuseReasonList();		
	$('#Add').bind('click', Add);//�������
	$('#Modify').bind('click', Modify);//����޸�
	$('#Delete').bind('click', Delete);//���ɾ��
});


//��ʼ���ܾ���ҩԭ���б�
function InitDrugRefuseReasonList(){
	//����columns
	var columns=[[
	    {field:'Rowid',title:'Rowid',width:200,hidden:true},
	    {field:'Code',title:'����',width:300},
	    {field:'Desc',title:'����',width:300}
	]];  
   //����datagrid	
   $('#drugrefusereasondg').datagrid({    
        url:url+'?action=GetDrugRefuseReasonList&HospId='+HospId,
        fit:true,
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[50,100,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['Rowid'];
				var desc=rowData['Desc'];
				var code=rowData['Code'];
				$("#Desc").val(desc);
				$("#Code").val(code);
			}
		}   
   });
}


///�ܾ���ҩԭ���������
function Add()
{
	var ReasonCode=$("#Code").val();
	var ReasonDesc=$("#Desc").val();
	if(ReasonCode=="" & ReasonDesc==""){
		$.messager.alert('��Ϣ��ʾ',"������ܾ���ҩԭ����������!");
		return;
	}
	if(ReasonCode==""){
		$.messager.alert('��Ϣ��ʾ',"������ܾ���ҩԭ�����!");
		return;
	}
	if(ReasonDesc==""){
		$.messager.alert('��Ϣ��ʾ',"������ܾ���ҩԭ������!");
		return;
	}
	else{
		var RowId=""
		var retValue= tkMakeServerCall("web.DHCINPHA.DrugRefuseReason","InsertRefReason",RowId,ReasonCode,ReasonDesc,HospId);
		if(retValue==-1){
			$.messager.alert('��Ϣ��ʾ',"�����ظ�,����������!","info");
		}
		else if(retValue==-2){
			$.messager.alert('��Ϣ��ʾ',"�����ظ�,����������!","info");
		}
		else if(retValue==-100){
			$.messager.alert('��Ϣ��ʾ',"���ʧ��,�������:"+retValue,"warning");
		}
		else{
			$.messager.alert('��Ϣ��ʾ',"��ӳɹ�!");
			$('#drugrefusereasondg').datagrid('reload');
		}
	}
}


///�ܾ���ҩԭ������޸�
function Modify()
{
	var selected = $("#drugrefusereasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('��Ϣ��ʾ',"����ѡ����Ҫ�޸ĵ�����!","info");
		return;
	}
	else{
		var RowId=selected.Rowid
		var ReasonCode=$("#Code").val();
		var ReasonDesc=$("#Desc").val();
		var retValue=tkMakeServerCall("web.DHCINPHA.DrugRefuseReason","UpdateRefReason",RowId,ReasonCode,ReasonDesc,HospId);
		if(retValue==-1){
			$.messager.alert('��Ϣ��ʾ',"�����ظ�,�������޸�!","info");
		}
		else if(retValue==-2){
			$.messager.alert('��Ϣ��ʾ',"�����ظ�,�������޸�!","info");
		}
		else if(retValue==-100){
			$.messager.alert('��Ϣ��ʾ',"�޸�ʧ��,�������:"+retValue,"warning");
		}
		else{
			$.messager.alert('��Ϣ��ʾ',"�޸ĳɹ�!");
			$('#drugrefusereasondg').datagrid('reload');
		}
	}
}

///�ܾ���ҩԭ�����ɾ��
function Delete(){
	var selected = $("#drugrefusereasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('��Ϣ��ʾ',"����ѡ����Ҫɾ��������!","info");
		return;
	}
	else{
		var RowId=selected.Rowid
		$.messager.confirm('��Ϣ��ʾ',"ȷ��ɾ����",function(r){
			if(r){
				var retValue=tkMakeServerCall("web.DHCINPHA.DrugRefuseReason","DeleteRefReason",RowId,HospId);
				if(retValue==0){
					$.messager.alert('��Ϣ��ʾ',"ɾ���ɹ�!");
					$("#Desc").val("");
					$("#Code").val("");
					$('#drugrefusereasondg').datagrid('reload');
				}
				else{
					$.messager.alert('��Ϣ��ʾ',"ɾ��ʧ��,�������:"+retValue,"error");
				}
			}
		});
	}
}

function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'DHC_STRefuseReason'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;	
				$("#Code").val('');
				$("#Desc").val('');
				$('#drugrefusereasondg').datagrid('options').queryParams.HospId=HospId;			
				$('#drugrefusereasondg').datagrid('reload');		
			}
        };
	}
}