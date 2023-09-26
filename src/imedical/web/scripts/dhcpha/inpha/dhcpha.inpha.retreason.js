/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-��ҳ-��˵�-��ҩԭ��ά��
createdate:2016-06-21
creator:dinghongying
*/
var url = "dhcpha.inpha.retreason.action.csp";
var HospId = session['LOGON.HOSPID'];
$(function(){
	InitHospCombo();
	InitRetReasonList();	
	
	$('#Badd').bind('click', Add);//�������
	$('#Bupdate').bind('click', Update);//�������
	$('#Bdelete').bind('click', Delete);//���ɾ��
});


//��ʼ����ҩԭ���б�
function InitRetReasonList(){
	//����columns
	var columns=[[
		{field:'TReasonCode',title:'����',width:300},
	    {field:'TReasonDesc',title:'����',width:300},
	    {field:'TRowid',title:'RowId',width:200,hidden:true}
	]];  
   //����datagrid	
   $('#retreasondg').datagrid({    
        url:url+'?action=GetRetReasonList&HospId='+HospId,
        fit:true,
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowid'];
				var retreasondesc=rowData['TReasonDesc'];
				var retreasoncode=rowData['TReasonCode'];
				$("#Desc").val(retreasondesc);
				$("#Code").val(retreasoncode);
			}
		}   
   });
}


///��ҩԭ���������
function Add()
{
	var ReasonDesc=$("#Desc").val();
	var ReasonCode=$("#Code").val();
	if(ReasonCode=="" & ReasonDesc==""){
		$.messager.alert('��Ϣ��ʾ',"��������ҩԭ����������!","info");
		return;
	}
	if(ReasonCode==""){
		$.messager.alert('��Ϣ��ʾ',"��������ҩԭ�����!","info");
		return;
	}
	if(ReasonDesc==""){
		$.messager.alert('��Ϣ��ʾ',"��������ҩԭ������!","info");
		return;
	}
	else{
		var RowId=""
		var returnValue= tkMakeServerCall("web.DHCINPHA.RetReason","InsertRetReason",ReasonDesc,RowId,ReasonCode,HospId);
		if(returnValue==0){
			$.messager.alert('��Ϣ��ʾ',"���ӳɹ�!");
			$('#retreasondg').datagrid('reload');
		}else if (returnValue=="-12"){
			$.messager.alert('��Ϣ��ʾ',"�����ظ�,����������!","info");
		}else if (returnValue=="-11"){
			$.messager.alert('��Ϣ��ʾ',"�����ظ�,����������!","info");
		}else{
			$.messager.alert('��Ϣ��ʾ',"���ʧ��,�������:"+returnValue,"warning");
		}
	}
}


///��ҩԭ������޸�
function Update()
{
	var selected = $("#retreasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('��Ϣ��ʾ',"����ѡ����Ҫ�޸ĵ�����!","info");
		return;
	}
	var RowId=selected.TRowid
	var ReasonCode=$("#Code").val();
	var ReasonDesc=$("#Desc").val();
    var retValue=tkMakeServerCall("web.DHCINPHA.RetReason","UpdateRetReason",ReasonDesc,RowId,ReasonCode,HospId);
    if(retValue==0){
	    //$.messager.alert('��Ϣ��ʾ',"�޸ĳɹ�!");
    	$('#retreasondg').datagrid('reload');
    }else if (retValue=="-12"){
		$.messager.alert('��Ϣ��ʾ',"�����ظ�,�������޸�!","info");
	}else if (retValue=="-11"){
		$.messager.alert('��Ϣ��ʾ',"�����ظ�,�������޸�!","info");
	}else {
		$.messager.alert('��Ϣ��ʾ',"�޸�ʧ��,�������:"+retValue,"warning");
	}
   
}

///��ҩԭ�����ɾ��
function Delete(){
	var selected = $("#retreasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('��Ϣ��ʾ',"����ѡ����Ҫɾ��������!","info");
		return;
	}
	var RowId=selected.TRowid
	$.messager.confirm('��Ϣ��ʾ',"ȷ��ɾ����",function(r){
		if(r){
			var retValue=tkMakeServerCall("web.DHCINPHA.RetReason","DeleteRetReason",RowId,HospId);
			if(retValue==0){
				$("#Desc").val("");
				$("#Code").val("");	
				$('#retreasondg').datagrid('reload');
			}
			else{
				$.messager.alert('��Ϣ��ʾ',"ɾ��ʧ��,�������:"+retValue,"error");
			}
		}
	});
}
function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'BLC_ReasonForRefund'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;	
				$("#Code").val('');
				$("#Desc").val('');
				$('#retreasondg').datagrid('options').queryParams.HospId=HospId;			
				$('#retreasondg').datagrid('reload');		
			}
        };
	}
}

