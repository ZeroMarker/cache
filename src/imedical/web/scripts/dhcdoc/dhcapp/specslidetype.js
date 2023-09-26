/**
* author :    QuNianpeng
* date:       2017-7-8
* descript:   ����걾��Ƭ�����ֵ����
*/

var editRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	initDgList();  		// ��ʼҳ��DataGrid�걾��Ƭ���ͱ�
	initButton();		// ��ʼ����ť
}

/// ��ʼҳ��DataGrid
function initDgList(){
	
	var hospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto", //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'astHospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'astHospDr'});
				$(ed.target).val(option.value); 
			} 			
		}
	}
	
	var astFlag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"��"},{"value":"N","text":"��"}],			
			panelHeight:"auto" , //���������߶��Զ�����	
			onSelect:function(option){
				///��������ֵ
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'astActiveFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#specslidetypedg").datagrid('getEditor',{index:editRow,field:'ActiveFlagCode'});
				$(ed.target).val(option.value); 
			} 		
		}
	}
	
	/// �ı��༭��
	var textEditor={
		type: 'validatebox',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns
	var columns=[[
		{field:"astRowId",title:'ID',width:20,hidden:'true',align:'center'},
		{field:"astCode",title:'�������',width:150,editor:textEditor},
		{field:"astDesc",title:'��������',width:170,editor:textEditor},
		{field:"astHospDesc",title:'ҽԺ',width:200,editor:hospEditor},
		{field:"astHospDr",title:'ҽԺID',width:40,align:'center',editor:textEditor,hidden:'true'},
		{field:"astActiveFlag",title:'�Ƿ����',width:80,align:'center',editor:astFlag},
		{field:"ActiveFlagCode",title:'ActiveFlagCode',width:80,align:'center',editor:textEditor,hidden:'true'}
		
	]];
	
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	     onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            onClickRow(rowIndex,rowData);
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPSpecSlideType&MethodName=QuerySpecSlideType";
	new ListComponent('specslidetypedg', columns, uniturl, option).Init(); 	
	
	
}

//����һ��
function addRow(){
	commonAddRow({'datagrid':'#specslidetypedg',value:{'astRowId':"",'astCode':"",'astDesc':"",'astHospDr':2,'astHospDesc':'2','astActiveFlag':'Y','ActiveFlagCode':"Y"}})
}
//�޸���
function onClickRow(index,row){
	CommonRowClick(index,row,"#specslidetypedg");
}
//����
function save(){
	saveByDataGrid("web.DHCAPPSpecSlideType","SaveSpecSlideType","#specslidetypedg",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#specslidetypedg").datagrid('reload');
			}else if(data==-1){
				$.messager.alert('��ʾ','����ʧ��:'+data);
			}else{	
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#specslidetypedg").datagrid('reload');
				
			}
		});	
}


//ɾ��һ��
function deleteRow(){
	
	if ($("#specslidetypedg").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$("#specslidetypedg").datagrid('getSelected');     
			 runClassMethod("web.DHCAPPSpecSlideType","DeleteSpecSlideType",{'astRowId':row.astRowId},function(data){ $('#specslidetypedg').datagrid('load'); })
	    }    
	}); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	// ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findSlideTypeList(); //���ò�ѯ
    });
    
    //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findSlideTypeList(); //���ò�ѯ
    });   
         
   	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
	    findSlideTypeList();
    });	 
}

// ��ѯ
function findSlideTypeList()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#specslidetypedg').datagrid('load',{params:params}); 
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })