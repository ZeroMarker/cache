//===========================================================================================
// Author��      lidong
// Date:		 2022-8-30
// Description:	 �û���λ����
//===========================================================================================
var editaddRow=0;

var nodeArr=[];	
function initPageDefault(){
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	InitDataList();			// ʵ��DataGrid��ʼ������
	
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#insert").bind("click",insertRow);	// ��������
	
	$("#save").bind("click",saveRow);		// ����
	
	$("#delete").bind("click",DeleteRow);	// ɾ��
	
	$("#find").bind("click",QueryUserList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
	/// ����.������ѯ
	$('#queryName').searchbox({
	    searcher:function(value,name){
	   		QueryUserList();
	    }	   
	});	
	
}
/// ʵ��DataGrid��ʼ����ͨ����
function InitDataList(){
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����
	var Nameeditor={
		type:'combobox',
	  	 options:{
		  	valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'UserID'});
				$(ed.target).val(option.value);
			},
	  		onShowPanel:function(){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetUserComboxData&q="+'';
				$(ed.target).combobox('reload',unitUrl);	
	    			}	  
				
	  	 	}
	  	 
	 }
		 
	// ְ��
	var Roleeditor={
		 type:'combobox',
		 options:{
		  	valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'RoleName'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'RoleID'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'RoleName'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetRoleComboxData&q="+'';
				$(ed.target).combobox('reload',unitUrl);	
					}	  
				
		 	}
		 }
	// ��λ
	var Jobeditor={type:'combobox',
	  	 options:{
		  	valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'JobName'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'JobID'});
				$(ed.target).val(option.value);
			},
	  		onShowPanel:function(){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'JobName'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetJobComboxData&q="+'';
				$(ed.target).combobox('reload',unitUrl);	
	    			}	  
				
	  	 	}
		 }
	// ����columns
	var columns=[[   	 
			{field:'RowID',title:'RowID',hidden:true},
			{field:'UserID',title:'����ID',width:200,align:'left',editor:textEditor,hidden:true},
			{field:'UserName',title:'����',width:200,align:'left',editor:Nameeditor,hidden:false},
			{field:'RoleID',title:'ְ��ID',width:200,align:'left',editor:textEditor,hidden:true},
			{field:'RoleName',title:'ְ��',width:200,align:'left',editor:Roleeditor,hidden:false},
			{field:'JobID',title:'��λID',width:200,align:'left',editor:textEditor,hidden:true},
			{field:'JobName',title:'��λ',width:200,align:'left',editor:Jobeditor,hidden:false},
						
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		editaddRow=rowIndex; 	
 		 }, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            editaddRow=rowIndex;
            if (editaddRow != ""||editaddRow == 0) { 
                $("#UserList").datagrid('endEdit', editaddRow); 
            } 
            $("#UserList").datagrid('beginEdit', rowIndex); 
            var editors = $('#UserList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#UserList").datagrid('endEdit', rowIndex);
                  });   
                  
            } 
             
        }
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetUserListByName&UserName=";
	new ListComponent('UserList', columns, uniturl, option).Init();
	
}
/// ʵ��datagrid��ѯ
function QueryUserList()
{
	var params = $HUI.searchbox("#queryName").getValue();
	$('#UserList').datagrid('load',{
		UserName:params
	}); 
}

/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryName').setValue("");
	QueryUserList();	

}

// ��������
function insertRow(){
	
	if(editaddRow>="0"){
		$("#UserList").datagrid('endEdit', editaddRow);		//�����༭������֮ǰ�༭����
	}
	$("#UserList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {}
	});
	$("#UserList").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editaddRow=0;
}
/// ����༭��
function saveRow(){
	
	if(editaddRow>="0"){
		$("#UserList").datagrid('endEdit', editaddRow);
	}

	var rowsData = $("#UserList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].UserName=="")||(rowsData[i].RoleName=="")||(rowsData[i].JobName=="")){
			$.messager.alert("��ʾ","������ְ����λ����Ϊ��!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].RowID) +"^"+ $g(rowsData[i].UserName) +"^"+ $g(rowsData[i].RoleName)+"^"+ $g(rowsData[i].JobName)+"^"+ $g(rowsData[i].UserID)+"^"+ $g(rowsData[i].RoleID)+"^"+ $g(rowsData[i].JobID);
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	
	//��������
	runClassMethod("web.DHCCKBUserAuthority","SaveUpdate",{"params":params},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -100){
			$.messager.alert('��ʾ','����ʧ��,�Ѵ��ڸ������ݣ�','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		InitPageInfo();		
		
	});
}

/// ʵ��datagridɾ��ѡ����
function DeleteRow(){
	 
	var rowsData = $("#UserList").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBUserAuthority","DeleteUser",{"RowID":rowsData.RowID},function(jsonString){
					if (jsonString == 0){
						$('#UserList').datagrid('reload'); //���¼���
					}else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })