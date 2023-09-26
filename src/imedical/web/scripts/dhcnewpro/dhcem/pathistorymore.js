/// author:    sufan
/// date:      2018-07-27
/// descript:  ���ﶾ������ά��

var ActiveArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var editRow = ""; editDRow = "";
$(function(){
	///��Ժ������
	MoreHospSetting("DHC_EmPatHistoryMore");
	InitWidListener();	//��ʼ�����水ť�¼�
	InitDetList();	    //��ʼ����ѯ��Ϣ�б�
})
///��Ժ������
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = findHisMorelist;
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$("#insert").bind("click",insertRow);
	$("#delete").bind("click",deleteRow);
	$("#save").bind("click",saveRow);
	
	// ����
    $('#query').bind('click',function(event){
         findHisMorelist(); //���ò�ѯ
    });
    
    //ͬʱ������������󶨻س��¼�
    $('#Code,#Desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findHisMorelist(); //���ò�ѯ
        }
    });
    
    // ����
    $('#reset').bind('click',function(event){
	     $('#Code').val("");
	     $('#Desc').val("");
         findHisMorelist(); //���ò�ѯ
    });
    
	
}

///��ʼ�������б�
function InitDetList(){
	/*
	 * ����columns
	 */
 
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ҽԺ
	var Hospeditor={		//������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'HospDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �Ƿ����
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:ActiveArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'PHIMIFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	
	var columns=[[
		{field:'PHIMRowID',title:'ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'PHIMICode',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'PHIMIDesc',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'HospDr',title:'HospDr',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'HospDesc',title:'���Ż�ҽԺ ',width:100,editor:Hospeditor,align:'center',hidden:true},
		{field:'PHIMIFlag',title:'���ñ�ʶ',width:100,editor:Flageditor,align:'center',formatter:function(value,row,index){
			if (value=='Y'){return '��';} 
			else {return '��';}
		 }},
		{field:'FlagCode',title:'FlagCode',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'Type',title:'����',width:100,editor:textEditor,align:'center'} //hxy 2019-11-15 ������
	]];
	
	var code=$('#Code').val();
	var desc=$('#Desc').val();
	var hospID = $HUI.combogrid("#_HospList").getValue();	
	var params=code+"^"+desc+"^"+hospID;
	
	$HUI.datagrid("#HisMoreList",{
		url: LINK_CSP+"?ClassName=web.DHCEMPatHistoryMore&MethodName=QueryPatHisMore&params="+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		title:'',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#HisMoreList").datagrid('endEdit', editRow); 
            } 
            $("#HisMoreList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }	
	})
	

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#HisMoreList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#HisMoreList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PHIMICode==="")){
			$.messager.alert("��ʾ","����Ϊ��");     
			return false;
		}
		
		if((rowsData[i].PHIMIDesc==="")){
			$.messager.alert("��ʾ","��������Ϊ��");     
			return false;
		}
		
		if((rowsData[i].HospDr==="")){
			$.messager.alert("��ʾ","����ҽԺ����Ϊ��");     
			return false;
		}
		
		if((rowsData[i].FlagCode==="")){
			$.messager.alert("��ʾ","���ñ�ʶ����Ϊ��");     
			return false;
		}
		
		
		
		var tmp=rowsData[i].PHIMRowID+"^"+rowsData[i].PHIMICode +"^"+ rowsData[i].PHIMIDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode+"^"+rowsData[i].Type ; //hxy 2019-11-15 Type
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMPatHistoryMore","SavePatHisMore",{"params":params},function(data){
		
		if (data==0){
			//$.messager.alert('��ʾ','��ӳɹ���');
		}
		if ((data=="-1")||(data=="-3")){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');	
		}
		if ((data=="-2")||(data=="-4")){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');	
		}
		
		$('#HisMoreList').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#HisMoreList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	var HospID=$HUI.combogrid("#_HospList").getValue();
	$("#HisMoreList").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {PHIMRowID:'',PHIMICode:'',PHIMIDesc:'',PHIMIFlag:'Y',FlagCode:'Y',HospDr:HospID,HospDesc:HospID}
	});
    
	$("#HisMoreList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#HisMoreList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMPatHistoryMore","DeletePatHisMore",{"PHIMRowID":rowsData.PHIMRowID},function(jsonString){
					if (jsonString != 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#HisMoreList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findHisMorelist()
{
	var code=$('#Code').val();
	var desc=$('#Desc').val();
	var hospID = $HUI.combogrid("#_HospList").getValue();	
	var params=code+"^"+desc+"^"+hospID;
	$('#HisMoreList').datagrid('load',{params:params}); 
}